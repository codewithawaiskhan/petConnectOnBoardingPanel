import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../resource_categories/presentation/providers/resource_category_provider.dart';
import '../../../resource_categories/presentation/widgets/category_svg_widget.dart';
import '../../domain/entities/resource_entity.dart';
import '../providers/resource_provider.dart';

class AddEditResourceDialog extends StatefulWidget {
  final ResourceEntity? resource;

  const AddEditResourceDialog({super.key, this.resource});

  static Future<bool?> show(BuildContext context, {ResourceEntity? resource}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddEditResourceDialog(resource: resource),
    );
  }

  @override
  State<AddEditResourceDialog> createState() => _AddEditResourceDialogState();
}

class _AddEditResourceDialogState extends State<AddEditResourceDialog>
    with AppColors, Constants {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _readTimeController;

  String? _selectedCategoryId;
  bool _isFeatured = false;

  String? _featuredImageDataURI;
  String? _selectedFileName;
  Uint8List? _selectedFileBytes;
  bool _isPickingImage = false;

  bool get _isEdit => widget.resource != null;

  @override
  void initState() {
    super.initState();
    final r = widget.resource;
    _titleController = TextEditingController(text: r?.title ?? '');
    _bodyController = TextEditingController(text: r?.body ?? '');
    _readTimeController = TextEditingController(
      text: (r != null && r.approxReadTimeInMinutes > 0)
          ? r.approxReadTimeInMinutes.toString()
          : '3',
    );
    _isFeatured = r?.isFeatured ?? false;
    _selectedCategoryId = r?.categoryId ?? r?.postCategory?.id;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final catProvider = context.read<ResourceCategoryProvider>();
      if (catProvider.categories.isEmpty) {
        catProvider.fetchCategories(isRefresh: true);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _readTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'svg'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;
        if (bytes != null && bytes.isNotEmpty) {
          final ext = file.extension?.toLowerCase() ?? 'png';
          final mime = ext == 'svg' ? 'image/svg+xml' : 'image/$ext';
          final base64Str = base64Encode(bytes);

          setState(() {
            _selectedFileName = file.name;
            _selectedFileBytes = bytes;
            _featuredImageDataURI = 'data:$mime;base64,$base64Str';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        showToast(context, 'Failed to pick image: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _clearImage() {
    setState(() {
      _featuredImageDataURI = '';
      _selectedFileName = null;
      _selectedFileBytes = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null || _selectedCategoryId!.trim().isEmpty) {
      showToast(context, 'Please select a post category', isError: true);
      return;
    }

    final readTime = int.tryParse(_readTimeController.text.trim()) ?? 1;
    final entity = CreateUpdateResourceEntity(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      postCategory: _selectedCategoryId!.trim(),
      isFeatured: _isFeatured,
      approxReadTimeInMinutes: readTime > 0 ? readTime : 1,
      featuredImageDataURI: _featuredImageDataURI,
    );

    final provider = context.read<ResourceProvider>();
    bool success;

    if (_isEdit) {
      success = await provider.updateResource(widget.resource!.id, entity);
    } else {
      success = await provider.addResource(entity);
    }

    if (!mounted) return;

    if (success) {
      showToast(
        context,
        _isEdit
            ? 'Resource updated successfully'
            : 'Resource created successfully',
      );
      Navigator.of(context).pop(true);
    } else {
      showToast(
        context,
        provider.errorMessage ?? 'Operation failed. Please try again.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final catProvider = context.watch<ResourceCategoryProvider>();
    final resourceProvider = context.watch<ResourceProvider>();
    final categories = catProvider.categories;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Container(
          width: 620,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const Divider(height: 1, thickness: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategorySection(catProvider, categories),
                        const SizedBox(height: 20),
                        _buildTitleSection(),
                        const SizedBox(height: 20),
                        _buildBodySection(),
                        const SizedBox(height: 20),
                        _buildReadTimeAndFeaturedSection(),
                        const SizedBox(height: 20),
                        _buildImageSection(),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              _buildFooter(resourceProvider.isActionLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isEdit ? Icons.edit_note_rounded : Icons.article_rounded,
              color: primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: _isEdit ? 'Edit Resource' : 'Add New Resource',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: _isEdit
                      ? 'Update the post details and settings.'
                      : 'Publish an educational or informational resource article.',
                  fontSize: 12,
                  color: textSecondaryColor,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded, color: textSecondaryColor, size: 22),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    ResourceCategoryProvider catProvider,
    List dynamicCategories,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Post Category *',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 8),
        if (catProvider.isLoading && dynamicCategories.isEmpty)
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                AppText(
                  text: 'Loading categories...',
                  fontSize: 13,
                  color: textSecondaryColor,
                ),
              ],
            ),
          )
        else
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: (_selectedCategoryId != null &&
                        dynamicCategories
                            .any((c) => c.id == _selectedCategoryId))
                    ? _selectedCategoryId
                    : null,
                hint: AppText(
                  text: dynamicCategories.isEmpty
                      ? 'No categories available'
                      : 'Select Category',
                  fontSize: 13,
                  color: textSecondaryColor,
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: textSecondaryColor,
                ),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategoryId = val);
                  }
                },
                items: dynamicCategories.map<DropdownMenuItem<String>>((cat) {
                  return DropdownMenuItem<String>(
                    value: cat.id,
                    child: Row(
                      children: [
                        CategorySvgWidget(
                          icon: cat.icon,
                          size: 22,
                          iconSize: 14,
                          radius: 5,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppText(
                            text: cat.title,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Resource Title *',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _titleController,
          hintText: 'e.g. Best Foods for Pets in Summer',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBodySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Resource Body Content *',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _bodyController,
          hintText: 'Enter comprehensive post content or markdown...',
          maxLines: 6,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter the body content';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildReadTimeAndFeaturedSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'Approx. Read Time (Minutes) *',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _readTimeController,
                hintText: '3',
                textInputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  final n = int.tryParse(value.trim());
                  if (n == null || n <= 0) {
                    return 'Must be > 0';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'Featured Post',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
              const SizedBox(height: 8),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: _isFeatured ? 'Featured (True)' : 'Standard (False)',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _isFeatured ? primaryColor : textSecondaryColor,
                    ),
                    Switch.adaptive(
                      value: _isFeatured,
                      activeTrackColor: primaryColor,
                      onChanged: (val) => setState(() => _isFeatured = val),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(String? existingUrl) {
    if (_selectedFileBytes != null) {
      return Image.memory(_selectedFileBytes!, fit: BoxFit.cover);
    }

    if (existingUrl == null ||
        existingUrl.trim().isEmpty ||
        _featuredImageDataURI == '') {
      return Icon(
        Icons.image_outlined,
        color: textSecondaryColor,
        size: 28,
      );
    }

    final trimmed = existingUrl.trim();

    if (trimmed.startsWith('data:image')) {
      try {
        final commaIndex = trimmed.indexOf(',');
        final base64Part =
            commaIndex != -1 ? trimmed.substring(commaIndex + 1) : trimmed;
        final bytes = base64Decode(base64Part.trim());
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.broken_image_rounded,
            color: textSecondaryColor,
            size: 28,
          ),
        );
      } catch (_) {
        return Icon(
          Icons.broken_image_rounded,
          color: textSecondaryColor,
          size: 28,
        );
      }
    }

    final fullUrl =
        (trimmed.startsWith('http://') || trimmed.startsWith('https://'))
            ? trimmed
            : "${ApiEndpoints.storageBaseUrl}/$trimmed";

    return Image.network(
      fullUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.broken_image_rounded,
        color: textSecondaryColor,
        size: 28,
      ),
    );
  }

  Widget _buildImageSection() {
    final existingUrl = widget.resource?.featuredImage;
    final hasNewImage = _selectedFileBytes != null;
    final hasExistingUrl = existingUrl != null &&
        existingUrl.trim().isNotEmpty &&
        _featuredImageDataURI != '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Featured Cover Image (Optional)',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildImagePreview(existingUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: _selectedFileName ??
                          (hasExistingUrl
                              ? 'Current image attached'
                              : 'Supports PNG, JPG, WEBP, SVG'),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textPrimaryColor,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: 'Recommended size: 1200x630 or 16:9 ratio',
                      fontSize: 11,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CustomButton(
                          text: hasNewImage || hasExistingUrl
                              ? 'Change Image'
                              : 'Upload Image',
                          height: 34,
                          fontSize: 12,
                          isIcon: true,
                          icon: Icon(
                            Icons.upload_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          isLoading: _isPickingImage,
                          onTap: _pickImage,
                        ),
                        if (hasNewImage || hasExistingUrl) ...[
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: _clearImage,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: AppText(
                                text: 'Remove',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: errorColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(bool isSaving) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            text: 'Cancel',
            height: 42,
            width: 100,
            fontSize: 13,
            isOutlined: true,
            textColor: primaryColor,
            fillColor: whiteColor,
            buttonBorder: Border.all(color: primaryColor),
            onTap: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(width: 12),
          CustomButton(
            text: _isEdit ? 'Save Changes' : 'Publish Resource',
            height: 42,
            width: 140,
            fontSize: 13,
            isLoading: isSaving,
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}

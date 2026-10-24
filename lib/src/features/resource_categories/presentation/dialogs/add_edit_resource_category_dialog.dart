import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/resource_category_entity.dart';
import '../providers/resource_category_provider.dart';
import '../widgets/category_svg_widget.dart';

class AddEditResourceCategoryDialog extends StatefulWidget {
  final ResourceCategoryEntity? category;

  const AddEditResourceCategoryDialog({super.key, this.category});

  static Future<bool?> show(
    BuildContext context, {
    ResourceCategoryEntity? category,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddEditResourceCategoryDialog(category: category),
    );
  }

  @override
  State<AddEditResourceCategoryDialog> createState() =>
      _AddEditResourceCategoryDialogState();
}

class _AddEditResourceCategoryDialogState
    extends State<AddEditResourceCategoryDialog>
    with AppColors, Constants {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  String? _selectedDataURI;
  String? _selectedSvgString;
  String? _selectedFileName;
  bool _isPicking = false;

  bool get _isEdit => widget.category != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.category?.title ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickIcon() async {
    setState(() => _isPicking = true);
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['svg'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;
        if (bytes != null && bytes.isNotEmpty) {
          final svgString = utf8.decode(bytes);
          final base64Str = base64Encode(bytes);

          setState(() {
            _selectedSvgString = svgString;
            _selectedFileName = file.name;
            _selectedDataURI = 'data:image/svg+xml;base64,$base64Str';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        showToast(context, 'Failed to pick SVG file: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  void _clearIcon() {
    setState(() {
      _selectedDataURI = '';
      _selectedSvgString = null;
      _selectedFileName = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ResourceCategoryProvider>();
    final title = _titleController.text.trim();

    bool success;
    if (_isEdit) {
      success = await provider.updateCategory(
        id: widget.category!.id,
        title: title,
        iconDataURI: _selectedDataURI,
      );
    } else {
      success = await provider.addCategory(
        title: title,
        iconDataURI: _selectedDataURI,
      );
    }

    if (!mounted) return;

    if (success) {
      showToast(
        context,
        _isEdit
            ? 'Resource category updated successfully!'
            : 'Resource category created successfully!',
      );
      Navigator.of(context).pop(true);
    } else {
      showToast(
        context,
        provider.errorMessage ?? 'Failed to save resource category',
        isError: true,
      );
    }
  }

  Widget _buildIconPreview() {
    // 1. Newly selected SVG
    if (_selectedSvgString != null && _selectedSvgString!.isNotEmpty) {
      return Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: SvgPicture.string(
            _selectedSvgString!,
            width: 44,
            height: 44,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
          ),
        ),
      );
    }

    // 2. Existing SVG icon on edit (and not cleared)
    final existingIcon = widget.category?.icon;
    if (existingIcon != null &&
        existingIcon.isNotEmpty &&
        _selectedDataURI != '') {
      return CategorySvgWidget(
        icon: existingIcon,
        size: 64,
        iconSize: 40,
        radius: 10,
        showBorder: true,
      );
    }

    // 3. Fallback placeholder
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Icon(Icons.category_outlined, color: primaryColor, size: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
        side: BorderSide(color: borderColor),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _isEdit
                            ? Icons.edit_rounded
                            : Icons.add_circle_outline_rounded,
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
                            text: _isEdit
                                ? "Update Resource Category"
                                : "Add Resource Category",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            text: _isEdit
                                ? "Modify category title or icon"
                                : "Create a new resource classification",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: textSecondaryColor,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      tooltip: "Close",
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(color: borderColor, height: 1),
                const SizedBox(height: 24),

                // Title Input
                AppText(
                  text: "Category Title *",
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textPrimaryColor,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _titleController,
                  hintText: "Enter category title",
                  prefixIcon: Icon(
                    Icons.label_outline,
                    color: textSecondaryColor,
                    size: 20,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Category title is required";
                    }
                    if (value.trim().length < 2) {
                      return "Title must be at least 2 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Icon Picker Section
                AppText(
                  text: "Category Icon (SVG only)",
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
                      _buildIconPreview(),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text:
                                  _selectedFileName ??
                                  (widget.category?.icon != null &&
                                          _selectedDataURI != ''
                                      ? "Current SVG icon attached"
                                      : "Only SVG format supported (.svg)"),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textPrimaryColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                CustomButton(
                                  text: _isPicking
                                      ? "Selecting..."
                                      : (_selectedSvgString != null ||
                                            (widget.category?.icon != null &&
                                                _selectedDataURI != ''))
                                      ? "Change SVG Icon"
                                      : "Upload SVG Icon",
                                  height: 36,
                                  fontSize: 12,
                                  isIcon: true,
                                  icon: const Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  isLoading: _isPicking,
                                  onTap: _pickIcon,
                                ),
                                if (_selectedSvgString != null ||
                                    (widget.category?.icon != null &&
                                        _selectedDataURI != ''))
                                  CustomButton(
                                    text: "Remove",
                                    height: 36,
                                    fontSize: 12,
                                    isOutlined: true,
                                    textColor: errorColor,
                                    buttonBorder: Border.all(
                                      color: errorColor.withValues(alpha: 0.5),
                                    ),
                                    onTap: _clearIcon,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Action Buttons
                Consumer<ResourceCategoryProvider>(
                  builder: (context, provider, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton(
                          text: "Cancel",
                          height: 42,
                          width: 100,
                          fontSize: 13,
                          isOutlined: true,
                          onTap: provider.isActionLoading
                              ? null
                              : () => Navigator.of(context).pop(false),
                        ),
                        const SizedBox(width: 12),
                        CustomButton(
                          text: _isEdit ? "Update Category" : "Save Category",
                          height: 42,
                          width: 150,
                          fontSize: 13,
                          isLoading: provider.isActionLoading,
                          onTap: _submit,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/config/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/presentation/widgets/app_country_picker_field.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/campaign_entity.dart';
import '../providers/campaign_provider.dart';

class AddEditCampaignDialog extends StatefulWidget {
  final CampaignEntity? campaign;

  const AddEditCampaignDialog({super.key, this.campaign});

  static Future<bool?> show(BuildContext context, {CampaignEntity? campaign}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddEditCampaignDialog(campaign: campaign),
    );
  }

  @override
  State<AddEditCampaignDialog> createState() => _AddEditCampaignDialogState();
}

class _AddEditCampaignDialogState extends State<AddEditCampaignDialog>
    with AppColors, Constants {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _countryNameController;
  late final TextEditingController _linkController;

  String _userType = 'all';
  String _frequency = 'Onetime';
  int? _weekDay;

  String? _featuredImageDataURI;
  String? _featuredFileName;
  Uint8List? _featuredFileBytes;
  bool _isPickingImage = false;

  String? _attachmentDataURI;

  bool get _isEdit => widget.campaign != null;

  static const List<Map<String, String>> _userTypes = [
    {'value': 'all', 'label': 'All Users'},
    {'value': 'petParent', 'label': 'Pet Parents'},
    {'value': 'doctor', 'label': 'Veterinarians'},
    {'value': 'lab', 'label': 'Diagnostic Labs'},
    {'value': 'serviceProvider', 'label': 'Service Providers'},
  ];

  static const List<Map<String, String>> _frequencies = [
    {'value': 'Onetime', 'label': 'One-time'},
    {'value': 'Daily', 'label': 'Daily'},
    {'value': 'Weekly', 'label': 'Weekly'},
  ];

  static const List<Map<String, dynamic>> _weekDays = [
    {'value': 0, 'label': 'Sunday'},
    {'value': 1, 'label': 'Monday'},
    {'value': 2, 'label': 'Tuesday'},
    {'value': 3, 'label': 'Wednesday'},
    {'value': 4, 'label': 'Thursday'},
    {'value': 5, 'label': 'Friday'},
    {'value': 6, 'label': 'Saturday'},
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.campaign;
    _titleController = TextEditingController(text: c?.title ?? '');
    _bodyController = TextEditingController(text: c?.body ?? '');
    _countryCodeController = TextEditingController(text: c?.countryCode ?? '');
    _countryNameController = TextEditingController(text: c?.countryName ?? '');
    _linkController = TextEditingController(text: c?.link ?? '');

    _userType = c?.userType ?? 'all';
    _frequency = c?.frequency ?? 'Onetime';
    _weekDay = c?.weekDay;
    _attachmentDataURI = c?.attachment;

    if (_frequency == 'Weekly' && _weekDay == null) {
      _weekDay = 1; // Default to Monday if weekly
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _countryCodeController.dispose();
    _countryNameController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;
        if (bytes != null && bytes.isNotEmpty) {
          final ext = file.extension?.toLowerCase() ?? 'png';
          final mime = ext == 'jpg' ? 'image/jpeg' : 'image/$ext';
          final base64Str = base64Encode(bytes);

          setState(() {
            _featuredFileName = file.name;
            _featuredFileBytes = bytes;
            _featuredImageDataURI = 'data:$mime;base64,$base64Str';
          });
        }
      }
    } catch (_) {
      if (mounted) {
        showToast(context, 'Failed to select banner image', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _clearImage() {
    setState(() {
      _featuredFileName = null;
      _featuredFileBytes = null;
      _featuredImageDataURI = '';
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_frequency == 'Weekly' && _weekDay == null) {
      showToast(context, 'Please select a weekday for weekly campaign', isError: true);
      return;
    }

    final provider = context.read<CampaignProvider>();
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    final countryCode = _countryCodeController.text.trim();
    final countryName = _countryNameController.text.trim();
    final link = _linkController.text.trim();

    final entity = CreateUpdateCampaignEntity(
      userType: _userType,
      frequency: _frequency,
      weekDay: _frequency == 'Weekly' ? _weekDay : null,
      title: title,
      body: body,
      countryCode: countryCode.isNotEmpty ? countryCode : null,
      countryName: countryName.isNotEmpty ? countryName : null,
      link: link.isNotEmpty ? link : null,
      featuredImageDataURI: _featuredImageDataURI,
      attachmentDataURI: _attachmentDataURI,
    );

    final bool success;
    if (_isEdit) {
      success = await provider.updateCampaign(widget.campaign!.id, entity);
    } else {
      success = await provider.addCampaign(entity);
    }

    if (!mounted) return;

    if (success) {
      showToast(
        context,
        _isEdit
            ? 'Campaign updated successfully!'
            : 'Campaign published successfully!',
      );
      Navigator.of(context).pop(true);
    } else {
      showToast(
        context,
        provider.errorMessage ?? 'Failed to save campaign',
        isError: true,
      );
    }
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: label,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          if (isRequired) ...[
            const SizedBox(width: 4),
            AppText(
              text: '*',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: errorColor,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CampaignProvider>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 860),
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: textPrimaryColor.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Divider(height: 1, thickness: 1, color: borderColor),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Campaign Title *
                        _buildFieldLabel("Campaign Title", isRequired: true),
                        CustomTextField(
                          controller: _titleController,
                          hintText: 'Exclusive November Offer: Get 30% Off!',
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter a campaign title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Target Audience * & Frequency * in responsive row
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 520;
                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildUserTypeDropdown()),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildFrequencyDropdown()),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                _buildUserTypeDropdown(),
                                const SizedBox(height: 16),
                                _buildFrequencyDropdown(),
                              ],
                            );
                          },
                        ),

                        // CRUCIAL LOGIC: Only show weekDay dropdown if frequency == "Weekly"
                        if (_frequency == 'Weekly') ...[
                          const SizedBox(height: 20),
                          _buildWeekDayDropdown(),
                        ],

                        const SizedBox(height: 20),

                        // Campaign Message / Body *
                        _buildFieldLabel("Campaign Message / Body", isRequired: true),
                        CustomTextField(
                          controller: _bodyController,
                          hintText: 'Enter campaign message or promotion details...',
                          maxLines: 4,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter campaign message body';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Country Dropdown (Integrated picker that automatically sets countryCode & countryName)
                        _buildCountryField(),
                        const SizedBox(height: 20),

                        // Target URL / Action Link
                        _buildFieldLabel("Target URL / Action Link", isRequired: false),
                        CustomTextField(
                          controller: _linkController,
                          hintText: 'https://petaccessapp.com/promo',
                          prefixIcon: Icon(
                            Icons.link_rounded,
                            color: textSecondaryColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Featured Banner / Image
                        _buildImagePickerSection(),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(height: 1, thickness: 1, color: borderColor),
              _buildActions(provider),
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
              Icons.campaign_rounded,
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
                  text: _isEdit ? 'Edit Campaign' : 'Create New Campaign',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: _isEdit
                      ? 'Modify campaign targeting, message, or schedule.'
                      : 'Broadcast promotions, notifications, or announcements to portal users.',
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

  Widget _buildUserTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Target Audience", isRequired: true),
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
              value: _userType,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: textSecondaryColor,
              ),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _userType = val);
                }
              },
              items: _userTypes.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value'],
                  child: AppText(
                    text: item['label']!,
                    fontSize: 13,
                    color: textPrimaryColor,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Frequency", isRequired: true),
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
              value: _frequency,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: textSecondaryColor,
              ),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _frequency = val;
                    if (_frequency == 'Weekly' && _weekDay == null) {
                      _weekDay = 1;
                    }
                  });
                }
              },
              items: _frequencies.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value'],
                  child: AppText(
                    text: item['label']!,
                    fontSize: 13,
                    color: textPrimaryColor,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDayDropdown() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 16, color: primaryColor),
              const SizedBox(width: 8),
              AppText(
                text: 'Scheduled Weekday',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              const SizedBox(width: 4),
              AppText(
                text: '*',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: errorColor,
              ),
            ],
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
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _weekDay ?? 1,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: textSecondaryColor,
                ),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _weekDay = val);
                  }
                },
                items: _weekDays.map((item) {
                  return DropdownMenuItem<int>(
                    value: item['value'] as int,
                    child: AppText(
                      text: item['label'] as String,
                      fontSize: 13,
                      color: textPrimaryColor,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Country", isRequired: false),
        AppCountryPickerField(
          hintText: "Select Country",
          radius: 30,
          countryCodeController: _countryCodeController,
          countryNameController: _countryNameController,
          selectedCountryCode: _countryCodeController.text.isNotEmpty
              ? _countryCodeController.text
              : null,
          selectedCountryName: _countryNameController.text.isNotEmpty
              ? _countryNameController.text
              : null,
          onCountryChanged: (name, code) {
            setState(() {
              _countryNameController.text = name;
              _countryCodeController.text = code;
            });
          },
          onCleared: () {
            setState(() {
              _countryNameController.clear();
              _countryCodeController.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildImagePickerSection() {
    final existingImage = widget.campaign?.featuredImage;
    final hasNewImage = _featuredFileBytes != null;
    final hasExistingImage = existingImage != null &&
        existingImage.isNotEmpty &&
        _featuredImageDataURI != '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Featured Banner / Image", isRequired: false),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasNewImage
                    ? Image.memory(_featuredFileBytes!, fit: BoxFit.cover)
                    : (hasExistingImage
                        ? Image.network(
                            existingImage.startsWith('http')
                                ? existingImage
                                : "${ApiEndpoints.storageBaseUrl}/$existingImage",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: textSecondaryColor,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              color: textSecondaryColor,
                              size: 26,
                            ),
                          )),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: _featuredFileName ??
                          (hasExistingImage
                              ? 'Existing campaign banner'
                              : 'No banner chosen'),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    AppText(
                      text: 'Optional visual banner for push/in-app campaign',
                      fontSize: 11,
                      color: textSecondaryColor,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CustomButton(
                          text: _isPickingImage ? 'Selecting...' : 'Select Banner',
                          height: 34,
                          fontSize: 12,
                          isOutlined: true,
                          textColor: primaryColor,
                          buttonBorder: Border.all(color: primaryColor),
                          isLoading: _isPickingImage,
                          onTap: _pickImage,
                        ),
                        if (hasNewImage || hasExistingImage) ...[
                          const SizedBox(width: 8),
                          CustomButton(
                            text: 'Remove',
                            height: 34,
                            fontSize: 12,
                            isOutlined: true,
                            textColor: errorColor,
                            buttonBorder: Border.all(color: errorColor),
                            onTap: _clearImage,
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

  Widget _buildActions(CampaignProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            text: 'Cancel',
            height: 42,
            width: 110,
            fontSize: 13,
            isOutlined: true,
            textColor: textSecondaryColor,
            buttonBorder: Border.all(color: borderColor),
            onTap: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(width: 12),
          CustomButton(
            text: _isEdit ? 'Save Changes' : 'Create Campaign',
            height: 42,
            width: 150,
            fontSize: 13,
            isLoading: provider.isActionLoading,
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}

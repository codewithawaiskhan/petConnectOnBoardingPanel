import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_text.dart';
import '../../../../core/presentation/widgets/custom_button.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
import '../../../../core/utils/mini_functions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../../shared/presentation/widgets/custom_date_picker_field.dart';
import '../../domain/entities/pet_parent_entity.dart';
import '../providers/pet_parents_list_provider.dart';

class EditPetParentDialog extends StatefulWidget {
  final PetParentItemEntity parent;

  const EditPetParentDialog({super.key, required this.parent});

  static Future<bool?> show(
    BuildContext context, {
    PetParentItemEntity? parent,
    PetParentItemEntity? petParent,
  }) {
    final item = petParent ?? parent;
    assert(item != null, 'parent or petParent must be provided');
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditPetParentDialog(parent: item!),
    );
  }

  @override
  State<EditPetParentDialog> createState() => _EditPetParentDialogState();
}

class _EditPetParentDialogState extends State<EditPetParentDialog>
    with AppColors {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _provinceController;
  late final TextEditingController _countryCodeController;
  late final TextEditingController _countryNameController;

  String? _selectedImageDataURI;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    final p = widget.parent;
    _fullNameController = TextEditingController(text: p.fullName ?? '');
    _fullNameController.addListener(_onFieldChanged);
    _phoneController = TextEditingController(text: p.phone ?? '');
    _dobController = TextEditingController(
      text: MiniFunctions().formatDateToYMD(p.dateOfBirth),
    );
    _addressController = TextEditingController(text: p.address ?? '');
    _cityController = TextEditingController(text: p.city ?? '');
    _provinceController = TextEditingController(text: p.province ?? '');
    _countryCodeController = TextEditingController(
      text: p.countryCode ?? 'PK',
    );
    _countryNameController = TextEditingController(
      text: p.countryName ?? 'Pakistan',
    );
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _fullNameController.removeListener(_onFieldChanged);
    _fullNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _countryCodeController.dispose();
    _countryNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);
    try {
      final FilePickerResult? picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
        withData: true,
      );

      if (picked != null && picked.files.isNotEmpty) {
        final platformFile = picked.files.first;
        final bytes = platformFile.bytes;
        if (bytes != null) {
          final base64String = base64Encode(bytes);
          final extension = (platformFile.extension ?? 'jpeg').toLowerCase();
          final mime = 'image/$extension';
          setState(() {
            _selectedImageDataURI = 'data:$mime;base64,$base64String';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        showToast(context, "Failed to pick image: $e", isError: true);
      }
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  Widget _buildProfileCard(bool isNarrow) {
    final parent = widget.parent;
    final currentName = _fullNameController.text.trim();
    final displayName = currentName.isNotEmpty
        ? currentName
        : (parent.fullName?.trim().isNotEmpty == true
            ? parent.fullName!.trim()
            : "Pet Parent");
    final initial = displayName.isNotEmpty
        ? displayName.substring(0, 1).toUpperCase()
        : "P";
    final displayId = parent.longAutoIncrementId ??
        (parent.autoIncrementId != null ? "#${parent.autoIncrementId}" : "N/A");
    final displayEmail = parent.email?.trim().isNotEmpty == true
        ? parent.email!.trim()
        : "No email provided";

    final avatarStack = Stack(
      children: [
        InkWell(
          onTap: _isPickingImage ? null : _pickImage,
          borderRadius: BorderRadius.circular(42),
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.25),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(child: _buildAvatarContent(initial)),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _isPickingImage ? null : _pickImage,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: whiteColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: _isPickingImage
                  ? SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: whiteColor,
                      ),
                    )
                  : Icon(
                      Icons.camera_alt_rounded,
                      color: whiteColor,
                      size: 13,
                    ),
            ),
          ),
        ),
      ],
    );

    final infoColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          text: displayName,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: AppText(
                text: displayId,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            StatusBadge(
              status: parent.user?.status ?? "Active",
              isDeleted: parent.isDeleted,
              fontSize: 10,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.mail_outline_rounded,
              size: 14,
              color: textSecondaryColor,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: AppText(
                text: displayEmail,
                fontSize: 12,
                color: textSecondaryColor,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );

    final actionsRow = Wrap(
      spacing: 10,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        InkWell(
          onTap: _isPickingImage ? null : _pickImage,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isPickingImage) ...[
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                ] else ...[
                  Icon(
                    Icons.upload_file_rounded,
                    size: 14,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 5),
                ],
                AppText(
                  text: _selectedImageDataURI != null
                      ? "Change Photo"
                      : "Upload Photo",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ),
        if (_selectedImageDataURI != null)
          InkWell(
            onTap: () => setState(() => _selectedImageDataURI = null),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: errorColor.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close_rounded, size: 14, color: errorColor),
                  const SizedBox(width: 4),
                  AppText(
                    text: "Remove",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: errorColor,
                  ),
                ],
              ),
            ),
          ),
        AppText(
          text: "JPG, PNG or WEBP (Max 5MB)",
          fontSize: 11,
          color: textSecondaryColor,
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              avatarStack,
              const SizedBox(width: 16),
              Expanded(child: infoColumn),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: primaryColor.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 12),
          actionsRow,
        ],
      ),
    );
  }

  Widget _buildAvatarContent(String initial) {
    if (_selectedImageDataURI != null) {
      try {
        final cleanBase64 = _selectedImageDataURI!.contains(',')
            ? _selectedImageDataURI!.split(',').last
            : _selectedImageDataURI!;
        return Image.memory(
          base64Decode(cleanBase64),
          width: 76,
          height: 76,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildInitialsAvatar(initial),
        );
      } catch (_) {
        return _buildInitialsAvatar(initial);
      }
    } else if (widget.parent.user?.image != null &&
        widget.parent.user!.image!.trim().isNotEmpty) {
      final imageUrl = MiniFunctions.getImageUrl(widget.parent.user!.image!);
      return Image.network(
        imageUrl,
        width: 76,
        height: 76,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildInitialsAvatar(initial),
      );
    } else {
      return _buildInitialsAvatar(initial);
    }
  }

  Widget _buildInitialsAvatar(String initial) {
    return Container(
      width: 76,
      height: 76,
      color: primaryColor.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: AppText(
        text: initial,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    );
  }

  Future<void> _handleSubmit(PetParentsListProvider provider) async {
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final dob = _dobController.text.trim();
    final address = _addressController.text.trim();
    final city = _cityController.text.trim();
    final province = _provinceController.text.trim();
    final countryCode = _countryCodeController.text.trim();
    final countryName = _countryNameController.text.trim();

    final entity = UpdatePetParentEntity(
      imageDataURI: _selectedImageDataURI,
      fullName: fullName.isNotEmpty ? fullName : null,
      phone: phone.isNotEmpty ? phone : null,
      dateOfBirth: dob.isNotEmpty ? dob : null,
      address: address.isNotEmpty ? address : null,
      city: city.isNotEmpty ? city : null,
      province: province.isNotEmpty ? province : null,
      countryCode: countryCode.isNotEmpty ? countryCode : null,
      countryName: countryName.isNotEmpty ? countryName : null,
    );

    final success = await provider.updatePetParent(
      context: context,
      id: widget.parent.id,
      entity: entity,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PetParentsListProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768;
    final dialogWidth = isDesktop ? 580.0 : (screenWidth * 0.95);
    final isNarrow = dialogWidth < 480;

    return Dialog(
      backgroundColor: whiteColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: dialogWidth,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.edit_rounded, color: primaryColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "Edit Pet Parent",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textPrimaryColor,
                            ),
                            AppText(
                              text: widget.parent.longAutoIncrementId ??
                                  widget.parent.email ??
                                  widget.parent.id,
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: textSecondaryColor),
                        tooltip: "Close",
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileCard(isNarrow),
                        const SizedBox(height: 20),
                        if (isNarrow) ...[
                          CustomTextField(
                            controller: _fullNameController,
                            title: "Full Name",
                            hintText: "Enter full name",
                            prefixIcon: Icon(Icons.person_outline_rounded, size: 18, color: textSecondaryColor),
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            controller: _phoneController,
                            title: "Phone Number",
                            hintText: "e.g. +923007777777",
                            prefixIcon: Icon(Icons.phone_outlined, size: 18, color: textSecondaryColor),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _fullNameController,
                                  title: "Full Name",
                                  hintText: "Enter full name",
                                  prefixIcon: Icon(Icons.person_outline_rounded, size: 18, color: textSecondaryColor),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: CustomTextField(
                                  controller: _phoneController,
                                  title: "Phone Number",
                                  hintText: "e.g. +923007777777",
                                  prefixIcon: Icon(Icons.phone_outlined, size: 18, color: textSecondaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 14),
                        CustomDatePickerField(
                          controller: _dobController,
                          title: "Date of Birth",
                          hintText: "YYYY-MM-DD",
                          prefixIcon: Icon(Icons.cake_outlined, size: 18, color: textSecondaryColor),
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _addressController,
                          title: "Address",
                          hintText: "Enter residential address",
                          prefixIcon: Icon(Icons.home_outlined, size: 18, color: textSecondaryColor),
                        ),
                        const SizedBox(height: 14),
                        if (isNarrow) ...[
                          CustomTextField(
                            controller: _cityController,
                            title: "City",
                            hintText: "e.g. Multan",
                            prefixIcon: Icon(Icons.location_city_outlined, size: 18, color: textSecondaryColor),
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            controller: _provinceController,
                            title: "Province / State",
                            hintText: "e.g. Punjab",
                            prefixIcon: Icon(Icons.map_outlined, size: 18, color: textSecondaryColor),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _cityController,
                                  title: "City",
                                  hintText: "e.g. Multan",
                                  prefixIcon: Icon(Icons.location_city_outlined, size: 18, color: textSecondaryColor),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: CustomTextField(
                                  controller: _provinceController,
                                  title: "Province / State",
                                  hintText: "e.g. Punjab",
                                  prefixIcon: Icon(Icons.map_outlined, size: 18, color: textSecondaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 14),
                        if (isNarrow) ...[
                          CustomTextField(
                            controller: _countryCodeController,
                            title: "Country Code",
                            hintText: "e.g. PK",
                            prefixIcon: Icon(Icons.flag_outlined, size: 18, color: textSecondaryColor),
                          ),
                          const SizedBox(height: 14),
                          CustomTextField(
                            controller: _countryNameController,
                            title: "Country Name",
                            hintText: "e.g. Pakistan",
                            prefixIcon: Icon(Icons.public_outlined, size: 18, color: textSecondaryColor),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _countryCodeController,
                                  title: "Country Code",
                                  hintText: "e.g. PK",
                                  prefixIcon: Icon(Icons.flag_outlined, size: 18, color: textSecondaryColor),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: CustomTextField(
                                  controller: _countryNameController,
                                  title: "Country Name",
                                  hintText: "e.g. Pakistan",
                                  prefixIcon: Icon(Icons.public_outlined, size: 18, color: textSecondaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    border: Border(top: BorderSide(color: borderColor)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: "Cancel",
                        width: 100,
                        height: 42,
                        fontSize: 13,
                        radius: 8,
                        isOutlined: true,
                        textColor: textSecondaryColor,
                        onTap: provider.isUpdating
                            ? null
                            : () => Navigator.of(context).pop(false),
                      ),
                      const SizedBox(width: 12),
                      CustomButton(
                        text: "Save Changes",
                        width: 130,
                        height: 42,
                        fontSize: 13,
                        radius: 8,
                        fillColor: primaryColor,
                        textColor: whiteColor,
                        isLoading: provider.isUpdating,
                        onTap: provider.isUpdating
                            ? null
                            : () => _handleSubmit(provider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

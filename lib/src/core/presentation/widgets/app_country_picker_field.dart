import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_countries.dart';
import 'app_text.dart';
import 'custom_text_field.dart';

class AppCountryPickerField extends StatefulWidget {
  final String? title;
  final String? selectedCountryCode;
  final String? selectedCountryName;
  final ValueChanged<AppCountry>? onCountrySelected;
  final void Function(String countryName, String countryCode)? onCountryChanged;
  final VoidCallback? onCleared;
  final String? hintText;
  final bool isRequired;
  final String? Function(String?)? validator;
  final bool isEnable;
  final double? width;
  final double? height;
  final double radius;
  final Color? fillColor;
  final bool hasBorder;
  final TextEditingController? countryCodeController;
  final TextEditingController? countryNameController;
  final bool isFilterMode;

  const AppCountryPickerField({
    super.key,
    this.title,
    this.selectedCountryCode,
    this.selectedCountryName,
    this.onCountrySelected,
    this.onCountryChanged,
    this.onCleared,
    this.hintText,
    this.isRequired = false,
    this.validator,
    this.isEnable = true,
    this.width,
    this.height,
    this.radius = 8,
    this.fillColor,
    this.hasBorder = true,
    this.countryCodeController,
    this.countryNameController,
    this.isFilterMode = false,
  });

  @override
  State<AppCountryPickerField> createState() => _AppCountryPickerFieldState();
}

class _AppCountryPickerFieldState extends State<AppCountryPickerField>
    with AppColors {
  late final TextEditingController _displayController;
  AppCountry? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _resolveInitialCountry();
    _displayController =
        TextEditingController(text: _formatDisplayText(_selectedCountry));

    widget.countryCodeController?.addListener(_handleExternalControllerChange);
    widget.countryNameController?.addListener(_handleExternalControllerChange);
  }

  @override
  void didUpdateWidget(covariant AppCountryPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.countryCodeController != oldWidget.countryCodeController) {
      oldWidget.countryCodeController
          ?.removeListener(_handleExternalControllerChange);
      widget.countryCodeController
          ?.addListener(_handleExternalControllerChange);
    }
    if (widget.countryNameController != oldWidget.countryNameController) {
      oldWidget.countryNameController
          ?.removeListener(_handleExternalControllerChange);
      widget.countryNameController
          ?.addListener(_handleExternalControllerChange);
    }

    if (widget.selectedCountryCode != oldWidget.selectedCountryCode ||
        widget.selectedCountryName != oldWidget.selectedCountryName) {
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    widget.countryCodeController
        ?.removeListener(_handleExternalControllerChange);
    widget.countryNameController
        ?.removeListener(_handleExternalControllerChange);
    _displayController.dispose();
    super.dispose();
  }

  void _handleExternalControllerChange() {
    final currentCode = _selectedCountry?.code.toUpperCase();
    final externalCode =
        widget.countryCodeController?.text.trim().toUpperCase();
    if (externalCode != null &&
        externalCode.isNotEmpty &&
        externalCode != currentCode) {
      _syncFromProps();
    }
  }

  void _syncFromProps() {
    final resolved = _resolveInitialCountry();
    if (resolved != _selectedCountry) {
      setState(() {
        _selectedCountry = resolved;
        _displayController.text = _formatDisplayText(resolved);
      });
    }
  }

  AppCountry? _resolveInitialCountry() {
    final code = (widget.selectedCountryCode != null &&
            widget.selectedCountryCode!.trim().isNotEmpty)
        ? widget.selectedCountryCode!.trim().toUpperCase()
        : (widget.countryCodeController != null &&
                widget.countryCodeController!.text.trim().isNotEmpty)
            ? widget.countryCodeController!.text.trim().toUpperCase()
            : null;

    final name = (widget.selectedCountryName != null &&
            widget.selectedCountryName!.trim().isNotEmpty)
        ? widget.selectedCountryName!.trim()
        : (widget.countryNameController != null &&
                widget.countryNameController!.text.trim().isNotEmpty)
            ? widget.countryNameController!.text.trim()
            : null;

    if (code != null && code.isNotEmpty) {
      final found = AppCountries.findByCode(code);
      if (found != null) return found;
    }

    if (name != null && name.isNotEmpty) {
      for (final c in AppCountries.countries) {
        if (c.name.toLowerCase() == name.toLowerCase()) {
          return c;
        }
      }
    }

    if (code != null || name != null) {
      return AppCountry(
        code: code ?? '',
        name: name ?? (code ?? ''),
        flag: AppCountries.getFlag(code),
      );
    }

    return null;
  }

  String _formatDisplayText(AppCountry? country) {
    if (country == null || country.code.isEmpty) return "";
    return "${country.flag}  ${country.name} (${country.code})";
  }

  Future<void> _handleTap(BuildContext context) async {
    if (!widget.isEnable) return;

    final picked = await showDialog<AppCountry>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => _CountrySelectionDialog(
        initialCountryCode: _selectedCountry?.code,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedCountry = picked;
        _displayController.text = _formatDisplayText(picked);
      });

      if (widget.countryCodeController != null) {
        widget.countryCodeController!.text = picked.code;
      }
      if (widget.countryNameController != null) {
        widget.countryNameController!.text = picked.name;
      }
      widget.onCountrySelected?.call(picked);
      widget.onCountryChanged?.call(picked.name, picked.code);
    }
  }

  void _handleClear() {
    setState(() {
      _selectedCountry = null;
      _displayController.clear();
    });
    if (widget.countryCodeController != null) {
      widget.countryCodeController!.clear();
    }
    if (widget.countryNameController != null) {
      widget.countryNameController!.clear();
    }
    widget.onCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    final country = _selectedCountry ?? _resolveInitialCountry();
    final hasSelection = country != null && country.code.isNotEmpty;

    if (widget.isFilterMode) {
      return Container(
        height: widget.height ?? 44,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.fillColor ?? whiteColor,
          borderRadius: BorderRadius.circular(widget.radius),
          border: widget.hasBorder
              ? Border.all(
                  color: hasSelection ? primaryColor : borderColor,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.radius),
            onTap: () => _handleTap(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.public_rounded,
                    size: 17,
                    color: hasSelection ? primaryColor : textSecondaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppText(
                      text: hasSelection
                          ? "${country.flag} ${country.name}"
                          : (widget.hintText ?? "Select Country"),
                      fontSize: 13,
                      fontWeight:
                          hasSelection ? FontWeight.w600 : FontWeight.w400,
                      color:
                          hasSelection ? textPrimaryColor : textSecondaryColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasSelection && widget.onCleared != null) ...[
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: textSecondaryColor,
                      ),
                      onPressed: _handleClear,
                    ),
                  ] else ...[
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: textSecondaryColor,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    return CustomTextField(
      title: widget.title,
      hintText: widget.hintText ?? "Select Country",
      readOnly: true,
      isEnable: widget.isEnable,
      radius: widget.radius,
      width: widget.width,
      fillColor: widget.fillColor,
      hasBorder: widget.hasBorder,
      controller: _displayController,
      onTap: () => _handleTap(context),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: hasSelection
            ? AppText(text: country.flag, fontSize: 18)
            : Icon(
                Icons.public_rounded,
                size: 18,
                color: textSecondaryColor,
              ),
      ),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasSelection && widget.onCleared != null)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                Icons.close_rounded,
                size: 16,
                color: textSecondaryColor,
              ),
              onPressed: _handleClear,
            ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: textSecondaryColor,
          ),
          const SizedBox(width: 8),
        ],
      ),
      validator: widget.validator ??
          (widget.isRequired
              ? (val) => !hasSelection ? "Please select a country" : null
              : null),
    );
  }
}

class _CountrySelectionDialog extends StatefulWidget {
  final String? initialCountryCode;

  const _CountrySelectionDialog({
    this.initialCountryCode,
  });

  @override
  State<_CountrySelectionDialog> createState() =>
      _CountrySelectionDialogState();
}

class _CountrySelectionDialogState extends State<_CountrySelectionDialog>
    with AppColors {
  late final TextEditingController _searchController;
  late List<AppCountry> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCountries = List<AppCountry>.from(AppCountries.countries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredCountries = List<AppCountry>.from(AppCountries.countries);
      } else {
        _filteredCountries = AppCountries.countries.where((c) {
          return c.name.toLowerCase().contains(q) ||
              c.code.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCode = widget.initialCountryCode?.trim().toUpperCase();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 600),
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 14, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.public_rounded,
                        size: 20,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "Select Country",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            text: "Pick a country to auto-fill name & code",
                            fontSize: 12,
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
                      tooltip: "Close",
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Search Box
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: CustomTextField(
                  controller: _searchController,
                  hintText: "Search country or ISO code (e.g. US, United States)...",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: textSecondaryColor,
                  ),
                  onChanged: _onSearchChanged,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            size: 16,
                            color: textSecondaryColor,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                ),
              ),

              // Country List
              Flexible(
                child: _filteredCountries.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 40,
                              color: textSecondaryColor.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            AppText(
                              text: "No countries found matching your search",
                              fontSize: 13,
                              color: textSecondaryColor,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        itemCount: _filteredCountries.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final country = _filteredCountries[index];
                          final isSelected = country.code == selectedCode;

                          return Material(
                            color: isSelected
                                ? primaryColor.withValues(alpha: 0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => Navigator.of(context).pop(country),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    AppText(
                                      text: country.flag,
                                      fontSize: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AppText(
                                        text: country.name,
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? primaryColor
                                            : textPrimaryColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? primaryColor.withValues(alpha: 0.15)
                                            : primaryColor.withValues(alpha: 0.06),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isSelected
                                              ? primaryColor
                                              : primaryColor.withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: AppText(
                                        text: country.code,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: primaryColor,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 18,
                                        color: primaryColor,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

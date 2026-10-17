import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/presentation/widgets/app_text.dart';
import '../../../core/presentation/widgets/custom_button.dart';
import '../../../core/presentation/widgets/custom_text_field.dart';

class DirectoryFilterBar extends StatelessWidget {
  final String? fromDate;
  final String? toDate;
  final String? countryCode;
  final void Function({
    String? fromDate,
    String? toDate,
    String? countryCode,
  }) onApply;
  final VoidCallback onClear;
  final bool isLoading;

  const DirectoryFilterBar({
    super.key,
    this.fromDate,
    this.toDate,
    this.countryCode,
    required this.onApply,
    required this.onClear,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return _DirectoryFilterBarContent(
      fromDate: fromDate,
      toDate: toDate,
      countryCode: countryCode,
      onApply: onApply,
      onClear: onClear,
      isLoading: isLoading,
    );
  }
}

class _DirectoryFilterBarContent extends StatefulWidget {
  final String? fromDate;
  final String? toDate;
  final String? countryCode;
  final void Function({
    String? fromDate,
    String? toDate,
    String? countryCode,
  }) onApply;
  final VoidCallback onClear;
  final bool isLoading;

  const _DirectoryFilterBarContent({
    required this.fromDate,
    required this.toDate,
    required this.countryCode,
    required this.onApply,
    required this.onClear,
    required this.isLoading,
  });

  @override
  State<_DirectoryFilterBarContent> createState() =>
      _DirectoryFilterBarContentState();
}

class _DirectoryFilterBarContentState extends State<_DirectoryFilterBarContent>
    with AppColors {
  late final TextEditingController _fromController;
  late final TextEditingController _toController;
  late final TextEditingController _countryController;

  DateTime? _fromDate;
  DateTime? _toDate;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController(text: widget.fromDate ?? '');
    _toController = TextEditingController(text: widget.toDate ?? '');
    _countryController = TextEditingController(text: widget.countryCode ?? '');
    _parseInitialDates();
  }

  void _parseInitialDates() {
    if (widget.fromDate != null && widget.fromDate!.isNotEmpty) {
      try {
        _fromDate = DateTime.parse(widget.fromDate!);
      } catch (_) {
        _fromDate = null;
      }
    } else {
      _fromDate = null;
    }

    if (widget.toDate != null && widget.toDate!.isNotEmpty) {
      try {
        _toDate = DateTime.parse(widget.toDate!);
      } catch (_) {
        _toDate = null;
      }
    } else {
      _toDate = null;
    }
  }

  @override
  void didUpdateWidget(covariant _DirectoryFilterBarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fromDate != oldWidget.fromDate) {
      _fromController.text = widget.fromDate ?? '';
    }
    if (widget.toDate != oldWidget.toDate) {
      _toController.text = widget.toDate ?? '';
    }
    if (widget.countryCode != oldWidget.countryCode) {
      _countryController.text = widget.countryCode ?? '';
    }
    _parseInitialDates();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters {
    return _fromController.text.trim().isNotEmpty ||
        _toController.text.trim().isNotEmpty ||
        _countryController.text.trim().isNotEmpty;
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_fromController.text.trim().isNotEmpty) count++;
    if (_toController.text.trim().isNotEmpty) count++;
    if (_countryController.text.trim().isNotEmpty) count++;
    return count;
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = _fromDate ?? now;
    final first = DateTime(2000);
    final last = _toDate ?? DateTime(2100);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(last) ? last : (initial.isBefore(first) ? first : initial),
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              surface: whiteColor,
              onSurface: textPrimaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked;
        _fromController.text = _dateFormat.format(picked);
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final now = DateTime.now();
    final first = _fromDate ?? DateTime(2000);
    final initial = _toDate ?? now;
    final last = DateTime(2100);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : (initial.isAfter(last) ? last : initial),
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              surface: whiteColor,
              onSurface: textPrimaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _toDate = picked;
        _toController.text = _dateFormat.format(picked);
      });
    }
  }

  void _handleApply() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();
    final country = _countryController.text.trim();

    widget.onApply(
      fromDate: from.isEmpty ? null : from,
      toDate: to.isEmpty ? null : to,
      countryCode: country.isEmpty ? null : country,
    );
  }

  void _handleClear() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _fromController.clear();
      _toController.clear();
      _countryController.clear();
    });
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (width >= 960) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(
                      width: 180,
                      child: _buildFromDateField(context),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 180,
                      child: _buildToDateField(context),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildCountryNameField(),
                    ),
                    const SizedBox(width: 12),
                    _buildApplyButton(),
                    const SizedBox(width: 8),
                    _buildClearButton(),
                  ],
                ),
              ],
            );
          } else if (width >= 620) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildFromDateField(context)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildToDateField(context)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildCountryNameField()),
                    const SizedBox(width: 10),
                    _buildApplyButton(),
                    const SizedBox(width: 8),
                    _buildClearButton(),
                  ],
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildFromDateField(context),
                const SizedBox(height: 10),
                _buildToDateField(context),
                const SizedBox(height: 10),
                _buildCountryNameField(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildApplyButton(isFullWidth: true)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildClearButton(isFullWidth: true)),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Icons.tune_rounded,
            size: 15,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        AppText(
          text: "Filter By Date Range & Country",
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: fontPoppins,
          color: textPrimaryColor,
        ),
        if (_hasActiveFilters) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: AppText(
              text: "$_activeFiltersCount active",
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: fontPoppins,
              color: primaryColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFromDateField(BuildContext context) {
    final hasVal = _fromController.text.trim().isNotEmpty;

    return CustomTextField(
      controller: _fromController,
      hintText: "From Date",
      readOnly: true,
      onTap: widget.isLoading ? null : () => _selectFromDate(context),
      isIcon: true,
      radius: 8,
      prefixIcon: Icon(
        Icons.calendar_today_outlined,
        size: 16,
        color: hasVal ? primaryColor : textSecondaryColor,
      ),
      suffixIcon: hasVal
          ? IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 16,
                color: textSecondaryColor,
              ),
              onPressed: () {
                setState(() {
                  _fromDate = null;
                  _fromController.clear();
                });
              },
            )
          : null,
    );
  }

  Widget _buildToDateField(BuildContext context) {
    final hasVal = _toController.text.trim().isNotEmpty;

    return CustomTextField(
      controller: _toController,
      hintText: "To Date",
      readOnly: true,
      onTap: widget.isLoading ? null : () => _selectToDate(context),
      isIcon: true,
      radius: 8,
      prefixIcon: Icon(
        Icons.event_outlined,
        size: 16,
        color: hasVal ? primaryColor : textSecondaryColor,
      ),
      suffixIcon: hasVal
          ? IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 16,
                color: textSecondaryColor,
              ),
              onPressed: () {
                setState(() {
                  _toDate = null;
                  _toController.clear();
                });
              },
            )
          : null,
    );
  }

  Widget _buildCountryNameField() {
    final hasVal = _countryController.text.trim().isNotEmpty;

    return CustomTextField(
      controller: _countryController,
      hintText: "Country Name (e.g. Pakistan, United States)",
      isIcon: true,
      radius: 8,
      prefixIcon: Icon(
        Icons.public_rounded,
        size: 17,
        color: hasVal ? primaryColor : textSecondaryColor,
      ),
      suffixIcon: hasVal
          ? IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 16,
                color: textSecondaryColor,
              ),
              onPressed: () {
                setState(() {
                  _countryController.clear();
                });
              },
            )
          : null,
      onChanged: (_) {
        if (mounted) setState(() {});
      },
    );
  }

  Widget _buildApplyButton({bool isFullWidth = false}) {
    return CustomButton(
      text: "Apply Filter",
      height: 44,
      width: isFullWidth ? double.infinity : 115,
      radius: 8,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      isIcon: true,
      icon: Icon(Icons.filter_alt_rounded, size: 16, color: whiteColor),
      fillColor: primaryColor,
      textColor: whiteColor,
      isLoading: widget.isLoading,
      onTap: widget.isLoading ? null : _handleApply,
    );
  }

  Widget _buildClearButton({bool isFullWidth = false}) {
    return CustomButton(
      text: "Clear Filter",
      height: 44,
      width: isFullWidth ? double.infinity : 110,
      radius: 8,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      isOutlined: true,
      isIcon: true,
      icon: Icon(Icons.refresh_rounded, size: 16, color: primaryColor),
      onTap: widget.isLoading ? null : _handleClear,
    );
  }
}

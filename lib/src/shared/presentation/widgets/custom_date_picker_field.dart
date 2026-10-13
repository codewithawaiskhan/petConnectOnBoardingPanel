import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/widgets/custom_text_field.dart';

class CustomDatePickerField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<String>? onChanged;
  final ValueChanged<DateTime>? onDateSelected;
  final FormFieldValidator<String>? validator;
  final bool isEnable;
  final Color? fillColor;
  final double radius;
  final double? width;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final DateFormat? dateFormat;

  const CustomDatePickerField({
    super.key,
    this.title,
    this.hintText,
    this.initialValue,
    this.controller,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.onDateSelected,
    this.validator,
    this.isEnable = true,
    this.fillColor,
    this.radius = 30,
    this.width,
    this.prefixIcon,
    this.suffixIcon,
    this.dateFormat,
  });

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField>
    with AppColors {
  late final TextEditingController _effectiveController;
  bool _isLocalController = false;
  late final DateFormat _formatter;

  @override
  void initState() {
    super.initState();
    _formatter = widget.dateFormat ?? DateFormat('yyyy-MM-dd');
    if (widget.controller != null) {
      _effectiveController = widget.controller!;
      if (widget.initialValue != null &&
          widget.initialValue!.isNotEmpty &&
          _effectiveController.text.isEmpty) {
        _effectiveController.text = widget.initialValue!;
      }
    } else {
      _isLocalController = true;
      _effectiveController = TextEditingController(
        text: widget.initialValue ?? '',
      );
    }
  }

  @override
  void didUpdateWidget(covariant CustomDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null &&
        widget.initialValue != _effectiveController.text) {
      _effectiveController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (_isLocalController) {
      _effectiveController.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate() async {
    if (!widget.isEnable) return;

    final now = DateTime.now();
    final first = widget.firstDate ?? DateTime(1900);
    final last = widget.lastDate ?? DateTime(2100);

    DateTime initial = now;
    if (_effectiveController.text.trim().isNotEmpty) {
      try {
        initial = _formatter.parseStrict(_effectiveController.text.trim());
      } catch (_) {
        try {
          initial = DateTime.parse(_effectiveController.text.trim());
        } catch (_) {
          initial = now;
        }
      }
    }

    if (initial.isBefore(first)) {
      initial = first;
    }
    if (initial.isAfter(last)) {
      initial = last;
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
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

    if (pickedDate != null) {
      final formatted = _formatter.format(pickedDate);
      _effectiveController.text = formatted;
      widget.onChanged?.call(formatted);
      widget.onDateSelected?.call(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      title: widget.title,
      hintText: widget.hintText ?? 'YYYY-MM-DD',
      controller: _effectiveController,
      readOnly: true,
      onTap: _selectDate,
      isEnable: widget.isEnable,
      fillColor: widget.fillColor,
      radius: widget.radius,
      width: widget.width,
      prefixIcon: widget.prefixIcon,
      suffixIcon:
          widget.suffixIcon ??
          IconButton(
            icon: Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: textSecondaryColor,
            ),
            onPressed: widget.isEnable ? _selectDate : null,
          ),
      validator: widget.validator,
    );
  }
}

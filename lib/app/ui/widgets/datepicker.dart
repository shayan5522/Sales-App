import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoporbit/app/themes/colors.dart';
import 'package:shoporbit/app/themes/styles.dart';

class CustomDatePicker extends StatefulWidget {
  final String? label;
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;
  final DateTime? firstDate;  // New optional parameter
  final DateTime? lastDate;   // New optional parameter
  final bool restrictToToday; // New optional parameter

  const CustomDatePicker({
    super.key,
    this.label,
    required this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.restrictToToday = false, // Default to false for backward compatibility
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  Future<void> _pickDate() async {
    final DateTime effectiveFirstDate = widget.firstDate ?? DateTime(2000);
    final DateTime effectiveLastDate = widget.restrictToToday
        ? DateTime.now()
        : widget.lastDate ?? DateTime(2100);

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: effectiveFirstDate,
      lastDate: effectiveLastDate,
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            height: 40,
            width: 140,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
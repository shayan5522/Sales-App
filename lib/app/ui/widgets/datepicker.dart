import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salesapp/app/themes/colors.dart';
import 'package:salesapp/app/themes/styles.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : 'dd/mm/yyyy';

    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.textseconadry,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 22,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 18,
                    color: selectedDate != null ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

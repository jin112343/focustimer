import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class TimePickerDialog extends StatefulWidget {
  final String title;
  final int currentValue;
  final Function(int) onChanged;

  const TimePickerDialog({
    super.key,
    required this.title,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  State<TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: GoogleFonts.notoSans(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '時間を選択してください',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppColors.textColor.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: ListWheelScrollView(
              itemExtent: 50,
              children: List.generate(60, (index) {
                final value = index + 1;
                final isSelected = value == selectedValue;
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${value}分',
                    style: GoogleFonts.notoSans(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : AppColors.textColor,
                    ),
                  ),
                );
              }),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedValue = index + 1;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'キャンセル',
            style: GoogleFonts.notoSans(),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onChanged(selectedValue);
            Navigator.of(context).pop();
          },
          child: Text(
            'OK',
            style: GoogleFonts.notoSans(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
} 
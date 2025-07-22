import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class TimePickerDialog extends StatefulWidget {
  final String title;
  final int currentMinutes;
  final int currentSeconds;
  final Function(int minutes, int seconds) onChanged;

  const TimePickerDialog({
    super.key,
    required this.title,
    required this.currentMinutes,
    required this.currentSeconds,
    required this.onChanged,
  });

  @override
  State<TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  late int selectedMinutes;
  late int selectedSeconds;

  @override
  void initState() {
    super.initState();
    selectedMinutes = widget.currentMinutes;
    selectedSeconds = widget.currentSeconds;
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
            '分と秒を選択してください',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppColors.textColor.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 150,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 40,
                  controller: FixedExtentScrollController(initialItem: selectedMinutes),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedMinutes = index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index == null || index < 0 || index >= 60) return null;
                      return Center(
                        child: Text('$index分',
                          style: GoogleFonts.notoSans(
                            fontSize: 18,
                            fontWeight: selectedMinutes == index ? FontWeight.bold : FontWeight.normal,
                            color: selectedMinutes == index ? AppColors.primaryColor : AppColors.textColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                height: 150,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 40,
                  controller: FixedExtentScrollController(initialItem: selectedSeconds),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedSeconds = index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index == null || index < 0 || index >= 60) return null;
                      return Center(
                        child: Text('$index秒',
                          style: GoogleFonts.notoSans(
                            fontSize: 18,
                            fontWeight: selectedSeconds == index ? FontWeight.bold : FontWeight.normal,
                            color: selectedSeconds == index ? AppColors.primaryColor : AppColors.textColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
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
            widget.onChanged(selectedMinutes, selectedSeconds);
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
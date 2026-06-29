import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

class DateSelector extends StatelessWidget {
  final List<Map<String, dynamic>> dates;
  final int selectedDate;
  final Function(int) onDateSelected;
  final VoidCallback onCalendarTap;

  const DateSelector({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(72),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length + 1,
        itemBuilder: (context, index) {
          if (index == dates.length) {
            return GestureDetector(
              onTap: onCalendarTap,
              child: Container(
                width: context.w(72),
                margin: EdgeInsets.only(left: context.w(16)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE9E9E9),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.calendar_today, size: context.w(18)),
                ),
              ),
            );
          }

          bool selected = selectedDate == index;

          return GestureDetector(
            onTap: () => onDateSelected(index),
            child: Container(
              width: context.w(72),
              margin: EdgeInsets.only(left: context.w(16)),
              padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(8)),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFFFFBF0) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFFFCB2F)
                      : const Color(0xFFE9E9E9),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dates[index]["day"]!,
                    style: TextStyle(
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: context.h(2)),
                  Text(
                    dates[index]["date"]!,
                    style: TextStyle(
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

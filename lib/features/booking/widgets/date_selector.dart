import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final List<Map<String, String>> dates;
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
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length + 1,
        itemBuilder: (context, index) {
          if (index == dates.length) {
            return GestureDetector(
              onTap: onCalendarTap,
              child: Container(
                width: 90,
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE9E9E9),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.calendar_today, size: 20),
                ),
              ),
            );
          }

          bool selected = selectedDate == index;

          return GestureDetector(
            onTap: () => onDateSelected(index),
            child: Container(
              width: 90,
              margin: const EdgeInsets.only(left: 16),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFFFFBF0) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFFFCB2F)
                      : const Color(0xFFE9E9E9),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dates[index]["day"]!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dates[index]["date"]!,
                    style: const TextStyle(
                      fontSize: 14,
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

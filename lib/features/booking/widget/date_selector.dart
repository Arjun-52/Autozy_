import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final List<Map<String, String>> dates;
  final int selectedDate;
  final Function(int) onDateSelected;

  const DateSelector({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          bool selected = selectedDate == index;

          return GestureDetector(
            onTap: () => onDateSelected(index),
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: selected ? const Color(0xffF5E6C8) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? Colors.orange : Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dates[index]["day"]!),
                  const SizedBox(height: 4),
                  Text(
                    dates[index]["date"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

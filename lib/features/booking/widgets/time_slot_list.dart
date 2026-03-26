import 'package:flutter/material.dart';

class TimeSlotList extends StatelessWidget {
  final List<Map<String, String>> times;
  final int selectedTime;
  final Function(int) onTimeSelected;

  const TimeSlotList({
    super.key,
    required this.times,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: times.length,
      itemBuilder: (context, index) {
        bool selected = selectedTime == index;

        return GestureDetector(
          onTap: () => onTimeSelected(index),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFFFFBF0) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? Colors.orange : Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      times[index]["title"]!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      times[index]["time"]!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (selected)
                  Container(
                    height: 24,
                    width: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFC107),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.check, color: Colors.black, size: 16),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

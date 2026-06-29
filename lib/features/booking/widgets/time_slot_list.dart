import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

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
            margin: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(5)),
            padding: EdgeInsets.all(context.w(10)),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFFFFBF0) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? const Color(0xFFFFCB2F) : const Color(0xFFE9E9E9),
                width: 1,
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
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: context.sp(11),
                      ),
                    ),
                    SizedBox(height: context.h(2)),
                    Text(
                      times[index]["time"]!,
                      style: TextStyle(
                        fontSize: context.sp(12.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (selected)
                  Container(
                    height: context.w(18),
                    width: context.w(18),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFCB2F),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.check, color: Colors.black, size: context.w(12)),
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

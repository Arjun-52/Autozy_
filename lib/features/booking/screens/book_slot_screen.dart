import 'package:autozy/features/booking/widgets/bottom_bar.dart';
import 'package:autozy/features/booking/widgets/date_selector.dart'
    show DateSelector;
import 'package:autozy/features/booking/widgets/info_box.dart';
import 'package:autozy/features/booking/widgets/section_title.dart';
import 'package:autozy/features/booking/widgets/time_slot_list.dart';
import 'package:flutter/material.dart';

class BookSlotScreen extends StatefulWidget {
  const BookSlotScreen({super.key});

  @override
  State<BookSlotScreen> createState() => _BookSlotScreenState();
}

class _BookSlotScreenState extends State<BookSlotScreen> {
  int selectedDate = 0;
  int selectedTime = 0;
  Future<void> pickDate() async {
    final today = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(today.year + 1),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xffF4C430),
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      print("Selected: $picked");
    }
  }

  final List<Map<String, String>> dates = [
    {"day": "Today", "date": "08 Mar"},
    {"day": "Tomorrow", "date": "09 Mar"},
    {"day": "Saturday", "date": "10 Mar"},
    {"day": "Sunday", "date": "11 Mar"},
  ];

  final List<Map<String, String>> times = [
    {"title": "Morning", "time": "08:00 - 13:00"},
    {"title": "Afternoon", "time": "14:00 - 18:00"},
    {"title": "Evening", "time": "18:00 - 21:00"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        title: const Text(
          "Book Slot",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const InfoBox(),

          const SectionTitle(icon: Icons.calendar_month, title: "Select Date"),

          DateSelector(
            dates: dates,
            selectedDate: selectedDate,
            onDateSelected: (index) {
              setState(() {
                selectedDate = index;
              });
            },
            onCalendarTap: pickDate,
          ),

          const SizedBox(height: 20),

          const SectionTitle(
            icon: Icons.access_time,
            title: "Select Time Slot",
          ),

          Expanded(
            child: TimeSlotList(
              times: times,
              selectedTime: selectedTime,
              onTimeSelected: (index) {
                setState(() {
                  selectedTime = index;
                });
              },
            ),
          ),

          BottomBar(
            date: dates[selectedDate]["date"]!,
            time: times[selectedTime]["time"]!,
          ),
        ],
      ),
    );
  }
}

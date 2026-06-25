import 'package:autozy/features/booking/widgets/bottom_bar.dart';
import 'package:autozy/features/booking/widgets/date_selector.dart'
    show DateSelector;
import 'package:autozy/features/booking/widgets/info_box.dart';
import 'package:autozy/features/booking/widgets/section_title.dart';
import 'package:autozy/features/booking/widgets/time_slot_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/subscription_provider.dart';

class BookSlotScreen extends StatefulWidget {
  const BookSlotScreen({super.key});

  @override
  State<BookSlotScreen> createState() => _BookSlotScreenState();
}

class _BookSlotScreenState extends State<BookSlotScreen> {
  int selectedDate = 0;
  int selectedTime = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedSlot();
    });
  }

  void _updateSelectedSlot() {
    if (mounted) {
      final slotTitle = times[selectedTime]["title"] ?? 'Morning';
      final slotType = slotTitle.toUpperCase() == 'MORNING' ? 'MORNING' : 'EVENING';
      final provider = context.read<SubscriptionProvider>();
      provider.selectSlotType(slotType);
      
      if (selectedDate < dates.length) {
        final selectedDateTime = dates[selectedDate]['dateTime'] as DateTime;
        provider.selectDate(selectedDateTime);
      }
    }
  }

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
      if (mounted) {
        final index = dates.indexWhere((element) {
          final dt = element['dateTime'] as DateTime;
          return dt.year == picked.year &&
                 dt.month == picked.month &&
                 dt.day == picked.day;
        });

        setState(() {
          if (index != -1) {
            selectedDate = index;
          } else {
            const months = [
              'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
            ];
            const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            final day = weekdays[picked.weekday - 1];
            final dateStr = '${picked.day.toString().padLeft(2, '0')} ${months[picked.month - 1]}';
            
            dates.add({
              'day': day,
              'date': dateStr,
              'dateTime': picked,
            });
            selectedDate = dates.length - 1;
          }
        });
        _updateSelectedSlot();
      }
    }
  }

  // Real upcoming dates (the chips were previously hardcoded to "08 Mar" etc.).
  late final List<Map<String, dynamic>> dates = _buildDates();

  List<Map<String, dynamic>> _buildDates() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(7, (i) {
      final d = today.add(Duration(days: i));
      final day = i == 0
          ? 'Today'
          : i == 1
              ? 'Tomorrow'
              : weekdays[d.weekday - 1];
      final date = '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]}';
      return {'day': day, 'date': date, 'dateTime': d};
    });
  }

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
              _updateSelectedSlot();
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
                _updateSelectedSlot();
              },
            ),
          ),

          BottomBar(
            day: dates[selectedDate]["day"]!,
            date: dates[selectedDate]["date"]!,
            time: times[selectedTime]["time"]!,
          ),
        ],
      ),
    );
  }
}

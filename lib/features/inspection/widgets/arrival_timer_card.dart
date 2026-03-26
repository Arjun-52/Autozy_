import 'dart:async';
import 'package:flutter/material.dart';

class ArrivalTimerCard extends StatefulWidget {
  final VoidCallback onTimerFinished;

  const ArrivalTimerCard({super.key, required this.onTimerFinished});

  @override
  State<ArrivalTimerCard> createState() => _ArrivalTimerCardState();
}

class _ArrivalTimerCardState extends State<ArrivalTimerCard> {
  Duration remainingTime = const Duration(seconds: 5); // change if needed
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds == 0) {
        timer.cancel();

        /// notify parent screen
        widget.onTimerFinished();
      } else {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      }
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),

      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, color: Colors.orange),
              SizedBox(width: 6),
              Text(
                "ESTIMATED ARRIVAL",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            formatTime(remainingTime),
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          const Text(
            "Inspector will arrive at your location",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

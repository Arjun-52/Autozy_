import 'package:flutter/material.dart';

class ArrivalTimerCard extends StatelessWidget {
  const ArrivalTimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),

      child: Column(
        children: const [
          Row(
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

          SizedBox(height: 10),

          Text(
            "00:59:54",
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 6),

          Text(
            "Inspector will arrive at your location",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

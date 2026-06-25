import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/responsive.dart';

class SupportCenterScreen extends StatelessWidget {
  const SupportCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Support Center",
          style: TextStyle(
            color: Colors.black,
            fontSize: context.sp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(context.w(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How can we help you today?",
              style: TextStyle(
                fontSize: context.sp(18),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: context.h(6)),
            Text(
              "Select an option below to raise a new support ticket or manage your existing tickets.",
              style: TextStyle(
                fontSize: context.sp(13),
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
                height: 1.3,
              ),
            ),
            SizedBox(height: context.h(24)),

            _SupportOptionCard(
              title: "Raise New Ticket",
              description: "Report missed service, wash quality issues, billing questions, or other issues.",
              icon: Icons.add_circle_outline,
              onTap: () {
                context.push('/raise-ticket');
              },
            ),
            SizedBox(height: context.h(16)),

            _SupportOptionCard(
              title: "My Tickets",
              description: "View history, status, and track updates on your active/closed support tickets.",
              icon: Icons.confirmation_number_outlined,
              onTap: () {
                context.push('/tickets');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _SupportOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(context.w(10)),
              decoration: BoxDecoration(
                color: const Color(0xffFFFBF0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFCB2F).withOpacity(0.3), width: 1),
              ),
              child: Icon(icon, color: const Color(0xffC68A00), size: context.w(24)),
            ),
            SizedBox(width: context.w(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: context.h(4)),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: context.sp(11.5),
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: context.w(20), color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

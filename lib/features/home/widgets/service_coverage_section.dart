import 'package:flutter/material.dart';
import '../../../data/models/dto/home_dashboard_response.dart';

class ServiceCoverageSection extends StatefulWidget {
  final HomeSubscription? subscription;

  const ServiceCoverageSection({
    super.key,
    this.subscription,
  });

  @override
  State<ServiceCoverageSection> createState() => _ServiceCoverageSectionState();
}

class _ServiceCoverageSectionState extends State<ServiceCoverageSection> {
  bool _isExpanded = false;

  Widget _buildItemRow({required IconData icon, required String text, required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          title: const Text(
            "Service Coverage",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.black,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // What's Included Column (Left side - Light Green background)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          color: const Color(0xFFE8F8EF),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "What's Included",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF008847),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildItemRow(
                                icon: Icons.check_circle_outline_rounded,
                                text: "Exterior Dust Removal",
                                color: const Color(0xFF008847),
                              ),
                              _buildItemRow(
                                icon: Icons.check_circle_outline_rounded,
                                text: "Glass Cleaning",
                                color: const Color(0xFF008847),
                              ),
                              _buildItemRow(
                                icon: Icons.check_circle_outline_rounded,
                                text: "Dashboard Wipe",
                                color: const Color(0xFF008847),
                              ),
                              _buildItemRow(
                                icon: Icons.check_circle_outline_rounded,
                                text: "Tyre Shine",
                                color: const Color(0xFF008847),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // What's Not Included Column (Right side - Light Red background)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          color: const Color(0xFFFFECEC),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "What's Not Included",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildItemRow(
                                icon: Icons.cancel_outlined,
                                text: "Engine Wash",
                                color: Colors.red,
                              ),
                              _buildItemRow(
                                icon: Icons.cancel_outlined,
                                text: "Paint Repair",
                                color: Colors.red,
                              ),
                              _buildItemRow(
                                icon: Icons.cancel_outlined,
                                text: "Dent Repair",
                                color: Colors.red,
                              ),
                              _buildItemRow(
                                icon: Icons.cancel_outlined,
                                text: "Scratch Removal",
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

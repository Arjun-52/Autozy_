import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/dto/home_dashboard_response.dart';
import '../../../data/models/plan_model.dart';
import '../../../providers/plan_provider.dart';

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

  // Fallback coverage shown until the plan's own features are available.
  static const List<String> _defaultIncluded = [
    "Exterior Dust Removal",
    "Glass Cleaning",
    "Dashboard Wipe",
    "Tyre Shine",
  ];
  static const List<String> _defaultExcluded = [
    "Engine Wash",
    "Paint Repair",
    "Dent Repair",
    "Scratch Removal",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final planProvider = context.read<PlanProvider>();
      if (planProvider.plans.isEmpty) {
        planProvider.fetchPlans();
      }
    });
  }

  /// Finds the plan whose name matches the active subscription's plan name,
  /// so we can read its real included/excluded coverage.
  Plan? _matchingPlan(PlanProvider planProvider) {
    final planName = widget.subscription?.plan;
    if (planName == null || planName.isEmpty) return null;
    final target = planName.toLowerCase().trim();
    for (final p in planProvider.plans) {
      if (p.name.toLowerCase().trim() == target) return p;
    }
    return null;
  }

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

  Widget _buildCoverageColumn({
    required String heading,
    required Color headingColor,
    required Color bgColor,
    required IconData icon,
    required List<String> items,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        color: bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: headingColor,
              ),
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              _buildItemRow(icon: icon, text: "—", color: headingColor)
            else
              ...items.map((t) => _buildItemRow(icon: icon, text: t, color: headingColor)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
    final plan = _matchingPlan(planProvider);
    final features = plan?.features;

    final included = (features != null && features.included.isNotEmpty)
        ? features.included
        : _defaultIncluded;
    final excluded = (features != null && features.excluded.isNotEmpty)
        ? features.excluded
        : _defaultExcluded;

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
                      _buildCoverageColumn(
                        heading: "What's Included",
                        headingColor: const Color(0xFF008847),
                        bgColor: const Color(0xFFE8F8EF),
                        icon: Icons.check_circle_outline_rounded,
                        items: included,
                      ),
                      _buildCoverageColumn(
                        heading: "What's Not Included",
                        headingColor: Colors.red,
                        bgColor: const Color(0xFFFFECEC),
                        icon: Icons.cancel_outlined,
                        items: excluded,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/promotion_provider.dart';

class SpecialOffersSection extends StatefulWidget {
  const SpecialOffersSection({super.key});

  @override
  State<SpecialOffersSection> createState() => _SpecialOffersSectionState();
}

class _SpecialOffersSectionState extends State<SpecialOffersSection> {
  // Rotating palette so backend promotions keep the polished gradient look.
  static const List<List<Color>> _gradients = [
    [Color(0xFF2E3192), Color(0xFF1BFFFF)],
    [Color(0xFFF2994A), Color(0xFFF2C94C)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
  ];
  static const List<IconData> _icons = [
    Icons.card_giftcard,
    Icons.clean_hands,
    Icons.umbrella,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromotionProvider>().fetchPromotions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PromotionProvider>();
    final offers = provider.promotions;

    // Hide the section entirely when there are no active promotions
    // (rather than showing mock data).
    if (offers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Exclusive Benefits",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF363636),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: offers.length,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final offer = offers[index];
              final gradient = LinearGradient(
                colors: _gradients[index % _gradients.length],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              );
              final icon = _icons[index % _icons.length];
              final badge = (offer.discountCode != null && offer.discountCode!.isNotEmpty)
                  ? offer.discountCode!
                  : "Offer";
              return Container(
                width: 310,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Background decorative circles for high-end look
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      bottom: -15,
                      child: Icon(
                        icon,
                        size: 110,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            offer.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            offer.description ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

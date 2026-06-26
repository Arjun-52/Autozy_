import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServicePackage {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  const ServicePackage({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class ServicePackagesSection extends StatelessWidget {
  const ServicePackagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Curated high quality car wash image URLs from Unsplash matching the design reference images
    final List<ServicePackage> packages = const [
      ServicePackage(
        id: '1',
        name: "Basic Wash",
        price: 499,
        imageUrl: "https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=150&auto=format&fit=crop&q=80",
      ),
      ServicePackage(
        id: '2',
        name: "Standard Wash",
        price: 499,
        imageUrl: "https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=150&auto=format&fit=crop&q=80",
      ),
      ServicePackage(
        id: '3',
        name: "Premium Wash",
        price: 999,
        imageUrl: "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=150&auto=format&fit=crop&q=80",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular Car Service Packages",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 112,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
               return Container(
                width: 175,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE9E9E9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top row: Image & Text
                    Row(
                      children: [
                        // Service Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: package.imageUrl,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade100,
                              width: 36,
                              height: 36,
                              child: const Center(
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade100,
                              width: 36,
                              height: 36,
                              child: const Icon(Icons.directions_car_filled, color: Colors.grey, size: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Text Column (Name & Price)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                package.name,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                "₹${package.price.toInt()}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Add Button with black border matching reference design exactly
                    SizedBox(
                      width: double.infinity,
                      height: 28,
                      child: OutlinedButton(
                        onPressed: () {
                          context.pushNamed('bookAddon');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          "+ Add",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

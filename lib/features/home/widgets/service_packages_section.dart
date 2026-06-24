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
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 145,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return Container(
                width: 185,
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE9E9E9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
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
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: package.imageUrl,
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade100,
                              width: 46,
                              height: 46,
                              child: const Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade100,
                              width: 46,
                              height: 46,
                              child: const Icon(Icons.directions_car_filled, color: Colors.grey, size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Text Column (Name & Price)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                package.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "₹${package.price.toInt()}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
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
                      height: 38,
                      child: OutlinedButton(
                        onPressed: () {
                          context.pushNamed('bookAddon');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          "+ Add",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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

import 'package:flutter/material.dart';

class PlanModel {
  final String name;
  final double price;
  final String duration;
  final IconData icon;
  final List<String> features;
  final bool isPopular;

  PlanModel({
    required this.name,
    required this.price,
    required this.duration,
    required this.icon,
    required this.features,
    this.isPopular = false,
  });
}

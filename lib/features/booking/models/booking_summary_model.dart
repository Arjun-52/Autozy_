class BookingSummary {
  final String planName;
  final double price;
  final double addons;

  BookingSummary({
    required this.planName,
    required this.price,
    required this.addons,
  });

  double get total => price + addons;
}

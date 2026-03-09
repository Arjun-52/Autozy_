class PaymentMethodModel {
  final String name;
  final String icon;
  final bool isSelected;

  PaymentMethodModel({
    required this.name,
    required this.icon,
    this.isSelected = false,
  });

  PaymentMethodModel copyWith({bool? isSelected}) {
    return PaymentMethodModel(
      name: name,
      icon: icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class CreateSubscriptionRequest {
  final String vehicleId;
  final String areaId;
  final String planPricingId;
  final String slotType; // 'MORNING' | 'EVENING'

  CreateSubscriptionRequest({
    required this.vehicleId,
    required this.areaId,
    required this.planPricingId,
    required this.slotType,
  });

  Map<String, dynamic> toJson() => {
        'vehicleId': vehicleId,
        'areaId': areaId,
        'planPricingId': planPricingId,
        'slotType': slotType,
      };
}

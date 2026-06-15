class BookAddonRequestModel {
  final String vehicleId;
  final String addonServiceId;
  final String scheduledDate; // YYYY-MM-DD
  final String scheduledSlotStart; // HH:mm:ss
  final String scheduledSlotEnd; // HH:mm:ss
  final String cityId;
  final String? pricingId;

  BookAddonRequestModel({
    required this.vehicleId,
    required this.addonServiceId,
    required this.scheduledDate,
    required this.scheduledSlotStart,
    required this.scheduledSlotEnd,
    required this.cityId,
    this.pricingId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'vehicleId': vehicleId,
      'addonServiceId': addonServiceId,
      'scheduledDate': scheduledDate,
      'scheduledSlotStart': scheduledSlotStart,
      'scheduledSlotEnd': scheduledSlotEnd,
      'cityId': cityId,
    };
    if (pricingId != null) {
      map['pricingId'] = pricingId;
    }
    return map;
  }
}

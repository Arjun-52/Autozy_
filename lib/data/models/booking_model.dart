class Booking {
  final String id;
  final String userId;
  final String vehicleId;
  final String planId;
  final DateTime bookingDate;
  final DateTime bookingTime;
  final String status;
  final double price;
  final Map<String, dynamic> additionalInfo;

  Booking({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.planId,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
    required this.price,
    this.additionalInfo = const {},
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      planId: json['planId'] ?? '',
      bookingDate: DateTime.parse(json['bookingDate']),
      bookingTime: DateTime.parse(json['bookingTime']),
      status: json['status'] ?? 'pending',
      price: (json['price'] ?? 0.0).toDouble(),
      additionalInfo: json['additionalInfo'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'vehicleId': vehicleId,
      'planId': planId,
      'bookingDate': bookingDate.toIso8601String(),
      'bookingTime': bookingTime.toIso8601String(),
      'status': status,
      'price': price,
      'additionalInfo': additionalInfo,
    };
  }

  Booking copyWith({
    String? id,
    String? userId,
    String? vehicleId,
    String? planId,
    DateTime? bookingDate,
    DateTime? bookingTime,
    String? status,
    double? price,
    Map<String, dynamic>? additionalInfo,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      planId: planId ?? this.planId,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      status: status ?? this.status,
      price: price ?? this.price,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}

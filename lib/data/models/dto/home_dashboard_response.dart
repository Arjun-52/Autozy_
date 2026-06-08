class HomeDashboardResponse {
  final bool success;
  final HomeDashboardData? data;
  final String? timestamp;

  HomeDashboardResponse({
    required this.success,
    this.data,
    this.timestamp,
  });

  factory HomeDashboardResponse.fromJson(Map<String, dynamic> json) {
    return HomeDashboardResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? HomeDashboardData.fromJson(json['data']) : null,
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'timestamp': timestamp,
    };
  }
}

class HomeDashboardData {
  final List<HomeSubscription> subscriptions;
  final List<TodayService> todayServices;
  final int unreadNotifications;
  final List<dynamic> addonBookings;
  final QuickActions quickActions;

  HomeDashboardData({
    required this.subscriptions,
    required this.todayServices,
    required this.unreadNotifications,
    required this.addonBookings,
    required this.quickActions,
  });

  factory HomeDashboardData.fromJson(Map<String, dynamic> json) {
    var subList = json['subscriptions'] as List?;
    var serviceList = json['todayServices'] as List?;
    var addonList = json['addonBookings'] as List?;
    
    return HomeDashboardData(
      subscriptions: subList != null ? subList.map((e) => HomeSubscription.fromJson(e)).toList() : [],
      todayServices: serviceList != null ? serviceList.map((e) => TodayService.fromJson(e)).toList() : [],
      unreadNotifications: json['unreadNotifications'] ?? 0,
      addonBookings: addonList ?? [],
      quickActions: QuickActions.fromJson(json['quickActions'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptions': subscriptions.map((e) => e.toJson()).toList(),
      'todayServices': todayServices.map((e) => e.toJson()).toList(),
      'unreadNotifications': unreadNotifications,
      'addonBookings': addonBookings,
      'quickActions': quickActions.toJson(),
    };
  }
}

class HomeSubscription {
  final String id;
  final String plan;
  final DashboardVehicle vehicle;
  final String status;
  final String endDate;
  final bool canPause;

  HomeSubscription({
    required this.id,
    required this.plan,
    required this.vehicle,
    required this.status,
    required this.endDate,
    required this.canPause,
  });

  factory HomeSubscription.fromJson(Map<String, dynamic> json) {
    return HomeSubscription(
      id: json['id'] ?? '',
      plan: json['plan'] ?? '',
      vehicle: DashboardVehicle.fromJson(json['vehicle'] ?? {}),
      status: json['status'] ?? '',
      endDate: json['endDate'] ?? '',
      canPause: json['canPause'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan': plan,
      'vehicle': vehicle.toJson(),
      'status': status,
      'endDate': endDate,
      'canPause': canPause,
    };
  }
}

class DashboardVehicle {
  final String id;
  final String number;
  final String brand;
  final String model;

  DashboardVehicle({
    required this.id,
    required this.number,
    required this.brand,
    required this.model,
  });

  factory DashboardVehicle.fromJson(Map<String, dynamic> json) {
    return DashboardVehicle(
      id: json['id'] ?? '',
      number: json['number'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'brand': brand,
      'model': model,
    };
  }
}

class TodayService {
  final String id;
  final String vehicleNumber;
  final String status;
  final String? completedAt;
  final List<dynamic>? photos;

  TodayService({
    required this.id,
    required this.vehicleNumber,
    required this.status,
    this.completedAt,
    this.photos,
  });

  factory TodayService.fromJson(Map<String, dynamic> json) {
    return TodayService(
      id: json['id'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      status: json['status'] ?? '',
      completedAt: json['completedAt'],
      photos: json['photos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleNumber': vehicleNumber,
      'status': status,
      'completedAt': completedAt,
      'photos': photos,
    };
  }
}

class QuickActions {
  final bool canPause;
  final bool hasPendingPayment;
  final int activeSubscriptionCount;

  QuickActions({
    required this.canPause,
    required this.hasPendingPayment,
    required this.activeSubscriptionCount,
  });

  factory QuickActions.fromJson(Map<String, dynamic> json) {
    return QuickActions(
      canPause: json['canPause'] ?? false,
      hasPendingPayment: json['hasPendingPayment'] ?? false,
      activeSubscriptionCount: json['activeSubscriptionCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canPause': canPause,
      'hasPendingPayment': hasPendingPayment,
      'activeSubscriptionCount': activeSubscriptionCount,
    };
  }
}

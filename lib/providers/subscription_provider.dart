import 'package:flutter/foundation.dart';
import '../core/utils/app_logger.dart';
import '../data/repositories/subscription_repository.dart';
import '../data/models/dto/create_subscription_request.dart';
import '../data/models/dto/create_subscription_response.dart';
import '../data/models/dto/subscription_list_response.dart' as list_dto;

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionRepository _subscriptionRepository;

  bool _isLoading = false;
  String? _error;
  SubscriptionModel? _createdSubscription;

  // Selected booking slot details
  DateTime? _selectedDate;
  String? _selectedSlotType; // 'MORNING' | 'EVENING'

  // Subscriptions list states
  List<list_dto.SubscriptionModel> _subscriptions = [];
  bool _isListLoading = false;
  String? _listError;

  SubscriptionProvider(this._subscriptionRepository);

  bool get isLoading => _isLoading;
  String? get error => _error;
  SubscriptionModel? get createdSubscription => _createdSubscription;

  DateTime? get selectedDate => _selectedDate;
  String? get selectedSlotType => _selectedSlotType;

  List<list_dto.SubscriptionModel> get subscriptions => _subscriptions;
  bool get isListLoading => _isListLoading;
  String? get listError => _listError;

  Future<void> fetchSubscriptions({int page = 1, int limit = 20, bool isRefresh = false}) async {
    if (!isRefresh) {
      _isListLoading = true;
      _listError = null;
      notifyListeners();
    }

    try {
      final fetched = await _subscriptionRepository.getSubscriptions(page: page, limit: limit);
      _subscriptions = fetched;
      _listError = null;
    } catch (e) {
      _listError = e.toString();
    } finally {
      _isListLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshSubscriptions({int limit = 20}) async {
    AppLogger.info('Refresh triggered for subscriptions list', tag: 'Subscriptions');
    await fetchSubscriptions(page: 1, limit: limit, isRefresh: true);
  }
  void selectDate(DateTime date) {
    _selectedDate = date;
    AppLogger.info('Selected date: ${date.toIso8601String()}', tag: 'Subscriptions');
    notifyListeners();
  }

  void selectSlotType(String slotType) {
    _selectedSlotType = slotType;
    AppLogger.info('Selected slot type: $slotType', tag: 'Subscriptions');
    notifyListeners();
  }

  Future<SubscriptionModel?> createSubscription({
    required String vehicleId,
    required String areaId,
    required String planPricingId,
    required String slotType,
  }) async {
    _isLoading = true;
    _error = null;
    _createdSubscription = null;
    notifyListeners();

    try {
      final request = CreateSubscriptionRequest(
        vehicleId: vehicleId,
        areaId: areaId,
        planPricingId: planPricingId,
        slotType: slotType,
      );

      final subscription = await _subscriptionRepository.createSubscription(request);
      _createdSubscription = subscription;
      _error = null;
      notifyListeners();
      return subscription;
    } catch (e) {
      _error = e.toString();
      _createdSubscription = null;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    _error = null;
    _isLoading = false;
    _createdSubscription = null;
    _selectedDate = null;
    _selectedSlotType = null;
    notifyListeners();
  }
}

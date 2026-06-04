import 'package:flutter/foundation.dart';
import '../core/utils/app_logger.dart';
import '../data/repositories/plan_repository.dart';
import '../data/models/plan_model.dart';

class PlanProvider extends ChangeNotifier {
  final PlanRepository _planRepository;
  
  List<Plan> _plans = [];
  List<Plan> _activePlans = [];
  Plan? _selectedPlan;
  List<dynamic> _pricings = [];
  bool _isLoading = false;
  String? _error;

  PlanProvider(this._planRepository);

  List<Plan> get plans => _plans;
  List<Plan> get activePlans => _activePlans;
  Plan? get selectedPlan => _selectedPlan;
  List<dynamic> get pricings => _pricings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPricing() async {
    _setLoading(true);
    _clearError();
    try {
      _pricings = await _planRepository.getPricing();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  String? getPricingIdForPlanAndVehicle({
    required String planId,
    required String vehicleSize,
    String? areaId,
    String? cityId,
  }) {
    if (_pricings.isEmpty) return null;
    final normalizedSize = vehicleSize.trim().toUpperCase();

    // Map frontend vehicle sizes (SMALL, MEDIUM, LARGE) to backend pricing sizes (HATCHBACK, SEDAN, SUV)
    String mappedSize = normalizedSize;
    if (normalizedSize == 'SMALL') {
      mappedSize = 'HATCHBACK';
    } else if (normalizedSize == 'MEDIUM') {
      mappedSize = 'SEDAN';
    } else if (normalizedSize == 'LARGE') {
      mappedSize = 'SUV';
    }

    // 1. Try to find match with plan_id, vehicle_size, and area_id
    if (areaId != null) {
      for (var p in _pricings) {
        if (p['plan_id'] == planId &&
            p['vehicle_size']?.toString().toUpperCase() == mappedSize &&
            p['area_id'] == areaId) {
          return p['id'] as String?;
        }
      }
    }

    // 2. Try to find match with plan_id, vehicle_size, and city_id
    if (cityId != null) {
      for (var p in _pricings) {
        if (p['plan_id'] == planId &&
            p['vehicle_size']?.toString().toUpperCase() == mappedSize &&
            p['city_id'] == cityId) {
          return p['id'] as String?;
        }
      }
    }

    // 3. Fallback to match with plan_id, vehicle_size
    for (var p in _pricings) {
      if (p['plan_id'] == planId &&
          p['vehicle_size']?.toString().toUpperCase() == mappedSize) {
        return p['id'] as String?;
      }
    }
    return null;
  }



  void selectPlan(Plan plan) {
    _selectedPlan = plan;
    AppLogger.info('Selected plan: ${plan.name} (${plan.id})', tag: 'Plans');
    notifyListeners();
  }

  Future<void> fetchPlans() async {
    _setLoading(true);
    _clearError();

    try {
      final fetched = await _planRepository.getPlans();
      if (fetched.isEmpty) {
        AppLogger.info('Empty response received for plans', tag: 'Plans');
      }

      final orderMap = {
        'BASIC': 0,
        'STANDARD': 1,
        'REGULAR_CLEANING': 2,
        'REGULAR_WATER_WASH': 3,
        'INTERNAL_CLEANING': 4,
        'PREMIUM': 5,
      };

      fetched.sort((a, b) {
        final aVal = orderMap[a.name.toUpperCase()] ?? 99;
        final bVal = orderMap[b.name.toUpperCase()] ?? 99;
        return aVal.compareTo(bVal);
      });

      _plans = fetched;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshPlans() async {
    AppLogger.info('Refresh triggered for plans', tag: 'Plans');
    await fetchPlans();
  }

  Future<void> fetchActivePlans() async {
    _setLoading(true);
    _clearError();

    try {
      _activePlans = await _planRepository.getActivePlans();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Plan> getPlanById(String planId) async {
    _clearError();

    try {
      return await _planRepository.getPlanById(planId);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> createPlan(Plan plan) async {
    _setLoading(true);
    _clearError();

    try {
      final newPlan = await _planRepository.createPlan(plan);
      _plans.add(newPlan);
      if (plan.isActive == true) {
        _activePlans.add(newPlan);
      }
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePlan(Plan plan) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedPlan = await _planRepository.updatePlan(plan);
      
      final index = _plans.indexWhere((p) => p.id == plan.id);
      if (index != -1) {
        _plans[index] = updatedPlan;
      }
      
      final activeIndex = _activePlans.indexWhere((p) => p.id == plan.id);
      if (activeIndex != -1) {
        if (updatedPlan.isActive == true) {
          _activePlans[activeIndex] = updatedPlan;
        } else {
          _activePlans.removeAt(activeIndex);
        }
      } else if (updatedPlan.isActive == true) {
        _activePlans.add(updatedPlan);
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePlan(String planId) async {
    _setLoading(true);
    _clearError();

    try {
      await _planRepository.deletePlan(planId);
      _plans.removeWhere((plan) => plan.id == planId);
      _activePlans.removeWhere((plan) => plan.id == planId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> activatePlan(String planId) async {
    _setLoading(true);
    _clearError();

    try {
      await _planRepository.activatePlan(planId);

      final index = _plans.indexWhere((p) => p.id == planId);
      Plan? updatedPlan;
      if (index != -1) {
        updatedPlan = _plans[index].copyWith(isActive: true);
        _plans[index] = updatedPlan;
      }

      if (updatedPlan != null && !_activePlans.any((p) => p.id == planId)) {
        _activePlans.add(updatedPlan);
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deactivatePlan(String planId) async {
    _setLoading(true);
    _clearError();

    try {
      await _planRepository.deactivatePlan(planId);

      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = _plans[index].copyWith(isActive: false);
      }

      _activePlans.removeWhere((p) => p.id == planId);
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void clearPlans() {
    _plans.clear();
    _activePlans.clear();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}

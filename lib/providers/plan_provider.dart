import 'package:flutter/foundation.dart';
import '../data/repositories/plan_repository.dart';
import '../data/models/plan_model.dart';

class PlanProvider extends ChangeNotifier {
  final PlanRepository _planRepository;
  
  List<Plan> _plans = [];
  List<Plan> _activePlans = [];
  bool _isLoading = false;
  String? _error;

  PlanProvider(this._planRepository);

  List<Plan> get plans => _plans;
  List<Plan> get activePlans => _activePlans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPlans() async {
    _setLoading(true);
    _clearError();

    try {
      _plans = await _planRepository.getPlans();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
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
      if (plan.isActive) {
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
        if (updatedPlan.isActive) {
          _activePlans[activeIndex] = updatedPlan;
        } else {
          _activePlans.removeAt(activeIndex);
        }
      } else if (updatedPlan.isActive) {
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
      
      final plan = _plans.firstWhere((p) => p.id == planId);
      final updatedPlan = plan.copyWith(isActive: true);
      
      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = updatedPlan;
      }
      
      if (!_activePlans.any((p) => p.id == planId)) {
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
      
      final plan = _plans.firstWhere((p) => p.id == planId);
      final updatedPlan = plan.copyWith(isActive: false);
      
      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = updatedPlan;
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

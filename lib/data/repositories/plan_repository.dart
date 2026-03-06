import '../services/api_service.dart';
import '../models/plan_model.dart';

class PlanRepository {
  final ApiService _apiService;

  PlanRepository(this._apiService);

  Future<List<Plan>> getPlans() async {
    try {
      final data = await _apiService.get('/plans');

      final List<dynamic> plans = data['plans'];
      return plans.map((plan) => Plan.fromJson(plan)).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<Plan> getPlanById(String planId) async {
    try {
      final data = await _apiService.get('/plans/$planId');
      return Plan.fromJson(data['plan']);
    } catch (e) {
      throw e;
    }
  }

  Future<List<Plan>> getActivePlans() async {
    try {
      final data = await _apiService.get('/plans/active');

      final List<dynamic> plans = data['plans'];
      return plans.map((plan) => Plan.fromJson(plan)).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<Plan>> getPlansByType(String type) async {
    try {
      final data = await _apiService.get(
        '/plans',
        queryParameters: {'type': type},
      );

      final List<dynamic> plans = data['plans'];
      return plans.map((plan) => Plan.fromJson(plan)).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<Plan> createPlan(Plan plan) async {
    try {
      final data = await _apiService.post('/plans', data: plan.toJson());
      return Plan.fromJson(data['plan']);
    } catch (e) {
      throw e;
    }
  }

  Future<Plan> updatePlan(Plan plan) async {
    try {
      final data = await _apiService.put(
        '/plans/${plan.id}',
        data: plan.toJson(),
      );
      return Plan.fromJson(data['plan']);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deletePlan(String planId) async {
    try {
      await _apiService.delete('/plans/$planId');
    } catch (e) {
      throw e;
    }
  }

  Future<void> activatePlan(String planId) async {
    try {
      await _apiService.patch('/plans/$planId/activate');
    } catch (e) {
      throw e;
    }
  }

  Future<void> deactivatePlan(String planId) async {
    try {
      await _apiService.patch('/plans/$planId/deactivate');
    } catch (e) {
      throw e;
    }
  }
}

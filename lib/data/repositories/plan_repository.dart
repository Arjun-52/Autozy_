import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/plan_model.dart';
import '../models/dto/plan_response.dart';

class PlanRepository {
  final ApiService _apiService;

  PlanRepository(this._apiService);

  Future<List<Plan>> getPlans() async {
    try {
      AppLogger.info('Plans requested', tag: 'Plans');
      final data = await _apiService.get('/api/v1/plans');
      print('RAW PLANS RESPONSE: $data');
      final response = PlanResponse.fromJson(data);
      final list = response.plans ?? [];
      AppLogger.info('Plans loaded count: ${list.length}', tag: 'Plans');
      return list;
    } catch (e, st) {
      AppLogger.error('API failure: Failed to fetch subscription plans', tag: 'Plans', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<List<dynamic>> getPricing() async {
    try {
      AppLogger.info('Pricing list requested', tag: 'Plans');
      final data = await _apiService.get('/api/v1/pricing');
      final list = data['data'] as List<dynamic>? ?? [];
      AppLogger.info('Pricing loaded count: ${list.length}', tag: 'Plans');
      return list;
    } catch (e, st) {
      AppLogger.error('API failure: Failed to fetch plan pricing list', tag: 'Plans', error: e, stackTrace: st);
      rethrow;
    }
  }


  Future<Plan> getPlanById(String planId) async {
    try {
      final data = await _apiService.get('/plans/$planId');
      return Plan.fromJson(data['plan']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Plan>> getActivePlans() async {
    try {
      final data = await _apiService.get('/plans/active');

      final List<dynamic> plans = data['plans'];
      return plans.map((plan) => Plan.fromJson(plan)).toList();
    } catch (e) {
      rethrow;
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
      rethrow;
    }
  }

  Future<Plan> createPlan(Plan plan) async {
    try {
      final data = await _apiService.post('/plans', data: plan.toJson());
      return Plan.fromJson(data['plan']);
    } catch (e) {
      rethrow;
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
      rethrow;
    }
  }

  Future<void> deletePlan(String planId) async {
    try {
      await _apiService.delete('/plans/$planId');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> activatePlan(String planId) async {
    try {
      await _apiService.patch('/plans/$planId/activate');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivatePlan(String planId) async {
    try {
      await _apiService.patch('/plans/$planId/deactivate');
    } catch (e) {
      rethrow;
    }
  }
}

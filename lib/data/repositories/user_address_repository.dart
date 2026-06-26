import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/user_address_model.dart';

class UserAddressRepository {
  final ApiService _apiService;

  UserAddressRepository(this._apiService);

  static const String _basePath = '/api/v1/users/me/addresses';

  Future<List<UserAddress>> getAddresses() async {
    try {
      AppLogger.info('Fetching saved addresses', tag: 'Addresses');
      final data = await _apiService.get(_basePath);
      final List<dynamic> list = data['data'] ?? data['addresses'] ?? [];
      return list
          .map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      AppLogger.error('Failed to fetch addresses', tag: 'Addresses', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<UserAddress> createAddress(UserAddress address) async {
    try {
      AppLogger.info('Creating saved address', tag: 'Addresses');
      final data = await _apiService.post(_basePath, data: address.toRequestJson());
      final node = data['data'] ?? data;
      return UserAddress.fromJson(node as Map<String, dynamic>);
    } catch (e, st) {
      AppLogger.error('Failed to create address', tag: 'Addresses', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<UserAddress> updateAddress(String id, UserAddress address) async {
    try {
      AppLogger.info('Updating saved address: $id', tag: 'Addresses');
      final data = await _apiService.put('$_basePath/$id', data: address.toRequestJson());
      final node = data['data'] ?? data;
      return UserAddress.fromJson(node as Map<String, dynamic>);
    } catch (e, st) {
      AppLogger.error('Failed to update address: $id', tag: 'Addresses', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      AppLogger.info('Deleting saved address: $id', tag: 'Addresses');
      await _apiService.delete('$_basePath/$id');
    } catch (e, st) {
      AppLogger.error('Failed to delete address: $id', tag: 'Addresses', error: e, stackTrace: st);
      rethrow;
    }
  }
}

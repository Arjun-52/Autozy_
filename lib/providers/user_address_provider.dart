import 'package:flutter/foundation.dart';
import '../data/repositories/user_address_repository.dart';
import '../data/models/user_address_model.dart';

class UserAddressProvider extends ChangeNotifier {
  final UserAddressRepository _repository;

  UserAddressProvider(this._repository);

  List<UserAddress> _addresses = [];
  bool _isLoading = false;
  bool _isMutating = false;
  String? _error;

  List<UserAddress> get addresses => _addresses;
  bool get isLoading => _isLoading;
  bool get isMutating => _isMutating;
  String? get error => _error;

  Future<void> fetchAddresses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _addresses = await _repository.getAddresses();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addAddress(UserAddress address) async {
    _isMutating = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.createAddress(address);
      await fetchAddresses();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isMutating = false;
      notifyListeners();
      return false;
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }

  Future<bool> editAddress(String id, UserAddress address) async {
    _isMutating = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.updateAddress(id, address);
      await fetchAddresses();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isMutating = false;
      notifyListeners();
      return false;
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }

  Future<bool> removeAddress(String id) async {
    _error = null;
    // Optimistic removal
    final previous = List<UserAddress>.from(_addresses);
    _addresses.removeWhere((a) => a.id == id);
    notifyListeners();
    try {
      await _repository.deleteAddress(id);
      return true;
    } catch (e) {
      _addresses = previous;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> setDefault(UserAddress address) async {
    final updated = UserAddress(
      id: address.id,
      flatNo: address.flatNo,
      building: address.building,
      locality: address.locality,
      landmark: address.landmark,
      city: address.city,
      state: address.state,
      pincode: address.pincode,
      lat: address.lat,
      lng: address.lng,
      isDefault: true,
    );
    return editAddress(address.id, updated);
  }
}

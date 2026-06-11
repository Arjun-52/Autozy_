import 'package:flutter/material.dart';
import '../data/repositories/addon_repository.dart';
import '../data/models/dto/addon_service_model.dart';
import '../core/utils/app_logger.dart';

class AddonServiceProvider extends ChangeNotifier {
  final AddonRepository _repository;

  List<AddonServiceModel> _services = [];
  bool _isLoading = false;
  String? _error;

  AddonServiceProvider(this._repository);

  List<AddonServiceModel> get services => _services;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchServices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetched = await _repository.getAddonServices();
      _services = fetched;
      AppLogger.info('Add-on services loaded: ${_services.length}', tag: 'Addons');
    } catch (e) {
      _error = e.toString();
      AppLogger.error('Failed to load add-on services', tag: 'Addons', error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

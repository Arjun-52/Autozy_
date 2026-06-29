import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../core/utils/app_logger.dart';
import '../data/repositories/vehicle_repository.dart';
import '../data/models/vehicle_model.dart';
import '../data/models/dto/add_vehicle_request.dart';
import '../data/models/dto/update_vehicle_request.dart';
import '../data/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleRepository _vehicleRepository;

  List<Vehicle> _vehicles = [];
  Vehicle? _selectedVehicle;
  bool _isLoading = false;
  String? _error;
  String? _patchStatus; // 'loading', 'success', 'error', null

  Vehicle? _createdVehicle;
  String? _creationStatus; // 'loading', 'success', 'error', null
  String? _deleteStatus; // 'loading', 'success', 'error', null

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isListLoading = false;
  bool _isPageLoading = false;
  String? _listError;

  // Vehicle Registration form state variables
  String _regNumber = "";
  String? _brand;
  String? _model;
  String? _size;
  String _latitude = "17.3850";
  String _longitude = "78.4867";
  String _parkingNotes = "";
  String _flat = "";
  String _building = "";
  String _locality = "";
  String _landmark = "";
  String _city = "";
  String _stateName = "";
  String _pincode = "";

  String get regNumber => _regNumber;
  String? get brand => _brand;
  String? get model => _model;
  String? get size => _size;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get parkingNotes => _parkingNotes;
  String get flat => _flat;
  String get building => _building;
  String get locality => _locality;
  String get landmark => _landmark;
  String get city => _city;
  String get stateName => _stateName;
  String get pincode => _pincode;

  void setRegNumber(String value) { _regNumber = value; }
  void setBrand(String? value) { _brand = value; }
  void setModel(String? value) { _model = value; }
  void setSize(String? value) { _size = value; }
  void setLatitude(String value) { _latitude = value; }
  void setLongitude(String value) { _longitude = value; }
  void setParkingNotes(String value) { _parkingNotes = value; }
  void setFlat(String value) { _flat = value; }
  void setBuilding(String value) { _building = value; }
  void setLocality(String value) { _locality = value; }
  void setLandmark(String value) { _landmark = value; }
  void setCity(String value) { _city = value; }
  void setStateName(String value) { _stateName = value; }
  void setPincode(String value) { _pincode = value; }

  bool isRegistrationFormDirty() {
    return _regNumber.isNotEmpty ||
        (_brand != null && _brand!.isNotEmpty) ||
        (_model != null && _model!.isNotEmpty) ||
        (_size != null && _size!.isNotEmpty) ||
        _parkingNotes.isNotEmpty ||
        (_latitude.isNotEmpty && _latitude != "17.3850") ||
        (_longitude.isNotEmpty && _longitude != "78.4867") ||
        _flat.isNotEmpty ||
        _building.isNotEmpty ||
        _locality.isNotEmpty ||
        _landmark.isNotEmpty ||
        _city.isNotEmpty ||
        _stateName.isNotEmpty ||
        _pincode.isNotEmpty;
  }

  void resetRegistrationForm() {
    _regNumber = "";
    _brand = null;
    _model = null;
    _size = null;
    _latitude = "17.3850";
    _longitude = "78.4867";
    _parkingNotes = "";
    _flat = "";
    _building = "";
    _locality = "";
    _landmark = "";
    _city = "";
    _stateName = "";
    _pincode = "";
    notifyListeners();
  }

  static final Map<String, String> _localImageCache = {};

  Future<void> _loadLocalImageCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith('vehicle_img_')) {
          final vehicleNum = key.replaceFirst('vehicle_img_', '');
          _localImageCache[vehicleNum] = prefs.getString(key) ?? '';
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveToLocalCache(String vehicleNumber, String url) async {
    _localImageCache[vehicleNumber] = url;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('vehicle_img_$vehicleNumber', url);
    } catch (_) {}
  }

  Future<void> _removeFromLocalCache(String vehicleNumber) async {
    _localImageCache.remove(vehicleNumber);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('vehicle_img_$vehicleNumber');
    } catch (_) {}
  }

  VehicleProvider(this._vehicleRepository) {
    _loadLocalImageCache();
  }

  List<Vehicle> get vehicles => _vehicles;
  Vehicle? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading; // legacy loading for create/delete actions
  String? get error => _error;

  /// The vehicle the user picked for the current booking. Used by checkout.
  void selectVehicle(Vehicle vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  // Pagination getters
  bool get isListLoading => _isListLoading;
  bool get isPageLoading => _isPageLoading;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Vehicle? get createdVehicle => _createdVehicle;
  String? get creationStatus => _creationStatus;
  String? get deleteStatus => _deleteStatus;
  String? get patchStatus => _patchStatus;

  Future<void> fetchVehicles({int page = 1, int limit = 20, bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _totalPages = 1;
    }

    // set appropriate loading flag
    if (page == 1) {
      _isListLoading = true;
    } else {
      _isPageLoading = true;
    }
    _listError = null;
    notifyListeners();

    try {
      final response = await _vehicleRepository.getVehicles(page: page, limit: limit);
      final fetched = response.vehicles ?? [];
      _currentPage = response.meta?.page ?? page;
      _totalPages = response.meta?.totalPages ?? 1;

      final mappedFetched = fetched.map((v) {
        final cachedUrl = _localImageCache[v.vehicleNumber];
        if (cachedUrl != null && cachedUrl.isNotEmpty) {
          return v.copyWith(vehicleImage: cachedUrl);
        }
        return v;
      }).toList();

      if (reset) {
        _vehicles = mappedFetched;
      } else {
        _vehicles.addAll(mappedFetched);
      }
    } catch (e) {
      _listError = e.toString();
    } finally {
      if (page == 1) {
        _isListLoading = false;
      } else {
        _isPageLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> refreshVehicles({int limit = 20}) async {
    await fetchVehicles(page: 1, limit: limit, reset: true);
  }

  Future<void> loadMore({int limit = 20}) async {
    if (_currentPage >= _totalPages) return;
    await fetchVehicles(page: _currentPage + 1, limit: limit);
  }

  Future<Vehicle> getVehicleById(String vehicleId) async {
    _error = null;
    try {
      final vehicle = await _vehicleRepository.getVehicleById(vehicleId);
      final cachedUrl = _localImageCache[vehicle.vehicleNumber];
      if (cachedUrl != null && cachedUrl.isNotEmpty) {
        return vehicle.copyWith(vehicleImage: cachedUrl);
      }
      return vehicle;
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<bool> createVehicle({required AddVehicleRequest request, File? imageFile}) async {
    _isLoading = true;
    _creationStatus = 'loading';
    _error = null;
    notifyListeners();

    debugPrint("Vehicle image selected: ${imageFile != null}");
    AppLogger.info('Vehicle image selected: ${imageFile != null}', tag: 'Vehicles');

    try {
      final response = await _vehicleRepository.createVehicle(request: request);
      debugPrint("Vehicle created: ${response.success}");
      AppLogger.info('Vehicle created: ${response.success}', tag: 'Vehicles');

      if (response.success && response.data != null) {
        final vehicleId = response.data!.id;
        debugPrint("Vehicle ID: $vehicleId");
        AppLogger.info('Vehicle ID: $vehicleId', tag: 'Vehicles');

        bool imageUploadSuccess = true;
        String? imageUrl;

        if (imageFile != null) {
          try {
            debugPrint("Immediately before uploadVehicleImage()");
            AppLogger.info('Calling POST /vehicles/{id}/image', tag: 'Vehicles');
            
            final filename = imageFile.path.split(RegExp(r'[/\\]')).last;
            AppLogger.info('Multipart filename: $filename', tag: 'Vehicles');

            final uploadResponse = await _vehicleRepository.uploadVehicleImageForId(vehicleId, imageFile);
            AppLogger.info('Upload status code: 201', tag: 'Vehicles'); // Success implied since no ApiException thrown
            AppLogger.info('Upload response: $uploadResponse', tag: 'Vehicles');

            final dataMap = uploadResponse['data'];
            imageUrl = uploadResponse['imageUrl'] ?? uploadResponse['image_url'] ?? uploadResponse['vehicleImage'] ??
                       (dataMap != null ? (dataMap['imageUrl'] ?? dataMap['image_url'] ?? dataMap['vehicleImage'] ?? dataMap['url']) : null);
            
            AppLogger.info('Parsed image_url: $imageUrl', tag: 'Vehicles');

            if (imageUrl != null && imageUrl.isNotEmpty) {
              await _saveToLocalCache(response.data!.vehicleNumber, imageUrl);
            }
          } catch (e, st) {
            debugPrint("Exception in provider upload phase: $e");
            debugPrint("Stacktrace: $st");
            AppLogger.error('Vehicle image upload failed after vehicle registration success', tag: 'Vehicles', error: e, stackTrace: st);
            if (e is ApiException) {
              final apiEx = e;
              AppLogger.info('Upload status code: ${apiEx.statusCode}', tag: 'Vehicles');
              AppLogger.info('Upload response: ${apiEx.body}', tag: 'Vehicles');
            } else {
              AppLogger.info('Upload response: $e', tag: 'Vehicles');
            }
            imageUploadSuccess = false;
          }
        } else {
          AppLogger.info('Upload skipped because no vehicle image was selected', tag: 'Vehicles');
        }

        _createdVehicle = response.data;
        if (imageUrl != null) {
          _createdVehicle = _createdVehicle?.copyWith(vehicleImage: imageUrl);
        }
        _vehicles.add(_createdVehicle!);

        if (imageUploadSuccess) {
          _creationStatus = 'success';
        } else {
          _creationStatus = 'image_upload_failed';
          _error = 'Vehicle added successfully, but the image could not be uploaded.';
        }

        resetRegistrationForm();
        
        debugPrint("Refreshing vehicles...");
        AppLogger.info('Refreshing vehicles...', tag: 'Vehicles');
        await refreshVehicles();
        debugPrint("Refreshed vehicle list response completed");
        AppLogger.info('Refreshed vehicle list response completed', tag: 'Vehicles');
        
        // Log image_url for every vehicle received
        for (final v in _vehicles) {
          debugPrint("Vehicle number: ${v.vehicleNumber}, image_url: ${v.imageUrl}");
        }
        
        notifyListeners();
        return true;
      } else {
        _creationStatus = 'error';
        _error = 'Unable to add vehicle';
        notifyListeners();
        return false;
      }
    } catch (e, st) {
      debugPrint("Exception in outer createVehicle block: $e");
      debugPrint("Stacktrace: $st");
      AppLogger.error('Exception in createVehicle', tag: 'Vehicles', error: e, stackTrace: st);
      if (e is ApiException) {
        final apiEx = e;
        AppLogger.info('Create Vehicle status code: ${apiEx.statusCode}', tag: 'Vehicles');
        AppLogger.info('Create Vehicle response: ${apiEx.body}', tag: 'Vehicles');
      }
      _creationStatus = 'error';
      String msg = e.toString();
      if (msg.contains('Exception:')) {
        msg = msg.replaceAll('Exception: ', '');
      }
      _error = msg;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedVehicle = await _vehicleRepository.updateVehicle(
        vehicle.id,
        vehicle,
      );
      final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
      if (index != -1) {
        _vehicles[index] = updatedVehicle;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // PATCH partial update
  Future<bool> patchVehicle(String vehicleId, UpdateVehicleRequest request, {File? imageFile}) async {
    _patchStatus = 'loading';
    _error = null;
    notifyListeners();
    try {
      UpdateVehicleRequest finalRequest = request;
      String? uploadedUrl;
      if (imageFile != null) {
        AppLogger.info('Uploading vehicle photo before updating vehicle', tag: 'Vehicles');
        final uploaded = await _vehicleRepository.uploadVehicleImage(imageFile);
        uploadedUrl = uploaded.url;
        finalRequest = UpdateVehicleRequest(
          brand: request.brand,
          model: request.model,
          parkingLocationLat: request.parkingLocationLat,
          parkingLocationLng: request.parkingLocationLng,
          parkingNotes: request.parkingNotes,
          vehicleImage: uploaded.url,
        );
      }
      final response = await _vehicleRepository.patchVehicle(vehicleId, finalRequest);
      if (response.success) {
        final existingVehicleIndex = _vehicles.indexWhere((v) => v.id == vehicleId);
        if (existingVehicleIndex != -1) {
          final v = _vehicles[existingVehicleIndex];
          if (imageFile != null && uploadedUrl != null) {
            await _saveToLocalCache(v.vehicleNumber, uploadedUrl);
          } else if (request.vehicleImage == "") {
            await _removeFromLocalCache(v.vehicleNumber);
          }
        }
        // refresh vehicle list
        await refreshVehicles();
        _patchStatus = 'success';
        notifyListeners();
        return true;
      } else {
        _patchStatus = 'error';
        _error = 'Patch failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _patchStatus = 'error';
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteVehicle(String vehicleId) async {
    _isLoading = true;
    _deleteStatus = 'loading';
    _error = null;
    notifyListeners();

    try {
      AppLogger.info('Vehicle deletion initiated', tag: 'Vehicles');
      AppLogger.info('Vehicle ID used: $vehicleId', tag: 'Vehicles');
      AppLogger.info('Delete request started', tag: 'Vehicles');

      final response = await _vehicleRepository.deleteVehicle(vehicleId);
      
      if (response.success) {
        _vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
        _deleteStatus = 'success';
        AppLogger.info('Delete request success', tag: 'Vehicles');
        AppLogger.info('Vehicle removed from state', tag: 'Vehicles');
        // refresh list to keep pagination meta correct
        await refreshVehicles();
        notifyListeners();
        return true;
      } else {
        _deleteStatus = 'error';
        _error = 'Unable to remove vehicle';
        AppLogger.error('API failures: Unable to remove vehicle', tag: 'Vehicles');
        notifyListeners();
        return false;
      }
    } catch (e, st) {
      _deleteStatus = 'error';
      String msg = e.toString();
      if (msg.contains('Exception:')) {
        msg = msg.replaceAll('Exception: ', '');
      }
      _error = msg;
      AppLogger.error('API failures: Failed to delete vehicle: $vehicleId', tag: 'Vehicles', error: e, stackTrace: st);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Vehicle>> searchVehicles(String query) async {
    _error = null;
    try {
      return await _vehicleRepository.searchVehicles(query);
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void removeVehicle(String vehicleId) {
    _vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
    notifyListeners();
  }

  void clearVehicles() {
    _vehicles.clear();
    notifyListeners();
  }
}

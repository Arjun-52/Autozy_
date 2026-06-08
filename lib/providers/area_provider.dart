import 'package:flutter/material.dart';
import '../core/utils/app_logger.dart';
import '../data/repositories/area_repository.dart';
import '../data/models/dto/nearby_areas_response.dart';

class AreaProvider extends ChangeNotifier {
  final AreaRepository _areaRepository;

  List<Area> _nearbyAreas = [];
  Area? _selectedArea;
  bool _isLoading = false;
  String? _error;

  double? _lastLat;
  double? _lastLng;

  AreaProvider(this._areaRepository);

  List<Area> get nearbyAreas => _nearbyAreas;
  Area? get selectedArea => _selectedArea;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double? get lastLat => _lastLat;
  double? get lastLng => _lastLng;

  Future<void> fetchNearbyAreas({
    required double latitude,
    required double longitude,
    bool isRefresh = false,
  }) async {
    _lastLat = latitude;
    _lastLng = longitude;
    
    if (!isRefresh) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    try {
      final response = await _areaRepository.getNearbyAreas(
        latitude: latitude,
        longitude: longitude,
      );

      final fetchedAreas = response.areas ?? [];
      
      // Sort: Available status first (AVAILABLE), then highest available slots next
      fetchedAreas.sort((a, b) {
        final aAvailable = a.status?.toUpperCase() == 'AVAILABLE';
        final bAvailable = b.status?.toUpperCase() == 'AVAILABLE';
        
        if (aAvailable && !bAvailable) return -1;
        if (!aAvailable && bAvailable) return 1;

        // If both are available or both are not, sort by slots descending
        final aSlots = a.availableSlots ?? 0;
        final bSlots = b.availableSlots ?? 0;
        return bSlots.compareTo(aSlots);
      });

      _nearbyAreas = fetchedAreas;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Area? _areaDetails;
  Area? get areaDetails => _areaDetails;

  void selectArea(Area area) {
    _selectedArea = area;
    _areaDetails = area; // Keep details in sync
    AppLogger.info('Selected service area: ${area.name} (${area.id})', tag: 'Areas');
    notifyListeners();
  }

  Future<void> fetchAreaDetails(String areaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    AppLogger.info('Controller fetch started for Area ID: $areaId', tag: 'Areas');

    try {
      final response = await _areaRepository.getAreaDetails(areaId);
      if (response.success && response.data != null) {
        _areaDetails = response.data;
        AppLogger.info('Controller fetch success', tag: 'Areas');
        AppLogger.info('UI state updates: success', tag: 'Areas');
      } else {
        _error = 'Failed to load area details';
        AppLogger.error('Controller fetch failure: Invalid response data', tag: 'Areas');
        AppLogger.info('UI state updates: error', tag: 'Areas');
      }
    } catch (e, st) {
      _error = e.toString();
      AppLogger.error('Controller fetch failure', tag: 'Areas', error: e, stackTrace: st);
      AppLogger.info('UI state updates: error', tag: 'Areas');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> joinWaitlist(String areaId, BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    AppLogger.info('Waitlist request start. Area ID: $areaId', tag: 'Areas');

    try {
      final response = await _areaRepository.joinAreaWaitlist(areaId);
      final success = response['success'] == true;
      final message = response['message'] as String?;
      
      if (success) {
        AppLogger.info('Waitlist join success', tag: 'Areas');
        AppLogger.info('UI state updates: success', tag: 'Areas');
        
        final successMsg = message ?? "Successfully joined the waitlist. We'll notify you when a slot becomes available.";
        AppLogger.info('Snackbar message displayed: $successMsg', tag: 'Areas');
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMsg),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception(message ?? 'Failed to join waitlist');
      }
    } catch (e) {
      final errStr = e.toString();
      AppLogger.info('Waitlist request failure: $errStr', tag: 'Areas');
      
      if (errStr.contains("Area is not full, you can subscribe directly")) {
        AppLogger.info('Area not full business-rule response', tag: 'Areas');
        const businessMsg = "This area has available slots. You can subscribe directly.";
        AppLogger.info('Snackbar message displayed: $businessMsg', tag: 'Areas');
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(businessMsg),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        final genericMsg = errStr.replaceAll('Exception: ', '');
        AppLogger.info('Snackbar message displayed: $genericMsg', tag: 'Areas');
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(genericMsg),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

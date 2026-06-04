import 'package:flutter/foundation.dart';
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

  void selectArea(Area area) {
    _selectedArea = area;
    AppLogger.info('Selected service area: ${area.name} (${area.id})', tag: 'Areas');
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

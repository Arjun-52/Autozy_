import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/app_logger.dart';
import '../../../providers/area_provider.dart';
import '../../../data/models/dto/nearby_areas_response.dart';

class AreaSelectionScreen extends StatefulWidget {
  const AreaSelectionScreen({super.key});

  @override
  State<AreaSelectionScreen> createState() => _AreaSelectionScreenState();
}

class _AreaSelectionScreenState extends State<AreaSelectionScreen> {
  bool _isLocating = false;
  String? _locationError;
  Area? _locallySelectedArea;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionAndGetLocation();
    });
  }

  Future<void> _checkPermissionAndGetLocation() async {
    setState(() {
      _isLocating = true;
      _locationError = null;
    });

    try {
      final permission = await Permission.location.status;
      if (permission.isDenied) {
        final requestResult = await Permission.location.request();
        if (requestResult.isDenied) {
          setState(() {
            _locationError = "Location access required to find nearby areas.";
            _isLocating = false;
          });
          return;
        }
      }

      if (await Permission.location.isPermanentlyDenied) {
        setState(() {
          _locationError = "Location access is permanently denied. Please enable it in settings.";
          _isLocating = false;
        });
        return;
      }

      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        setState(() {
          _locationError = "Location services are disabled. Please enable GPS.";
          _isLocating = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );

      if (mounted) {
        AppLogger.info('Location retrieved successfully. Lat: ${position.latitude}, Lng: ${position.longitude}', tag: 'Areas');
        await context.read<AreaProvider>().fetchNearbyAreas(
              latitude: position.latitude,
              longitude: position.longitude,
            );
      }
    } catch (e) {
      setState(() {
        _locationError = "Unable to determine current location";
        _isLocating = false;
      });
      AppLogger.error("Location fetching error", error: e);
    } finally {
      if (mounted) {
        setState(() {
          _isLocating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final areaProvider = context.watch<AreaProvider>();
    final areas = areaProvider.nearbyAreas;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text(
          "Select Service Area",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (areaProvider.lastLat != null && areaProvider.lastLng != null) {
            await areaProvider.fetchNearbyAreas(
              latitude: areaProvider.lastLat!,
              longitude: areaProvider.lastLng!,
              isRefresh: true,
            );
          } else {
            await _checkPermissionAndGetLocation();
          }
        },
        child: () {
          if (_isLocating || areaProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFF6C431)),
                  SizedBox(height: 16),
                  Text("Determining your location...", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          if (_locationError != null) {
            return _buildErrorState(
              title: "Location Error",
              message: _locationError!,
              onRetry: _checkPermissionAndGetLocation,
            );
          }

          if (areaProvider.error != null) {
            return _buildErrorState(
              title: "Server Error",
              message: areaProvider.error!.contains("SocketException")
                  ? "Unable to load nearby areas"
                  : areaProvider.error!,
              onRetry: () {
                if (areaProvider.lastLat != null && areaProvider.lastLng != null) {
                  areaProvider.fetchNearbyAreas(
                    latitude: areaProvider.lastLat!,
                    longitude: areaProvider.lastLng!,
                  );
                } else {
                  _checkPermissionAndGetLocation();
                }
              },
            );
          }

          if (areas.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: areas.length,
                  itemBuilder: (context, index) {
                    final area = areas[index];
                    final isSelected = _locallySelectedArea?.id == area.id;
                    final isAvailable = area.status?.toUpperCase() == 'AVAILABLE';

                    return GestureDetector(
                      onTap: isAvailable
                          ? () {
                              setState(() {
                                _locallySelectedArea = area;
                              });
                            }
                          : null,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.white : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFF6C431)
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Opacity(
                          opacity: isAvailable ? 1.0 : 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      area.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isAvailable
                                          ? const Color(0xFFE8F8EF)
                                          : const Color(0xFFFFECEC),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isAvailable ? "Available" : "Full",
                                      style: TextStyle(
                                        color: isAvailable ? Colors.green : Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${area.city?.name ?? ''}, ${area.city?.state ?? ''}",
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Slots Available", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${area.availableSlots ?? 0} / ${area.maxCapacity ?? 0}",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text("Coverage Radius", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${area.radiusKm ?? '0.0'} km",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _locallySelectedArea == null
                        ? null
                        : () {
                            areaProvider.selectArea(_locallySelectedArea!);
                            context.go('/home');
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF6C431),
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _locallySelectedArea == null
                          ? "Select an Area"
                          : "Confirm & Continue",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "No Areas Available Nearby",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "No service areas were found near your current location.",
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _checkPermissionAndGetLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF6C431),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Retry Search", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState({
    required String title,
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF6C431),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Retry", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

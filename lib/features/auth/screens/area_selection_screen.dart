import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/app_logger.dart';
import '../../../providers/area_provider.dart';
import '../../../data/models/dto/nearby_areas_response.dart';
import '../../../core/utils/responsive.dart';

class AreaSelectionScreen extends StatefulWidget {
  /// When true (e.g. opened via "Change" from checkout), confirming pops back to
  /// the caller instead of navigating to /home.
  final bool returnOnSelect;

  const AreaSelectionScreen({super.key, this.returnOnSelect = false});

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
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        title: Text(
          "Select Service Area",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: context.sp(16),
          ),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFFFFCB2F)),
                  SizedBox(height: context.h(16)),
                  Text(
                    "Determining your location...",
                    style: TextStyle(color: Colors.grey, fontSize: context.sp(14), fontWeight: FontWeight.w400),
                  ),
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
                  padding: EdgeInsets.all(context.w(16)),
                  itemCount: areas.length,
                  itemBuilder: (context, index) {
                    final area = areas[index];
                    final isSelected = _locallySelectedArea?.id == area.id;
                    final isAvailable = area.status?.toUpperCase() == 'AVAILABLE';

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _locallySelectedArea = area;
                        });
                        context.read<AreaProvider>().fetchAreaDetails(area.id);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: context.h(10)),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(16),
                          vertical: context.h(12),
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.white : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFFFCB2F)
                                : const Color(0xFFE9E9E9),
                            width: isSelected ? 1.8 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.015),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
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
                                      style: TextStyle(
                                        fontSize: context.sp(15),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.w(8),
                                      vertical: context.h(4),
                                    ),
                                    decoration: BoxDecoration(
                                      color: isAvailable
                                          ? const Color(0xFFE8F8EF)
                                          : const Color(0xFFFFECEC),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      isAvailable ? "Available" : "Full",
                                      style: TextStyle(
                                        color: isAvailable ? Colors.green : Colors.red,
                                        fontSize: context.sp(11),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: context.h(4)),
                              Text(
                                "${area.city?.name ?? ''}, ${area.city?.state ?? ''}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: context.sp(12),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Divider(height: context.h(18)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Slots Available",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: context.sp(11),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: context.h(2)),
                                      Text(
                                        "${area.availableSlots ?? 0} / ${area.maxCapacity ?? 0}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: context.sp(13),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Coverage Radius",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: context.sp(11),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: context.h(2)),
                                      Text(
                                        "${area.radiusKm ?? '0.0'} km",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: context.sp(13),
                                          color: Colors.black,
                                        ),
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
                padding: EdgeInsets.only(
                  left: context.w(16),
                  right: context.w(16),
                  top: context.h(16),
                  bottom: context.h(24),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_locallySelectedArea != null &&
                        areaProvider.areaDetails != null &&
                        areaProvider.areaDetails!.id == _locallySelectedArea!.id) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Selected Area Details",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: context.sp(15),
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(10),
                              vertical: context.h(4),
                            ),
                            decoration: BoxDecoration(
                              color: (areaProvider.areaDetails!.status?.toUpperCase() == 'AVAILABLE')
                                  ? const Color(0xFFE8F8EF)
                                  : const Color(0xFFFFECEC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: (areaProvider.areaDetails!.status?.toUpperCase() == 'AVAILABLE')
                                        ? Colors.green
                                        : Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: context.w(6)),
                                Text(
                                  areaProvider.areaDetails!.status?.toUpperCase() == 'AVAILABLE'
                                      ? "Available"
                                      : "Full",
                                  style: TextStyle(
                                    color: (areaProvider.areaDetails!.status?.toUpperCase() == 'AVAILABLE')
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: context.sp(12),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(12)),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(context.w(11)),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE9E9E9)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    areaProvider.areaDetails!.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: context.sp(14),
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: context.h(2)),
                                  Text(
                                    "${areaProvider.areaDetails!.city?.name ?? ''}, ${areaProvider.areaDetails!.city?.state ?? ''}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: context.sp(12),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: context.w(8)),
                          _buildMiniMetric(
                            label: "Radius",
                            value: "${areaProvider.areaDetails!.radiusKm ?? '0.0'} km",
                            icon: Icons.map_outlined,
                          ),
                          SizedBox(width: context.w(8)),
                          _buildMiniMetric(
                            label: "Slots",
                            value:
                                "${areaProvider.areaDetails!.availableSlots ?? 0}/${areaProvider.areaDetails!.maxCapacity ?? 0}",
                            icon: Icons.people_outline,
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(16)),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: context.h(46),
                      child: ElevatedButton(
                        onPressed: _locallySelectedArea == null || areaProvider.isLoading
                            ? null
                            : () {
                                final isAvailable = _locallySelectedArea!.status?.toUpperCase() == 'AVAILABLE';
                                if (isAvailable) {
                                  areaProvider.selectArea(_locallySelectedArea!);
                                  if (widget.returnOnSelect && context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go('/home');
                                  }
                                } else {
                                  areaProvider.joinWaitlist(_locallySelectedArea!.id, context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFCB2F),
                          disabledBackgroundColor: Colors.grey.shade300,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: areaProvider.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                              )
                            : Text(
                                _locallySelectedArea == null
                                    ? "Select an Area"
                                    : (_locallySelectedArea!.status?.toUpperCase() == 'AVAILABLE'
                                        ? "Confirm & Continue"
                                        : "Join Waitlist"),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.sp(14),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }(),
      ),
    );
  }

  Widget _buildMiniMetric({required String label, required String value, required IconData icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(8)),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          SizedBox(height: context.h(4)),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: context.sp(10),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: context.h(2)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: context.sp(12),
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off_outlined, size: context.w(64), color: Colors.grey),
            SizedBox(height: context.h(16)),
            Text(
              "No Areas Available Nearby",
              style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(8)),
            Text(
              "No service areas were found near your current location.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: context.sp(13), fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            ElevatedButton(
              onPressed: _checkPermissionAndGetLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCB2F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Retry Search",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: context.sp(13)),
              ),
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
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: context.w(64), color: Colors.redAccent),
            SizedBox(height: context.h(16)),
            Text(
              title,
              style: TextStyle(fontSize: context.sp(18), fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(8)),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade600, fontSize: context.sp(13), fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCB2F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Retry",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: context.sp(13)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../core/utils/app_logger.dart';

class MapPickerResult {
  final double latitude;
  final double longitude;
  final String address;

  MapPickerResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class MapPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapPickerScreen({
    super.key,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(17.3850, 78.4867); // Default
  String _currentAddress = "Loading address...";
  bool _isGeocoding = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null) {
      _center = LatLng(widget.initialLat!, widget.initialLng!);
    } else {
      _getUserLocation();
    }
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition();
      LatLng userLatLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _center = userLatLng;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(userLatLng));
    } catch (e) {
      AppLogger.error('Failed to get user location on map', error: e);
    }
  }

  Future<void> _updateAddress(LatLng position) async {
    setState(() {
      _isGeocoding = true;
      _currentAddress = "Loading address...";
    });
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        List<String> parts = [];
        if (place.name != null && place.name!.isNotEmpty && place.name != place.street) {
          parts.add(place.name!);
        }
        if (place.street != null && place.street!.isNotEmpty) {
          parts.add(place.street!);
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          parts.add(place.subLocality!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          parts.add(place.locality!);
        }
        
        setState(() {
          _currentAddress = parts.isNotEmpty ? parts.join(', ') : "Selected Location";
        });
      } else {
        setState(() {
          _currentAddress = "Selected Location";
        });
      }
    } catch (e) {
      AppLogger.error('Geocoding error', error: e);
      setState(() {
        _currentAddress = "Selected Location";
      });
    } finally {
      setState(() {
        _isGeocoding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Parking Location"),
        backgroundColor: const Color(0xFFF6C431),
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _updateAddress(_center);
            },
            onCameraMove: (position) {
              _center = position.target;
            },
            onCameraIdle: () {
              _updateAddress(_center);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36.0),
              child: const Icon(
                Icons.location_on,
                size: 45,
                color: Colors.redAccent,
              ),
            ),
          ),
          
          Positioned(
            right: 16,
            bottom: 150,
            child: FloatingActionButton(
              onPressed: _getUserLocation,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PARKING ADDRESS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFF6C431)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isGeocoding
                          ? null
                          : () {
                              Navigator.pop(
                                context,
                                MapPickerResult(
                                  latitude: _center.latitude,
                                  longitude: _center.longitude,
                                  address: _currentAddress,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF6C431),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Confirm Location",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

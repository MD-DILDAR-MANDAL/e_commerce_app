import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class OsmMapPickerScreen extends StatefulWidget {
  const OsmMapPickerScreen({super.key});

  @override
  State<OsmMapPickerScreen> createState() => _OsmMapPickerScreenState();
}

class _OsmMapPickerScreenState extends State<OsmMapPickerScreen> {
  LatLng? _selectedLatLng;
  MapController? _mapController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position pos = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLatLng = LatLng(pos.latitude, pos.longitude);
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _selectedLatLng = LatLng(28.6139, 77.20900);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _selectedLatLng == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _selectedLatLng!,
          initialZoom: 14.0,
          onTap: (tapPosition, latLng) {
            setState(() {
              _selectedLatLng = latLng;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            //subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.e_commerce_app',
          ),
          if (_selectedLatLng != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _selectedLatLng!,
                  width: 48,
                  height: 48,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.check),
        label: Text('use this location'),
        onPressed: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => const Center(child: CircularProgressIndicator()),
          );
          try {
            final placemarks = await placemarkFromCoordinates(
              _selectedLatLng!.latitude,
              _selectedLatLng!.longitude,
            );
            final place = placemarks.isNotEmpty ? placemarks.first : null;
            String address = place != null
                ? "${place.street ?? ''},${place.locality ?? ''},${place.administrativeArea ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}"
                : '${_selectedLatLng!.latitude}, ${_selectedLatLng!.longitude}';

            Navigator.of(context).pop();
            Navigator.of(
              context,
            ).pop({'latLng': _selectedLatLng, 'address': address});
          } catch (e) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to get address"),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }
}

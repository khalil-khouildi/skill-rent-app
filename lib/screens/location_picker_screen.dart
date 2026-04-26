import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  
  const LocationPickerScreen({super.key, this.initialLocation});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _selectedAddress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation ?? const LatLng(48.8566, 2.3522);
  }

  Future<void> _getAddressFromLocation(LatLng location) async {
    if (kIsWeb) return;
    setState(() => _isLoading = true);
    
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '';
        
        if (place.street != null) address += place.street!;
        if (place.locality != null) address += ', ${place.locality}';
        if (place.postalCode != null) address += ' ${place.postalCode}';
        if (place.country != null) address += ', ${place.country}';
        
        setState(() => _selectedAddress = address);
      }
    } catch (e) {
      print('Erreur: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionner un lieu', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation!,
              zoom: 14,
            ),
            onTap: (LatLng position) async {
              setState(() => _selectedLocation = position);
              await _getAddressFromLocation(position);
              
              // Ajouter un marqueur
              _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: position, zoom: 14),
                ),
              );
            },
            markers: {
              if (_selectedLocation != null)
                Marker(
                  markerId: const MarkerId('selected'),
                  position: _selectedLocation!,
                  infoWindow: InfoWindow(
                    title: 'Position sélectionnée',
                    snippet: _selectedAddress ?? 'Chargement...',
                  ),
                ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _selectedLocation == null
                  ? null
                  : () {
                      Navigator.pop(context, {
                        'location': _selectedLocation,
                        'address': _selectedAddress ?? 'Lieu sélectionné',
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005BBF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Confirmer cette position', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

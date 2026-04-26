import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleLocationService {
  final String _apiKey = 'AIzaSyCfOezmuy9z00jOu7GvrHGO6guUNSrL9fA';
  Position? _currentPosition;
  LatLng? _currentLatLng;
  String? _currentAddress;

  LatLng? get currentLatLng => _currentLatLng;
  String? get currentAddress => _currentAddress;

  // Demander les permissions
  Future<bool> requestPermissions() async {
    if (kIsWeb) return true; // Les navigateurs gèrent les permissions via le dialogue natif
    
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }

  // Obtenir la position actuelle
  Future<LatLng?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestPermissions();
      if (!hasPermission) return null;

      if (!kIsWeb) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _currentPosition = position;
      _currentLatLng = LatLng(position.latitude, position.longitude);
      await _getAddressFromCoordinates();
      
      return _currentLatLng;
    } catch (e) {
      print('❌ Erreur localisation: $e');
      return null;
    }
  }

  // Obtenir l'adresse
  Future<String?> _getAddressFromCoordinates() async {
    if (_currentPosition == null) return null;
    
    if (kIsWeb) {
      try {
        final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_currentPosition!.latitude},${_currentPosition!.longitude}&key=$_apiKey';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK' && data['results'].isNotEmpty) {
            _currentAddress = data['results'][0]['formatted_address'];
            return _currentAddress;
          }
        }
      } catch (e) {
        print('❌ Erreur géocodage Web: $e');
      }
      return null;
    }
    
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '';
        
        if (place.street != null) address += place.street!;
        if (place.locality != null) address += ', ${place.locality}';
        if (place.country != null) address += ', ${place.country}';
        
        _currentAddress = address;
        return address;
      }
    } catch (e) {
      print('❌ Erreur géocodage: $e');
    }
    return null;
  }

  // Convertir adresse en coordonnées
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    if (kIsWeb) {
      try {
        final url = 'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$_apiKey';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK' && data['results'].isNotEmpty) {
            final loc = data['results'][0]['geometry']['location'];
            return LatLng(loc['lat'], loc['lng']);
          }
        }
      } catch (e) {
        print('❌ Erreur conversion adresse Web: $e');
      }
      return null;
    }

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print('❌ Erreur conversion adresse: $e');
    }
    return null;
  }

  // Calculer la distance
  double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude, point1.longitude,
      point2.latitude, point2.longitude,
    );
  }

  // Formater la distance
  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} mètres';
    } else {
      double km = meters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }
}

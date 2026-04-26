import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/google_location_service.dart';
import '../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final GoogleLocationService _locationService = GoogleLocationService();
  
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  String? _currentAddress;
  
  bool _isLoading = true;
  bool _isMapReady = false;
  
  // Marqueurs
  final Set<Marker> _markers = {};
  
  // Liste des freelances (chargée depuis Firebase)
  List<Map<String, dynamic>> _freelancers = [];

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    await _locationService.requestPermissions();
    await _getUserLocation();
    await _fetchFreelancersFromFirebase();
    _loadFreelancersMarkers();
  }

  Future<void> _fetchFreelancersFromFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'freelancer')
          .get();
      
      if (mounted) {
        setState(() {
          _freelancers = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).where((f) => f['latitude'] != null && f['longitude'] != null).toList();
        });
      }
      print('📍 Freelancers chargés sur la carte: ${_freelancers.length}');
    } catch (e) {
      print('❌ Erreur fetch freelancers: $e');
    }
  }

  Future<void> _getUserLocation() async {
    if (mounted) setState(() => _isLoading = true);
    
    final location = await _locationService.getCurrentLocation();
    final address = _locationService.currentAddress;
    
    if (mounted) {
      setState(() {
        _currentLocation = location;
        _currentAddress = address;
        _isLoading = false;
      });
      
      if (location != null && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: location,
              zoom: 14,
            ),
          ),
        );
        
        // Ajouter marqueur utilisateur
        _addUserMarker(location);
      }
    }
  }

  void _addUserMarker(LatLng location) {
    if (mounted) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('current_user'),
            position: location,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
              title: 'Votre position',
              snippet: _currentAddress,
            ),
          ),
        );
      });
    }
  }

  void _loadFreelancersMarkers() {
    if (_currentLocation == null) return;
    
    // Vider les anciens marqueurs de freelances (garder celui de l'utilisateur)
    _markers.removeWhere((m) => m.markerId.value != 'current_user');
    
    for (var freelancer in _freelancers) {
      final lat = freelancer['latitude'];
      final lng = freelancer['longitude'];
      if (lat == null || lng == null) continue;

      final position = LatLng(lat, lng);
      final distance = _locationService.calculateDistance(
        _currentLocation!,
        position,
      );
      final distanceText = _locationService.formatDistance(distance);
      final name = freelancer['fullName'] ?? 'Freelancer';
      final category = freelancer['category'] ?? 'Service';
      final rating = (freelancer['rating'] ?? 0.0).toStringAsFixed(1);
      
      if (mounted) {
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(freelancer['id']),
              position: position,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              infoWindow: InfoWindow(
                title: name,
                snippet: '$category • $rating⭐ • À $distanceText',
              ),
              onTap: () {
                _showFreelancerDetails(freelancer, distanceText);
              },
            ),
          );
        });
      }
    }
  }

  void _showFreelancerDetails(Map<String, dynamic> freelancer, String distance) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F3FD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 24, color: Color(0xFF005BBF)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        freelancer['fullName'] ?? 'Freelancer',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        freelancer['category'] ?? 'Service',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        (freelancer['rating'] ?? 0.0).toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${freelancer['price'] ?? 40}€',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF005BBF),
                          ),
                        ),
                        const Text(
                          'Tarif /h',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600]),
                        const SizedBox(height: 4),
                        Text(
                          distance,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Naviguer vers le profil du freelance
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005BBF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Voir le profil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchAddress() async {
    final TextEditingController searchController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Entrez une adresse...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) async {
                final coordinates = await _locationService.getCoordinatesFromAddress(value);
                if (coordinates != null && _mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: coordinates, zoom: 15),
                    ),
                  );
                  Navigator.pop(context);
                  
                  // Ajouter un marqueur temporaire
                  setState(() {
                    _markers.add(
                      Marker(
                        markerId: const MarkerId('search_result'),
                        position: coordinates,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        infoWindow: InfoWindow(
                          title: 'Recherche',
                          snippet: value,
                        ),
                      ),
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9F9FF),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentLocation == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9F9FF),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Position non disponible',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Activez votre GPS et réessayez',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _getUserLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Freelances à proximité',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_currentAddress != null)
              Text(
                _currentAddress!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _searchAddress,
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: _getUserLocation,
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
          setState(() => _isMapReady = true);
          
          if (_currentLocation != null) {
            _addUserMarker(_currentLocation!);
          }
        },
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        compassEnabled: true,
        zoomControlsEnabled: true,
        mapToolbarEnabled: true,
        onTap: (LatLng position) {
          print('Carte tapée à: $position');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _getUserLocation();
          if (_mapController != null && _currentLocation != null) {
            _mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: _currentLocation!, zoom: 14),
              ),
            );
          }
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}

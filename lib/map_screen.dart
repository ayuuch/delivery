import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'auth_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedLocation; // Stocker l'emplacement sélectionné
  final AuthService authService = AuthService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  /// Demande les autorisations de localisation et obtient la position actuelle
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Invite l'utilisateur à activer le service de localisation
      await Geolocator.openLocationSettings();
      return;
    }

    // Vérifie si l'autorisation de localisation est accordée
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar('Location permissions are permanently denied.');
      return;
    }

    // Si autorisation accordée, obtient la position actuelle
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      selectedLocation = LatLng(position.latitude, position.longitude);
      isLoading = false; // Arrête l'indicateur de chargement
    });
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      selectedLocation = location;
    });
  }

  Future<void> _sendLocationToBackend(LatLng location) async {
    final token = Get.arguments['token']; // Récupère le token de l'utilisateur
    final response =
        await authService.sendLocation(location.latitude, location.longitude, token);

    if (response.statusCode == 201) {
      _showSnackBar('Location saved successfully!', success: true);
    } else {
      _showSnackBar('Failed to save location.');
    }
  }

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your Location',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow.shade700,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Carte ou écran de chargement
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : FlutterMap(
                  options: MapOptions(
                    center: selectedLocation,
                    zoom: 15.0,
                    onTap: (tapPosition, point) {
                      _onMapTapped(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    if (selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: selectedLocation!,
                            builder: (ctx) => Icon(
                              Icons.location_pin,
                              color: Colors.yellow.shade700,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
          // Bouton pour sauvegarder la localisation
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                if (selectedLocation != null) {
                  _sendLocationToBackend(selectedLocation!);
                } else {
                  _showSnackBar('Please select a location.');
                }
              },
              icon: Icon(Icons.save_alt, color: Colors.black),
              label: Text(
                'Save Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade700,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          if (selectedLocation == null && !isLoading)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                color: Colors.black,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.yellow.shade700),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tap on the map to select your location.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

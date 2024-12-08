import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'game.dart'; // Import the new game page
import 'gameidcall.dart'; // Import the fetchGameId functions

class Map extends StatelessWidget {
  final int radius;
  final String gameId;

  const Map({super.key, required this.radius, required this.gameId}); // Accept radius as a parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyMapWidget(radius: radius, gameId: gameId), // Pass the radius to MyMapWidget
    );
  }
}

class MyMapWidget extends StatefulWidget {
  final int radius;
  final String gameId;

  const MyMapWidget({super.key, required this.radius, required this.gameId}); // Accept radius as a parameter

  @override
  createState() => _MyMapWidgetState();
}

class _MyMapWidgetState extends State<MyMapWidget> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(0, 0); // Initialize with a default value
  Set<Marker> _markers = {}; // Set to hold markers
  Set<Polyline> _polylines = {}; // Set to hold polylines

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();

    // Update state and move camera to current position
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 16.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers, // Add markers to the map
            polylines: _polylines, // Add polylines to the map
          ),
          _buildOverlayButtons(context),
        ],
      ),
    );
  }

  Widget _buildOverlayButtons(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewGamePage(
                    latitude: _currentPosition.latitude,
                    longitude: _currentPosition.longitude,
                    radius: widget.radius, // Use the passed radius
                    gameId: widget.gameId,
                  ),
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.camera, size: 30.0),
          ),
          FloatingActionButton(
            onPressed: () async {
              // Fetch the score
              String score = await fetchGameId('https://71ec-5-2-197-133.ngrok-free.app/api/v1/score/sebi?longitude=${_currentPosition.longitude}&latitude=${_currentPosition.latitude}&radius=${widget.radius}&gameId=${widget.gameId}');
               List<double> lista = await fetchCoordinatesId('https://71ec-5-2-197-133.ngrok-free.app/api/v1/score/coordinates?gameId=${widget.gameId}');

              // Parse the score and position
      
              await Future.delayed(const Duration(seconds: 1));

              // Add a red marker at the specified latitude and longitude
              LatLng markerPosition = LatLng(lista[0], lista[1]);
              
              setState(() {
                _markers.add(Marker(
                  markerId: const MarkerId('score'),
                  position: markerPosition,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ));

                // Draw a polyline between the current position and the new marker
                _polylines.add(Polyline(
                  polylineId: const PolylineId('line_to_marker'),
                  points: [_currentPosition, markerPosition],
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: 4,
                  patterns: [PatternItem.dash(20), PatternItem.gap(35)], // Make the line discontinued
                ));


                mapController.animateCamera(CameraUpdate.newLatLng(LatLng(lista[0], lista[1])));

              });
            
              // Show the SnackBar
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                  'Score: $score',
                  style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color.fromARGB(255, 38, 229, 48),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 650),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  ),
                  duration: const Duration(seconds: 5),
                ));
              }

              // Wait for 5 seconds
              await Future.delayed(const Duration(seconds: 10));

              // Navigate to the home page
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ),
                );
              }
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.send, size: 30.0), // Use a different icon
          ),
        ],
      ),
    );
  }
}

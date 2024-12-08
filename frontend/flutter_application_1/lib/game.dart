import 'package:flutter/material.dart';
import 'package:flutter_application_1/webview.dart';
import 'map.dart' as map;
import 'minimap.dart' as minimap;

class NewGamePage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final int radius;
  final String gameId;

  const NewGamePage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: WebViewPage( // Use WebViewPage instead of Map
              latitude: latitude,
              longitude: longitude,
              radius: radius,
              gameId: gameId,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              width: 150,
              height: 150,
              color: Colors.blue, // You can customize this as needed
              child: Center(
                child: minimap.MyMapWidget(radius: radius, gameId: gameId), // Pass the radius to MyMapWidget
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => map.MyMapWidget(radius: radius, gameId: gameId),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.map, size: 30.0),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/gameidcall.dart';
import 'map.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _radius = 500; // Initial radius value
  String _gameId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.blue.withOpacity(0.3),
                trackHeight: 8.0,
                thumbColor: Colors.blue,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                overlayColor: Colors.blue.withOpacity(0.2),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              child: Slider(
                value: _radius.toDouble(),
                min: 500,
                max: 10000,
                divisions: 19,
                label: '${_radius.round()} m',
                onChanged: (value) {
                  setState(() {
                    _radius = value.toInt();
                  });
                },
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                // Fetch the game ID
                String gameId = await fetchGameId('https://71ec-5-2-197-133.ngrok-free.app/api/v1/game/sebi');
                
                // Update the state with the fetched game ID
                setState(() {
                  _gameId = gameId;
                });

                // Wait for 2 seconds
                await Future.delayed(const Duration(seconds: 2));

                // Navigate to the next page
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyMapWidget(radius: _radius, gameId: _gameId), // Pass radius and gameId
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: const TextStyle(fontSize: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Open Map'),
            ),
          ],
        ),
      ),
    );
  }
}

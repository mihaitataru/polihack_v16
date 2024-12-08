import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LeadbordsWidget extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchLeaderboardData() async {
    final response = await http.get(Uri.parse('https://71ec-5-2-197-133.ngrok-free.app/api/v1/score/users'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => {
        'username': item['username'],
        'score': item['score'],
      }).toList();
    } else {
      throw Exception('Failed to load leaderboard data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchLeaderboardData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else {
              final leaderboardData = snapshot.data ?? [];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: leaderboardData.length,
                      itemBuilder: (BuildContext context, int index) {
                        int rank = index + 1;
                        final player = leaderboardData[index];

                        // Determine the color and icon for the rank
                        Color rankColor;
                        IconData? rankIcon;
                        if (rank == 1) {
                          rankColor = Colors.amber; // Gold
                          rankIcon = Icons.emoji_events; // Trophy icon
                        } else if (rank == 2) {
                          rankColor = Colors.grey; // Silver
                          rankIcon = Icons.emoji_events_outlined; // Silver Trophy
                        } else if (rank == 3) {
                          rankColor = Colors.deepOrange; // Bronze
                          rankIcon = Icons.emoji_events_outlined; // Bronze Trophy
                        } else {
                          rankColor = Colors.lightBlue; // Default rank color
                          rankIcon = null;
                        }

                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 8,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: rankColor,
                              child: rankIcon != null
                                  ? Icon(rankIcon, color: Colors.white)
                                  : Text(
                                      '$rank',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            title: Text(
                              player['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.indigo,
                              ),
                            ),
                            subtitle: Text(
                              'Score: ${player['score']}',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
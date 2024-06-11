import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Patient/Pharmacy/nearby.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Places',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NearbyPlacesPage(),
    );
  }
}

class NearbyPlacesPage extends StatefulWidget {
  @override
  _NearbyPlacesPageState createState() => _NearbyPlacesPageState();
}

class _NearbyPlacesPageState extends State<NearbyPlacesPage> {
  late Future<List<Nearby>> _nearbyPlaces = Future.value([]); // Initialize with an empty list

  Future<void> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _nearbyPlaces = fetchNearbyPlaces(position.latitude, position.longitude);
    });

    print('Latitude: ${position.latitude}');
    print('Longitude: ${position.longitude}');
  }

  Future<List<Nearby>> fetchNearbyPlaces(double latitude, double longitude) async {
    final userLocation = '$latitude,$longitude';
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?type=pharmacy&location=$userLocation&radius=10000&key=AIzaSyABU4Dq6xe0a4uWhJWU5dQEGSySZdvBROA';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      List<Nearby> nearbyPlaces = [];

      for (var place in results) {
        Nearby nearby = Nearby.fromJson(place);
        nearby.photos = []; // Initialize photos list

        // Extract photo references
        if (place['photos'] != null) {
          for (var photo in place['photos']) {
            nearby.photos!.add(Photos.fromJson(photo));
          }
        }

        // Calculate distance and duration
        final result = await getDistanceAndDuration(
          LatLng(latitude, longitude),
          LatLng(place['geometry']['location']['lat'], place['geometry']['location']['lng']),
        );

        nearby.distance = result['distance'];
        nearby.duration = result['duration'];

        nearbyPlaces.add(nearby);
      }

      // Sort the list by distance
      nearbyPlaces.sort((a, b) {
        final distanceA = double.tryParse(a.distance?.split(' ')[0] ?? '') ?? double.infinity;
        final distanceB = double.tryParse(b.distance?.split(' ')[0] ?? '') ?? double.infinity;
        return distanceA.compareTo(distanceB);
      });

      return nearbyPlaces;
    } else {
      throw Exception('Failed to load nearby places');
    }
  }

  Future<Map<String, String>> getDistanceAndDuration(LatLng origin, LatLng destination) async {
    final apiKey = 'AIzaSyABU4Dq6xe0a4uWhJWU5dQEGSySZdvBROA';
    final apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}&'
        'destination=${destination.latitude},${destination.longitude}&'
        'mode=driving&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);

      if (decodedData['status'] == 'OK') {
        final List<dynamic> routes = decodedData['routes'];
        if (routes.isNotEmpty) {
          final List<dynamic> legs = routes[0]['legs'];
          if (legs.isNotEmpty) {
            final Map<String, String> result = {
              'distance': legs[0]['distance']['text'],
              'duration': legs[0]['duration']['text'],
            };
            return result;
          }
        }
      }
    }

    print('Failed to fetch distance and duration');
    return {};
  }

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Places'),
      ),
      body: Center(
        child: FutureBuilder<List<Nearby>>(
          future: _nearbyPlaces,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final place = snapshot.data![index];
                  return ListTile(
                    title: Text(place.name ?? 'Unknown'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Business Status: ${place.businessStatus ?? 'Unknown'}'),
                        if (place.distance != null && place.duration != null)
                          Text('Distance: ${place.distance} | Duration: ${place.duration}'),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return SizedBox(); // Placeholder
          },
        ),
      ),
    );
  }
}
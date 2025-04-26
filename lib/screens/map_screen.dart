import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  double _currentZoom = 12.0;
  LatLng? _userLocation;

  final List<Map<String, dynamic>> stadiums = [
    {
      'name': 'Astana Arena',
      'position': LatLng(51.106826, 71.392560),
      'description': 'Capacity: 30,000 spectators\nHome stadium of FC Astana.',
    },
    {
      'name': 'Sairan Arena',
      'position': LatLng(51.1252, 71.4603),
      'description': 'A multifunctional sports complex for various events.',
    },
    {
      'name': 'Munaitpasov Stadium',
      'position': LatLng(51.1580, 71.4322),
      'description': 'One of the oldest stadiums in Astana.',
    },
    {
      'name': 'Another Stadium',
      'position': LatLng(51.090459, 71.408736),
      'description': 'Newly added stadium for sports events.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _moveToPosition(LatLng position) {
    _mapController.move(position, _currentZoom);
  }

  void _showStadiumInfo(String name, String description) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(name),
        content: Text(description),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  Future<void> _searchStadium(String query) async {
    final fullQuery = '$query Astana Kazakhstan';
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$fullQuery&format=json&limit=1');

    try {
      final response = await http.get(url, headers: {'User-Agent': 'FlutterApp'});
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final double lat = double.parse(data[0]['lat']);
          final double lon = double.parse(data[0]['lon']);
          final LatLng foundPosition = LatLng(lat, lon);

          _moveToPosition(foundPosition);
          _showStadiumInfo(query, 'Found stadium based on search.');
        } else {
          _showError('Stadium not found. Try a different name.');
        }
      } else {
        _showError('Failed to search.');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _moveToUserLocation() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 16); // Увеличенный зум
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User location not available.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stadium Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  final TextEditingController _controller = TextEditingController();
                  return AlertDialog(
                    title: const Text('Search Stadium'),
                    content: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Enter stadium name'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _searchStadium(_controller.text);
                          Navigator.pop(context);
                        },
                        child: const Text('Search'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(51.1282, 71.4304),
              zoom: _currentZoom,
              onTap: (_, __) {},
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  ...stadiums.map((stadium) {
                    return Marker(
                      width: 40,
                      height: 40,
                      point: stadium['position'],
                      child: GestureDetector(
                        onTap: () {
                          _moveToPosition(stadium['position']);
                          _showStadiumInfo(stadium['name'], stadium['description']);
                        },
                        child: const Icon(
                          Icons.stadium,
                          color: Colors.blueAccent,
                          size: 30,
                        ),
                      ),
                    );
                  }).toList(),
                  if (_userLocation != null)
                    Marker(
                      width: 40,
                      height: 40,
                      point: _userLocation!,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  mini: true,
                  child: const Icon(Icons.add),
                  onPressed: _zoomIn,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  mini: true,
                  child: const Icon(Icons.remove),
                  onPressed: _zoomOut,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'my_location',
                  mini: true,
                  child: const Icon(Icons.my_location),
                  onPressed: _moveToUserLocation,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

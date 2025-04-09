import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  final List<LatLng> taskLocations;
  final List<String> taskNames;
  final Function(GoogleMapController)? onMapCreated;

  const MapPage({
    super.key,
    required this.taskLocations,
    required this.taskNames,
    this.onMapCreated,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final String _googleApiKey = 'AIzaSyBBIiosm_7Yl46uYsFy5lUdwj0DLUxSeVk';

  LatLng? _currentDestination;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
    _setMarkers();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  void _setMarkers() {
    _markers.clear();
    for (int i = 0; i < widget.taskLocations.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: widget.taskLocations[i],
          infoWindow: InfoWindow(
            title: widget.taskNames[i],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          onTap: () => _createRoute(widget.taskLocations[i]),
        ),
      );
    }
    setState(() {});
  }

  void _startLocationUpdates() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentPosition!),
        );
      }

      if (_currentDestination != null) {
        _createRoute(_currentDestination!);
      }
    });
  }

  Future<void> _createRoute(LatLng destination) async {
    if (_currentPosition == null) return;

    _currentDestination = destination;

    final origin = '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final dest = '${destination.latitude},${destination.longitude}';

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$dest&mode=walking&key=$_googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nie znaleziono trasy do tego punktu.')),
        );
        return;
      }

      final points = data['routes'][0]['overview_polyline']['points'];
      final polylinePoints = _decodePolyline(points);

      setState(() {
        _polylines.clear();
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: polylinePoints,
        ));
      });
    } else {
      print('❌ Błąd API: ${response.body}');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return _currentPosition == null
        ? const Center(child: CircularProgressIndicator())
        : Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFA3822A), width: 3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 400,
          width: 380,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 15,
            ),
            myLocationEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
              if (widget.onMapCreated != null) {
                widget.onMapCreated!(controller);
              }
            },
            markers: _markers,
            polylines: _polylines,
          ),
        ),
      ),
    );
  }
}

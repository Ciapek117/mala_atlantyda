import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pGooglePlex = LatLng(54.463687912308444, 17.014346844387898);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c4767),
      body: Center(
        child: SizedBox(
          height: 500, // Większy rozmiar, aby mapa była lepiej widoczna
          width: 500,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFA3822A), width: 3), // Obramowanie
                  borderRadius: BorderRadius.circular(20), // Zaokrąglenie rogów
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Zaokrąglenie wewnątrz
                  child: SizedBox(
                    height: 400,
                    width: 380,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(target: _pGooglePlex, zoom: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

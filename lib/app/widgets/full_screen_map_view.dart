import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../utils/app_size.dart';
import 'package:latlong2/latlong.dart';

class FullScreenMapView extends StatelessWidget {
  final String title;
  final double latitude;
  final double longitude;

  const FullScreenMapView({
    super.key,
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6B5345);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xffF3EFE9),
        iconTheme: const IconThemeData(color: primaryColor),
        elevation: 0,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 16.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://mt1.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}',
            userAgentPackageName: 'com.example.george',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(latitude, longitude),
                width: 60.r,
                height: 60.r,
                child: Icon(
                  Icons.location_on,
                  color: const Color(0xFFC62828),
                  size: 45.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

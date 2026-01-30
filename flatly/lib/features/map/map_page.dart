import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Mapa
          Positioned.fill(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(40.4168, -3.7038), // Madrid
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.flatly.app',
                ),
              ],
            ),
          ),

          // Search Bar Overlay
          Positioned(
            top: 20, // SafeArea padding usually
            left: 16,
            right: 16,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  SizedBox(width: 16),
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 12),
                  Text(
                    'Buscar piso...',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.22,
            minChildSize: 0.16,
            maxChildSize: 0.70,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 20,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: const [
                    SizedBox(height: 6),
                    Center(
                      child: SizedBox(
                        width: 42,
                        height: 5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFFD1D5DB),
                            borderRadius: BorderRadius.all(
                              Radius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Pisos cercanos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('Aquí irá la lista de pisos (mock)'),
                    SizedBox(height: 400), // para poder scrollear
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

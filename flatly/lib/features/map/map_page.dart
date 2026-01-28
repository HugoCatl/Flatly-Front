import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Fondo "mapa" placeholder
          Positioned.fill(
            child: Container(
              color: AppColors.backgroundAlt,
              child: const Center(child: Text('MAPA (placeholder)')),
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

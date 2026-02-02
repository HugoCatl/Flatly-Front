// lib/features/map/pages/map_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../data/mock_properties.dart';
import '../models/property_model.dart';
import 'search_page.dart';
import 'filters_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  List<PropertyModel> _allProperties = MockProperties.madridProperties;
  List<PropertyModel> _properties = MockProperties.madridProperties;
  PropertyModel? _selectedProperty;
  PropertyFilters _filters = PropertyFilters();

  void _toggleFavorite(int propertyId) {
    setState(() {
      final index = _allProperties.indexWhere((p) => p.id == propertyId);
      if (index != -1) {
        // TODO: Aquí harías la llamada al backend: POST /api/favorites/:propertyId
        final prop = _allProperties[index];
        _allProperties[index] = PropertyModel(
          id: prop.id,
          title: prop.title,
          description: prop.description,
          priceMonth: prop.priceMonth,
          city: prop.city,
          zone: prop.zone,
          rooms: prop.rooms,
          bathrooms: prop.bathrooms,
          squareMeters: prop.squareMeters,
          isFurnished: prop.isFurnished,
          expensesIncluded: prop.expensesIncluded,
          latitude: prop.latitude,
          longitude: prop.longitude,
          address: prop.address,
          images: prop.images,
          tags: prop.tags,
          isFavorite: !prop.isFavorite,
        );
        _applyFilters();
      }
    });
  }

  void _onMarkerTap(PropertyModel property) {
    setState(() {
      _selectedProperty = property;
    });
    // Centrar el mapa en el marcador con un zoom suave
    _mapController.move(
      LatLng(property.latitude, property.longitude),
      15,
    );
  }

  void _closePreview() {
    setState(() {
      _selectedProperty = null;
    });
  }

  void _openPropertyDetail() {
    if (_selectedProperty != null) {
      // TODO: Navegar a la página de detalle del piso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Abrir detalle de: ${_selectedProperty!.title}'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
          allProperties: _allProperties,
          onPropertySelected: (property) {
            _onMarkerTap(property);
          },
        ),
      ),
    );
  }

  Future<void> _openFilters() async {
    final result = await Navigator.push<PropertyFilters>(
      context,
      MaterialPageRoute(
        builder: (context) => FiltersPage(
          currentFilters: _filters,
          allProperties: _allProperties,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _filters = result;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _properties = _allProperties.where((property) {
        // Filtro de precio
        if (_filters.minPrice != null && property.priceMonth < _filters.minPrice!) {
          return false;
        }
        if (_filters.maxPrice != null && property.priceMonth > _filters.maxPrice!) {
          return false;
        }

        // Filtro de habitaciones
        if (_filters.rooms != null && property.rooms != _filters.rooms) {
          return false;
        }

        // Filtro de baños
        if (_filters.bathrooms != null && property.bathrooms != _filters.bathrooms) {
          return false;
        }

        // Filtro de tags
        if (_filters.selectedTags.isNotEmpty) {
          final hasAllTags = _filters.selectedTags.every(
            (tag) => property.tags.contains(tag),
          );
          if (!hasAllTags) return false;
        }

        // Filtro de amueblado
        if (_filters.isFurnished != null && property.isFurnished != _filters.isFurnished) {
          return false;
        }

        // Filtro de gastos incluidos
        if (_filters.expensesIncluded != null && property.expensesIncluded != _filters.expensesIncluded) {
          return false;
        }

        return true;
      }).toList();

      // Si el piso seleccionado ya no está en los filtrados, deseleccionarlo
      if (_selectedProperty != null && !_properties.contains(_selectedProperty)) {
        _selectedProperty = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Mapa
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(40.4168, -3.7038),
                initialZoom: 13.0,
                minZoom: 11.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.flatly.app',
                ),
                // Marcadores
                MarkerLayer(
                  markers: _properties.map((property) {
                    final isSelected = _selectedProperty?.id == property.id;
                    return Marker(
                      point: LatLng(property.latitude, property.longitude),
                      width: isSelected ? 80 : 65,
                      height: isSelected ? 80 : 65,
                      child: GestureDetector(
                        onTap: () => _onMarkerTap(property),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // Sombra del pin
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: isSelected ? 20 : 16,
                                height: isSelected ? 8 : 6,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Pin principal
                            Icon(
                              Icons.location_on,
                              color: isSelected
                                  ? const Color(0xFF4F46E5)
                                  : const Color(0xFFEF4444),
                              size: isSelected ? 65 : 50,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            // Precio dentro del pin
                            Positioned(
                              top: isSelected ? 12 : 10,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSelected ? 7 : 5,
                                  vertical: isSelected ? 3 : 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${property.priceMonth.toInt()}€',
                                  style: TextStyle(
                                    fontSize: isSelected ? 11 : 10,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Search Bar con filtros
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Botón de búsqueda
                  Expanded(
                    child: GestureDetector(
                      onTap: _openSearch,
                      child: Container(
                        color: Colors.transparent,
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
                  ),
                  // Botón de filtros
                  GestureDetector(
                    onTap: _openFilters,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _filters.hasActiveFilters 
                                ? const Color(0xFF4F46E5) 
                                : const Color(0xFF4F46E5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        // Badge de filtros activos
                        if (_filters.hasActiveFilters)
                          Positioned(
                            top: -4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  '${_filters.activeFiltersCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Preview Card (aparece cuando seleccionas un marcador)
          if (_selectedProperty != null)
            Positioned(
              bottom: 90, // Ajustado para no chocar con el bottom nav (era 20)
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Imagen
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Image.network(
                            _selectedProperty!.images.first,
                            height: 160, // Reducido de 200 a 160
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 160,
                                color: Colors.grey[300],
                                child: const Icon(Icons.home, size: 50),
                              );
                            },
                          ),
                        ),
                        // Botón cerrar
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: _closePreview,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        // Botón favorito
                        Positioned(
                          top: 12,
                          left: 12,
                          child: GestureDetector(
                            onTap: () => _toggleFavorite(_selectedProperty!.id),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _selectedProperty!.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _selectedProperty!.isFavorite
                                    ? Colors.red
                                    : Colors.grey[700],
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        // Badge gastos incluidos
                        if (_selectedProperty!.expensesIncluded)
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Gastos incluidos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Info del piso
                    Padding(
                      padding: const EdgeInsets.all(14), // Reducido de 18 a 14
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_selectedProperty!.priceMonth.toStringAsFixed(0)}€/mes',
                                      style: const TextStyle(
                                        fontSize: 24, // Reducido de 28 a 24
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedProperty!.title,
                                      style: const TextStyle(
                                        fontSize: 15, // Reducido de 17 a 15
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF334155),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _selectedProperty!.zone,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12), // Reducido de 16 a 12
                          // Características
                          Row(
                            children: [
                              _buildFeature(
                                Icons.bed_rounded,
                                '${_selectedProperty!.rooms} hab',
                              ),
                              const SizedBox(width: 20),
                              _buildFeature(
                                Icons.bathtub_outlined,
                                '${_selectedProperty!.bathrooms} baño${_selectedProperty!.bathrooms > 1 ? 's' : ''}',
                              ),
                              if (_selectedProperty!.squareMeters != null) ...[
                                const SizedBox(width: 20),
                                _buildFeature(
                                  Icons.square_foot,
                                  '${_selectedProperty!.squareMeters}m²',
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 10), // Reducido de 14 a 10
                          // Tags principales
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedProperty!.tags.take(4).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4F46E5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12), // Reducido de 18 a 12
                          // Botón ver detalles
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _openPropertyDetail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4F46E5),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14), // Reducido de 16 a 14
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Ver detalles completos',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
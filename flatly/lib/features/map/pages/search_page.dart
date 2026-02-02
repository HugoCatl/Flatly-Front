// lib/features/map/pages/search_page.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/property_model.dart';
import '../widgets/property_card.dart';

class SearchPage extends StatefulWidget {
  final List<PropertyModel> allProperties;
  final Function(PropertyModel) onPropertySelected;

  const SearchPage({
    super.key,
    required this.allProperties,
    required this.onPropertySelected,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<PropertyModel> _filteredProperties = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredProperties = widget.allProperties;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filterProperties();
    });
  }

  void _filterProperties() {
    if (_searchQuery.isEmpty) {
      _filteredProperties = widget.allProperties;
    } else {
      _filteredProperties = widget.allProperties.where((property) {
        // Buscar en título
        final titleMatch = property.title.toLowerCase().contains(_searchQuery);
        
        // Buscar en zona
        final zoneMatch = property.zone.toLowerCase().contains(_searchQuery);
        
        // Buscar en tags
        final tagMatch = property.tags.any(
          (tag) => tag.toLowerCase().contains(_searchQuery),
        );
        
        // Buscar en dirección
        final addressMatch = property.address.toLowerCase().contains(_searchQuery);

        return titleMatch || zoneMatch || tagMatch || addressMatch;
      }).toList();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Buscar por zona, nombre, tags...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: Column(
        children: [
          // Resultados encontrados
          if (_searchQuery.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF8FAFC),
              child: Row(
                children: [
                  Text(
                    '${_filteredProperties.length} resultado${_filteredProperties.length != 1 ? 's' : ''} encontrado${_filteredProperties.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          
          // Lista de resultados
          Expanded(
            child: _filteredProperties.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Escribe para buscar pisos'
                              : 'No se encontraron resultados',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Intenta con otra búsqueda',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredProperties.length,
                    itemBuilder: (context, index) {
                      return PropertyCard(
                        property: _filteredProperties[index],
                        onTap: () {
                          widget.onPropertySelected(_filteredProperties[index]);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

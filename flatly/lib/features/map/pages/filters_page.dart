// lib/features/map/pages/filters_page.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/property_model.dart';

class PropertyFilters {
  double? minPrice;
  double? maxPrice;
  int? rooms;
  int? bathrooms;
  List<String> selectedTags;
  bool? isFurnished;
  bool? expensesIncluded;

  PropertyFilters({
    this.minPrice,
    this.maxPrice,
    this.rooms,
    this.bathrooms,
    this.selectedTags = const [],
    this.isFurnished,
    this.expensesIncluded,
  });

  bool get hasActiveFilters =>
      minPrice != null ||
      maxPrice != null ||
      rooms != null ||
      bathrooms != null ||
      selectedTags.isNotEmpty ||
      isFurnished != null ||
      expensesIncluded != null;

  int get activeFiltersCount {
    int count = 0;
    if (minPrice != null || maxPrice != null) count++;
    if (rooms != null) count++;
    if (bathrooms != null) count++;
    if (selectedTags.isNotEmpty) count++;
    if (isFurnished != null) count++;
    if (expensesIncluded != null) count++;
    return count;
  }

  PropertyFilters copyWith({
    double? minPrice,
    double? maxPrice,
    int? rooms,
    int? bathrooms,
    List<String>? selectedTags,
    bool? isFurnished,
    bool? expensesIncluded,
  }) {
    return PropertyFilters(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      rooms: rooms ?? this.rooms,
      bathrooms: bathrooms ?? this.bathrooms,
      selectedTags: selectedTags ?? this.selectedTags,
      isFurnished: isFurnished ?? this.isFurnished,
      expensesIncluded: expensesIncluded ?? this.expensesIncluded,
    );
  }

  void clear() {
    minPrice = null;
    maxPrice = null;
    rooms = null;
    bathrooms = null;
    selectedTags = [];
    isFurnished = null;
    expensesIncluded = null;
  }
}

class FiltersPage extends StatefulWidget {
  final PropertyFilters currentFilters;
  final List<PropertyModel> allProperties;

  const FiltersPage({
    super.key,
    required this.currentFilters,
    required this.allProperties,
  });

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  late PropertyFilters _filters;
  late RangeValues _priceRange;
  final double _minPrice = 0;
  final double _maxPrice = 2000;

  // Tags comunes extraídos de los pisos
  final List<String> _availableTags = [
    'wifi',
    'amueblado',
    'ascensor',
    'calefacción',
    'terraza',
    'mascotas',
    'vistas',
    'luminoso',
    'céntrico',
    'metro',
    'gastos incluidos',
    'cerca universidad',
    'duplex',
    'loft',
  ];

  @override
  void initState() {
    super.initState();
    _filters = PropertyFilters(
      minPrice: widget.currentFilters.minPrice,
      maxPrice: widget.currentFilters.maxPrice,
      rooms: widget.currentFilters.rooms,
      bathrooms: widget.currentFilters.bathrooms,
      selectedTags: List.from(widget.currentFilters.selectedTags),
      isFurnished: widget.currentFilters.isFurnished,
      expensesIncluded: widget.currentFilters.expensesIncluded,
    );
    
    _priceRange = RangeValues(
      _filters.minPrice ?? _minPrice,
      _filters.maxPrice ?? _maxPrice,
    );
  }

  void _applyFilters() {
    Navigator.pop(context, _filters);
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _priceRange = RangeValues(_minPrice, _maxPrice);
    });
  }

  int _getFilteredCount() {
    return widget.allProperties.where((property) {
      // Filtro de precio
      if (_priceRange.start > _minPrice || _priceRange.end < _maxPrice) {
        if (property.priceMonth < _priceRange.start ||
            property.priceMonth > _priceRange.end) {
          return false;
        }
      }

      // Filtro de habitaciones
      if (_filters.rooms != null && property.rooms != _filters.rooms) {
        return false;
      }

      // Filtro de baños
      if (_filters.bathrooms != null &&
          property.bathrooms != _filters.bathrooms) {
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
      if (_filters.isFurnished != null &&
          property.isFurnished != _filters.isFurnished) {
        return false;
      }

      // Filtro de gastos incluidos
      if (_filters.expensesIncluded != null &&
          property.expensesIncluded != _filters.expensesIncluded) {
        return false;
      }

      return true;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final filteredCount = _getFilteredCount();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filtros',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_filters.hasActiveFilters)
            TextButton(
              onPressed: _clearAllFilters,
              child: const Text(
                'Limpiar',
                style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Precio
                _buildSection(
                  title: 'Precio mensual',
                  child: Column(
                    children: [
                      RangeSlider(
                        values: _priceRange,
                        min: _minPrice,
                        max: _maxPrice,
                        divisions: 40,
                        activeColor: const Color(0xFF4F46E5),
                        labels: RangeLabels(
                          '${_priceRange.start.round()}€',
                          '${_priceRange.end.round()}€',
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _priceRange = values;
                            _filters.minPrice = values.start;
                            _filters.maxPrice = values.end;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_priceRange.start.round()}€',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${_priceRange.end.round()}€',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Habitaciones
                _buildSection(
                  title: 'Habitaciones',
                  child: Wrap(
                    spacing: 10,
                    children: [1, 2, 3, 4].map((room) {
                      final isSelected = _filters.rooms == room;
                      return ChoiceChip(
                        label: Text('$room hab'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters.rooms = selected ? room : null;
                          });
                        },
                        selectedColor: const Color(0xFF4F46E5),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: const Color(0xFFF1F5F9),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // Baños
                _buildSection(
                  title: 'Baños',
                  child: Wrap(
                    spacing: 10,
                    children: [1, 2].map((bath) {
                      final isSelected = _filters.bathrooms == bath;
                      return ChoiceChip(
                        label: Text('$bath baño${bath > 1 ? 's' : ''}'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters.bathrooms = selected ? bath : null;
                          });
                        },
                        selectedColor: const Color(0xFF4F46E5),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: const Color(0xFFF1F5F9),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // Características
                _buildSection(
                  title: 'Características',
                  child: Column(
                    children: [
                      _buildCheckboxTile(
                        'Amueblado',
                        _filters.isFurnished,
                        (value) {
                          setState(() {
                            _filters.isFurnished = value;
                          });
                        },
                      ),
                      _buildCheckboxTile(
                        'Gastos incluidos',
                        _filters.expensesIncluded,
                        (value) {
                          setState(() {
                            _filters.expensesIncluded = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Tags/Extras
                _buildSection(
                  title: 'Extras',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableTags.map((tag) {
                      final isSelected = _filters.selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _filters.selectedTags.add(tag);
                            } else {
                              _filters.selectedTags.remove(tag);
                            }
                          });
                        },
                        selectedColor: const Color(0xFFEEF2FF),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? const Color(0xFF4F46E5)
                              : const Color(0xFF64748B),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                        backgroundColor: const Color(0xFFF8FAFC),
                        checkmarkColor: const Color(0xFF4F46E5),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar con botón aplicar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Ver $filteredCount resultado${filteredCount != 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool? value,
    Function(bool?) onChanged,
  ) {
    return InkWell(
      onTap: () {
        if (value == null) {
          onChanged(true);
        } else if (value == true) {
          onChanged(null);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: value ?? false,
              tristate: true,
              onChanged: onChanged,
              activeColor: const Color(0xFF4F46E5),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

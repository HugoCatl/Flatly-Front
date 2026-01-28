import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = _mockProperties();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Fondo "mapa" placeholder
          Positioned.fill(
            child: Container(
              color: AppColors.backgroundAlt,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined,
                        size: 56, color: AppColors.textDisabled),
                    const SizedBox(height: 8),
                    const Text(
                      'Mapa (placeholder)',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Explora pisos desde el listado',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Buscador + filtros flotante
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _SearchBar(
                      hint: 'Buscar zona, calle...',
                      onTap: () {
                        // TODO: abrir búsqueda
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  _SquareGradientButton(
                    gradient: AppGradients.search,
                    icon: Icons.tune_rounded,
                    onTap: () {
                      _openFiltersPlaceholder(context, 'Filtros');
                    },
                  ),
                ],
              ),
            ),
          ),

          // Chips de filtros (placeholder)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 68, 16, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Precio',
                      onTap: () => _openFiltersPlaceholder(context, 'Precio'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Hab',
                      onTap: () => _openFiltersPlaceholder(context, 'Habitaciones'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Zona',
                      onTap: () => _openFiltersPlaceholder(context, 'Zona'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Más',
                      onTap: () => _openFiltersPlaceholder(context, 'Más filtros'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sheet deslizable
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
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: items.length + 2,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    if (index == 0) return const _SheetHandle();
                    if (index == 1) return const _SheetHeader();
                    final item = items[index - 2];
                    return _PropertyCard(
                      item: item,
                      onTap: item.isAvailable
                          ? () => _openPropertyQuickView(context, item)
                          : null,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/* ===========================
   FILTERS PLACEHOLDER
=========================== */

void _openFiltersPlaceholder(BuildContext context, String title) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Filtros en construcción 👷‍♂️\nLuego aquí meteremos sliders, chips y switches.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/* ===========================
   UI PIECES
=========================== */

class _SearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;

  const _SearchBar({required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSoft),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AppColors.textDisabled),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hint,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.borderSoft),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _SquareGradientButton extends StatelessWidget {
  final LinearGradient gradient;
  final IconData icon;
  final VoidCallback onTap;

  const _SquareGradientButton({
    required this.gradient,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Pisos cercanos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cyan.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.cyan.withOpacity(0.25)),
            ),
            child: const Text(
              'Valencia',
              style: TextStyle(
                color: AppColors.cyanDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final _Property item;
  final VoidCallback? onTap;

  const _PropertyCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = !item.isAvailable;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Opacity(
          opacity: disabled ? 0.55 : 1.0,
          child: Row(
            children: [
              const _Thumb(),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título + estado
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (disabled)
                          const _MiniChip(
                            text: 'No disponible',
                            color: AppColors.red,
                            textColor: AppColors.redDark,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    Text(
                      '${item.city} · ${item.zone} · ${item.rooms} hab',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Menos chips (máx 2)
                    Row(
                      children: [
                        _MiniChip(
                          text: '€${item.priceMonth.toStringAsFixed(0)}/mes',
                          color: AppColors.cyan,
                          textColor: AppColors.cyanDark,
                        ),
                        const SizedBox(width: 8),
                        if (item.expensesIncluded)
                          const _MiniChip(
                            text: 'Gastos incl.',
                            color: AppColors.green,
                            textColor: AppColors.greenDark,
                          )
                        else if (item.isFurnished)
                          const _MiniChip(
                            text: 'Amueblado',
                            color: AppColors.green,
                            textColor: AppColors.greenDark,
                          )
                        else if (item.squareMeters != null)
                          _MiniChip(
                            text: '${item.squareMeters} m²',
                            color: AppColors.indigo,
                            textColor: AppColors.indigo,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Icon(
                item.isFav ? Icons.star_rounded : Icons.star_border_rounded,
                color: item.isFav ? AppColors.amber : AppColors.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: const Icon(
        Icons.apartment_rounded,
        color: AppColors.textDisabled,
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _MiniChip({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

/* ===========================
   QUICK VIEW (BOTTOM SHEET)
=========================== */

void _openPropertyQuickView(BuildContext context, _Property item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Portada (placeholder)
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundAlt,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: const Center(
                child: Icon(Icons.image_outlined,
                    size: 42, color: AppColors.textDisabled),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              item.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              '${item.city} · ${item.zone} · ${item.rooms} hab',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.address,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MiniChip(
                  text: '€${item.priceMonth.toStringAsFixed(0)}/mes',
                  color: AppColors.cyan,
                  textColor: AppColors.cyanDark,
                ),
                _MiniChip(
                  text: '${item.bathrooms} baño${item.bathrooms == 1 ? '' : 's'}',
                  color: AppColors.indigo,
                  textColor: AppColors.indigo,
                ),
                if (item.squareMeters != null)
                  _MiniChip(
                    text: '${item.squareMeters} m²',
                    color: AppColors.indigo,
                    textColor: AppColors.indigo,
                  ),
                if (item.isFurnished)
                  const _MiniChip(
                    text: 'Amueblado',
                    color: AppColors.green,
                    textColor: AppColors.greenDark,
                  ),
                if (item.expensesIncluded)
                  const _MiniChip(
                    text: 'Gastos incluidos',
                    color: AppColors.green,
                    textColor: AppColors.greenDark,
                  ),
              ],
            ),

            const SizedBox(height: 14),

            Text(
              item.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: favorito
                    },
                    icon: const Icon(Icons.star_border_rounded),
                    label: const Text('Favorito'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: ir a PropertyDetailPage(item)
                    },
                    child: const Text('Ver detalle'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

/* ===========================
   MOCK DATA (updated)
=========================== */

class _Property {
  final String title;
  final String description;
  final String city;
  final String zone;
  final String address;

  final int rooms;
  final int bathrooms;
  final int? squareMeters;

  final double priceMonth;
  final bool expensesIncluded;
  final bool isFurnished;
  final bool isAvailable;

  final double? latitude;
  final double? longitude;

  final bool isFav;

  _Property({
    required this.title,
    required this.description,
    required this.city,
    required this.zone,
    required this.address,
    required this.rooms,
    required this.bathrooms,
    required this.squareMeters,
    required this.priceMonth,
    required this.expensesIncluded,
    required this.isFurnished,
    required this.isAvailable,
    required this.latitude,
    required this.longitude,
    required this.isFav,
  });
}

List<_Property> _mockProperties() => [
      _Property(
        title: 'Piso céntrico',
        description: 'Piso cerca de la universidad, luminoso y bien conectado.',
        city: 'Valencia',
        zone: 'Centro',
        address: 'C/ Colón 12',
        rooms: 3,
        bathrooms: 1,
        squareMeters: 78,
        priceMonth: 750,
        expensesIncluded: false,
        isFurnished: true,
        isAvailable: true,
        latitude: 39.4699,
        longitude: -0.3763,
        isFav: true,
      ),
      _Property(
        title: 'Ático con terraza',
        description: 'Ático luminoso con terraza, ideal para estudiantes.',
        city: 'Valencia',
        zone: 'Benimaclet',
        address: 'Av. Primado Reig 101',
        rooms: 2,
        bathrooms: 1,
        squareMeters: 65,
        priceMonth: 900,
        expensesIncluded: true,
        isFurnished: false,
        isAvailable: true,
        latitude: 39.4782,
        longitude: -0.3615,
        isFav: true,
      ),
      _Property(
        title: 'Estudio acogedor',
        description: 'Estudio pequeño pero muy bien cuidado, zona con ambiente.',
        city: 'Valencia',
        zone: 'Ruzafa',
        address: 'C/ Sueca 44',
        rooms: 1,
        bathrooms: 1,
        squareMeters: 32,
        priceMonth: 620,
        expensesIncluded: false,
        isFurnished: true,
        isAvailable: false, // ejemplo “no disponible”
        latitude: 39.4621,
        longitude: -0.3720,
        isFav: false,
      ),
    ];

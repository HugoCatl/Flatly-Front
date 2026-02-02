// lib/features/map/models/property_model.dart
class PropertyModel {
  final int id;
  final String title;
  final String description;
  final double priceMonth;
  final String city;
  final String zone;
  final int rooms;
  final int bathrooms;
  final int? squareMeters;
  final bool isFurnished;
  final bool expensesIncluded;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> images;
  final List<String> tags;
  final bool isFavorite;

  PropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priceMonth,
    required this.city,
    required this.zone,
    required this.rooms,
    required this.bathrooms,
    this.squareMeters,
    required this.isFurnished,
    required this.expensesIncluded,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.images,
    required this.tags,
    this.isFavorite = false,
  });

  // Factory para cuando conectes el backend
  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      priceMonth: json['price_month'].toDouble(),
      city: json['city'],
      zone: json['zone'],
      rooms: json['rooms'],
      bathrooms: json['bathrooms'],
      squareMeters: json['square_meters'],
      isFurnished: json['is_furnished'] ?? false,
      expensesIncluded: json['expenses_included'] ?? false,
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      address: json['address'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}

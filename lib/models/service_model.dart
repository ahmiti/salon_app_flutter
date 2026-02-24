import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String name;
  final IconData icon;
  final double price;
  final int duration; // en minutes
  final String description;
  final List<String> images;
  final String category;
  final bool isPopular;
  final double rating;
  final int reviewsCount;

  ServiceModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.price,
    required this.duration,
    required this.description,
    required this.images,
    required this.category,
    this.isPopular = false,
    this.rating = 0.0,
    this.reviewsCount = 0,
  });

  // Données de démonstration
  static List<ServiceModel> demoServices = [
    ServiceModel(
      id: '1',
      name: 'Coiffure',
      icon: Icons.brush,
      price: 45.0,
      duration: 60,
      category: 'Soins capillaires',
      isPopular: true,
      rating: 4.9,
      reviewsCount: 127,
      description: 'Coupe, brushing, coloration et soins capillaires par nos experts.',
      images: [
        'https://images.unsplash.com/photo-1560066984-138dadb4c035',
        'https://images.unsplash.com/photo-1522338242992-e1a54906a8da',
      ],
    ),
    ServiceModel(
      id: '2',
      name: 'Manucure',
      icon: Icons.handshake,
      price: 35.0,
      duration: 45,
      category: 'Soins des mains',
      isPopular: true,
      rating: 4.8,
      reviewsCount: 98,
      description: 'Soin des mains, pose de vernis, nail art et modelage.',
      images: [
        'https://images.unsplash.com/photo-1610992235714-4b5c3bb8da30',
        'https://images.unsplash.com/photo-1604654894610-df63bc536371',
      ],
    ),
    ServiceModel(
      id: '3',
      name: 'Maquillage',
      icon: Icons.face_retouching_natural,
      price: 55.0,
      duration: 60,
      category: 'Maquillage',
      isPopular: true,
      rating: 5.0,
      reviewsCount: 156,
      description: 'Maquillage jour, soirée ou mariage. Produits haut de gamme.',
      images: [
        'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f',
        'https://images.unsplash.com/photo-1512496015851-a90fb38ba796',
      ],
    ),
    ServiceModel(
      id: '4',
      name: 'Soins visage',
      icon: Icons.spa,
      price: 65.0,
      duration: 75,
      category: 'Soins du visage',
      isPopular: false,
      rating: 4.9,
      reviewsCount: 84,
      description: 'Nettoyage, hydratation, masques et soins anti-âge.',
      images: [
        'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881',
        'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c',
      ],
    ),
  ];
}
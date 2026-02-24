import 'package:flutter/material.dart';

enum AppointmentStatus { pending, confirmed, completed, cancelled }

class AppointmentModel {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final DateTime date;
  final TimeOfDay time;
  final String specialistName;
  final double price;
  final AppointmentStatus status;
  final String? notes;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.specialistName,
    required this.price,
    required this.status,
    this.notes,
  });

  // Données de démonstration
  static List<AppointmentModel> demoAppointments = [
    AppointmentModel(
      id: '1',
      userId: 'user1',
      serviceId: '1',
      serviceName: 'Coiffure',
      date: DateTime.now().add(const Duration(days: 2)),
      time: const TimeOfDay(hour: 14, minute: 30),
      specialistName: 'Sophie Martin',
      price: 45.0,
      status: AppointmentStatus.confirmed,
    ),
    AppointmentModel(
      id: '2',
      userId: 'user1',
      serviceId: '2',
      serviceName: 'Manucure',
      date: DateTime.now().add(const Duration(days: 5)),
      time: const TimeOfDay(hour: 10, minute: 0),
      specialistName: 'Marie Laurent',
      price: 35.0,
      status: AppointmentStatus.pending,
    ),
  ];
}
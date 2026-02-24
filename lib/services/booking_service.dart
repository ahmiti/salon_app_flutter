import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../models/service_model.dart';

class BookingService {
  static List<AppointmentModel> _userAppointments = [];

  Future<bool> createBooking({
    required String userId,
    required ServiceModel service,
    required DateTime date,
    required TimeOfDay time,
    required String specialistName,
    String? notes,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final newAppointment = AppointmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      serviceId: service.id,
      serviceName: service.name,
      date: date,
      time: time,
      specialistName: specialistName,
      price: service.price,
      status: AppointmentStatus.confirmed,
      notes: notes,
    );
    
    _userAppointments.add(newAppointment);
    return true;
  }

  Future<List<AppointmentModel>> getUserAppointments(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _userAppointments.where((a) => a.userId == userId).toList();
  }

  Future<bool> cancelAppointment(String appointmentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _userAppointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      _userAppointments[index] = AppointmentModel(
        id: _userAppointments[index].id,
        userId: _userAppointments[index].userId,
        serviceId: _userAppointments[index].serviceId,
        serviceName: _userAppointments[index].serviceName,
        date: _userAppointments[index].date,
        time: _userAppointments[index].time,
        specialistName: _userAppointments[index].specialistName,
        price: _userAppointments[index].price,
        status: AppointmentStatus.cancelled,
        notes: _userAppointments[index].notes,
      );
      return true;
    }
    return false;
  }

  // Créneaux horaires disponibles
  static List<TimeOfDay> getAvailableTimeSlots() {
    List<TimeOfDay> slots = [];
    for (int hour = 9; hour <= 18; hour++) {
      if (hour != 13) { // Pause déjeuner
        slots.add(TimeOfDay(hour: hour, minute: 0));
        slots.add(TimeOfDay(hour: hour, minute: 30));
      }
    }
    return slots;
  }
}
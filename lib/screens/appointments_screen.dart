import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../models/appointment_model.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';
import '../widgets/custom_button.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AppointmentModel> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);
    
    final authService = AuthService();
    if (authService.currentUser != null) {
      final bookingService = BookingService();
      _appointments = await bookingService.getUserAppointments(authService.currentUser!.id);
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkBrown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'MES RENDEZ-VOUS',
          style: TextStyle(
            color: AppColors.darkBrown,
            fontSize: 20,
            letterSpacing: 2,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.gold,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.gold,
          tabs: const [
            Tab(text: 'À VENIR'),
            Tab(text: 'HISTORIQUE'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildAppointmentsList(statuses: [AppointmentStatus.confirmed, AppointmentStatus.pending]),
                  _buildAppointmentsList(statuses: [AppointmentStatus.completed, AppointmentStatus.cancelled]),
                ],
              ),
      ),
    );
  }

  Widget _buildAppointmentsList({required List<AppointmentStatus> statuses}) {
    final filteredAppointments = _appointments
        .where((a) => statuses.contains(a.status))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Aucun rendez-vous',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: CustomButton(
                text: 'RÉSERVER',
                onPressed: () {
                  Navigator.pop(context);
                  // Naviguer vers la page de réservation
                  // À décommenter quand booking_screen sera créé
                  // Navigator.pushNamed(context, '/booking');
                },
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    Color statusColor;
    String statusText;
    
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        statusColor = Colors.green;
        statusText = 'Confirmé';
        break;
      case AppointmentStatus.pending:
        statusColor = Colors.orange;
        statusText = 'En attente';
        break;
      case AppointmentStatus.completed:
        statusColor = Colors.blue;
        statusText = 'Effectué';
        break;
      case AppointmentStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'Annulé';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appointment.serviceName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, color: AppColors.gold, size: 16),
                const SizedBox(width: 8),
                Text(appointment.specialistName),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.gold, size: 16),
                const SizedBox(width: 8),
                Text('${appointment.date.day}/${appointment.date.month}/${appointment.date.year}'),
                const SizedBox(width: 16),
                Icon(Icons.access_time, color: AppColors.gold, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${appointment.time.hour.toString().padLeft(2, '0')}:${appointment.time.minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${appointment.price}€',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (appointment.status == AppointmentStatus.confirmed)
                  OutlinedButton(
                    onPressed: () => _cancelAppointment(appointment.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('ANNULER'),
                  ),
              ],
            ),
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.note, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.notes!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler le rendez-vous'),
        content: const Text('Êtes-vous sûr de vouloir annuler ce rendez-vous ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('NON'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('OUI'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final bookingService = BookingService();
      final success = await bookingService.cancelAppointment(appointmentId);
      
      if (success && mounted) {
        _loadAppointments();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rendez-vous annulé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
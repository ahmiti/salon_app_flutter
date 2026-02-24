import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../models/service_model.dart';
import '../models/appointment_model.dart';
import '../services/booking_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';

class BookingScreen extends StatefulWidget {
  final ServiceModel? selectedService;

  const BookingScreen({super.key, this.selectedService});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ServiceModel? _selectedService;
  String? _selectedSpecialist;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _notes;
  int _currentStep = 0;
  bool _isLoading = false;

  final List<String> _specialists = [
    'Sophie Martin - Coiffeuse expert',
    'Marie Laurent - Esthéticienne',
    'Julie Dubois - Maquilleuse pro',
    'Claire Bernard - Styliste ongulaire',
  ];

  List<TimeOfDay> _availableSlots = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedService = widget.selectedService;
    _availableSlots = BookingService.getAvailableTimeSlots();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.darkBrown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'RÉSERVER',
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
            Tab(icon: Icon(Icons.spa), text: 'Service'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Date & Heure'),
            Tab(icon: Icon(Icons.check_circle), text: 'Confirmation'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildServiceSelection(),
                  _buildDateTimeSelection(),
                  _buildConfirmation(),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choisissez votre service',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Découvrez nos prestations haut de gamme',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ...ServiceModel.demoServices.map((service) => _buildServiceCard(service)),
          const SizedBox(height: 24),
          if (_selectedService != null) ...[
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'Choisissez votre expert',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),
            const SizedBox(height: 16),
            ..._specialists.map((specialist) => _buildSpecialistCard(specialist)),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    bool isSelected = _selectedService?.id == service.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedService = service;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.gold : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: (service == ServiceModel.demoServices[0] || service == ServiceModel.demoServices[2]
                    ? AppColors.gold
                    : AppColors.brown).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                service.icon,
                color: service == ServiceModel.demoServices[0] || service == ServiceModel.demoServices[2]
                    ? AppColors.gold
                    : AppColors.brown,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${service.price.toStringAsFixed(0)}€',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: service == ServiceModel.demoServices[0] || service == ServiceModel.demoServices[2]
                        ? AppColors.gold
                        : AppColors.brown,
                  ),
                ),
                Text(
                  '${service.duration}min',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialistCard(String specialist) {
    bool isSelected = _selectedSpecialist == specialist;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSpecialist = specialist;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.gold : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.gold.withOpacity(0.2),
              child: Icon(Icons.person, color: AppColors.gold),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    specialist.split('-')[0].trim(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    specialist.split('-')[1].trim(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.gold),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    if (_selectedService == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Choisissez d\'abord un service',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choisissez votre créneau',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pour ${_selectedService!.name}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _buildDateSelector(),
          const SizedBox(height: 32),
          _buildTimeSelector(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    DateTime now = DateTime.now();
    List<DateTime> dates = List.generate(14, (index) => now.add(Duration(days: index)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              DateTime date = dates[index];
              bool isSelected = _selectedDate?.day == date.day &&
                  _selectedDate?.month == date.month &&
                  _selectedDate?.year == date.year;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.gold : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.grey.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'][date.weekday - 1],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.darkBrown,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'][date.month - 1],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    if (_selectedDate == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horaire',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _availableSlots.map((slot) {
            bool isSelected = _selectedTime?.hour == slot.hour &&
                _selectedTime?.minute == slot.minute;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTime = slot;
                });
              },
              child: Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.gold : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${slot.hour.toString().padLeft(2, '0')}:${slot.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.darkBrown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConfirmation() {
    if (_selectedTime == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Complétez votre réservation',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Récapitulatif',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(height: 32),
          
          // Résumé de la réservation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSummaryRow(Icons.spa, 'Service', _selectedService!.name),
                const Divider(height: 24),
                _buildSummaryRow(Icons.person, 'Expert', _selectedSpecialist ?? 'À déterminer'),
                const Divider(height: 24),
                _buildSummaryRow(Icons.calendar_today, 'Date', 
                    '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                const Divider(height: 24),
                _buildSummaryRow(Icons.access_time, 'Horaire',
                    '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'),
                const Divider(height: 24),
                _buildSummaryRow(Icons.euro, 'Total', '${_selectedService!.price}€',
                    isTotal: true),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Notes
          const Text(
            'Notes (optionnel)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            onChanged: (value) => _notes = value,
            decoration: InputDecoration(
              hintText: 'Ajoutez des informations complémentaires...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? AppColors.gold : AppColors.darkBrown,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                      _tabController.animateTo(_currentStep);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.gold,
                    side: const BorderSide(color: AppColors.gold),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('RETOUR'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
                  : CustomButton(
                      text: _currentStep < 2 ? 'SUIVANT' : 'CONFIRMER',
                      onPressed: _currentStep < 2 ? _nextStep : _confirmBooking,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    bool canProceed = false;
    
    switch (_currentStep) {
      case 0:
        canProceed = _selectedService != null;
        if (!canProceed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veuillez choisir un service'),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;
      case 1:
        canProceed = _selectedDate != null && _selectedTime != null;
        if (!canProceed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veuillez choisir une date et un horaire'),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;
    }
    
    if (canProceed) {
      setState(() {
        _currentStep++;
        _tabController.animateTo(_currentStep);
      });
    }
  }

  Future<void> _confirmBooking() async {
    setState(() => _isLoading = true);
    
    final authService = AuthService();
    final bookingService = BookingService();
    
    if (authService.currentUser == null) {
      // Rediriger vers login
      Navigator.pop(context);
      Navigator.pushNamed(context, '/login');
      return;
    }
    
    final success = await bookingService.createBooking(
      userId: authService.currentUser!.id,
      service: _selectedService!,
      date: _selectedDate!,
      time: _selectedTime!,
      specialistName: _selectedSpecialist ?? 'À déterminer',
      notes: _notes,
    );
    
    setState(() => _isLoading = false);
    
    if (success && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Icon(Icons.check_circle, color: AppColors.gold, size: 64),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Réservation confirmée !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Votre rendez-vous ${_selectedService!.name} est confirmé pour le ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} à ${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Retour à l'accueil
              },
              child: const Text('FERMER'),
            ),
          ],
        ),
      );
    }
  }
}
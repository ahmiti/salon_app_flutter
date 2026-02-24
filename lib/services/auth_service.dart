import '../models/user_model.dart';

class AuthService {
  static UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    // Simulation de connexion
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'client@test.com' && password == 'password') {
      _currentUser = UserModel(
        id: '1',
        name: 'Marie Client',
        email: email,
        phone: '06 12 34 56 78',
        memberSince: DateTime.now().subtract(const Duration(days: 30)),
        loyaltyPoints: 120,
        favoriteServices: ['1', '3'],
      );
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    // Simulation d'inscription
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      memberSince: DateTime.now(),
      loyaltyPoints: 50, // Bonus de bienvenue
    );
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  bool get isLoggedIn => _currentUser != null;
}
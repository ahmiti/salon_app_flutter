class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final int loyaltyPoints;
  final List<String> favoriteServices;
  final DateTime memberSince;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    this.loyaltyPoints = 0,
    this.favoriteServices = const [],
    required this.memberSince,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'loyaltyPoints': loyaltyPoints,
      'favoriteServices': favoriteServices,
      'memberSince': memberSince.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
      favoriteServices: List<String>.from(json['favoriteServices'] ?? []),
      memberSince: DateTime.parse(json['memberSince']),
    );
  }
}
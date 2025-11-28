class User {
  final String id;
  String name;
  String email;
  String? phone;
  DateTime? birthday;
  String? gender; // Male/Female/Other
  String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.birthday,
    this.gender,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
        id: j['id'].toString(),
        name: j['name'] ?? '',
        email: j['email'] ?? '',
        phone: j['phone'],
        birthday:
            j['birthday'] != null ? DateTime.tryParse(j['birthday']) : null,
        gender: j['gender'],
        avatarUrl: j['avatarUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'birthday': birthday?.toIso8601String(),
        'gender': gender,
        'avatarUrl': avatarUrl,
      };
}

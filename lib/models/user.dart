class User {
  final String name;
  final String email;
  final String phone;
  final String password;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'password': password,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    password: json['password'],
  );
} 
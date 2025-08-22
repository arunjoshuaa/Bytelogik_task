class UserModel {
  final int? id; // Auto-increment primary key
  final String name;
  final String email;
  final String? password; // For demo, plain text (but normally use hashing)

  UserModel({
    this.id,
    required this.name,
    required this.email,
     this.password,

  });

  // Convert a User object into a Map (for SQLite insert)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name':name,
      'email': email,
      'password': password,
    };
  }

  // Convert a Map (from SQLite) into a User object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
}

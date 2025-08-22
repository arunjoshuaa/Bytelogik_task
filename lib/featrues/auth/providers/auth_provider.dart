import 'package:bytelogik_task/models/user_model.dart';
import 'package:bytelogik_task/services/db_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Expose the singleton DB service
final dbServiceProvider = Provider<DBService>((ref) => DBService());

/// Auth state: holds the currently logged-in user (or null)
class AuthNotifier extends StateNotifier<UserModel?> {
  final DBService _db;

  AuthNotifier(this._db, {UserModel? initialUser}) : super(initialUser) {
    // If no initial user passed, try restoring
    if (initialUser == null) {
      _restoreUser();
    }
  }

  Future<void> _restoreUser() async {
    final userId = await _db.getSavedCurrentUserId();
    if (userId != null) {
      final user = await _db.getUserById(userId);
      if (user != null) {
        state = user;
      }
    }
  }

  Future<String?> signUp(String name, String email, String password) async {
    final exists = await _db.emailExists(email);
    if (exists) return 'Email already registered';

    await _db.insertUser(UserModel(name: name, email: email, password: password));
    return null;
  }

  Future<String?> login(String email, String password) async {
    final user = await _db.getUser(email, password);
    if (user == null) return 'Invalid email or password';
    await _db.saveCurrentUser(user.id!);
    state = user;
    return null;
  }

  void logout() {
    _db.clearCurrentUser();
    state = null;
  }
}

/// Riverpod provider for auth state
final authProvider =
    StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  final db = ref.watch(dbServiceProvider);
  return AuthNotifier(db); // default: restores itself
});

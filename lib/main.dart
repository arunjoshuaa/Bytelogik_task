import 'package:bytelogik_task/featrues/auth/presentation/login_page.dart';
import 'package:bytelogik_task/featrues/auth/presentation/signup_page.dart';
import 'package:bytelogik_task/featrues/auth/providers/auth_provider.dart';
import 'package:bytelogik_task/featrues/counter/presentation/counter_page.dart';
import 'package:bytelogik_task/models/user_model.dart';
import 'package:bytelogik_task/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = DBService();
  final currentUserMap = await db.getCurrentUser();
  print("currentUserMap: $currentUserMap");

  UserModel? currentUser;
  if (currentUserMap != null) {
    currentUser = UserModel.fromMap(currentUserMap);
  }

  runApp(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(
          (ref) => AuthNotifier(db, initialUser: currentUser), // ✅ inject preload
        ),
      ],
      child: MyApp(initialRoute: currentUser == null ? '/login' : '/counter'),
    ),
  );
}


class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => SignupPage(),
        '/counter': (context) => const CounterPage(),
      },
    );
  }
}


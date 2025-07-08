import 'package:easytravel/pages/forget_password.dart';
import 'package:easytravel/pages/dashboard_page.dart';
import 'package:easytravel/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EasyTravelApp());
}

class EasyTravelApp extends StatelessWidget {
  const EasyTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyTravel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        // '/login': (context) => const LoginPage(), // Supprime si tu n'as plus cette page séparée
        '/dashboard': (context) => const DashboardPage(),
        '/forgot-password': (context) => const ForgotPasswordModal(),
        // Pas de route '/register' car géré dans la modale
      },
    );
  }
}

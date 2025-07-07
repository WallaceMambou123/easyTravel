import 'package:easytravel/pages/registre_modal.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import des pages
import 'package:easytravel/pages/login_page.dart';
import 'package:easytravel/pages/registre_modal.dart';
import 'package:easytravel/pages/dashboard_page.dart';
import 'package:easytravel/pages/welcome_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Assure-toi que ton firebase_options.dart est bien configuré si tu utilises FlutterFire CLI
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
      // Gestion des routes
      initialRoute: '/welcome',

      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterModal(),
        '/dashboard': (context) => const DashboardPage(),
        '/forgot-password': (context) => const DummyForgotPasswordPage(),

      },
    );
  }
}

// Redirige selon l'état de connexion
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const DummyDashboardPage();
    } else {
      return const LoginPage();
    }
  }
}

// Pages temporaires (pour test)
class DummyDashboardPage extends StatelessWidget {
  const DummyDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bienvenue dans EasyTravel !"),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Déconnexion"),
            ),
          ],
        ),
      ),
    );
  }
}

class DummyForgotPasswordPage extends StatelessWidget {
  const DummyForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mot de passe oublié")),
      body: const Center(
        child: Text("On fera ça plus tard, sois patient."),
      ),
    );
  }
}

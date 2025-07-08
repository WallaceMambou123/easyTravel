import 'package:flutter/material.dart';
import 'package:easytravel/pages/login_modal.dart';
import 'package:easytravel/pages/register_modal.dart'; // À créer si pas encore fait

class AuthModal extends StatefulWidget {
  const AuthModal({super.key});

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  bool _showLogin = true;

  void _toggleForm() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: _showLogin
          ? LoginModal(
        key: const ValueKey('login'),
        onSwitchToRegister: _toggleForm,
      )
          : RegisterModal(
        key: const ValueKey('register'),
        onSwitchToLogin: _toggleForm,
      ),
    );
  }
}

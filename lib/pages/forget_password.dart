import 'package:flutter/material.dart';

class ForgotPasswordModal extends StatefulWidget {
  const ForgotPasswordModal({super.key});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simule une attente

    setState(() {
      _isLoading = false;
      _message = "Un lien de réinitialisation a été envoyé à votre adresse email.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Mot de passe oublié",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16),
          if (_message != null)
            Text(
              _message!,
              style: const TextStyle(color: Colors.green),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
            onPressed: _sendResetLink,
            child: const Text("Envoyer le lien de réinitialisation"),
          ),
        ],
      ),
    );
  }
}

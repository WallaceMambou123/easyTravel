import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterModal extends StatelessWidget {
  final VoidCallback onSwitchToLogin;

  const RegisterModal({super.key, required this.onSwitchToLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Material(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          color: Colors.white,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: _RegisterFormStyled(onSwitch: onSwitchToLogin),
          ),
        ),
      ],
    );
  }
}

class _RegisterFormStyled extends StatefulWidget {
  final VoidCallback onSwitch;

  const _RegisterFormStyled({super.key, required this.onSwitch});

  @override
  State<_RegisterFormStyled> createState() => _RegisterFormStyledState();
}

class _RegisterFormStyledState extends State<_RegisterFormStyled> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  bool _obscureText = true;

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      setState(() => _error = "Passwords do not match.");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null && mounted) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _fieldDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87),
      filled: true,
      fillColor: const Color(0xFFF2F2F2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Column(
            children: [
              Text(
                "Register",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C2A4B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Create your Easy Travel account\nto book tickets with ease",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Text("Email", style: _labelStyle),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _fieldDecoration(""),
        ),

        const SizedBox(height: 16),

        Text("Password", style: _labelStyle),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: _obscureText,
          decoration: _fieldDecoration(
            "",
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text("Confirm Password", style: _labelStyle),
        const SizedBox(height: 6),
        TextField(
          controller: _confirmPasswordController,
          obscureText: _obscureText,
          decoration: _fieldDecoration(""),
        ),

        const SizedBox(height: 8),

        if (_error != null)
          Text(_error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center),
        const SizedBox(height: 8),

        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C2A4B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Register",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Center(
          child: Wrap(
            children: [
              const Text("Already have an account ? \n"),
    GestureDetector(
    onTap: widget.onSwitch,
    child: const Text(
    "Login",
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Color(0xFF0C2A4B), // même couleur que le reste de l'UI
    decoration: TextDecoration.none,
    ),
    ),
    ),

            ],
          ),
        ),
      ],
    );
  }

  TextStyle get _labelStyle =>
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
}

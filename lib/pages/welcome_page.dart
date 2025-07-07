import 'package:flutter/material.dart';
import 'package:easytravel/pages/login_modal.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  late AnimationController _contentController;
  late Animation<Offset> _titleAnimation;

  late AnimationController _backgroundController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _titleAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.3),
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    ));

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: 1.0, // 100% height
      end: 300 / MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _contentController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _onStartPressed() {
    _contentController.forward();
    _backgroundController.forward();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Login",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, _) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: anim1,
            curve: Curves.easeOut,
          )),
          child: const LoginModal(),
        );
      },
    ).then((_) {
      _contentController.reverse();
      _backgroundController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          final bgHeight = size.height * _heightAnimation.value;

          return Stack(
            children: [
              // Image de fond qui se rétrécit
              SizedBox(
                width: size.width,
                height: bgHeight,
                child: Image.asset(
                  'src/assets/images/fondNoir.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // Le reste de l'écran devient bleu foncé
              Positioned(
                top: bgHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(color: const Color(0xFF0C2A4B)),
              ),

              // Contenu avec animation
              SafeArea(
                child: SlideTransition(
                  position: _titleAnimation,
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      Image.asset(
                        'src/assets/images/iconBus.jpg',
                        width: 90,
                        height: 90,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'EasyTravel',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const Spacer(flex: 3),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _onStartPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0C2A4B),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Commencer",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

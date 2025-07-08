// Bienvenue dans ta WelcomePage avec animation dynamique
import 'package:easytravel/pages/auth_modal.dart';
import 'package:flutter/material.dart';
import 'package:easytravel/pages/login_modal.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  late AnimationController _contentController; // Contrôleur pour animer le logo + texte
  late Animation<Offset> _titleAnimation; // Animation pour faire glisser le titre vers le haut

  late AnimationController _backgroundController; // Contrôleur pour animer la hauteur de l'image de fond
  late Animation<double> _heightAnimation; // Animation de la hauteur de l'image de fond

  @override
  void initState() {
    super.initState();

    // Initialise l'animation du contenu (logo + texte)
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _titleAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.3), // glissement vers le haut
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    ));

    // Initialise l'animation de l'image de fond qui se réduit
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Réduction de l'image jusqu'à une hauteur de 500px
    _heightAnimation = Tween<double>(
      begin: 1.0,
      end: 500 / MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    // Nettoyage des contrôleurs
    _contentController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _onStartPressed() {
    // Lance les animations
    _contentController.forward();
    _backgroundController.forward();

    // Ouvre la fenêtre modale de login
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
          // Augmentation de la hauteur de la modale à 80% de l'écran
          child: FractionallySizedBox(
            heightFactor: 0.8, // Augmentez cette valeur pour rendre la modale plus grande
            alignment: Alignment.bottomCenter,
              child: const AuthModal(),
          ),
        );
      },
    ).then((_) {
      // Réinitialisation des animations après fermeture de la modale
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
              // Image de fond animée
              SizedBox(
                width: size.width,
                height: bgHeight,
                child: Image.asset(
                  'src/assets/images/fondNoir.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // Fond bleu foncé qui occupe le reste de l'écran
              Positioned(
                top: bgHeight,
                left: 50,
                right: 100,
                bottom: 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Couleur de fond
                    borderRadius: BorderRadius.circular(20), // Coins arrondis)//Color(0xFF0C2A4B)),

                  ),

                ),
              ),

              // Contenu animé : logo + texte + bouton
              SafeArea(
                child: SlideTransition(
                  position: _titleAnimation,
                  child: Column(
                    children: [
                      const Spacer(flex: 3),

                      Image.asset(
                        'src/assets/images/iconBusVrai.png',
                        width: 200,
                        height: 190,
                      ),
                      const SizedBox(height: 10),

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

                      const SizedBox(height: 30),
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

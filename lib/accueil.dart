import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé principal avec bulles décoratives
          AnimatedBackground(),
          // Contenu principal centré
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Texte principal "Foodator"
                AnimatedText(
                  text: 'Foodator',
                  fontSize: 48,
                  glowColor: Colors.orangeAccent,
                ),
                SizedBox(height: 20),
                // Logo circulaire animé
                AnimatedLogo(),
                SizedBox(height: 20),
                // Texte slogan décoré sous le logo
                AnimatedText(
                  text: 'Votre repas, livré en un clin d\'œil',
                  fontSize: 20,
                  glowColor: Colors.white70,
                  italic: true,
                ),
                SizedBox(height: 40),
                // Bouton moderne et animé
                AnimatedButton(),
              ],
            ),
          ),
          // Formes décoratives
          Positioned(
            top: -100,
            left: -100,
            child: CircleDecoration(size: 300, color: Colors.orange.withOpacity(0.2)),
          ),
          Positioned(
            bottom: 50,
            right: -60,
            child: CircleDecoration(size: 180, color: Colors.white.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }
}

// Fond animé avec dégradé fluide
class AnimatedBackground extends StatefulWidget {
  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFA726).withOpacity(0.8 + 0.2 * _controller.value),
                Color(0xFFFF7043).withOpacity(0.8 + 0.2 * (1 - _controller.value)),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );
      },
    );
  }
}

// Texte animé avec effet Neon Glow
class AnimatedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color glowColor;
  final bool italic;

  const AnimatedText({
    required this.text,
    required this.fontSize,
    required this.glowColor,
    this.italic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        shadows: [
          Shadow(
            offset: Offset(0, 0),
            blurRadius: 20,
            color: glowColor,
          ),
        ],
      ),
    );
  }
}

// Logo animé
class AnimatedLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(seconds: 2),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value as double,
          child: Transform.scale(
            scale: value as double,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.jpeg', // Remplacez par votre logo
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Bouton moderne avec effet lumineux
class AnimatedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(seconds: 2),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value as double,
          child: ElevatedButton(
            onPressed: () {
              // Action pour le bouton
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.orangeAccent,
              elevation: 10,
              shadowColor: Colors.orange.withOpacity(0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.restaurant, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Formes décoratives en cercles
class CircleDecoration extends StatelessWidget {
  final double size;
  final Color color;

  const CircleDecoration({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Slightly longer delay to let the animations play out beautifully
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        // Use a perfectly smooth cross-fade transition into the dashboard!
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        // Ultra-premium gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF061616),
              Color(0xFF003737),
              Color(0xFF001F1F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Abstract Background Glowing Orbs (Dynamic Environment)
            Positioned(
              top: -100,
              left: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.tealAccent.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scaleXY(begin: 1.0, end: 1.5, duration: 4.seconds, curve: Curves.easeInOutSine)
               .blurXY(begin: 20, end: 50),
            ),
            Positioned(
              bottom: -150,
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.amberAccent.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scaleXY(begin: 1.0, end: 1.3, duration: 5.seconds, curve: Curves.easeInOutSine)
               .blurXY(begin: 30, end: 60),
            ),
            
            // Floating Particles
            ...List.generate(10, (index) {
              return Positioned(
                left: 30.0 + (index * 35 % 300),
                bottom: 100.0 + (index * 50 % 400),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.tealAccent, blurRadius: 6)
                    ]
                  ),
                ).animate(onPlay: (c) => c.repeat())
                 .moveY(begin: 0, end: -200, duration: Duration(seconds: 4 + index % 3))
                 .fade(begin: 1.0, end: 0.0, duration: Duration(seconds: 4 + index % 3)),
              );
            }),

            // Main Core Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glassmorphic Container for the Logo
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 30, spreadRadius: 5)
                    ],
                  ),
                  child: SizedBox(
                    child: Lottie.asset(
                      'assets/lottie/sun.json',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.teal.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.tealAccent, width: 2),
                        ),
                        child: const Icon(Icons.public, size: 80, color: Colors.white),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 2.seconds, color: Colors.white30)
                      .slideY(begin: -0.05, end: 0.05, duration: 1.5.seconds, curve: Curves.easeInOutSine)
                      .then()
                      .slideY(begin: 0.05, end: -0.05, duration: 1.5.seconds, curve: Curves.easeInOutSine),
                    ),
                  ),
                )
                // Entry animation for the Sun
                .animate()
                .scaleXY(begin: 0.5, end: 1.0, curve: Curves.easeOutBack, duration: 1200.ms)
                .fadeIn(duration: 800.ms)
                .then()
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: -5, end: 5, duration: 2.seconds, curve: Curves.easeInOutSine),
                
                const SizedBox(height: 48),
                
                // Pulsing Main Title with Gradient
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Colors.tealAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'EcoThermal',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 500.ms, duration: 800.ms)
                .slideY(begin: 0.2, end: 0, duration: 800.ms, curve: Curves.easeOutQuart)
                .shimmer(delay: 1500.ms, duration: 2.seconds, color: Colors.white.withValues(alpha: 0.5)),
                
                const SizedBox(height: 12),

                // Staggered Subtitle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: const Text(
                    'PHYSICS & CLIMATE CHANGE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 1000.ms, duration: 800.ms)
                .slideY(begin: 0.2, end: 0, duration: 800.ms),
                
                const SizedBox(height: 80),

                // Modern Loading Bar
                Container(
                  width: 140,
                  height: 4,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 140,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.tealAccent, Colors.blueAccent],
                          ),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(color: Colors.tealAccent.withValues(alpha: 0.5), blurRadius: 10)
                          ]
                        ),
                      ).animate(onPlay: (c) => c.repeat())
                       .slideX(begin: -1.0, end: 1.0, duration: 1500.ms, curve: Curves.easeInOutSine),
                    ],
                  ),
                ).animate().fadeIn(delay: 1500.ms, duration: 800.ms),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shikharDrawProgress;
  late Animation<double> _textSlide;
  late Animation<double> _glowRadius;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );

    // 0.0 to 0.5: Draw the Temple Spire (Shikhar) line art
    _shikharDrawProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    );

    // 0.3 to 0.7: Soft glowing saffron aura grows behind the spire
    _glowRadius = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    );

    // 0.7 to 1.0: Text slides up and fades in
    _textSlide = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic),
    );

    _controller.forward();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // Wait for the full animation + short pause
    await Future.delayed(const Duration(milliseconds: 3200));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Background soft gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
            ),
          ),

          // Animated Saffron Spiritual Glow
          Center(
            child: AnimatedBuilder(
              animation: _glowRadius,
              builder: (context, child) {
                return Container(
                  width: size.width * 0.8 * _glowRadius.value,
                  height: size.width * 0.8 * _glowRadius.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.saffron.withValues(alpha: 0.15),
                        AppColors.saffron.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Main Animation Container
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spire drawing + logo overlap area
                SizedBox(
                  width: 200,
                  height: 240,
                  child: AnimatedBuilder(
                    animation: _shikharDrawProgress,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _ShikharPainter(
                          progress: _shikharDrawProgress.value,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Title and premium linear progress indicator
                AnimatedBuilder(
                  animation: _textSlide,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textSlide.value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1.0 - _textSlide.value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'Mewad Bhavan',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Palitana Dharamshala',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Human-designed linear progress bar (sleek progress load)
                      Container(
                        width: 140,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Container(
                                width: 140 * _controller.value,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppColors.saffron,
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.saffron.withValues(alpha: 0.4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Elegant Temple Spire (Shikhar) Custom Painter
class _ShikharPainter extends CustomPainter {
  final double progress;

  _ShikharPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = AppColors.maroon.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Spire Center Coordinate Points
    final topX = size.width / 2;
    final topY = 40.0;
    
    // Left side curvature of the Shikhar (spire)
    path.moveTo(topX, topY);
    path.cubicTo(
      topX - 30, topY + 40,
      topX - 60, topY + 110,
      topX - 70, topY + 160,
    );
    path.lineTo(topX - 70, topY + 180);
    path.lineTo(topX + 70, topY + 180);
    path.lineTo(topX + 70, topY + 160);
    
    // Right side curvature back to top
    path.cubicTo(
      topX + 60, topY + 110,
      topX + 30, topY + 40,
      topX, topY,
    );

    // Inner detail layers (traditional steps/Shikhara design)
    for (int i = 1; i <= 3; i++) {
      final double widthOffset = i * 16.0;
      final double heightOffset = i * 40.0;
      path.moveTo(topX - widthOffset, topY + heightOffset);
      path.quadraticBezierTo(topX, topY + heightOffset - 8, topX + widthOffset, topY + heightOffset);
    }

    // Top Kalash & Flag (Dhvaj)
    path.moveTo(topX, topY);
    path.lineTo(topX, topY - 20); // flagpole
    
    // Flag (flowing triangle)
    path.moveTo(topX, topY - 20);
    path.lineTo(topX + 25, topY - 14);
    path.lineTo(topX, topY - 8);

    // Animate the path drawing by extracting path metrics
    final totalPath = Path();
    for (final metric in path.computeMetrics()) {
      final length = metric.length * progress;
      totalPath.addPath(metric.extractPath(0, length), Offset.zero);
    }

    canvas.drawPath(totalPath, paint);
  }

  @override
  bool shouldRepaint(covariant _ShikharPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

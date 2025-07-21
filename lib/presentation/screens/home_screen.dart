import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'camera_inference_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('🚀 YOLO Home'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5B247A), Color(0xFF1BCEDF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AnimatedMenuButton(
                icon: Icons.camera_alt_rounded,
                label: 'Camera YOLO',
                color: Colors.orangeAccent,
                page: CameraInferenceScreen(),
              ),
              SizedBox(height: 30),
              AnimatedMenuButton(
                icon: Icons.memory_rounded,
                label: 'Chức năng khác 1',
                color: Colors.green,
                onTapMessage: 'Chưa làm đâu anh ơi 😅',
              ),
              SizedBox(height: 30),
              AnimatedMenuButton(
                icon: Icons.settings_rounded,
                label: 'Chức năng khác 2',
                color: Colors.indigo,
                onTapMessage: 'Làm sau nhé anh 😎',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedMenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Widget? page;
  final String? onTapMessage;

  const AnimatedMenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.page,
    this.onTapMessage,
  });

  @override
  State<AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<AnimatedMenuButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTap(BuildContext context) {
    if (widget.page != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => widget.page!,
          transitionsBuilder: (_, animation, __, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            );
            return ScaleTransition(scale: curve, child: child);
          },
        ),
      );
    } else {
      _shakeController.forward(from: 0);
      HapticFeedback.vibrate();
      if (widget.onTapMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(widget.onTapMessage!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final offsetX = sin(_shakeAnimation.value * pi * 2) * 6;
        return Transform.translate(
          offset: Offset(widget.page == null ? offsetX : 0, 0),
          child: InkWell(
            onTap: () {
              setState(() => _isPressed = true);
              Future.delayed(const Duration(milliseconds: 80), () {
                setState(() => _isPressed = false);
                _handleTap(context);
              });
            },
            onTapCancel: () => setState(() => _isPressed = false),
            splashColor: Colors.white24,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedScale(
              scale: _isPressed ? 0.96 : 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeInOut,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.6),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(widget.icon, color: Colors.white, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

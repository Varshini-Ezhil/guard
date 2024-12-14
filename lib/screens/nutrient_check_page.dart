import 'package:flutter/material.dart';
import '../constants.dart';

class NutrientCheckPage extends StatefulWidget {
  const NutrientCheckPage({super.key});

  @override
  State<NutrientCheckPage> createState() => _NutrientCheckPageState();
}

class _NutrientCheckPageState extends State<NutrientCheckPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _nitrogenAnimation;
  late Animation<double> _phosphorusAnimation;
  late Animation<double> _potassiumAnimation;

  // Example nutrient values (0.0 to 1.0)
  final double nitrogenValue = 0.75;
  final double phosphorusValue = 0.45;
  final double potassiumValue = 0.60;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with longer duration
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500), // Increased duration
      vsync: this,
    );

    // Create animations with custom curves for each nutrient
    _nitrogenAnimation = Tween<double>(
      begin: 0.0,
      end: nitrogenValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8,
          curve: Curves.easeOutCubic), // Custom interval and curve
    ));

    _phosphorusAnimation = Tween<double>(
      begin: 0.0,
      end: phosphorusValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.9,
          curve: Curves.easeOutCubic), // Staggered start
    ));

    _potassiumAnimation = Tween<double>(
      begin: 0.0,
      end: potassiumValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0,
          curve: Curves.easeOutCubic), // Staggered start
    ));

    // Start the animation
    _controller.forward();
  }

  void _resetAnimation() async {
    // Reverse the animation first
    await _controller.reverse();
    // Then forward it again
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrient Check'),
        backgroundColor: kPrimaryGreen,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNutrientCircle(
                  'Nitrogen (N)',
                  _nitrogenAnimation.value,
                  Colors.blue,
                ),
                const SizedBox(height: 20),
                _buildNutrientCircle(
                  'Phosphorus (P)',
                  _phosphorusAnimation.value,
                  Colors.orange,
                ),
                const SizedBox(height: 20),
                _buildNutrientCircle(
                  'Potassium (K)',
                  _potassiumAnimation.value,
                  Colors.purple,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetAnimation, // Use new reset method
        backgroundColor: kPrimaryGreen,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildNutrientCircle(String label, double value, Color color) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                    Text(
                      '${(value * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _getNutrientStatus(value),
                  style: TextStyle(
                    fontSize: 16,
                    color: _getNutrientStatusColor(value),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getNutrientStatus(double value) {
    if (value < 0.3) return 'Low';
    if (value < 0.7) return 'Moderate';
    return 'High';
  }

  Color _getNutrientStatusColor(double value) {
    if (value < 0.3) return Colors.red;
    if (value < 0.7) return Colors.orange;
    return Colors.green;
  }
}

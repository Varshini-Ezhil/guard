import 'package:flutter/material.dart';
import 'dart:math';

const Color kPrimaryGreen = Color.fromRGBO(42, 164, 94, 1);
const Color kSecondaryGreen = Color.fromRGBO(108, 205, 102, 1);

class NutrientsPage extends StatefulWidget {
  const NutrientsPage({super.key});

  @override
  State<NutrientsPage> createState() => _NutrientsPageState();
}

class _NutrientsPageState extends State<NutrientsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<double> levels = [0.7, 0.45, 0.85];
  List<String> values = ['70', '45', '85'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshValues() {
    setState(() {
      levels = List.generate(3, (index) => (0.1 + Random().nextDouble() * 0.9));
      values = levels.map((e) => (e * 100).toStringAsFixed(0)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nutrient Levels',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPrimaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kPrimaryGreen.withOpacity(0.1),
              kSecondaryGreen.withOpacity(0.1),
            ],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Current Nutrient Levels',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryGreen,
                ),
              ),
              SizedBox(height: 30),
              // Rest of the implementation...
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math';
import 'pages/profile_page.dart';
import 'models/user.dart';
import 'services/user_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/settings_page.dart';
import 'screens/youtube_search_page.dart';
import 'screens/help_support_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';

// At the top of the file, add these color constants
const Color kPrimaryGreen = Color.fromRGBO(42, 164, 94, 1); // #2AA45E
const Color kSecondaryGreen = Color.fromRGBO(108, 205, 102, 1); // #6CCD66

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
        Locale('gu'),
        Locale('hr'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ChangeNotifierProvider(
        create: (_) => LanguageProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const LogoPage(),
    );
  }
}

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Create scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    // Start the animation
    _controller.forward();

    // Navigate after animations complete
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background.png'), // Add your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Green Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryGreen.withOpacity(0.3),
                  kSecondaryGreen.withOpacity(0.3),
                ],
              ),
            ),
          ),
          // Animated Logo and Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Fertile Future',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Green Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryGreen.withOpacity(0.3),
                  kSecondaryGreen.withOpacity(0.3),
                ],
              ),
            ),
          ),
          // Language Selector
          Padding(
            padding: const EdgeInsets.only(top: 40.0, right: 16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: DropdownButton<String>(
                value: context.locale.languageCode,
                underline: Container(), // Removes the underline
                icon: const Text("🌐",
                    style: TextStyle(
                        fontSize: 18, color: Colors.blue)), // Blue globe
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
                  DropdownMenuItem(value: 'mr', child: Text('मराठी')),
                  DropdownMenuItem(value: 'gu', child: Text('ગુજરાતી')),
                  DropdownMenuItem(value: 'hr', child: Text('हरियाणवी')),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    context.setLocale(Locale(value));
                    Provider.of<LanguageProvider>(context, listen: false)
                        .changeLocale(Locale(value));
                  }
                },
              ),
            ),
          ),
          // Welcome Back Card
          Expanded(
            child: Center(
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.all(20),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_florist,
                        size: 50,
                        color: Colors.green[700],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'welcomeBack'.tr(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'monitorNutrients'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryGreen,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginDetailsPage(),
                              ),
                            );
                          },
                          child: Text('login'.tr()),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryGreen,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: Text('signUp'.tr()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginDetailsPage extends StatefulWidget {
  const LoginDetailsPage({super.key});

  @override
  State<LoginDetailsPage> createState() => _LoginDetailsPageState();
}

class _LoginDetailsPageState extends State<LoginDetailsPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Green Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryGreen.withOpacity(0.3),
                  kSecondaryGreen.withOpacity(0.3),
                ],
              ),
            ),
          ),
          // Main Content
          Center(
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.all(20),
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'phone'.tr(),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone, color: kPrimaryGreen),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'password'.tr(),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock, color: kPrimaryGreen),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final user = await UserService.loginUser(
                              phoneController.text,
                              passwordController.text,
                            );

                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(username: user.name),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: Text('login'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Green Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryGreen.withOpacity(0.3),
                  kSecondaryGreen.withOpacity(0.3),
                ],
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Main Content
          Center(
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.all(20),
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'name'.tr(),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person, color: kPrimaryGreen),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'email'.tr(),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, color: kPrimaryGreen),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'phone'.tr(),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone, color: kPrimaryGreen),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'password'.tr(),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock, color: kPrimaryGreen),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final user = User(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                            );

                            await UserService.registerUser(user);
                            await UserService.saveUserData(user);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('accountCreated'.tr())),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: Text('createAccount'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      // Generate random values between 0.1 and 1.0
      levels = List.generate(3, (index) => (0.1 + Random().nextDouble() * 0.9));
      values = levels.map((e) => (e * 100).toStringAsFixed(0)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'nutrientLevels'.tr(),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'currentNutrientLevels'.tr(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryGreen,
                ),
              ),
              const SizedBox(height: 30),
              // Single Row with Three Containers
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Nitrogen Container
                      NutrientContainer(
                        nutrientName: 'nitrogen'.tr(),
                        level: levels[0],
                        color: Colors.blue,
                        icon: Icons.water_drop,
                        unit: 'mg/L',
                        value: values[0],
                        animation: _animationController,
                      ),
                      // Phosphorus Container
                      NutrientContainer(
                        nutrientName: 'phosphorus'.tr(),
                        level: levels[1],
                        color: Colors.orange,
                        icon: Icons.science,
                        unit: 'mg/L',
                        value: values[1],
                        animation: _animationController,
                      ),
                      // Potassium Container
                      NutrientContainer(
                        nutrientName: 'potassium'.tr(),
                        level: levels[2],
                        color: Colors.purple,
                        icon: Icons.spa,
                        unit: 'mg/L',
                        value: values[2],
                        animation: _animationController,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _refreshValues,
                icon: const Icon(Icons.refresh),
                label: Text('refreshValues'.tr()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NutrientContainer extends StatelessWidget {
  final String nutrientName;
  final double level;
  final Color color;
  final IconData icon;
  final String unit;
  final String value;
  final AnimationController animation;

  const NutrientContainer({
    super.key,
    required this.nutrientName,
    required this.level,
    required this.color,
    required this.icon,
    required this.unit,
    required this.value,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 350,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Nutrient Icon
          Icon(
            icon,
            size: 40,
            color: color,
          ),
          const SizedBox(height: 10),
          // Nutrient Name
          Text(
            nutrientName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Liquid Container
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: color, width: 2),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Animated Liquid
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        heightFactor: level * (0.95 + 0.05 * animation.value),
                        child: Container(
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: color.withOpacity(0.5)),
                          ),
                        ),
                      );
                    },
                  ),
                  // Value Label
                  Positioned(
                    bottom: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: color),
                      ),
                      child: Text(
                        '$value $unit',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child:
                    Icon(Icons.person, size: 20), // Moved person icon to right
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kPrimaryGreen, kSecondaryGreen],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: kPrimaryGreen, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text('home'.tr()),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('profile'.tr()),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final currentUser = await UserService.getCurrentUser();
                  if (context.mounted && currentUser != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(user: currentUser),
                      ),
                    );
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User data not found'.tr())),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text('history'.tr()),
              onTap: () {
                // Handle history
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: Text('notifications'.tr()),
              onTap: () {
                // Handle notifications
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('settings'.tr()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: kPrimaryGreen),
              title: Text('helpSupport'.tr()),
              onTap: () {
                Navigator.pop(context); // Close drawer first
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HelpSupportPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text('aboutUs'.tr()),
              onTap: () {
                // Handle about us
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('logout'.tr(),
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image and Overlay (existing code)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryGreen.withOpacity(0.3),
                  kSecondaryGreen.withOpacity(0.3),
                ],
              ),
            ),
          ),
          // New Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Top Image
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image:
                          AssetImage('assets/farm_image.png'), // Add your image
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                // Grid of Buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      // Check Manure Nutrients Button
                      _buildGridButton(
                        context,
                        'checkManure'.tr(),
                        Icons.eco,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NutrientsPage()),
                          );
                        },
                      ),
                      // Calculate Nutrients Button
                      _buildGridButton(
                        context,
                        'calculateNutrients'.tr(),
                        Icons.calculate,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NutrientsCalculatorPage()),
                          );
                        },
                      ),
                      // Analyze Soil Button
                      _buildGridButton(
                        context,
                        'analyzeSoil'.tr(),
                        Icons.landscape,
                        () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SoilAnalysisPage() as Widget),
                          );
                        },
                      ),
                      // YouTube Videos Button
                      _buildGridButton(
                        context,
                        'youtubeVideos'.tr(),
                        Icons.play_circle_fill,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const YouTubeSearchPage()),
                          );
                        },
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

  Widget _buildGridButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: kPrimaryGreen,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: kPrimaryGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SoilAnalysisPage {
  const SoilAnalysisPage();
}

class NutrientsCalculatorPage extends StatefulWidget {
  const NutrientsCalculatorPage({super.key});

  @override
  State<NutrientsCalculatorPage> createState() =>
      _NutrientsCalculatorPageState();
}

class _NutrientsCalculatorPageState extends State<NutrientsCalculatorPage> {
  final TextEditingController landAreaController = TextEditingController();
  final TextEditingController nitrogenController = TextEditingController();
  final TextEditingController phosphorusController = TextEditingController();
  final TextEditingController potassiumController = TextEditingController();
  String? recommendedLitres;
  String? npkRatio;

  void _calculateNutrients() {
    double n = double.tryParse(nitrogenController.text) ?? 0;
    double p = double.tryParse(phosphorusController.text) ?? 0;
    double k = double.tryParse(potassiumController.text) ?? 0;
    double area = double.tryParse(landAreaController.text) ?? 0;

    double litres = area * (n + p + k) * 0.5;
    double total = n + p + k;

    setState(() {
      if (total > 0) {
        double nRatio = (n / total) * 10;
        double pRatio = (p / total) * 10;
        double kRatio = (k / total) * 10;
        recommendedLitres = '${litres.toStringAsFixed(1)} L';
        npkRatio =
            '${nRatio.toStringAsFixed(1)} : ${pRatio.toStringAsFixed(1)} : ${kRatio.toStringAsFixed(1)}';
      } else {
        recommendedLitres = '0.0 L';
        npkRatio = '0 : 0 : 0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calculateNutrients'.tr(),
            style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Green Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryGreen.withOpacity(0.3),
                  kSecondaryGreen.withOpacity(0.3),
                ],
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'enterLandDetails'.tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryGreen,
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: landAreaController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'landArea'.tr(),
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.landscape, color: kPrimaryGreen),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: nitrogenController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'nitrogenN'.tr(),
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.science, color: kPrimaryGreen),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: phosphorusController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'phosphorusP'.tr(),
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.science, color: kPrimaryGreen),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: potassiumController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'potassiumK'.tr(),
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.science, color: kPrimaryGreen),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _calculateNutrients,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              'calculateNutrients'.tr(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (recommendedLitres != null) ...[
                  const SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'recommendations'.tr(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryGreen,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(Icons.water_drop,
                                          size: 40, color: kPrimaryGreen),
                                      const SizedBox(height: 10),
                                      Text(
                                        'recommendedManure'.tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        recommendedLitres!,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(Icons.science,
                                          size: 40, color: kPrimaryGreen),
                                      const SizedBox(height: 10),
                                      Text(
                                        'npkRatio'.tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        npkRatio!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  landAreaController.clear();
                                  nitrogenController.clear();
                                  phosphorusController.clear();
                                  potassiumController.clear();
                                  recommendedLitres = null;
                                  npkRatio = null;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryGreen,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: Text(
                                'calculateAgain'.tr(),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

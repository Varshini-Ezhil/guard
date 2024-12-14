import 'package:flutter/material.dart';
import 'screens/settings_page.dart';
import 'screens/youtube_search_page.dart';
import 'screens/help_support_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/soil_analysis_page.dart';
import 'dart:convert';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_blue/flutter_blue.dart';



// At the top of the file, add these color constants
const Color kPrimaryGreen = Color.fromRGBO(42, 164, 94, 1); // #2AA45E
const Color kSecondaryGreen = Color.fromRGBO(108, 205, 102, 1); // #6CCD66

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Check if user is already logged in
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final savedUsername = prefs.getString('username');

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
        child: MyApp(isLoggedIn: isLoggedIn, username: savedUsername),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? username;

  const MyApp({super.key, required this.isLoggedIn, this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: isLoggedIn && username != null
          ? HomePage(username: username!)
          : const LogoPage(),
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
        MaterialPageRoute(
            builder: (context) => HomePage(username: 'default'),
      ));
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

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool dataReceived = false;
  final List<String> imgList = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];
  int currentIndex = 0;

  
    
  

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
                    widget.username,
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Add Carousel at the top

// Then in your widget:
            FlutterCarousel(
              options: CarouselOptions(
                height: 220.0,
                showIndicator: true,
                autoPlay: true,
                viewportFraction: 0.75,
                enableInfiniteScroll: true,
                slideIndicator: const CircularSlideIndicator(),
              ),
              items: imgList.map((item) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      item,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              }).toList(),
            ),
            // Your existing content starts here
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
                        MaterialPageRoute(builder: (context) => const NutrientsPage()),
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
                            builder: (context) => const NutrientCalculator()),
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
                            builder: (context) => const YouTubeSearchPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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


class NutrientsPage extends StatefulWidget {
  const NutrientsPage({super.key});

  @override
  State<NutrientsPage> createState() => _NutrientsPageState();
}

class _NutrientsPageState extends State<NutrientsPage> {
  List<double> levels = [0.0, 0.0, 0.0, 0.0, 0.0]; // Initialize NPK, moisture, pH levels
  List<String> values = ['0', '0', '0', '0', '0']; // Initialize NPK, moisture, pH values

  @override
  void initState() {
    super.initState();
    _fetchNutrientData();
  }

  Future<void> _fetchNutrientData() async {
    try {
      final response = await http.get(Uri.parse('https://8554-49-37-215-65.ngrok-free.app/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final latestData = data.first; // Assuming you want the latest data point
          print(latestData);
          setState(() {
            levels = [
              (double.tryParse(latestData['nitrogen']?.toString() ?? '0') ?? 0) / 100.0,
              (double.tryParse(latestData['phosphorus']?.toString() ?? '0') ?? 0) / 100.0,
              (double.tryParse(latestData['potassium']?.toString() ?? '0') ?? 0) / 100.0,
              (double.tryParse(latestData['moisture']?.toString() ?? '0') ?? 0) / 100.0,
              (double.tryParse(latestData['ph']?.toString() ?? '0') ?? 0) / 14.0 // Assuming pH is scaled to 0-14
            ];
            
            values = [
              latestData['nitrogen']?.toString() ?? '0',
              latestData['phosphorus']?.toString() ?? '0',
              latestData['potassium']?.toString() ?? '0',
              latestData['moisture']?.toString() ?? '0',
              latestData['ph']?.toString() ?? '0'
            ];
          });
        }
      } else {
        throw Exception('Failed to load nutrient data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _navigateToBluetoothDevices() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AvailableBluetoothDevicesPage(),
      ),
    );
  }

  void _resetValues() {
    setState(() {
      levels = [0.0, 0.0, 0.0, 0.0, 0.0];
      values = ['0', '0', '0', '0', '0'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrient Levels'),
        backgroundColor: kPrimaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              // Add your PDF generation or navigation logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF icon pressed')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              const Text(
                'Current Nutrient Levels',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryGreen,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    final colors = [Colors.blue, Colors.orange, Colors.purple, Colors.brown, Colors.green];
                    final icons = [Icons.water_drop, Icons.science, Icons.spa, Icons.opacity, Icons.eco];
                    final names = ['Nitrogen', 'Phosphorus', 'Potassium', 'Moisture', 'pH'];

                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.width * 0.45,
                              child: CircularProgressIndicator(
                                value: levels[index],
                                strokeWidth: 25,
                                backgroundColor: colors[index].withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    colors[index]),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icons[index],
                                    color: colors[index], size: 32),
                                const SizedBox(height: 1),
                                Text(
                                  names[index],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  values[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: colors[index],
                                  ),
                                ),
                                Text(
                                  index == 4 ? '' : 'mg/L',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colors[index].withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (index < 4) const SizedBox(height: 35),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToBluetoothDevices,
                child: const Text('Connect Bluetooth'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetValues,
                child: const Text('Refresh Values'),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class AvailableBluetoothDevicesPage extends StatefulWidget {
  const AvailableBluetoothDevicesPage({super.key});

  @override
  State<AvailableBluetoothDevicesPage> createState() => _AvailableBluetoothDevicesPageState();
}

class _AvailableBluetoothDevicesPageState extends State<AvailableBluetoothDevicesPage> {
  // FlutterBlue flutterBlue = FlutterBlue.instance;
  // List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    // _startScan();
  }

  void _startScan() {
    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 5));

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });

    // Stop scanning after timeout
    Future.delayed(const Duration(seconds: 5), () {
      flutterBlue.stopScan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Bluetooth Devices'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          final device = scanResults[index].device;
          return ListTile(
            title: Text(device.name.isNotEmpty ? device.name : 'Unknown Device'),
            subtitle: Text(device.id.toString()),
            onTap: () {
              // Handle device selection
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected ${device.name}')),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startScan,
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.blue,
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

  const NutrientContainer({
    super.key,
    required this.nutrientName,
    required this.level,
    required this.color,
    required this.icon,
    required this.unit,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: screenWidth * 0.65,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(vertical: -25),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                  child: CircularProgressIndicator(
                    value: level,
                    strokeWidth: 12,
                    backgroundColor: color.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: color, size: 32),
                    const SizedBox(height: 1),
                    Text(
                      nutrientName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      unit,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: color.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class NutrientCalculator extends StatefulWidget {
  const NutrientCalculator({super.key});

  @override
  State<NutrientCalculator> createState() => _NutrientCalculatorState();
}

class _NutrientCalculatorState extends State<NutrientCalculator> {
  final Map<String, Map<String, dynamic>> soilData = {
    "Karnal": {
      "soil_types": "Alluvial, Loamy",
      "deficiencies": "Zn deficiency common",
      "rainfall": "650-750 mm",
      "n_content": "180-250 kg/ha",
      "p_content": "15-25 kg/ha",
      "k_content": "200-450 kg/ha",
      "suitable_crops": ["Rice", "Wheat", "Sugarcane", "Cotton"],
    },
    "Panipat": {
      "soil_types": "Alluvial, Loamy",
      "deficiencies": "Zn deficiency common",
      "rainfall": "600-700 mm",
      "n_content": "170-240 kg/ha",
      "p_content": "10-20 kg/ha",
      "k_content": "200-400 kg/ha",
      "suitable_crops": ["Rice", "Wheat", "Sugarcane", "Mustard"],
    },
  };

  String? recommendedLitres;
  String? npkRatio;

  final Map<String, Map<String, dynamic>> cropRequirements = {
    "Rice": {"n_req": 100, "p_req": 50, "k_req": 50},
    "Wheat": {"n_req": 120, "p_req": 60, "k_req": 40},
    "Cotton": {"n_req": 100, "p_req": 50, "k_req": 50},
    "Maize": {"n_req": 80, "p_req": 40, "k_req": 40},
    "Sugarcane": {"n_req": 150, "p_req": 60, "k_req": 60},
    "Groundnut": {"n_req": 20, "p_req": 40, "k_req": 30},
  };

  final TextEditingController nitrogenController = TextEditingController();
  final TextEditingController phosphorusController = TextEditingController();
  final TextEditingController potassiumController = TextEditingController();
  final TextEditingController landAreaController = TextEditingController();

  String? selectedLocation;
  String? selectedCrop;
  String landArea = '';
  Map<String, String> cropNutrients = {'n': '', 'p': '', 'k': ''};

  // Add this variable to track if calculation was performed
  bool showResults = false;

  void calculateNutrients() {
    if (selectedCrop != null && landArea.isNotEmpty) {
      final area = double.parse(landArea);
      final nReq = cropRequirements[selectedCrop!]?['n_req'] as int;
      final pReq = cropRequirements[selectedCrop!]?['p_req'] as int;
      final kReq = cropRequirements[selectedCrop!]?['k_req'] as int;

      setState(() {
        cropNutrients['n'] = (nReq * area).toStringAsFixed(1);
        cropNutrients['p'] = (pReq * area).toStringAsFixed(1);
        cropNutrients['k'] = (kReq * area).toStringAsFixed(1);
        showResults = true; // Set to true when calculation is performed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calculateNutrients'.tr()),
        backgroundColor: kPrimaryGreen,
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
          // Main Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Select Location:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryGreen,
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('Select your location'),
                        value: selectedLocation,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLocation = newValue;
                            selectedCrop = null;
                            cropNutrients = {
                              'n': '0.0',
                              'p': '0.0',
                              'k': '0.0'
                            };
                          });
                        },
                        items: soilData.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (selectedLocation != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Details:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryGreen,
                      ),
                    ),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Soil Type:', soilData[selectedLocation]!['soil_types']),
                            _buildDetailRow('Deficiencies:', soilData[selectedLocation]!['deficiencies']),
                            _buildDetailRow('Rainfall:', soilData[selectedLocation]!['rainfall']),
                            _buildDetailRow('N Content:', soilData[selectedLocation]!['n_content']),
                            _buildDetailRow('P Content:', soilData[selectedLocation]!['p_content']),
                            _buildDetailRow('K Content:', soilData[selectedLocation]!['k_content']),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'Enter Land Area (acres):',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryGreen,
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        hintText: 'Land Area',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          landArea = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Crop:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryGreen,
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Select crop'),
                          value: selectedCrop,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCrop = newValue;
                            });
                          },
                          items: selectedLocation != null
                              ? (soilData[selectedLocation!]?['suitable_crops'] as List<String>)
                                  .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      child: Text(value),
                                    ),
                                  );
                                }).toList()
                              : [],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      calculateNutrients();
                      setState(() {});
                    },
                    child: Text(
                      'Calculate Nutrients',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  if (showResults && selectedCrop != null && landArea.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Crop Nutrients:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryGreen,
                      ),
                    ),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildNutrientRow('Nitrogen (N):', '${cropNutrients['n']} kg', Colors.blue),
                            _buildNutrientRow('Phosphorus (P):', '${cropNutrients['p']} kg', Colors.orange),
                            _buildNutrientRow('Potassium (K):', '${cropNutrients['k']} kg', Colors.purple),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final double progress;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: color.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NutrientCheckPage extends StatefulWidget {
  const NutrientCheckPage({super.key});

  @override
  State<NutrientCheckPage> createState() => _NutrientCheckPageState();
}

class _NutrientCheckPageState extends State<NutrientCheckPage>
    with SingleTickerProviderStateMixin {
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

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create animations for each nutrient
    _nitrogenAnimation = Tween<double>(
      begin: 0.0,
      end: nitrogenValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _phosphorusAnimation = Tween<double>(
      begin: 0.0,
      end: phosphorusValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _potassiumAnimation = Tween<double>(
      begin: 0.0,
      end: potassiumValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation
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
        onPressed: () {
          // Reset and replay animation
          _controller.reset();
          _controller.forward();
        },
        backgroundColor: kPrimaryGreen,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildNutrientCircle(String label, double value, Color color) {
    return Container(
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

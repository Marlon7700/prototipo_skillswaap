import 'package:flutter/foundation.dart'; // Importar kIsWeb
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'Interfaz_IA.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      // Configuración para Web de Firebase
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCItV1rbi780g9cpEWFHIi85VnmgwJFVgg",
          appId: "1:968748392183:web:7e3eda83857820f8417df2",
          messagingSenderId: "968748392183",
          projectId: "skillwask",
          authDomain: "skillwask.firebaseapp.com",
          storageBucket: "skillwask.firebasestorage.app",
          measurementId: "G-R28YGSJKRT",
        ),
      );
    } else {
      // Configuración automática para Android/iOS (usa google-services.json)
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }
  runApp(const SkillSwapApp());
}

class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6BCE7A),
          primary: const Color(0xFF6BCE7A),
          secondary: const Color(0xFF00A99D),
        ),
        primaryColor: const Color(0xFF6BCE7A),
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'Arial',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/ai': (context) => const InterfazIA(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Controladores para las animaciones del bot
  late AnimationController _botAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  // Controladores para la animación del globo de texto
  late AnimationController _bubbleAnimationController;
  late Animation<double> _bubbleOpacityAnimation;
  late Animation<double> _bubbleScaleAnimation;
  bool _showGreeting = false;

  // Animación de la mano
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    // -- Campo de Configuración de la animación del Bot
    _botAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Repetir infinitamente

    // Animación de escala (pulso)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _botAnimationController, curve: Curves.easeInOut),
    );

    // Animación de opacidad del brillo
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _botAnimationController, curve: Curves.easeInOut),
    );

    // --- Configuración animación del Globo de Saludo ---
    _bubbleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bubbleOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _bubbleAnimationController, curve: Curves.easeIn),
    );

    _bubbleScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
          parent: _bubbleAnimationController, curve: Curves.elasticOut),
    );

    // Mostrar el saludo después de un pequeño retraso y ocultarlo después
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showGreeting = true;
        });
        _bubbleAnimationController.forward();
      }
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showGreeting) {
        _bubbleAnimationController.reverse().then((value) {
          if (mounted) {
            setState(() {
              _showGreeting = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _botAnimationController.dispose();
    _bubbleAnimationController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF6BCE7A);
    const Color darkText = Color(0xFF334A5F);

    // Obtener el usuario actual
    final user = FirebaseAuth.instance.currentUser;
    String userName = "Guest";
    if (user != null && user.email != null) {
      // Extrae la parte antes del @ del correo
      userName = user.email!.split('@')[0];
    }

    return Scaffold(
      body: Stack(
        children: [
          // 1. FONDO
          Positioned.fill(
            child: Image.asset('assets/Fondo_SkillSwap.png', fit: BoxFit.cover),
          ),

          // 2. CONTENIDO
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Logo ---
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.swap_calls,
                                    color: Color(0xFF00A99D), size: 30),
                                SizedBox(width: 8),
                                Text(
                                  "SkillSwap",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // --- Saludo ---
                        Row(
                          children: [
                            Text("Bienvenido, $userName!",
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: darkText)),
                            const SizedBox(width: 10),
                            AnimatedBuilder(
                              animation: _waveAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _waveAnimation.value,
                                  child: const Text("👋", style: TextStyle(fontSize: 32)),
                                );
                              },
                            ),
                          ],
                        ),
                        const Text("What skills do you want to swap?",
                            style: TextStyle(fontSize: 16, color: darkText)),
                        const SizedBox(height: 30),

                        // --- Offer / Need ---
                        Row(
                          children: [
                            Expanded(child: _buildOfferCard(primaryGreen)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.swap_horiz_rounded,
                                  color: primaryGreen, size: 35),
                            ),
                            Expanded(child: _buildNeedCard()),
                          ],
                        ),
                        const SizedBox(height: 30),

                        _buildFindMatchButton(primaryGreen),
                        const SizedBox(height: 40),

                        // --- Matches ---
                        const Text("Suggested Matches",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: darkText)),
                        const SizedBox(height: 15),

                        _buildMatchCard(context,
                            name: "Mateo",
                            needs: "Web Development",
                            offers: "Photography",
                            imageUrl:
                                'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                        const SizedBox(height: 15),
                        _buildMatchCard(context,
                            name: "Sara",
                            needs: "Spanish Lessons",
                            offers: "Video Editing",
                            imageUrl:
                                'https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                        const SizedBox(height: 30),

                        // --- Cerrar sesión ---
                        Center(
                          child: TextButton.icon(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, '/login'),
                            icon: const Icon(Icons.logout,
                                color: Color(0xFF00A99D)),
                            label: const Text('Cerrar sesión',
                                style: TextStyle(
                                    color: darkText,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                // --- Copyright ---
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    '© 2026 SkillSwap. Todos los derechos reservados.',
                    style: TextStyle(
                        color: darkText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // --- Chat AI Bot con Saludo Animado ---
          Positioned(
            bottom: 60,
            right: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Globo de saludo animado
                if (_showGreeting)
                  FadeTransition(
                    opacity: _bubbleOpacityAnimation,
                    child: ScaleTransition(
                      scale: _bubbleScaleAnimation,
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10, right: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00A99D), // Color secundario para el chat
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(0),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 2))
                          ],
                        ),
                        child: const Text(
                          "Hola, bienvenido a SkillSwap",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                // Botón del Bot IA animado
                _buildAIBotButton(primaryGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Color green) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: green, borderRadius: BorderRadius.circular(20)),
            child: const Text("I OFFER",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.laptop_chromebook_rounded,
              size: 60, color: Color(0xFF00A99D)),
          const SizedBox(height: 10),
          const Text("Graphic Design",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFF334A5F))),
        ],
      ),
    );
  }

  Widget _buildNeedCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: const Color(0xFF00A99D),
                borderRadius: BorderRadius.circular(20)),
            child: const Text("I NEED",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.forum_rounded, size: 60, color: Color(0xFF8CC63F)),
          const SizedBox(height: 10),
          const Text("English Practice",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFF334A5F))),
        ],
      ),
    );
  }

  Widget _buildFindMatchButton(Color green) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: green,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: const Center(
        child: Text("Find a Match",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMatchCard(
    BuildContext context, {
    required String name,
    required String needs,
    required String offers,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 35, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334A5F))),
                  const Spacer(),
                  const Icon(Icons.check_circle,
                      color: Color(0xFF6BCE7A), size: 20),
                ]),
                const SizedBox(height: 4),
                RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Color(0xFF334A5F)),
                        children: [
                      const TextSpan(
                          text: "Needs: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6BCE7A))),
                      TextSpan(text: needs),
                    ])),
                RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Color(0xFF334A5F)),
                        children: [
                      const TextSpan(
                          text: "Offers: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6BCE7A))),
                      TextSpan(text: offers),
                    ])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget del Bot IA Animado ---
  Widget _buildAIBotButton(Color green) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/ai'),
      child: AnimatedBuilder(
        animation: _botAnimationController,
        builder: (context, child) {
          return ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              height: 70, // Un poco más grande para que resalte la imagen
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco para que resalte el robot verde
                shape: BoxShape.circle,
                boxShadow: [
                  // Brillo parpadeante animado
                  BoxShadow(
                    color: green.withOpacity(_glowAnimation.value),
                    blurRadius: 20 * _scaleAnimation.value,
                    spreadRadius: 5 * _scaleAnimation.value,
                  ),
                  // Sombra base
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5), // Espacio para el borde blanco
              child: ClipOval(
                child: Image.asset(
                  'assets/Chatbot_SkillSwap.png', // Tu imagen proporcionada
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
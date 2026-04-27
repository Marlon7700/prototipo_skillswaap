import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login.dart';
import 'Interfaz_IA.dart';
//import 'ventana_perfil.dart' 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDh4LU3VSh02Hfk7xUR6fDl6F7SWIRrKpk",
          authDomain: "skillswapp-b7fc0.firebaseapp.com",
          projectId: "skillswapp-b7fc0",
          storageBucket: "skillswapp-b7fc0.firebasestorage.app",
          messagingSenderId: "141826962219",
          appId: "1:141826962219:web:a9e4fb7613e727e7344b6e",
          databaseURL: "https://skillswapp-b7fc0-default-rtdb.firebaseio.com",
        ),
      );
    } else {
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
<<<<<<< Updated upstream
        primaryColor: const Color(0xFF6BCE7A),
=======
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6BCE7A),
          primary: const Color(0xFF6BCE7A),
          secondary: const Color(0xFF00A99D),
        ),
        primaryColor: const Color(0xFF6BCE7A),
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'Arial',
>>>>>>> Stashed changes
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/ai': (context) => const InterfazIA(),
        //'/perfil': (context) => const ventana_perfil(),
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

<<<<<<< Updated upstream
  final Color primaryGreen = const Color(0xFF6BCE7A);
  final Color darkText = const Color(0xFF334A5F);
  final Color lightGray = const Color(0xFFF4F6F5);
=======
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
    _updatePresence();

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

  void _showProfileMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: 80,
              right: 24,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 220,
                  // Ajustamos el diseño para que se vea como una sola pieza
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20), // Bordes más redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  // Eliminamos los Dividers y usamos un ClipRRect para que los 
                  // toques (InkWell) respeten los bordes redondeados del contenedor
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuItem(Icons.accessibility, "Accesibilidad", () {}),
                        _buildMenuItem(Icons.person_outline, "Perfil", () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/perfil');
                        }),
                        _buildMenuItem(Icons.check_box_outlined, "Calificaciones", () {}),
                        _buildMenuItem(Icons.calendar_today_outlined, "Calendario", () {}),
                        _buildMenuItem(Icons.folder_open_outlined, "Archivos personales", () {}),
                        // El último ítem puede tener un color diferente si deseas resaltar el cierre de sesión
                        _buildMenuItem(Icons.logout, "Cerrar sesión", () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/login');
                        }, isExit: true),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper actualizado para un look más integrado
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap,
      {bool isExit = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 15), // Más espacio interno
        child: Row(
          children: [
            Icon(icon,
                color: isExit ? Colors.redAccent : const Color(0xFF6BCE7A),
                size: 22),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: isExit ? Colors.redAccent : const Color(0xFF334A5F),
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePresence() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DatabaseReference presenceRef =
        FirebaseDatabase.instance.ref("status/${user.uid}");

    FirebaseDatabase.instance.ref(".info/connected").onValue.listen((event) {
      if (event.snapshot.value == true) {
        presenceRef.onDisconnect().set({
          "presence": "offline",
          "last_seen": ServerValue.timestamp,
          "email": user.email,
        });

        presenceRef.set({
          "presence": "online",
          "last_seen": ServerValue.timestamp,
          "email": user.email,
        });
      }
    });
  }
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFFE8F5E9).withOpacity(0.5),
                ],
              ),
            ),
=======
          // 1. FONDO
          Positioned.fill(
            child: Image.asset('assets/Fondo_SkillSwap.png', fit: BoxFit.cover),
>>>>>>> Stashed changes
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
                        // --- Header con Logo y Perfil clickable ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
<<<<<<< Updated upstream
                            Icon(Icons.swap_horizontal_circle, color: primaryGreen, size: 40),
                            const SizedBox(width: 10),
                            Text(
                              'SkillSwap',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: primaryGreen,
                                letterSpacing: -0.5,
=======
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/imagen_skillwasp.jpeg',
                                    height: 30,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.swap_calls,
                                            color: Color(0xFF00A99D), size: 30),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "SkillSwap",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6BCE7A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Avatar interactivo (Imagen 2)
                            GestureDetector(
                              onTap: () {
                                _showProfileMenu(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: NetworkImage(
                                          'https://ui-avatars.com/api/?name=$userName&background=6BCE7A&color=fff'),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                          color: Color(0xFF334A5F),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                  ],
                                ),
>>>>>>> Stashed changes
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // --- Saludo ---
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "Bienvenido, $userName!",
                              style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: darkText),
                            ),
                            const SizedBox(width: 10),
                            AnimatedBuilder(
                              animation: _waveAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _waveAnimation.value,
                                  child: const Text("👋",
                                      style: TextStyle(fontSize: 32)),
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
<<<<<<< Updated upstream
                        _buildGoogleButton(),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                          ),
=======

                        _buildFindMatchButton(primaryGreen),
                        const SizedBox(height: 40),

                        // --- Matches ---
                        const Text("Suggested Matches",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: darkText)),
                        const SizedBox(height: 15),

                        // StreamBuilder para mostrar usuarios desde Firebase
                        StreamBuilder(
                          stream: FirebaseDatabase.instance.ref("status").onValue,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                              return const Text("No hay usuarios disponibles");
                            }

                            Map<dynamic, dynamic> usersData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                            List<String> userIds = usersData.keys.cast<String>().toList();
                            
                            // Filtramos para no mostrar al usuario actual
                            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                            userIds.remove(currentUserId);

                            if (userIds.isEmpty) {
                              return const Text("No hay otros usuarios conectados");
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: userIds.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 15),
                              itemBuilder: (context, index) {
                                String uid = userIds[index];
                                Map data = usersData[uid] as Map;
                                bool isOnline = data["presence"] == "online";
                                
                                // Intentamos obtener el correo del usuario si está disponible o usamos un genérico
                                String name = data["email"]?.split('@')[0] ?? "User $index"; 
                                
                                return _buildMatchCard(
                                  context,
                                  name: name,
                                  userId: uid,
                                  needs: "Learning",
                                  offers: "Teaching",
                                  imageUrl: 'https://ui-avatars.com/api/?name=$name&background=random',
                                );
                              },
                            );
                          },
>>>>>>> Stashed changes
                        ),
                        const SizedBox(height: 30),
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
          // ignore: deprecated_member_use
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
<<<<<<< Updated upstream
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: primaryGreen),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Row(
=======
      child: Column(
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
        side: BorderSide(color: primaryGreen),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(text, style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
=======
  Widget _buildNeedCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // ignore: deprecated_member_use
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
    required String userId,
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
          StreamBuilder(
            stream: FirebaseDatabase.instance.ref("status/$userId").onValue,
            builder: (context, snapshot) {
              bool isOnline = false;
              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                Map data = snapshot.data!.snapshot.value as Map;
                isOnline = data["presence"] == "online";
              }

              return Stack(
                children: [
                  CircleAvatar(
                      radius: 35, backgroundImage: NetworkImage(imageUrl)),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
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
                    // ignore: deprecated_member_use
                    color: green.withOpacity(_glowAnimation.value),
                    blurRadius: 20 * _scaleAnimation.value,
                    spreadRadius: 5 * _scaleAnimation.value,
                  ),
                  // Sombra base
                  BoxShadow(
                    // ignore: deprecated_member_use
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
>>>>>>> Stashed changes
    );
  }
}
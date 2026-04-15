import 'package:flutter/foundation.dart'; // Importar kIsWeb
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // ─── Brand colors ─────────────────────────────────────────────────────────
  final Color primaryGreen = const Color(0xFF6BCE7A);
  final Color secondaryTeal = const Color(0xFF00A99D);

  // ─── Form ──────────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isSubmitting = false;

  // ─── Typewriter ────────────────────────────────────────────────────────────
  final String _fullText = "SkillSwap";
  String _displayedText = "";
  int _charIndex = 0;
  bool _isLoading = true;

  // ─── Controllers ──────────────────────────────────────────────────────────
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _colorController;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  late AnimationController _bgShiftController;
  late Animation<double> _bgShiftAnimation;

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _bgShiftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _bgShiftAnimation = Tween<double>(begin: -0.015, end: 0.015).animate(
      CurvedAnimation(parent: _bgShiftController, curve: Curves.easeInOut),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _startTypewriter();
  }

  void _startTypewriter() {
    Timer.periodic(const Duration(milliseconds: 90), (timer) {
      if (_charIndex < _fullText.length) {
        if (mounted) {
          setState(() {
            _displayedText += _fullText[_charIndex];
            _charIndex++;
          });
        }
      } else {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 700), () {
          if (mounted) {
            setState(() => _isLoading = false);
            _fadeController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _colorController.dispose();
    _floatController.dispose();
    _bgShiftController.dispose();
    _shakeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Validators ───────────────────────────────────────────────────────────
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo es obligatorio';
    }
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Ingresa un correo válido (ej. usuario@gmail.com)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  // ─── Handlers ─────────────────────────────────────────────────────────────
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _shakeController.forward(from: 0);
      return;
    }
    setState(() => _isSubmitting = true);
    
    try {
      // Intenta iniciar sesión
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // SI EL USUARIO NO EXISTE, LO CREAMOS AUTOMÁTICAMENTE
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
          return;
        } catch (signUpError) {
          debugPrint("Error al crear cuenta automática: $signUpError");
        }
      }

      String message = 'Error al entrar';
      if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta para este correo';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isSubmitting = true);
    try {
      debugPrint("Iniciando Google Sign In con selector de cuentas forzado...");
      
      // Creamos la instancia con scopes específicos y el ClientID solo si es Web
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? "968748392183-3hn4t2hsue66bp51gieuk9hn0j0dfth1.apps.googleusercontent.com" : null,
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      
      // Cerramos cualquier sesión previa para que SIEMPRE pida elegir cuenta
      await googleSignIn.signOut();
      
      // Abrimos el selector de cuentas
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        debugPrint("El usuario cerró el selector de cuentas sin elegir ninguna");
        setState(() => _isSubmitting = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint("Cuenta seleccionada: ${googleUser.email}. Autenticando en Firebase...");
      await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (!mounted) return;
      debugPrint("Login exitoso. Navegando al Home...");
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      debugPrint("ERROR DETALLADO EN GOOGLE LOGIN: $e");
      
      String friendlyError = "No se pudo conectar con Google.";
      if (e.toString().contains("DEVELOPER_ERROR")) {
        friendlyError = "Error de configuración: Asegúrate de que el SHA-1 de tu PC esté en Firebase.";
      } else if (e.toString().contains("network_error")) {
        friendlyError = "Error de red. Revisa tu internet.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(friendlyError),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu correo primero')),
      );
      return;
    }
    FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Se ha enviado un correo para restablecer tu contraseña'),
        backgroundColor: primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<void> _handleCreateAccount() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _shakeController.forward(from: 0);
      return;
    }
    
    setState(() => _isSubmitting = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message = 'Error en el registro';
      if (e.code == 'weak-password') {
        message = 'La contraseña es muy débil';
      } else if (e.code == 'email-already-in-use') {
        message = 'El correo ya está en uso';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          Container(color: Colors.black.withOpacity(0.04)),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            60,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 36),

                          // ── Logo header ──────────────────────────────────
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeInOutQuart,
                            padding: EdgeInsets.only(
                              top: _isLoading
                                  ? MediaQuery.of(context).size.height * 0.35
                                  : 0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildAnimatedHeader(),
                                if (_isLoading) ...[
                                  const SizedBox(height: 24),
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        primaryGreen),
                                    strokeWidth: 3,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 36),

                          // ── "Login" title ────────────────────────────────
                          if (!_isLoading)
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: _buildLoginTitle(),
                                ),
                              ),
                            ),
                          const SizedBox(height: 28),

                          // ── Form ─────────────────────────────────────────
                          if (!_isLoading)
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: _buildForm(),
                              ),
                            )
                          else
                            const SizedBox.shrink(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Create Account (pegado al fondo) ──────────────────────
                if (!_isLoading) _buildCreateAccountButton(),
                const SizedBox(height: 12),

                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Background ─────────────────────────────────────────────────────────────
  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _bgShiftAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              MediaQuery.of(context).size.width * _bgShiftAnimation.value, 0),
          child: Transform.scale(
            scale: 1.04,
            child: Image.asset(
              'assets/Fondo_SkillSwap.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
            ),
          ),
        );
      },
    );
  }

  // ── Animated logo header ───────────────────────────────────────────────────
  Widget _buildAnimatedHeader() {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_colorController, _scaleAnimation, _floatAnimation]),
      builder: (context, child) {
        final t = _colorController.value;
        final stops = [
          (t - 0.35).clamp(0.0, 1.0),
          t.clamp(0.0, 1.0),
          (t + 0.35).clamp(0.0, 1.0),
        ];

        // Letras saltarinas individuales
        List<Widget> animatedChars = [];
        for (int i = 0; i < _displayedText.length; i++) {
          final charDelay = i * 0.15;
          final charBounce = (Curves.easeInOut.transform(
                      (t + charDelay) % 1.0) *
                  -6.0)
              .toDouble();

          animatedChars.add(
            Transform.translate(
              offset: Offset(0, charBounce),
              child: Text(
                _displayedText[i],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          );
        }

        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.90),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.20),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.asset('assets/icon1.png',
                          height: 44, width: 44),
                    ),
                    const SizedBox(width: 14),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          primaryGreen,
                          secondaryTeal,
                          const Color(0xFF4ADE80),
                          secondaryTeal,
                          primaryGreen,
                        ],
                        stops: [0.0, stops[0], stops[1], stops[2], 1.0],
                        tileMode: TileMode.clamp,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: animatedChars,
                      ),
                    ),
                  ],
                ),
                if (_isLoading)
                  Positioned(
                    bottom: -10,
                    child: SizedBox(
                      width: 140,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            primaryGreen.withOpacity(0.5)),
                        minHeight: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // **"Login" bold title 
  Widget _buildLoginTitle() {
    return const Text(
      'Login',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        color: Colors.white, // Cambiado de Color(0xFF2A3D50) a blanco
        letterSpacing: 0.3,
        shadows: [
          Shadow(
            blurRadius: 10.0,
            color: Colors.black45,
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
    );
  }

  // **Form 
  Widget _buildForm() {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final progress = _shakeController.value;
        final shakeX = progress < 1.0
            ? 10.0 * (1.0 - progress) * _sineWave(progress)
            : 0.0;
        return Transform.translate(
          offset: Offset(_shakeController.isAnimating ? shakeX : 0, 0),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Email
              _HoverAnimatedField(
                child: _buildValidatedField(
                  controller: _emailController,
                  hintText: 'email@example.com',
                  icon: Icons.email_outlined,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: 16),

              // ── Password 
              _HoverAnimatedField(
                child: _buildValidatedField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  icon: Icons.lock_outline,
                  validator: _validatePassword,
                  obscureText: _obscureText,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                ),
              ),
              const SizedBox(height: 28),

              // ── Login button   
              _PressAnimatedButton(
                onPressed: _isSubmitting ? () {} : _handleLogin,
                primaryGreen: primaryGreen,
                secondaryTeal: secondaryTeal,
                child: _buildLoginButton(),
              ),
              const SizedBox(height: 20),

              // ── Divider "or login with" ────────────────────────────────
              _buildDivider(),
              const SizedBox(height: 20),

              // ── Google button ──────────────────────────────────────────
              _PressAnimatedButton(
                onPressed: _handleGoogleLogin,
                primaryGreen: primaryGreen,
                secondaryTeal: secondaryTeal,
                child: _buildGoogleButton(),
              ),
              const SizedBox(height: 20),

              // ── Forgot Password ────────────────────────────────────────
              GestureDetector(
                onTap: _handleForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _sineWave(double t) {
    return (t * 4 * 3.14159).abs() < 0.001
        ? 0.0
        : (t * 4 * 3.14159 * 2).truncate().isEven
            ? 1.0
            : -1.0;
  }

  // ── Validated field ───────────────────────────────────────────────────────
  Widget _buildValidatedField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    void Function(String)? onFieldSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: primaryGreen, size: 22),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscureText = !_obscureText),
                )
              : null,
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(
            color: Colors.red.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 18,
          ),
        ),
      ),
    );
  }

  // ── Login button ──────────────────────────────────────────────────────────
  Widget _buildLoginButton() {
    return Container(
      height: 58,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryGreen, secondaryTeal],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.40),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: _isSubmitting
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
      ),
    );
  }

  // ── Divider ───────────────────────────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or login with',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }

  // ── Google button with real logo via network image ─────────────────────────
  Widget _buildGoogleButton() {
    return Container(
      height: 58,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbqxB37HobSQL9mtgDqpGeq5He6mTe917MTg&s',
              height: 24,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_circle,
                color: Colors.grey,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Google',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // ── Create Account button ─────────────────────────────────────────────────
  Widget _buildCreateAccountButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: _PressAnimatedButton(
        onPressed: _isSubmitting ? () {} : _handleCreateAccount,
        primaryGreen: primaryGreen,
        secondaryTeal: secondaryTeal,
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: primaryGreen.withOpacity(0.35), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: secondaryTeal,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        '© 2026 SkillSwap. Todos los derechos reservados.',
        style: TextStyle(
          color: Color(0xFF334A5F),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.white, blurRadius: 4)],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  _HoverAnimatedField
// ═══════════════════════════════════════════════════════════════════════════
class _HoverAnimatedField extends StatefulWidget {
  final Widget child;
  const _HoverAnimatedField({required this.child});

  @override
  State<_HoverAnimatedField> createState() => _HoverAnimatedFieldState();
}

class _HoverAnimatedFieldState extends State<_HoverAnimatedField>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _lift;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _lift = Tween<double>(begin: 0, end: -5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _glow = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) => Future.delayed(
            const Duration(milliseconds: 300), _ctrl.reverse),
        onTapCancel: () => _ctrl.reverse(),
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _lift.value),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6BCE7A)
                          .withOpacity(0.16 * _glow.value),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: child,
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  _PressAnimatedButton
// ═══════════════════════════════════════════════════════════════════════════
class _PressAnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color primaryGreen;
  final Color secondaryTeal;

  const _PressAnimatedButton({
    required this.child,
    required this.onPressed,
    required this.primaryGreen,
    required this.secondaryTeal,
  });

  @override
  State<_PressAnimatedButton> createState() => _PressAnimatedButtonState();
}

class _PressAnimatedButtonState extends State<_PressAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 130));
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: ScaleTransition(
          scale: _scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            foregroundDecoration: _hovered
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(0.06),
                  )
                : null,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
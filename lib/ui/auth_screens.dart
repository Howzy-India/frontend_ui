part of '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _iconCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _taglineCtrl;

  late final Animation<double> _iconRotation;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _iconScale;
  late final Animation<double> _textOpacity;
  late final Animation<double> _textWidth;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;

  static const _iconSize = 112.0;
  static const _fontSize = 76.0;

  @override
  void initState() {
    super.initState();

    _iconCtrl = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textCtrl = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _taglineCtrl = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _iconRotation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut),
    );
    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut),
    );
    _iconScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeInOut),
    );
    _textWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeInOut),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut),
    );
    _taglineSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut),
    );

    _iconCtrl.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _textCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) _taglineCtrl.forward();
    });
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _textCtrl.dispose();
    _taglineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5F0FF), Colors.white, Color(0xFFEEF2FF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animated house icon
                  AnimatedBuilder(
                    animation: _iconCtrl,
                    builder: (context, _) => Transform.scale(
                      scale: _iconScale.value,
                      child: Transform.rotate(
                        angle: _iconRotation.value * 3.14159,
                        child: Opacity(
                          opacity: _iconOpacity.value,
                          child: const SizedBox(
                            width: _iconSize,
                            height: _iconSize,
                            child: CustomPaint(
                              painter: _HowzyMarkPainter(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Animated "howzy.in" text sliding in
                  AnimatedBuilder(
                    animation: _textCtrl,
                    builder: (context, child) => ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _textWidth.value,
                        child: Opacity(
                          opacity: _textOpacity.value,
                          child: child,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            'howzy',
                            style: TextStyle(
                              fontSize: _fontSize,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -2,
                              color: Color(0xFF0F172A),
                              height: 1,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '.in',
                            style: TextStyle(
                              fontSize: _fontSize * 0.38,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4F46E5),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // Animated tagline fading in last
              AnimatedBuilder(
                animation: _taglineCtrl,
                builder: (context, child) => SlideTransition(
                  position: _taglineSlide,
                  child: Opacity(
                    opacity: _taglineOpacity.value,
                    child: child,
                  ),
                ),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'GROW BIG ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      TextSpan(
                        text: 'EARN BIG',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.authService,
    required this.firebaseEnabled,
  });

  final ValueChanged<UserRole> onLogin;
  final AuthService? authService;
  final bool firebaseEnabled;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleFirebaseLogin() async {
    if (!widget.firebaseEnabled || widget.authService == null) {
      _showMessage('Firebase is not configured.');
      return;
    }

    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showMessage('Email and password are required.');
      return;
    }

    setState(() => _submitting = true);
    try {
      await widget.authService!.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final profile = await widget.authService!.getCurrentProfile();
      if (!mounted) {
        return;
      }
      widget.onLogin(_toUserRole(profile.role));
    } catch (error) {
      _showMessage('Login failed: $error');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  UserRole _toUserRole(AuthRole role) {
    switch (role) {
      case AuthRole.superAdmin:
        return UserRole.superAdmin;
      case AuthRole.admin:
        return UserRole.admin;
      case AuthRole.agent:
        return UserRole.agent;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE6E8F1), Color(0xFFEDEFF7)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: HowzyLogo()),
                    const SizedBox(height: 28),
                    const Text(
                      'Enter your credentials to access the dashboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Username',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Color(0xFFD1D5DB),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        hintStyle: const TextStyle(color: Color(0xFF0F172A)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFD8DEE9),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFFD1D5DB),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        hintStyle: const TextStyle(color: Color(0xFF0F172A)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFD8DEE9),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA855F7), Color(0xFF4338CA)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3A4F46E5),
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: _submitting
                            ? null
                            : () {
                                if (widget.firebaseEnabled) {
                                  _handleFirebaseLogin();
                                } else {
                                  widget.onLogin(UserRole.agent);
                                }
                              },
                        child: _submitting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GreetingsScreen extends StatelessWidget {
  const GreetingsScreen({
    super.key,
    required this.role,
    required this.onContinue,
  });

  final UserRole role;
  final VoidCallback onContinue;

  String get _title {
    switch (role) {
      case UserRole.agent:
        return 'Welcome back, Howzy Partner!';
      case UserRole.admin:
        return 'Welcome back, Admin!';
      case UserRole.superAdmin:
        return 'Welcome back, Super Admin!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const HowzyLogo(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Ready to close some deals today?'),
            const SizedBox(height: 18),
            if (role == UserRole.agent)
              Expanded(
                child: ListView.builder(
                  itemCount: tutorials.length,
                  itemBuilder: (context, index) {
                    final item = tutorials[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.play_circle_fill_outlined),
                        title: Text(item.title),
                        trailing: Text(item.duration),
                      ),
                    );
                  },
                ),
              )
            else
              const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: FilledButton.icon(
                onPressed: onContinue,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to Dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

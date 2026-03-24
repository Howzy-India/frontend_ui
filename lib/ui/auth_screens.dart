part of '../main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEDE9FE), Colors.white, Color(0xFFE0E7FF)],
          ),
        ),
        child: const Center(child: HowzyLogo(tagline: true, large: true)),
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

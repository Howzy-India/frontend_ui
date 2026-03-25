import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/auth/auth_service.dart';
import 'core/widgets/firebase_setup_banner.dart';
import 'firebase/firebase_options.dart';
import 'features/builders/builder_service.dart';
import 'features/users/user_management_service.dart';
import 'features/properties/property_service.dart';

part 'data/mock_models.dart';
part 'data/property_data.dart';
part 'ui/auth_screens.dart';
part 'ui/dashboards.dart';
part 'ui/dashboard_views.dart';
part 'ui/shared_widgets.dart';
part 'ui/client_landing.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseEnabled = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseEnabled = true;
  } catch (_) {
    firebaseEnabled = false;
  }

  runApp(HowzyApp(firebaseEnabled: firebaseEnabled));
}

enum AppView { splash, login, greetings, pilot, partner, admin, clientLanding }

enum UserRole { superAdmin, admin, agent }

class HowzyApp extends StatelessWidget {
  const HowzyApp({
    super.key,
    this.firebaseEnabled = false,
    AuthService? authService,
  }) : _authService = authService;

  final bool firebaseEnabled;
  final AuthService? _authService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Howzy',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4F46E5),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: AppRoot(
        firebaseEnabled: firebaseEnabled,
        authService: _authService ?? (firebaseEnabled ? AuthService() : null),
      ),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({
    super.key,
    required this.firebaseEnabled,
    required this.authService,
  });

  final bool firebaseEnabled;
  final AuthService? authService;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  AppView _view = AppView.splash;
  UserRole? _role;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _view = AppView.clientLanding);
      }
    });

    if (widget.firebaseEnabled) {
      widget.authService!.authStateChanges().listen((user) async {
        if (!mounted) {
          return;
        }

        if (user == null) {
          setState(() {
            _role = null;
            _view = AppView.clientLanding;
          });
          return;
        }

        final profile = await widget.authService!.getCurrentProfile();
        if (!mounted) {
          return;
        }
        setState(() {
          _role = _mapAuthRole(profile.role);
        });
      });
    }
  }

  void _onLogin(UserRole role) {
    setState(() {
      _role = role;
      _view = AppView.greetings;
    });
  }

  void _onContinue() {
    switch (_role) {
      case UserRole.agent:
        setState(() => _view = AppView.pilot);
      case UserRole.admin:
        setState(() => _view = AppView.partner);
      case UserRole.superAdmin:
        setState(() => _view = AppView.admin);
      default:
        setState(() => _view = AppView.login);
    }
  }

  Future<void> _onLogout() async {
    if (widget.firebaseEnabled) {
      await widget.authService!.signOut();
    }
    setState(() {
      _role = null;
      _view = AppView.clientLanding;
    });
  }

  UserRole _mapAuthRole(AuthRole role) {
    switch (role) {
      case AuthRole.superAdmin:
        return UserRole.superAdmin;
      case AuthRole.admin:
        return UserRole.admin;
      case AuthRole.agent:
        return UserRole.agent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: switch (_view) {
        AppView.splash => const SplashScreen(key: ValueKey('splash')),
        AppView.login => LoginScreen(
          key: const ValueKey('login'),
          onLogin: _onLogin,
          authService: widget.authService,
          firebaseEnabled: widget.firebaseEnabled,
        ),
        AppView.greetings => GreetingsScreen(
          key: const ValueKey('greetings'),
          role: _role ?? UserRole.agent,
          onContinue: _onContinue,
        ),
        AppView.pilot => PilotDashboard(
          key: const ValueKey('pilot'),
          onLogout: _onLogout,
        ),
        AppView.partner => PartnerDashboard(
          key: const ValueKey('partner'),
          onLogout: _onLogout,
        ),
        AppView.admin => AdminDashboard(
          key: const ValueKey('admin'),
          onLogout: _onLogout,
        ),
        AppView.clientLanding => ClientLandingScreen(
          key: const ValueKey('clientLanding'),
          onLoginClick: () => setState(() => _view = AppView.login),
          onLogout: _onLogout,
        ),
      },
    );

    if (widget.firebaseEnabled) {
      return body;
    }

    return Scaffold(
      body: Column(
        children: [
          const FirebaseSetupBanner(),
          Expanded(child: body),
        ],
      ),
    );
  }
}

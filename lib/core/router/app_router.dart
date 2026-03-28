import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/projects/projects_screen.dart';
import '../../features/services/services_screen.dart';
import '../../features/about/about_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../widgets/app_shell.dart';

// ─── Route paths ──────────────────────────────────────────────────────────────
class AppRoutes {
  static const home      = '/';
  static const projects  = '/projects';
  static const services  = '/services';
  static const about     = '/about';
  static const dashboard = '/dashboard';
}

// ─── Router provider ─────────────────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.home,      builder: (ctx, _) => const HomeScreen()),
          GoRoute(path: AppRoutes.projects,  builder: (ctx, _) => const ProjectsScreen()),
          GoRoute(path: AppRoutes.services,  builder: (ctx, _) => const ServicesScreen()),
          GoRoute(path: AppRoutes.about,     builder: (ctx, _) => const AboutScreen()),
          GoRoute(path: AppRoutes.dashboard, builder: (ctx, _) => const DashboardScreen()),
        ],
      ),
    ],
  );
});

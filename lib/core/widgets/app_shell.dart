import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../router/app_router.dart';
import 'howzy_logo.dart';

// ─── App Shell: wraps all routes with persistent nav ─────────────────────────
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth.isDesktop) {
        return _WebShell(child: child);
      }
      return _MobileShell(child: child);
    });
  }
}

// ─── Web Shell (Top NavBar) ───────────────────────────────────────────────────
class _WebShell extends StatelessWidget {
  const _WebShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: Column(
        children: [
          _WebNavBar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _WebNavBar extends StatefulWidget {
  @override
  State<_WebNavBar> createState() => _WebNavBarState();
}

class _WebNavBarState extends State<_WebNavBar> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.slate200)),
        boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  // Logo
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.home),
                    child: const HowzyLogoWidget(),
                  ),
                  const SizedBox(width: 20),
                  // State dropdown
                  _StateDropdown(),
                  const SizedBox(width: 16),
                  // Search
                  SizedBox(
                    width: 240,
                    height: 38,
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Search city, project…',
                        prefixIcon: const Icon(Icons.search, size: 16, color: AppColors.slate400),
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.slate200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.slate200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.indigo600, width: 1.5),
                        ),
                        fillColor: AppColors.slate50,
                        filled: true,
                      ),
                      style: const TextStyle(fontSize: 13),
                      onSubmitted: (v) {
                        if (v.isNotEmpty) context.go(AppRoutes.projects);
                      },
                    ),
                  ),
                  const Spacer(),
                  // Nav links
                  ...[
                    ('Projects', AppRoutes.projects),
                    ('Services', AppRoutes.services),
                    ('About',    AppRoutes.about),
                  ].map((item) => _NavItem(
                    label: item.$1,
                    route: item.$2,
                    isActive: location.startsWith(item.$2),
                    onTap: () => context.go(item.$2),
                  )),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 20, color: AppColors.slate200),
                  const SizedBox(width: 12),
                  // Contact
                  TextButton(
                    onPressed: () {},
                    child: const Text('Contact', style: TextStyle(fontSize: 13, color: AppColors.slate600, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 4),
                  // Login
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: const BorderSide(color: AppColors.slate200),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slate700)),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.indigo600,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Sign Up', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.label, required this.route, required this.isActive, required this.onTap});
  final String label, route;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            color: isActive ? AppColors.indigo600 : Colors.transparent,
            width: 2,
          )),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.indigo600 : AppColors.slate600,
          ),
        ),
      ),
    );
  }
}

class _StateDropdown extends StatefulWidget {
  @override
  State<_StateDropdown> createState() => _StateDropdownState();
}

class _StateDropdownState extends State<_StateDropdown> {
  String _selected = 'Telangana';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showMenu<String>(
          context: context,
          position: const RelativeRect.fromLTRB(200, 64, 0, 0),
          items: ['Telangana', 'Karnataka', 'Maharashtra', 'Tamil Nadu', 'Andhra Pradesh']
              .map((s) => PopupMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13))))
              .toList(),
        );
        if (picked != null) setState(() => _selected = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.slate50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.slate200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on_outlined, size: 13, color: AppColors.indigo600),
            const SizedBox(width: 4),
            Text(_selected, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slate700)),
            const SizedBox(width: 3),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AppColors.slate500),
          ],
        ),
      ),
    );
  }
}

// ─── Mobile Shell (Bottom Nav) ────────────────────────────────────────────────
class _MobileShell extends StatelessWidget {
  const _MobileShell({required this.child});
  final Widget child;

  static const _tabs = [
    (Icons.home_rounded,       Icons.home_outlined,       'Home',     AppRoutes.home),
    (Icons.apartment_rounded,  Icons.apartment_outlined,  'Projects', AppRoutes.projects),
    (Icons.handshake_rounded,  Icons.handshake_outlined,  'Services', AppRoutes.services),
    (Icons.person_rounded,     Icons.person_outline,      'Profile',  AppRoutes.dashboard),
  ];

  int _indexFor(String location) {
    if (location.startsWith(AppRoutes.projects)) return 1;
    if (location.startsWith(AppRoutes.services)) return 2;
    if (location.startsWith(AppRoutes.dashboard)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFor(location);

    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.slate200)),
          boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, -2))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isActive = i == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => context.go(tab.$4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isActive ? tab.$1 : tab.$2,
                          color: isActive ? AppColors.indigo600 : AppColors.slate400,
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.$3,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive ? AppColors.indigo600 : AppColors.slate400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

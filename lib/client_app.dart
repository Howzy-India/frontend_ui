import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../core/widgets/howzy_logo.dart';
import '../core/providers/property_providers.dart';
import '../features/home/home_screen.dart';
import '../features/projects/projects_screen.dart';
import '../features/services/services_screen.dart';
import '../features/about/about_screen.dart';
import '../features/dashboard/dashboard_screen.dart';

// ─── Tab definition ───────────────────────────────────────────────────────────
enum ClientTab { home, projects, services, about, dashboard }

// ─── Provider for current tab ─────────────────────────────────────────────────
final clientTabProvider = StateProvider<ClientTab>((ref) => ClientTab.home);

// ─── Root client app widget ───────────────────────────────────────────────────
class ClientApp extends ConsumerWidget {
  const ClientApp({super.key, this.onLoginClick});
  final VoidCallback? onLoginClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth.isDesktop) {
        return _WebClientApp(onLoginClick: onLoginClick);
      }
      return _MobileClientApp(onLoginClick: onLoginClick);
    });
  }
}

// ─── Web shell ────────────────────────────────────────────────────────────────
class _WebClientApp extends ConsumerWidget {
  const _WebClientApp({this.onLoginClick});
  final VoidCallback? onLoginClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(clientTabProvider);
    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: Column(
        children: [
          _WebNavBar(currentTab: tab, onLoginClick: onLoginClick),
          Expanded(child: _TabBody(tab: tab)),
        ],
      ),
    );
  }
}

// ─── Mobile shell ─────────────────────────────────────────────────────────────
class _MobileClientApp extends ConsumerWidget {
  const _MobileClientApp({this.onLoginClick});
  final VoidCallback? onLoginClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(clientTabProvider);
    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: _MobileTopBar(onLoginClick: onLoginClick),
      ),
      body: _TabBody(tab: tab),
      bottomNavigationBar: _MobileBottomNav(currentTab: tab),
    );
  }
}

// ─── Tab body (IndexedStack for persistent state) ────────────────────────────
class _TabBody extends StatelessWidget {
  const _TabBody({required this.tab});
  final ClientTab tab;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: tab.index,
      children: const [
        HomeScreen(),
        ProjectsScreen(),
        ServicesScreen(),
        AboutScreen(),
        DashboardScreen(),
      ],
    );
  }
}

// ─── Web Nav Bar (two-row layout matching React) ──────────────────────────────
class _WebNavBar extends ConsumerStatefulWidget {
  const _WebNavBar({required this.currentTab, this.onLoginClick});
  final ClientTab currentTab;
  final VoidCallback? onLoginClick;

  @override
  ConsumerState<_WebNavBar> createState() => _WebNavBarState();
}

class _WebNavBarState extends ConsumerState<_WebNavBar> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Row 1: Logo | Location | Search (wide) | Contact Us | Login ──
                SizedBox(
                  height: 64,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => ref.read(clientTabProvider.notifier).state = ClientTab.home,
                        child: const HowzyLogoWidget(),
                      ),
                      const SizedBox(width: 14),
                      _StateDropdown(),
                      const SizedBox(width: 16),
                      // Wide search bar (flex-1)
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: InputDecoration(
                              hintText: 'Search properties, locations, or projects...',
                              prefixIcon: const Icon(Icons.search, size: 16, color: AppColors.slate400),
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.slate200)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.slate200)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.indigo600, width: 1.5)),
                              fillColor: AppColors.slate50,
                              filled: true,
                            ),
                            style: const TextStyle(fontSize: 13),
                            onSubmitted: (v) {
                              if (v.isNotEmpty) {
                                ref.read(propertyFilterProvider.notifier).setSearch(v);
                                ref.read(clientTabProvider.notifier).state = ClientTab.projects;
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Contact Us', style: TextStyle(fontSize: 13, color: AppColors.slate600, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: widget.onLoginClick,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.indigo600,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                // ── Row 2: Tab navigation ─────────────────────────────────────
                SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      ('Home',     ClientTab.home),
                      ('Projects', ClientTab.projects),
                      ('Services', ClientTab.services),
                      ('About',    ClientTab.about),
                    ].map((item) => _NavLink(
                      label: item.$1,
                      isActive: widget.currentTab == item.$2,
                      onTap: () => ref.read(clientTabProvider.notifier).state = item.$2,
                    )).toList(),
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

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.isActive, required this.onTap});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isActive ? AppColors.indigo600 : Colors.transparent, width: 2))),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? AppColors.indigo600 : AppColors.slate600)),
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

  static const _states = ['Telangana', 'Karnataka', 'Maharashtra', 'Tamil Nadu', 'Andhra Pradesh'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showMenu<String>(
          context: context,
          position: const RelativeRect.fromLTRB(200, 64, 0, 0),
          items: _states.map((s) => PopupMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
        );
        if (picked != null) setState(() => _selected = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: AppColors.slate50, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.slate200)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.location_on_outlined, size: 13, color: AppColors.indigo600),
          const SizedBox(width: 4),
          Text(_selected, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slate700)),
          const SizedBox(width: 3),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AppColors.slate500),
        ]),
      ),
    );
  }
}

// ─── Mobile Top Bar ───────────────────────────────────────────────────────────
class _MobileTopBar extends ConsumerWidget {
  const _MobileTopBar({this.onLoginClick});
  final VoidCallback? onLoginClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.slate200)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => ref.read(clientTabProvider.notifier).state = ClientTab.home,
              child: const HowzyLogoWidget(),
            ),
            const SizedBox(width: 10),
            _StateDropdown(),
            const Spacer(),
            GestureDetector(
              onTap: onLoginClick,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(color: AppColors.indigo600, borderRadius: BorderRadius.circular(8)),
                child: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mobile Bottom Nav ────────────────────────────────────────────────────────
class _MobileBottomNav extends ConsumerWidget {
  const _MobileBottomNav({required this.currentTab});
  final ClientTab currentTab;

  static const _items = [
    (Icons.home_rounded,         Icons.home_outlined,          'Home',    ClientTab.home),
    (Icons.explore_rounded,      Icons.explore_outlined,       'Explore', ClientTab.projects),
    (Icons.handshake_rounded,    Icons.handshake_outlined,     'Consult', ClientTab.services),
    (Icons.mail_rounded,         Icons.mail_outline,           'Contact', ClientTab.dashboard),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.slate200)),
        boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: _items.map((item) {
              final isActive = currentTab == item.$4;
              return Expanded(
                child: GestureDetector(
                  onTap: () => ref.read(clientTabProvider.notifier).state = item.$4,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(isActive ? item.$1 : item.$2, color: isActive ? AppColors.indigo600 : AppColors.slate400, size: 22),
                    const SizedBox(height: 3),
                    Text(item.$3, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? AppColors.indigo600 : AppColors.slate400)),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

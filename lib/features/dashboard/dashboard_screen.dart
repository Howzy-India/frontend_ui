import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/property_providers.dart';
import '../../data/property_data_standalone.dart';
import '../projects/widgets/property_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  int _selectedIdx = 0;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() {
      if (_tab.indexIsChanging) setState(() => _selectedIdx = _tab.index);
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  static const _tabs = ['My Listings', 'My Enquiries', 'Saved Properties'];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth.isDesktop;
      return isDesktop
          ? _DesktopDashboard(tab: _tab, tabs: _tabs, selectedIdx: _selectedIdx, onTabChange: (i) => setState(() => _selectedIdx = i))
          : _MobileDashboard(tab: _tab, tabs: _tabs);
    });
  }
}

// ─── Desktop: sidebar + content ───────────────────────────────────────────────
class _DesktopDashboard extends ConsumerWidget {
  const _DesktopDashboard({required this.tab, required this.tabs, required this.selectedIdx, required this.onTabChange});
  final TabController tab;
  final List<String> tabs;
  final int selectedIdx;
  final ValueChanged<int> onTabChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar
        Container(
          width: 240,
          decoration: const BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: AppColors.slate200))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 28, backgroundColor: AppColors.indigoLight, child: const Icon(Icons.person_rounded, size: 28, color: AppColors.indigo600)),
                    const SizedBox(height: 12),
                    const Text('Welcome back!', style: TextStyle(fontSize: 13, color: AppColors.slate500)),
                    const Text('User', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                  ],
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: 8),
              ...List.generate(tabs.length, (i) => _SidebarItem(
                label: tabs[i],
                icon: const [Icons.home_work_rounded, Icons.question_answer_rounded, Icons.bookmark_rounded][i],
                selected: selectedIdx == i,
                onTap: () {
                  onTabChange(i);
                  tab.animateTo(i);
                },
              )),
              const Spacer(),
              const Divider(height: 1),
              _SidebarItem(label: 'Settings', icon: Icons.settings_rounded, selected: false, onTap: () {}),
              _SidebarItem(label: 'Sign Out',  icon: Icons.logout_rounded,  selected: false, onTap: () {}, danger: true),
              const SizedBox(height: 16),
            ],
          ),
        ),
        // Content
        Expanded(
          child: TabBarView(
            controller: tab,
            children: const [
              _MyListingsTab(),
              _EnquiriesTab(),
              _SavedTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.label, required this.icon, required this.selected, required this.onTap, this.danger = false});
  final String label;
  final IconData icon;
  final bool selected, danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.indigoLight : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Icon(icon, size: 18, color: danger ? const Color(0xFFDC2626) : (selected ? AppColors.indigo600 : AppColors.slate500)),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: danger ? const Color(0xFFDC2626) : (selected ? AppColors.indigo600 : AppColors.slate700))),
        ]),
      ),
    );
  }
}

// ─── Mobile: tab bar ──────────────────────────────────────────────────────────
class _MobileDashboard extends ConsumerWidget {
  const _MobileDashboard({required this.tab, required this.tabs});
  final TabController tab;
  final List<String> tabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // User info header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(children: [
            CircleAvatar(radius: 24, backgroundColor: AppColors.indigoLight, child: const Icon(Icons.person_rounded, color: AppColors.indigo600)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Welcome back!', style: TextStyle(fontSize: 12, color: AppColors.slate500)),
              const Text('User', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.slate900)),
            ]),
          ]),
        ),
        // Tab bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: tab,
            indicatorColor: AppColors.indigo600,
            labelColor: AppColors.indigo600,
            unselectedLabelColor: AppColors.slate500,
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            tabs: tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: tab,
            children: const [
              _MyListingsTab(),
              _EnquiriesTab(),
              _SavedTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Tab Contents ─────────────────────────────────────────────────────────────
class _MyListingsTab extends StatelessWidget {
  const _MyListingsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Listings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.slate900)),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add Listing', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                style: FilledButton.styleFrom(backgroundColor: AppColors.indigo600, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _EmptyState(icon: Icons.home_work_outlined, title: 'No listings yet', subtitle: 'Create your first property listing to start attracting buyers.', action: 'Add Listing', onAction: () {}),
        ],
      ),
    );
  }
}

class _EnquiriesTab extends StatelessWidget {
  const _EnquiriesTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Enquiries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.slate900)),
          const SizedBox(height: 20),
          _EmptyState(icon: Icons.question_answer_outlined, title: 'No enquiries yet', subtitle: 'When you reach out about a property, your enquiries will appear here.', action: 'Browse Projects', onAction: () {}),
        ],
      ),
    );
  }
}

class _SavedTab extends ConsumerWidget {
  const _SavedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedIds    = ref.watch(savedPropertiesProvider);
    final allProps    = mockProperties;
    final savedProps  = allProps.where((p) => savedIds.contains(p.id)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Saved Properties (${savedProps.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.slate900)),
          const SizedBox(height: 20),
          if (savedProps.isEmpty)
            _EmptyState(icon: Icons.bookmark_border_rounded, title: 'No saved properties', subtitle: 'Save properties you like while browsing to review them later.', action: 'Browse Projects', onAction: () {})
          else
            LayoutBuilder(builder: (ctx, constraints) {
              final isDesktop = constraints.maxWidth.isDesktop;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 3 : 1,
                  crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: isDesktop ? 0.75 : 3,
                ),
                itemCount: savedProps.length,
                itemBuilder: (ctx, i) => PropertyCard(property: savedProps[i], compact: !isDesktop),
              );
            }),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, required this.subtitle, required this.action, required this.onAction});
  final IconData icon;
  final String title, subtitle, action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      decoration: BoxDecoration(color: AppColors.slate50, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.slate200, style: BorderStyle.solid)),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.slate300),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.slate700)),
          const SizedBox(height: 6),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.slate500, height: 1.5)),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onAction,
            style: FilledButton.styleFrom(backgroundColor: AppColors.indigo600, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), minimumSize: Size.zero),
            child: Text(action, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

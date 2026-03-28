import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/property_providers.dart';
import '../../data/property_data_standalone.dart';
import 'widgets/property_card.dart';

// ─── Projects Screen ──────────────────────────────────────────────────────────
class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final props    = ref.watch(filteredPropertiesProvider);

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final isMobile  = w.isMobile;
      final isDesktop = w.isDesktop;

      if (isDesktop) {
        // Web: sidebar filters + grid
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 280, child: _FilterSidebar()),
            Expanded(child: _ResultsArea(properties: props, isMobile: isMobile, isDesktop: isDesktop)),
          ],
        );
      }

      // Mobile/tablet: filter bar on top
      return Column(
        children: [
          _MobileFilterBar(),
          Expanded(child: _ResultsArea(properties: props, isMobile: isMobile, isDesktop: isDesktop)),
        ],
      );
    });
  }
}

// ─── Filter Sidebar (web) ─────────────────────────────────────────────────────
class _FilterSidebar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(propertyFilterProvider);
    final notifier = ref.read(propertyFilterProvider.notifier);

    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.slate200)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                if (filters.hasFilters)
                  GestureDetector(
                    onTap: notifier.clear,
                    child: const Text('Clear All', style: TextStyle(fontSize: 12, color: AppColors.indigo600, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _FilterGroup(
              label: 'City',
              options: propertyCities,
              selected: filters.city,
              onSelect: notifier.setCity,
            ),
            _FilterGroup(
              label: 'Property Type',
              options: propertyCategories.map((c) => c[0].toUpperCase() + c.substring(1)).toList(),
              selected: filters.type,
              onSelect: (v) => notifier.setType(v.toLowerCase()),
            ),
            _FilterGroup(
              label: 'Budget',
              options: budgetRanges,
              selected: filters.budget,
              onSelect: notifier.setBudget,
            ),
            _FilterGroup(
              label: 'Move-in Time',
              options: moveInOptions,
              selected: filters.moveIn,
              onSelect: notifier.setMoveIn,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterGroup extends StatelessWidget {
  const _FilterGroup({required this.label, required this.options, required this.selected, required this.onSelect});
  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.slate400, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6, runSpacing: 6,
          children: options.map((o) {
            final isActive = selected == o || selected == o.toLowerCase();
            return GestureDetector(
              onTap: () => onSelect(isActive ? '' : o),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.indigo600 : AppColors.slate50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isActive ? AppColors.indigo600 : AppColors.slate200),
                ),
                child: Text(o, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? Colors.white : AppColors.slate600)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 4),
      ],
    );
  }
}

// ─── Mobile Filter Bar ────────────────────────────────────────────────────────
class _MobileFilterBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(propertyFilterProvider);
    final notifier = ref.read(propertyFilterProvider.notifier);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search city, project, developer...',
              prefixIcon: Icon(Icons.search, size: 18, color: AppColors.slate400),
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            onChanged: notifier.setSearch,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 10),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip2('City', filters.city, propertyCities, notifier.setCity, context),
                const SizedBox(width: 8),
                _filterChip2('Budget', filters.budget, budgetRanges, notifier.setBudget, context),
                const SizedBox(width: 8),
                _filterChip2('Type', filters.type, propertyCategories, notifier.setType, context),
                const SizedBox(width: 8),
                _filterChip2('Move-in', filters.moveIn, moveInOptions, notifier.setMoveIn, context),
                if (filters.hasFilters) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: notifier.clear,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(color: AppColors.red100, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFCA5A5))),
                      child: const Row(children: [
                        Icon(Icons.close, size: 12, color: Color(0xFFDC2626)),
                        SizedBox(width: 4),
                        Text('Clear', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFDC2626))),
                      ]),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip2(String label, String value, List<String> options, ValueChanged<String> onPick, BuildContext ctx) {
    final isActive = value.isNotEmpty;
    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: ctx,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (sheetCtx) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                ...options.map((o) => ListTile(
                  dense: true,
                  title: Text(o, style: const TextStyle(fontSize: 14)),
                  trailing: (o == value || o.toLowerCase() == value) ? const Icon(Icons.check_circle_rounded, color: AppColors.indigo600) : null,
                  onTap: () => Navigator.pop(sheetCtx, (o == value || o.toLowerCase() == value) ? '' : o),
                )),
              ],
            ),
          ),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppColors.indigoLight : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? AppColors.indigo600 : AppColors.slate200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isActive ? value : label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? AppColors.indigo600 : AppColors.slate600)),
            const SizedBox(width: 3),
            Icon(Icons.keyboard_arrow_down_rounded, size: 13, color: isActive ? AppColors.indigo600 : AppColors.slate500),
          ],
        ),
      ),
    );
  }
}

// ─── Results Area ─────────────────────────────────────────────────────────────
class _ResultsArea extends ConsumerWidget {
  const _ResultsArea({required this.properties, required this.isMobile, required this.isDesktop});
  final List<HowzyProperty> properties;
  final bool isMobile, isDesktop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(propertyFilterProvider);
    final notifier = ref.read(propertyFilterProvider.notifier);

    if (properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 52, color: AppColors.slate300),
            const SizedBox(height: 16),
            const Text('No properties found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.slate700)),
            const SizedBox(height: 6),
            const Text('Try adjusting your filters', style: TextStyle(fontSize: 13, color: AppColors.slate500)),
            const SizedBox(height: 20),
            FilledButton(onPressed: notifier.clear, child: const Text('Clear Filters')),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Text('${properties.length} Properties', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                const Spacer(),
                _SortButton(current: filters.sort, onChanged: notifier.setSort),
              ],
            ),
          ),
        ),
        isMobile
            // Mobile: vertical list
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: PropertyCard(property: properties[i], compact: true),
                  ),
                  childCount: properties.length,
                ),
              )
            // Tablet/Desktop: grid
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 3 : 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => PropertyCard(property: properties[i]),
                    childCount: properties.length,
                  ),
                ),
              ),
      ],
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.current, required this.onChanged});
  final String current;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (sheetCtx) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sort by', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                ...sortOptions.map((o) => ListTile(
                  dense: true,
                  title: Text(o),
                  trailing: o == current ? const Icon(Icons.check_circle_rounded, color: AppColors.indigo600) : null,
                  onTap: () => Navigator.pop(sheetCtx, o == current ? '' : o),
                )),
              ],
            ),
          ),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: current.isNotEmpty ? AppColors.indigoLight : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: current.isNotEmpty ? AppColors.indigo600 : AppColors.slate200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort_rounded, size: 14, color: current.isNotEmpty ? AppColors.indigo600 : AppColors.slate500),
            const SizedBox(width: 5),
            Text(current.isNotEmpty ? current : 'Sort', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: current.isNotEmpty ? AppColors.indigo600 : AppColors.slate600)),
            const SizedBox(width: 3),
            Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: current.isNotEmpty ? AppColors.indigo600 : AppColors.slate500),
          ],
        ),
      ),
    );
  }
}

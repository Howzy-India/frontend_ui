part of '../main.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
const _kIndigo       = Color(0xFF4F46E5);
const _kIndigoLight  = Color(0xFFE0E7FF);
const _kSlate50      = Color(0xFFF8FAFC);
const _kSlate100     = Color(0xFFF1F5F9);
const _kSlate200     = Color(0xFFE2E8F0);
const _kSlate400     = Color(0xFF94A3B8);
const _kSlate500     = Color(0xFF64748B);
const _kSlate300     = Color(0xFFCBD5E1);
const _kSlate600     = Color(0xFF475569);
const _kSlate700     = Color(0xFF334155);
const _kSlate800     = Color(0xFF1E293B);
const _kSlate900     = Color(0xFF0F172A);

enum _NavTab { home, projects, services, about }

enum LandingCategory { all, newProjects, resaleHomes, openPlots, farmLands, commercial }

// ─── Main Screen ──────────────────────────────────────────────────────────────

class ClientLandingScreen extends StatefulWidget {
  const ClientLandingScreen({
    super.key,
    required this.onLoginClick,
    this.onLogout,
  });

  final VoidCallback onLoginClick;
  final VoidCallback? onLogout;

  @override
  State<ClientLandingScreen> createState() => _ClientLandingScreenState();
}

class _ClientLandingScreenState extends State<ClientLandingScreen> {
  final _propertyService = PropertyService();
  final _scrollCtrl = ScrollController();

  _NavTab _navTab       = _NavTab.home;
  LandingCategory _cat  = LandingCategory.all;
  String _searchQuery   = '';
  String _locFilter     = '';
  String _priceFilter   = '';
  String _bhkFilter     = '';
  String _possFilter    = '';
  String _sortBy        = '';
  final Set<String> _savedIds = {};
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  List<PropertyListing> _applySortAndFilters(List<PropertyListing> source) {
    final filtered = source.where((p) {
      switch (_cat) {
        case LandingCategory.newProjects:
          if (p.category != PropertyCategory.project) return false;
        case LandingCategory.resaleHomes:
          if (p.category != PropertyCategory.villa && p.category != PropertyCategory.project) return false;
        case LandingCategory.openPlots:
          if (p.category != PropertyCategory.plot) return false;
        case LandingCategory.farmLands:
          if (p.category != PropertyCategory.farmland) return false;
        case LandingCategory.commercial:
          if (p.category != PropertyCategory.villa) return false;
        case LandingCategory.all:
          break;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!p.name.toLowerCase().contains(q) &&
            !p.location.toLowerCase().contains(q) &&
            !p.city.toLowerCase().contains(q) &&
            !p.developer.toLowerCase().contains(q)) return false;
      }
      if (_locFilter.isNotEmpty &&
          !p.location.toLowerCase().contains(_locFilter.toLowerCase()) &&
          !p.city.toLowerCase().contains(_locFilter.toLowerCase())) return false;
      if (_bhkFilter.isNotEmpty && !(p.bhkOptions?.contains(_bhkFilter) ?? false)) return false;
      if (_priceFilter.isNotEmpty && p.priceRangeKey != _priceFilter) return false;
      if (_possFilter.isNotEmpty && p.possession != _possFilter) return false;
      return true;
    }).toList();

    if (_sortBy == 'Newest') {
      filtered.sort((a, b) => b.id.compareTo(a.id));
    }

    return filtered;
  }

  void _clearFilters() => setState(() {
    _searchQuery = _locFilter = _priceFilter = _bhkFilter = _possFilter = '';
    _sortBy = '';
    _cat = LandingCategory.all;
    _searchCtrl.clear();
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PropertyListing>>(
      stream: _propertyService.watchProperties(),
      initialData: allProperties,
      builder: (context, snapshot) {
        final properties = snapshot.data ?? allProperties;
        return Scaffold(
          backgroundColor: _kSlate50,
          body: SafeArea(
            child: Column(
              children: [
                _TopNavBar(
                  onLoginClick: widget.onLoginClick,
                  onLogout: widget.onLogout,
                  activeTab: _navTab,
                  onTabSelect: (t) => setState(() => _navTab = t),
                ),
                Expanded(
                  child: _buildHomePage(properties),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomePage(List<PropertyListing> properties) {
    final filtered = _applySortAndFilters(properties);
    final showCategories = _cat == LandingCategory.all &&
        _searchQuery.isEmpty && _locFilter.isEmpty &&
        _priceFilter.isEmpty && _bhkFilter.isEmpty && _possFilter.isEmpty;

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final isMobile = w < 600;
      final isTablet = w >= 600 && w < 1024;
      final gridCols = isMobile ? 1 : (isTablet ? 2 : 3);
      final hPad = isMobile ? 16.0 : 24.0;

      return CustomScrollView(
        controller: _scrollCtrl,
        slivers: [
          SliverToBoxAdapter(
            child: _HeroSection(
              searchCtrl: _searchCtrl,
              budgetFilter: _priceFilter,
              typeFilter: _cat,
              bhkFilter: _bhkFilter,
              onSearch: (q) => setState(() => _searchQuery = q),
              onBudget: (v) => setState(() => _priceFilter = v),
              onType: (c) => setState(() => _cat = c),
              onBhk: (v) => setState(() => _bhkFilter = v),
              onBrowse: () => _scrollCtrl.animateTo(
                500,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterChipDelegate(
              active: _cat,
              onSelect: (c) => setState(() => _cat = c),
            ),
          ),
          if (showCategories)
            SliverToBoxAdapter(
              child: _FeaturedCategoriesSection(
                onSelect: (c) => setState(() => _cat = c),
                hPad: hPad,
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${filtered.length} ${filtered.length == 1 ? "Property" : "Properties"} Found',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: FontWeight.w800,
                      color: _kSlate900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  _SortDropdown(
                    value: _sortBy,
                    onChanged: (v) => setState(() => _sortBy = v),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 14),
              child: _InlineFilterBar(
                locFilter: _locFilter,
                priceFilter: _priceFilter,
                bhkFilter: _bhkFilter,
                possFilter: _possFilter,
                onLoc: (v) => setState(() => _locFilter = v),
                onPrice: (v) => setState(() => _priceFilter = v),
                onBhk: (v) => setState(() => _bhkFilter = v),
                onPoss: (v) => setState(() => _possFilter = v),
                onClear: _clearFilters,
              ),
            ),
          ),
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, size: 52, color: _kSlate300),
                    const SizedBox(height: 14),
                    const Text('No properties found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _kSlate700)),
                    const SizedBox(height: 6),
                    const Text('Try adjusting your filters', style: TextStyle(fontSize: 13, color: _kSlate500)),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _clearFilters,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(color: _kIndigo, borderRadius: BorderRadius.circular(8)),
                        child: const Text('Clear Filters', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCols,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: isMobile ? 0.85 : 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final p = filtered[i];
                    return _PropertyCard(
                      property: p,
                      isSaved: _savedIds.contains(p.id),
                      onSave: () => setState(() => _savedIds.contains(p.id)
                          ? _savedIds.remove(p.id)
                          : _savedIds.add(p.id)),
                      onTap: () => _showDetail(ctx, p),
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: _WhyChooseSection()),
          SliverToBoxAdapter(child: _buildFooter()),
        ],
      );
    });
  }

  Widget _buildFooter() {
    return Container(
      color: _kSlate800,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HowzyLogo(dark: true),
          const SizedBox(height: 10),
          const Text(
            'Connecting you with verified properties across India.\nTransparency, trust, and technology.',
            style: TextStyle(color: _kSlate500, fontSize: 12, height: 1.6),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF334155)),
          const SizedBox(height: 10),
          const Center(
            child: Text('© 2025 Howzy. All rights reserved.', style: TextStyle(color: _kSlate600, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, PropertyListing p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PropertyDetailSheet(
        property: p,
        isSaved: _savedIds.contains(p.id),
        onSave: () => setState(() => _savedIds.contains(p.id) ? _savedIds.remove(p.id) : _savedIds.add(p.id)),
        onEnquire: () {
          Navigator.pop(ctx);
          final rootCtx = context;
          // ignore: use_build_context_synchronously
          Future.delayed(Duration.zero, () {
            if (mounted) {
              // ignore: use_build_context_synchronously
              showModalBottomSheet(
                context: rootCtx,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
                builder: (_) => _EnquirySheet(
                  property: p,
                  onLoginClick: widget.onLoginClick,
                ),
              );
            }
          });
        },
      ),
    );
  }
}

// ─── Top Navigation Bar ───────────────────────────────────────────────────────

class _TopNavBar extends StatelessWidget {
  const _TopNavBar({
    required this.onLoginClick,
    this.onLogout,
    required this.activeTab,
    required this.onTabSelect,
  });

  final VoidCallback onLoginClick;
  final VoidCallback? onLogout;
  final _NavTab activeTab;
  final ValueChanged<_NavTab> onTabSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 0, isMobile ? 16 : 24, 0),
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    const HowzyLogo(),
                    if (!isMobile) ...[
                      const SizedBox(width: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _kSlate50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _kSlate200),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on_outlined, size: 13, color: _kIndigo),
                            SizedBox(width: 4),
                            Text('Hyderabad', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kSlate700)),
                            SizedBox(width: 3),
                            Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: _kSlate500),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (!isMobile) ...[
                      _NavLink(label: 'Projects', isActive: activeTab == _NavTab.projects, onTap: () => onTabSelect(_NavTab.projects)),
                      _NavLink(label: 'Services', isActive: activeTab == _NavTab.services, onTap: () => onTabSelect(_NavTab.services)),
                      _NavLink(label: 'About', isActive: activeTab == _NavTab.about, onTap: () => onTabSelect(_NavTab.about)),
                      Container(width: 1, height: 20, color: _kSlate200, margin: const EdgeInsets.symmetric(horizontal: 12)),
                      GestureDetector(
                        onTap: onLoginClick,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Text('Login', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kSlate700)),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    GestureDetector(
                      onTap: onLoginClick,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 18, vertical: 8),
                        decoration: BoxDecoration(color: _kIndigo, borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          isMobile ? 'Login' : 'Sign Up',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: _kSlate200),
          ],
        ),
      );
    });
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? _kIndigo : _kSlate600,
          ),
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatefulWidget {
  const _HeroSection({
    required this.searchCtrl,
    required this.budgetFilter,
    required this.typeFilter,
    required this.bhkFilter,
    required this.onSearch,
    required this.onBudget,
    required this.onType,
    required this.onBhk,
    required this.onBrowse,
  });

  final TextEditingController searchCtrl;
  final String budgetFilter;
  final LandingCategory typeFilter;
  final String bhkFilter;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onBudget;
  final ValueChanged<LandingCategory> onType;
  final ValueChanged<String> onBhk;
  final VoidCallback onBrowse;

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  late final _bgAnim    = CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.5, curve: Curves.easeOut));
  late final _badgeAnim = CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.35, curve: Curves.easeOut));
  late final _titleAnim = CurvedAnimation(parent: _ctrl, curve: const Interval(0.1, 0.55, curve: Curves.easeOut));
  late final _subAnim   = CurvedAnimation(parent: _ctrl, curve: const Interval(0.28, 0.65, curve: Curves.easeOut));
  late final _ctaAnim   = CurvedAnimation(parent: _ctrl, curve: const Interval(0.45, 0.85, curve: Curves.easeOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final heroH     = isMobile ? 420.0 : 500.0;
      final hPad      = isMobile ? 20.0 : 60.0;
      final titleSize = isMobile ? 30.0 : 52.0;
      final subSize   = isMobile ? 14.0 : 18.0;

      return SizedBox(
        height: heroH,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _bgAnim,
              builder: (_, child) => Opacity(
                opacity: _bgAnim.value.clamp(0.0, 1.0),
                child: child,
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=900&q=80',
                fit: BoxFit.cover,
                errorBuilder: (context, err, stack) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xFF1E3A5F), Color(0xFF0F1928)],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0x881E1B4B), Color(0xE60F172A)],
                ),
              ),
            ),
            if (!isMobile) ...[
              Positioned(
                top: -60, right: -60,
                child: _PulsingGlow(color: const Color(0xFF4F46E5), size: 220),
              ),
              Positioned(
                bottom: -80, left: -60,
                child: _PulsingGlow(color: const Color(0xFF7C3AED), size: 300, delay: const Duration(milliseconds: 1000)),
              ),
            ],
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _badgeAnim,
                        builder: (_, child) => Opacity(
                          opacity: _badgeAnim.value,
                          child: Transform.scale(scale: 0.8 + 0.2 * _badgeAnim.value, child: child),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                          ),
                          child: const Text(
                            'VERIFIED REAL ESTATE LISTINGS',
                            style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0),
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      AnimatedBuilder(
                        animation: _titleAnim,
                        builder: (_, child) => Opacity(
                          opacity: _titleAnim.value,
                          child: Transform.translate(offset: Offset(0, 30 * (1 - _titleAnim.value)), child: child),
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(text: 'Find Your ', style: TextStyle(color: Colors.white, fontSize: titleSize, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1.5)),
                            TextSpan(text: 'Perfect', style: TextStyle(color: const Color(0xFF818CF8), fontSize: titleSize, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1.5)),
                            TextSpan(text: ' Property', style: TextStyle(color: Colors.white, fontSize: titleSize, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1.5)),
                          ]),
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 10),
                      AnimatedBuilder(
                        animation: _subAnim,
                        builder: (_, child) => Opacity(
                          opacity: _subAnim.value,
                          child: Transform.translate(offset: Offset(0, 20 * (1 - _subAnim.value)), child: child),
                        ),
                        child: Text(
                          'Explore verified listings across locations',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: const Color(0xFFCBD5E1), fontSize: subSize, height: 1.5, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(height: isMobile ? 20 : 28),
                      AnimatedBuilder(
                        animation: _ctaAnim,
                        builder: (_, child) => Opacity(
                          opacity: _ctaAnim.value,
                          child: Transform.translate(offset: Offset(0, 40 * (1 - _ctaAnim.value)), child: child),
                        ),
                        child: _HeroSearchCard(
                          searchCtrl: widget.searchCtrl,
                          budgetFilter: widget.budgetFilter,
                          typeFilter: widget.typeFilter,
                          bhkFilter: widget.bhkFilter,
                          onSearch: widget.onSearch,
                          onBudget: widget.onBudget,
                          onType: widget.onType,
                          onBhk: widget.onBhk,
                          onBrowse: widget.onBrowse,
                          isMobile: isMobile,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─── Hero Search Card ─────────────────────────────────────────────────────────

class _HeroSearchCard extends StatelessWidget {
  const _HeroSearchCard({
    required this.searchCtrl,
    required this.budgetFilter,
    required this.typeFilter,
    required this.bhkFilter,
    required this.onSearch,
    required this.onBudget,
    required this.onType,
    required this.onBhk,
    required this.onBrowse,
    required this.isMobile,
  });

  final TextEditingController searchCtrl;
  final String budgetFilter;
  final LandingCategory typeFilter;
  final String bhkFilter;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onBudget;
  final ValueChanged<LandingCategory> onType;
  final ValueChanged<String> onBhk;
  final VoidCallback onBrowse;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 40, offset: const Offset(0, 16)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: _kSlate50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kSlate200),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Icon(Icons.search, size: 18, color: _kSlate400),
                ),
                Expanded(
                  child: TextField(
                    controller: searchCtrl,
                    style: const TextStyle(fontSize: 14, color: _kSlate900),
                    decoration: const InputDecoration(
                      hintText: 'Search "Apartments in Hyderabad"',
                      hintStyle: TextStyle(fontSize: 14, color: _kSlate400),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: onSearch,
                    textInputAction: TextInputAction.search,
                  ),
                ),
                GestureDetector(
                  onTap: () => onSearch(searchCtrl.text),
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _kIndigo,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Search', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          isMobile
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _HeroDropdown(label: 'Budget', value: budgetFilter, options: const ['Under 50L', '50L–1Cr', '1Cr–2Cr', '2Cr–5Cr', 'Above 5Cr'], onPick: onBudget)),
                        const SizedBox(width: 8),
                        Expanded(child: _HeroTypeDropdown(value: typeFilter, onPick: onType)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _HeroDropdown(label: 'BHK', value: bhkFilter, options: const ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '5+ BHK'], onPick: onBhk)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: onBrowse,
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(color: _kIndigo, borderRadius: BorderRadius.circular(10)),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.grid_view_rounded, color: Colors.white, size: 15),
                                  SizedBox(width: 6),
                                  Text('Browse', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _HeroDropdown(label: 'Budget', value: budgetFilter, options: const ['Under 50L', '50L–1Cr', '1Cr–2Cr', '2Cr–5Cr', 'Above 5Cr'], onPick: onBudget)),
                    const SizedBox(width: 10),
                    Expanded(child: _HeroTypeDropdown(value: typeFilter, onPick: onType)),
                    const SizedBox(width: 10),
                    Expanded(child: _HeroDropdown(label: 'BHK', value: bhkFilter, options: const ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '5+ BHK'], onPick: onBhk)),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: onBrowse,
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(color: _kIndigo, borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          children: [
                            Icon(Icons.grid_view_rounded, color: Colors.white, size: 15),
                            SizedBox(width: 6),
                            Text('Browse Projects', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _HeroDropdown extends StatelessWidget {
  const _HeroDropdown({required this.label, required this.value, required this.options, required this.onPick});
  final String label, value;
  final List<String> options;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final isActive = value.isNotEmpty;
    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (_) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter by $label', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _kSlate900)),
                const SizedBox(height: 12),
                ...options.map((o) => ListTile(
                  dense: true,
                  title: Text(o, style: const TextStyle(fontSize: 14)),
                  trailing: o == value ? const Icon(Icons.check_circle_rounded, color: _kIndigo) : null,
                  onTap: () => Navigator.pop(context, o == value ? '' : o),
                )),
              ],
            ),
          ),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? _kIndigoLight : _kSlate50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? _kIndigo : _kSlate200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                isActive ? value : label,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isActive ? _kIndigo : _kSlate500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: isActive ? _kIndigo : _kSlate400),
          ],
        ),
      ),
    );
  }
}

class _HeroTypeDropdown extends StatelessWidget {
  const _HeroTypeDropdown({required this.value, required this.onPick});
  final LandingCategory value;
  final ValueChanged<LandingCategory> onPick;

  static const _options = [
    (LandingCategory.all, 'All Types'),
    (LandingCategory.newProjects, 'New Projects'),
    (LandingCategory.resaleHomes, 'Resale/Villas'),
    (LandingCategory.openPlots, 'Open Plots'),
    (LandingCategory.farmLands, 'Farm Lands'),
    (LandingCategory.commercial, 'Commercial'),
  ];

  @override
  Widget build(BuildContext context) {
    final isActive = value != LandingCategory.all;
    final label = isActive ? _options.firstWhere((o) => o.$1 == value).$2 : 'Property Type';
    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<LandingCategory>(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (_) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Property Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _kSlate900)),
                const SizedBox(height: 12),
                ..._options.map((o) => ListTile(
                  dense: true,
                  title: Text(o.$2, style: const TextStyle(fontSize: 14)),
                  trailing: o.$1 == value ? const Icon(Icons.check_circle_rounded, color: _kIndigo) : null,
                  onTap: () => Navigator.pop(context, o.$1),
                )),
              ],
            ),
          ),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? _kIndigoLight : _kSlate50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? _kIndigo : _kSlate200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isActive ? _kIndigo : _kSlate500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: isActive ? _kIndigo : _kSlate400),
          ],
        ),
      ),
    );
  }
}

// ─── Sticky Filter Chip Bar ───────────────────────────────────────────────────

class _FilterChipDelegate extends SliverPersistentHeaderDelegate {
  const _FilterChipDelegate({required this.active, required this.onSelect});
  final LandingCategory active;
  final ValueChanged<LandingCategory> onSelect;

  @override double get minExtent => 52;
  @override double get maxExtent => 52;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _FilterChipBar(active: active, onSelect: onSelect);
  }

  @override
  bool shouldRebuild(_FilterChipDelegate old) => old.active != active;
}

class _FilterChipBar extends StatelessWidget {
  const _FilterChipBar({required this.active, required this.onSelect});
  final LandingCategory active;
  final ValueChanged<LandingCategory> onSelect;

  @override
  Widget build(BuildContext context) {
    const chips = [
      (LandingCategory.all,          'All'),
      (LandingCategory.newProjects,  'New Projects'),
      (LandingCategory.resaleHomes,  'Resale'),
      (LandingCategory.openPlots,    'Villas & Plots'),
      (LandingCategory.farmLands,    'Farm Lands'),
      (LandingCategory.commercial,   'Commercial'),
    ];

    return Container(
      height: 52,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: chips.map((c) {
                  final isActive = c.$1 == active;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => onSelect(c.$1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive ? _kIndigo : _kSlate50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isActive ? _kIndigo : _kSlate200),
                        ),
                        child: Text(
                          c.$2,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : _kSlate600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1, color: _kSlate200),
        ],
      ),
    );
  }
}

// ─── Featured Categories Section ─────────────────────────────────────────────

class _FeaturedCategoriesSection extends StatelessWidget {
  const _FeaturedCategoriesSection({required this.onSelect, required this.hPad});
  final ValueChanged<LandingCategory> onSelect;
  final double hPad;

  static const _cats = [
    (LandingCategory.newProjects, Icons.apartment_rounded, 'New Projects',    'Premium townships & gated communities', Color(0xFFDBEAFE), Color(0xFF1D4ED8)),
    (LandingCategory.resaleHomes, Icons.villa_rounded,      'Villas',          'Luxury villas with modern amenities',   Color(0xFFD1FAE5), Color(0xFF065F46)),
    (LandingCategory.farmLands,   Icons.eco_rounded,         'Farm Lands',      'Agricultural & investment land',        Color(0xFFDCFCE7), Color(0xFF166534)),
    (LandingCategory.commercial,  Icons.business_rounded,    'Commercial',      'Office spaces & retail properties',     Color(0xFFFEF3C7), Color(0xFF92400E)),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      return Padding(
        padding: EdgeInsets.fromLTRB(hPad, 32, hPad, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore by Category',
              style: TextStyle(
                fontSize: isMobile ? 18 : 24,
                fontWeight: FontWeight.w800,
                color: _kSlate900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Discover the right type of property for you',
              style: TextStyle(fontSize: isMobile ? 13 : 15, color: _kSlate500),
            ),
            const SizedBox(height: 16),
            isMobile
                ? Column(
                    children: [
                      Row(children: [
                        Expanded(child: _CatCard(cat: _cats[0], onSelect: onSelect)),
                        const SizedBox(width: 10),
                        Expanded(child: _CatCard(cat: _cats[1], onSelect: onSelect)),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(child: _CatCard(cat: _cats[2], onSelect: onSelect)),
                        const SizedBox(width: 10),
                        Expanded(child: _CatCard(cat: _cats[3], onSelect: onSelect)),
                      ]),
                    ],
                  )
                : Row(
                    children: List.generate(_cats.length, (i) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < _cats.length - 1 ? 12 : 0),
                        child: _CatCard(cat: _cats[i], onSelect: onSelect),
                      ),
                    )),
                  ),
          ],
        ),
      );
    });
  }
}

class _CatCard extends StatelessWidget {
  const _CatCard({required this.cat, required this.onSelect});
  final (LandingCategory, IconData, String, String, Color, Color) cat;
  final ValueChanged<LandingCategory> onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(cat.$1),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kSlate100),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: cat.$5, borderRadius: BorderRadius.circular(12)),
              child: Icon(cat.$2, size: 22, color: cat.$6),
            ),
            const SizedBox(height: 12),
            Text(cat.$3, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kSlate900)),
            const SizedBox(height: 4),
            Text(cat.$4, style: const TextStyle(fontSize: 11, color: _kSlate500, height: 1.4)),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Explore', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: cat.$6)),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward, size: 11, color: cat.$6),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Inline Filter Bar (above results) ───────────────────────────────────────

class _InlineFilterBar extends StatelessWidget {
  const _InlineFilterBar({
    required this.locFilter,
    required this.priceFilter,
    required this.bhkFilter,
    required this.possFilter,
    required this.onLoc,
    required this.onPrice,
    required this.onBhk,
    required this.onPoss,
    required this.onClear,
  });

  final String locFilter, priceFilter, bhkFilter, possFilter;
  final ValueChanged<String> onLoc, onPrice, onBhk, onPoss;
  final VoidCallback onClear;

  bool get _hasFilters => locFilter.isNotEmpty || priceFilter.isNotEmpty || bhkFilter.isNotEmpty || possFilter.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(context, 'Location',   locFilter,   onLoc,   ['Hyderabad', 'Bengaluru', 'Mumbai', 'Shamshabad', 'Mokila', 'Mahabubnagar']),
          const SizedBox(width: 8),
          _chip(context, 'Price',      priceFilter, onPrice, ['Under 50L', '50L–1Cr', '1Cr–2Cr', '2Cr–5Cr', 'Above 5Cr']),
          const SizedBox(width: 8),
          _chip(context, 'BHK',        bhkFilter,   onBhk,   ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '5+ BHK']),
          const SizedBox(width: 8),
          _chip(context, 'Possession', possFilter,  onPoss,  ['Ready to Move', 'Under Construction', 'Pre-Launch']),
          if (_hasFilters) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFCA5A5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.close, size: 12, color: Color(0xFFDC2626)),
                    SizedBox(width: 4),
                    Text('Clear All', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFDC2626))),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(BuildContext ctx, String label, String value, ValueChanged<String> onPick, List<String> options) {
    final isActive = value.isNotEmpty;
    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: ctx,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (_) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter by $label', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _kSlate900)),
                const SizedBox(height: 12),
                ...options.map((o) => ListTile(
                  dense: true,
                  title: Text(o, style: const TextStyle(fontSize: 14)),
                  trailing: o == value ? const Icon(Icons.check_circle_rounded, color: _kIndigo) : null,
                  onTap: () => Navigator.pop(ctx, o == value ? '' : o),
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
          color: isActive ? _kIndigoLight : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? _kIndigo : _kSlate200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isActive ? value : label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? _kIndigo : _kSlate600),
            ),
            const SizedBox(width: 3),
            Icon(Icons.keyboard_arrow_down_rounded, size: 13, color: isActive ? _kIndigo : _kSlate500),
          ],
        ),
      ),
    );
  }
}

// ─── Sort Dropdown ────────────────────────────────────────────────────────────

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = ['Newest', 'Price: Low to High', 'Price: High to Low'];
    final isActive = value.isNotEmpty;
    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (_) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sort by', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _kSlate900)),
                const SizedBox(height: 12),
                ...options.map((o) => ListTile(
                  dense: true,
                  title: Text(o, style: const TextStyle(fontSize: 14)),
                  trailing: o == value ? const Icon(Icons.check_circle_rounded, color: _kIndigo) : null,
                  onTap: () => Navigator.pop(context, o == value ? '' : o),
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
          color: isActive ? _kIndigoLight : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? _kIndigo : _kSlate200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort_rounded, size: 14, color: isActive ? _kIndigo : _kSlate500),
            const SizedBox(width: 4),
            Text(
              isActive ? value : 'Sort',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? _kIndigo : _kSlate600),
            ),
            const SizedBox(width: 3),
            Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: isActive ? _kIndigo : _kSlate500),
          ],
        ),
      ),
    );
  }
}

// Continuously pulsing ambient glow blob
class _PulsingGlow extends StatefulWidget {
  const _PulsingGlow({required this.color, required this.size, this.delay = Duration.zero});
  final Color color;
  final double size;
  final Duration delay;

  @override
  State<_PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<_PulsingGlow> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5000),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_ctrl.value);
        return Transform.scale(
          scale: 1.0 + 0.12 * t,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.15 + 0.05 * t),
            ),
          ),
        );
      },
    );
  }
}

// ─── Why Choose Howzy Section ─────────────────────────────────────────────────

class _WhyChooseSection extends StatefulWidget {
  const _WhyChooseSection();

  @override
  State<_WhyChooseSection> createState() => _WhyChooseSectionState();
}

class _WhyChooseSectionState extends State<_WhyChooseSection> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  bool _triggered = false;

  void _onVisibilityChanged(bool visible) {
    if (visible && !_triggered) {
      _triggered = true;
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stagger: title (0–0.4), card1 (0.2–0.6), card2 (0.35–0.75), card3 (0.5–1.0)
    final titleAnim  = CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.45, curve: Curves.easeOut));
    final card1Anim  = CurvedAnimation(parent: _ctrl, curve: const Interval(0.2, 0.65, curve: Curves.easeOut));
    final card2Anim  = CurvedAnimation(parent: _ctrl, curve: const Interval(0.35, 0.78, curve: Curves.easeOut));
    final card3Anim  = CurvedAnimation(parent: _ctrl, curve: const Interval(0.50, 1.00, curve: Curves.easeOut));

    return NotificationListener<ScrollNotification>(
      child: _VisibilityDetector(
        onVisible: _onVisibilityChanged,
        child: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final hPad = isMobile ? 12.0 : 20.0;

          final cards = [
            _AnimatedFeatureCard(animation: card1Anim, icon: Icons.verified_outlined,           color: _kIndigo,          title: '100% Verified',  desc: 'Every listing is manually verified by our experts.', isMobile: isMobile),
            _AnimatedFeatureCard(animation: card2Anim, icon: Icons.chat_bubble_outline_rounded, color: const Color(0xFF4F46E5), title: 'Direct Connect', desc: 'No middleman. Talk directly to owners or partners.', isMobile: isMobile),
            _AnimatedFeatureCard(animation: card3Anim, icon: Icons.sell_outlined,               color: const Color(0xFFF59E0B), title: 'Zero Brokerage', desc: 'Save thousands on commission fees.', isMobile: isMobile),
          ];

          return Padding(
            padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 24),
            child: Column(
              children: [
                // Title
                AnimatedBuilder(
                  animation: titleAnim,
                  builder: (_, child) => Opacity(
                    opacity: titleAnim.value,
                    child: Transform.translate(offset: Offset(0, 20 * (1 - titleAnim.value)), child: child),
                  ),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'Why Choose ',   style: TextStyle(fontSize: isMobile ? 24 : 36, fontWeight: FontWeight.w900, color: _kSlate900, letterSpacing: -0.5)),
                            TextSpan(text: 'Howzy',         style: TextStyle(fontSize: isMobile ? 24 : 36, fontWeight: FontWeight.w900, color: _kIndigo, letterSpacing: -0.5)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We bring transparency, trust, and technology to your property search.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _kSlate500, fontSize: isMobile ? 14 : 18, height: 1.5, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 16 : 28),
                // Cards — Row on desktop, Column on mobile
                isMobile
                    ? Column(
                        children: [
                          cards[0],
                          const SizedBox(height: 12),
                          cards[1],
                          const SizedBox(height: 12),
                          cards[2],
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: cards[0]),
                          const SizedBox(width: 16),
                          Expanded(child: cards[1]),
                          const SizedBox(width: 16),
                          Expanded(child: cards[2]),
                        ],
                      ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// Detects when widget becomes visible in the viewport
class _VisibilityDetector extends StatefulWidget {
  const _VisibilityDetector({required this.onVisible, required this.child});
  final Widget child;
  final ValueChanged<bool> onVisible;

  @override
  State<_VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<_VisibilityDetector> {
  final _key = GlobalKey();
  bool _seen = false;

  void _check() {
    if (_seen) return;
    final ctx = _key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(ctx).size.height;
    if (pos.dy < screenH * 1.1) {
      _seen = true;
      widget.onVisible(true);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (_) { _check(); return false; },
      child: KeyedSubtree(key: _key, child: widget.child),
    );
  }
}

class _AnimatedFeatureCard extends StatelessWidget {
  const _AnimatedFeatureCard({required this.animation, required this.icon, required this.color, required this.title, required this.desc, this.isMobile = false});
  final Animation<double> animation;
  final IconData icon;
  final Color color;
  final String title, desc;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - animation.value)),
          child: child,
        ),
      ),
      child: _FeatureCard(icon: icon, color: color, title: title, desc: desc, isMobile: isMobile),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.icon, required this.color, required this.title, required this.desc, this.isMobile = false});
  final IconData icon;
  final Color color;
  final String title, desc;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final pad   = isMobile ? 20.0 : 40.0;
    final iconSz = isMobile ? 48.0 : 64.0;
    final titleSz = isMobile ? 18.0 : 24.0;
    final descSz  = isMobile ? 14.0 : 16.0;

    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 32),
        border: Border.all(color: _kSlate100),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, 8)),
          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: isMobile
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: iconSz, height: iconSz,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: titleSz, fontWeight: FontWeight.w700, color: _kSlate900, letterSpacing: -0.3)),
                      const SizedBox(height: 4),
                      Text(desc, style: TextStyle(fontSize: descSz, color: _kSlate500, height: 1.5, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: iconSz, height: iconSz,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(height: 20),
                Text(title, style: TextStyle(fontSize: titleSz, fontWeight: FontWeight.w700, color: _kSlate900, letterSpacing: -0.3)),
                const SizedBox(height: 8),
                Text(desc, style: TextStyle(fontSize: descSz, color: _kSlate500, height: 1.6, fontWeight: FontWeight.w500)),
              ],
            ),
    );
  }
}

// ─── Search + Filter Bar (Projects tab) ───────────────────────────────────────

class _SearchFilterBar extends StatelessWidget {
  const _SearchFilterBar({
    required this.controller,
    required this.locFilter,
    required this.priceFilter,
    required this.bhkFilter,
    required this.possFilter,
    required this.onSearch,
    required this.onLoc,
    required this.onPrice,
    required this.onBhk,
    required this.onPoss,
    required this.onClear,
  });

  final TextEditingController controller;
  final String locFilter, priceFilter, bhkFilter, possFilter;
  final ValueChanged<String> onSearch, onLoc, onPrice, onBhk, onPoss;
  final VoidCallback onClear;

  bool get _hasFilters => locFilter.isNotEmpty || priceFilter.isNotEmpty || bhkFilter.isNotEmpty || possFilter.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search bar
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: _kSlate50,
              borderRadius: BorderRadius.circular(21),
              border: Border.all(color: _kSlate200),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Icon(Icons.search, size: 16, color: _kSlate400),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(fontSize: 13, color: _kSlate900),
                    decoration: const InputDecoration(
                      hintText: 'Search location or project...',
                      hintStyle: TextStyle(fontSize: 13, color: _kSlate400),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: onSearch,
                    textInputAction: TextInputAction.search,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip(context, 'Location',   locFilter,   onLoc,   ['Hyderabad', 'Bengaluru', 'Mumbai', 'Shamshabad', 'Mokila', 'Mahabubnagar']),
                const SizedBox(width: 8),
                _chip(context, 'Price',      priceFilter, onPrice, ['Under 50L', '50L-1Cr', '1Cr-2Cr', '2Cr-5Cr', 'Above 5Cr']),
                const SizedBox(width: 8),
                _chip(context, 'BHK',        bhkFilter,   onBhk,   ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '5+ BHK']),
                const SizedBox(width: 8),
                _chip(context, 'Possession', possFilter,  onPoss,  ['Ready to Move', 'Under Construction', 'Pre-Launch']),
                if (_hasFilters) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onClear,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.close, size: 12, color: Color(0xFFDC2626)),
                          SizedBox(width: 4),
                          Text('Clear', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFDC2626))),
                        ],
                      ),
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

  Widget _chip(
    BuildContext ctx,
    String label,
    String value,
    ValueChanged<String> onPick,
    List<String> options,
  ) {
    final isActive = value.isNotEmpty;
    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: ctx,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (_) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter by $label', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _kSlate900)),
                const SizedBox(height: 12),
                ...options.map((o) => ListTile(
                  dense: true,
                  title: Text(o, style: const TextStyle(fontSize: 14)),
                  trailing: o == value ? const Icon(Icons.check_circle_rounded, color: _kIndigo) : null,
                  onTap: () => Navigator.pop(ctx, o == value ? '' : o),
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
          color: isActive ? _kIndigoLight : _kSlate50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? _kIndigo : _kSlate200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isActive ? value : label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? _kIndigo : _kSlate600),
            ),
            const SizedBox(width: 3),
            Icon(Icons.keyboard_arrow_down_rounded, size: 13, color: isActive ? _kIndigo : _kSlate500),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Property Card
// ─────────────────────────────────────────────────────────────────────────────

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({
    required this.property,
    required this.isSaved,
    required this.onSave,
    required this.onTap,
  });

  final PropertyListing property;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onTap;

  Color get _categoryColor {
    switch (property.category) {
      case PropertyCategory.project:
        return const Color(0xFFDBEAFE);
      case PropertyCategory.villa:
        return const Color(0xFFD1FAE5);
      case PropertyCategory.plot:
        return const Color(0xFFFEF3C7);
      case PropertyCategory.farmland:
        return const Color(0xFFDCFCE7);
    }
  }

  Color get _categoryTextColor {
    switch (property.category) {
      case PropertyCategory.project:
        return const Color(0xFF1D4ED8);
      case PropertyCategory.villa:
        return const Color(0xFF065F46);
      case PropertyCategory.plot:
        return const Color(0xFF92400E);
      case PropertyCategory.farmland:
        return const Color(0xFF166534);
    }
  }

  IconData get _categoryIcon {
    switch (property.category) {
      case PropertyCategory.project:
        return Icons.apartment_outlined;
      case PropertyCategory.villa:
        return Icons.home_outlined;
      case PropertyCategory.plot:
        return Icons.map_outlined;
      case PropertyCategory.farmland:
        return Icons.park_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kSlate100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  // Image placeholder gradient (used since network images need connectivity)
                  Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _categoryColor,
                          _categoryColor.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                    child: Icon(
                      _categoryIcon,
                      size: 40,
                      color: _categoryTextColor.withValues(alpha: 0.4),
                    ),
                  ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badges row
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      children: [
                        if (property.isNew) _badge('New', const Color(0xFF4F46E5)),
                        if (property.isTrending) ...[
                          if (property.isNew) const SizedBox(width: 4),
                          _badge('🔥 Hot', const Color(0xFFEA580C)),
                        ],
                      ],
                    ),
                  ),
                  // Save button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onSave,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          size: 15,
                          color: isSaved ? Colors.red : _kSlate500,
                        ),
                      ),
                    ),
                  ),
                  // Possession badge at bottom
                  if (property.possession != null)
                    Positioned(
                      bottom: 6,
                      left: 8,
                      child: _possessionBadge(property.possession!),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _categoryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_categoryIcon, size: 10, color: _categoryTextColor),
                          const SizedBox(width: 3),
                          Text(
                            property.category.label,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: _categoryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      property.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: _kSlate900,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 10, color: _kSlate400),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${property.location}, ${property.city}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: _kSlate500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Size info
                    if (property.bhkOptions != null &&
                        property.bhkOptions!.isNotEmpty)
                      _sizeChips(
                        property.bhkOptions!.take(2).toList(),
                      ),
                    if (property.plotSize != null)
                      _sizeChips([property.plotSize!]),
                    if (property.farmAcres != null)
                      _sizeChips([property.farmAcres!]),
                    const SizedBox(height: 6),
                    // Price
                    Text(
                      property.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: _kIndigo,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _possessionBadge(String text) {
    Color color;
    if (text == 'Ready to Move') {
      color = const Color(0xFF059669);
    } else if (text == 'New Launch') {
      color = _kIndigo;
    } else {
      color = const Color(0xFFD97706);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _sizeChips(List<String> items) {
    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: items
          .map(
            (s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _kSlate100,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                s,
                style: const TextStyle(fontSize: 9, color: _kSlate600),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Property Detail Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _PropertyDetailSheet extends StatelessWidget {
  const _PropertyDetailSheet({
    required this.property,
    required this.isSaved,
    required this.onSave,
    required this.onEnquire,
  });

  final PropertyListing property;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onEnquire;

  Color get _catColor {
    switch (property.category) {
      case PropertyCategory.project:
        return const Color(0xFFDBEAFE);
      case PropertyCategory.villa:
        return const Color(0xFFD1FAE5);
      case PropertyCategory.plot:
        return const Color(0xFFFEF3C7);
      case PropertyCategory.farmland:
        return const Color(0xFFDCFCE7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.97,
      minChildSize: 0.5,
      builder: (ctx, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: scrollCtrl,
          padding: EdgeInsets.zero,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _kSlate200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header image area
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_catColor, _catColor.withValues(alpha: 0.4)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _iconFor(property.category),
                      size: 64,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      children: [
                        _IconButton(
                          icon: isSaved ? Icons.favorite : Icons.favorite_border,
                          color: isSaved ? Colors.red : _kSlate700,
                          onTap: onSave,
                        ),
                        const SizedBox(width: 8),
                        _IconButton(
                          icon: Icons.close,
                          color: _kSlate700,
                          onTap: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: _kSlate900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 13,
                              color: _kSlate500,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${property.location}, ${property.city}',
                              style: const TextStyle(
                                color: _kSlate600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price + possession
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PRICE RANGE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _kSlate400,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              property.price,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: _kIndigo,
                              ),
                            ),
                            if (property.pricePerSqft != null)
                              Text(
                                property.pricePerSqft!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: _kSlate500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (property.possession != null)
                        _PossessionBadge(possession: property.possession!),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // USP
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _kIndigoLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome, size: 16, color: _kIndigo),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            property.usp,
                            style: const TextStyle(
                              color: Color(0xFF3730A3),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Key details grid
                  _SectionTitle('Key Details'),
                  const SizedBox(height: 10),
                  _DetailsGrid(property: property),

                  // BHK options
                  if (property.bhkOptions != null &&
                      property.bhkOptions!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _SectionTitle('Available Configurations'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: property.bhkOptions!
                          .map(
                            (bhk) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: _kIndigoLight,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFFC7D2FE),
                                ),
                              ),
                              child: Text(
                                bhk,
                                style: const TextStyle(
                                  color: _kIndigo,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  // Amenities
                  if (property.amenities.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _SectionTitle('Amenities'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: property.amenities
                          .map(
                            (a) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _kSlate100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 12,
                                    color: Color(0xFF10B981),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    a,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: _kSlate700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  // Tags
                  if (property.tags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 6,
                      children: property.tags
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: _kSlate200),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.sell_outlined,
                                    size: 11,
                                    color: _kSlate500,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    t,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: _kSlate600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // CTAs
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onEnquire,
                          icon: const Icon(Icons.chat_bubble_outline, size: 16),
                          label: const Text(
                            'Enquire Now',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kIndigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.map_outlined, size: 16),
                        label: const Text(
                          'Map',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _kSlate700,
                          side: const BorderSide(color: _kSlate200, width: 1.5),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(PropertyCategory cat) {
    switch (cat) {
      case PropertyCategory.project:
        return Icons.apartment;
      case PropertyCategory.villa:
        return Icons.house;
      case PropertyCategory.plot:
        return Icons.landscape;
      case PropertyCategory.farmland:
        return Icons.agriculture;
    }
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _PossessionBadge extends StatelessWidget {
  const _PossessionBadge({required this.possession});
  final String possession;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    if (possession == 'Ready to Move') {
      bg = const Color(0xFFD1FAE5);
      fg = const Color(0xFF065F46);
    } else if (possession == 'New Launch') {
      bg = _kIndigoLight;
      fg = _kIndigo;
    } else {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFF92400E);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        possession,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: _kSlate400,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _DetailsGrid extends StatelessWidget {
  const _DetailsGrid({required this.property});
  final PropertyListing property;

  @override
  Widget build(BuildContext context) {
    final items = <(String, String)>[
      ('Developer', property.developer),
      ('RERA No.', property.reraNumber),
      if (property.area != null) ('Area', property.area!),
      if (property.plotSize != null) ('Plot Size', property.plotSize!),
      if (property.farmAcres != null) ('Land Size', property.farmAcres!),
      if (property.segment != null) ('Segment', property.segment!),
      if (property.gatedCommunity != null)
        ('Gated Community', property.gatedCommunity! ? 'Yes' : 'No'),
      if (property.approvalType != null)
        ('Approval', property.approvalType!),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.8,
      ),
      itemBuilder: (ctx, i) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _kSlate50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              items[i].$1.toUpperCase(),
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: _kSlate400,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              items[i].$2,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _kSlate800,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Enquiry Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _EnquirySheet extends StatefulWidget {
  const _EnquirySheet({
    required this.property,
    // ignore: unused_element_parameter
    this.userEmail,
    required this.onLoginClick,
  });

  final PropertyListing property;
  final String? userEmail;
  final VoidCallback onLoginClick;

  @override
  State<_EnquirySheet> createState() => _EnquirySheetState();
}

class _EnquirySheetState extends State<_EnquirySheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    if (widget.userEmail != null && widget.userEmail!.isNotEmpty) {
      _nameCtrl.text = widget.userEmail!.split('@').first;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _kSlate200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            if (_submitted)
              _buildSuccess()
            else
              _buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.check_circle,
            color: Color(0xFF10B981),
            size: 32,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Enquiry Sent!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: _kSlate900,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Our team will reach out to you within 24 hours.',
          style: TextStyle(color: _kSlate500, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: _kIndigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
          ),
          child: const Text(
            'Done',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enquire About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _kSlate900,
                      ),
                    ),
                    Text(
                      widget.property.name,
                      style: const TextStyle(
                        color: _kIndigo,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: _kSlate500),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _inputField(
            controller: _nameCtrl,
            label: 'Your Name',
            hint: 'Enter your name',
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 12),
          _inputField(
            controller: _phoneCtrl,
            label: 'Phone Number',
            hint: '+91 XXXXX XXXXX',
            keyboardType: TextInputType.phone,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Phone is required' : null,
          ),
          const SizedBox(height: 12),
          _inputField(
            controller: _msgCtrl,
            label: 'Message (Optional)',
            hint: "I'm interested in ${widget.property.name}...",
            maxLines: 3,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() => _submitted = true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _kIndigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Send Enquiry',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (widget.userEmail == null || widget.userEmail!.isEmpty) ...[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: widget.onLoginClick,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, color: _kSlate500),
                    children: [
                      TextSpan(text: 'Already a member? '),
                      TextSpan(
                        text: 'Login for faster enquiry',
                        style: TextStyle(
                          color: _kIndigo,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: _kSlate400,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: _kSlate900),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: _kSlate400, fontSize: 13),
            filled: true,
            fillColor: _kSlate50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _kSlate200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _kSlate200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _kIndigo, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

// Colour helpers not in Material palette — previously declared above

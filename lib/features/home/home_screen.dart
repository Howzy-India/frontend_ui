import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/howzy_logo.dart';

// ─── Home Screen ─────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollCtrl = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() => setState(() => _scrollOffset = _scrollCtrl.offset));
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollCtrl,
      slivers: [
        // Category filter chips row (visible only on desktop, matches React)
        SliverToBoxAdapter(child: _CategoryChipsBar()),
        SliverToBoxAdapter(child: _HeroSection(scrollOffset: _scrollOffset)),
        SliverToBoxAdapter(child: _WhyChooseHowzySection()),
        SliverToBoxAdapter(child: _TrendingLocationsSection()),
        SliverToBoxAdapter(child: _TrendingProjectsSection()),
        SliverToBoxAdapter(child: _TrustStatsSection()),
        SliverToBoxAdapter(child: _TestimonialsSection()),
        SliverToBoxAdapter(child: _HomeFooter()),
      ],
    );
  }
}

// ─── 0. Category Filter Chips Bar (desktop only, matches React) ───────────────
class _CategoryChipsBar extends StatefulWidget {
  @override
  State<_CategoryChipsBar> createState() => _CategoryChipsBarState();
}

class _CategoryChipsBarState extends State<_CategoryChipsBar> {
  int _selected = 0;

  static const _chips = [
    (Icons.apps_rounded,            'EXPLORE ALL'),
    (Icons.apartment_rounded,       'NEW PROJECTS'),
    (Icons.home_rounded,            'RESALE HOMES'),
    (Icons.landscape_rounded,       'OPEN PLOTS'),
    (Icons.eco_rounded,             'FARM LANDS'),
    (Icons.business_rounded,        'COMMERCIAL'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Container(
        color: Colors.white,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
                  child: Row(
                    children: List.generate(_chips.length, (i) {
                      final chip = _chips[i];
                      final active = _selected == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selected = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(right: isMobile ? 20 : 28),
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: active ? AppColors.indigo600 : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                chip.$1,
                                size: isMobile ? 15 : 18,
                                color: active ? AppColors.indigo600 : AppColors.slate400,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                chip.$2,
                                style: TextStyle(
                                  fontSize: isMobile ? 9 : 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: active ? AppColors.indigo600 : AppColors.slate500,
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
          ),
        ),
      );
    });
  }
}

// ─── 1. Hero Section (Parallax) ───────────────────────────────────────────────
class _HeroSection extends StatefulWidget {
  const _HeroSection({required this.scrollOffset});
  final double scrollOffset;

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
  late final _fadeAnim  = CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.5, curve: Curves.easeOut));
  late final _titleAnim = CurvedAnimation(parent: _ctrl, curve: const Interval(0.1, 0.6, curve: Curves.easeOut));
  late final _subAnim   = CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 0.75, curve: Curves.easeOut));
  late final _ctaAnim   = CurvedAnimation(parent: _ctrl, curve: const Interval(0.5, 0.9, curve: Curves.easeOut));
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      final heroH = isMobile ? 480.0 : 560.0;
      final parallaxOffset = widget.scrollOffset * 0.4;

      final heroCard = SizedBox(
        height: heroH,
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Parallax background image
              Transform.translate(
                offset: Offset(0, -parallaxOffset),
                child: Image.network(
                  'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200&q=80',
                  fit: BoxFit.cover,
                  height: heroH + 80,
                  errorBuilder: (_, _, _) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [Color(0xFF1E3A5F), Color(0xFF0F1928)]),
                    ),
                  ),
                ),
              ),
              // Dark gradient overlay (40% opacity tint matching React)
              Container(color: const Color(0xFF0F172A).withValues(alpha: 0.6)),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0x990F172A), Color(0x661E1B4B)],
                  ),
                ),
              ),
              // Ambient blobs
              if (!isMobile) ...[
                Positioned(top: -40, right: -40, child: _GlowBlob(color: AppColors.indigo600, size: 260)),
                Positioned(bottom: -60, left: -40, child: _GlowBlob(color: const Color(0xFF7C3AED), size: 320, delay: 800)),
              ],
              // Content
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Badge
                        AnimatedBuilder(
                          animation: _fadeAnim,
                          builder: (_, child) => Opacity(opacity: _fadeAnim.value, child: Transform.scale(scale: 0.8 + 0.2 * _fadeAnim.value, child: child)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                            ),
                            child: const Text('PREMIUM REAL ESTATE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                          ),
                        ),
                        SizedBox(height: isMobile ? 14 : 20),
                        // Headline
                        AnimatedBuilder(
                          animation: _titleAnim,
                          builder: (_, child) => Opacity(opacity: _titleAnim.value, child: Transform.translate(offset: Offset(0, 40 * (1 - _titleAnim.value)), child: child)),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(text: 'Find ', style: TextStyle(color: Colors.white, fontSize: isMobile ? 32 : 52, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1.0)),
                              TextSpan(text: 'Your', style: TextStyle(color: const Color(0xFF818CF8), fontSize: isMobile ? 32 : 52, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1.0)),
                              TextSpan(text: ' Perfect Property with Howzy', style: TextStyle(color: Colors.white, fontSize: isMobile ? 32 : 52, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1.0)),
                            ]),
                          ),
                        ),
                        SizedBox(height: isMobile ? 12 : 16),
                        // Subtitle
                        AnimatedBuilder(
                          animation: _subAnim,
                          builder: (_, child) => Opacity(opacity: _subAnim.value, child: Transform.translate(offset: Offset(0, 30 * (1 - _subAnim.value)), child: child)),
                          child: Text(
                            'Explore verified farm lands, plots, and commercial properties. Connect directly with trusted partners.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: const Color(0xFFCBD5E1), fontSize: isMobile ? 14 : 18, height: 1.6, fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(height: isMobile ? 24 : 32),
                        // Frosted glass search row
                        AnimatedBuilder(
                          animation: _ctaAnim,
                          builder: (_, child) => Opacity(opacity: _ctaAnim.value, child: Transform.translate(offset: Offset(0, 30 * (1 - _ctaAnim.value)), child: child)),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchCtrl,
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                    decoration: const InputDecoration(
                                      hintText: 'Search location or project...',
                                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 18),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => context.go(AppRoutes.projects),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('Explore All →', style: TextStyle(color: const Color(0xFF0F172A), fontSize: isMobile ? 13 : 14, fontWeight: FontWeight.w700)),
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
              ),
            ],
          ),
        ),
      );

      // Wrap in rounded dark card with margin (matching React bg-slate-900 rounded-[2rem])
      return Container(
        color: AppColors.slate50,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            decoration: const BoxDecoration(color: Color(0xFF0F172A)),
            child: heroCard,
          ),
        ),
      );
    });
  }
}


// ─── 2. Why Choose Howzy Section ─────────────────────────────────────────────
class _WhyChooseHowzySection extends StatelessWidget {
  static const _usps = [
    (Icons.verified_rounded,  'emerald', '100% Verified',  'Every listing is manually verified by our experts.'),
    (Icons.message_rounded,   'indigo',  'Direct Connect', 'No middleman. Talk directly to owners or partners.'),
    (Icons.label_rounded,     'amber',   'Zero Brokerage', 'Save thousands on commission fees.'),
  ];

  static const _iconColors = {
    'emerald': (Color(0xFFECFDF5), Color(0xFF059669)),
    'indigo':  (Color(0xFFEEF2FF), Color(0xFF4F46E5)),
    'amber':   (Color(0xFFFFFBEB), Color(0xFFD97706)),
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      final cols = isMobile ? 1 : 3;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: isMobile ? 40 : 64),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'Why Choose Howzy',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isMobile ? 24 : 36, fontWeight: FontWeight.w900, color: AppColors.slate900, letterSpacing: -0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  'We bring transparency, trust, and technology to your property search.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isMobile ? 14 : 18, color: AppColors.slate500, fontWeight: FontWeight.w500, height: 1.5),
                ),
              ],
            ),
            const SizedBox(height: 40),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: isMobile ? 2.8 : 1.6,
              ),
              itemCount: _usps.length,
              itemBuilder: (ctx, i) {
                final u = _usps[i];
                final colors = _iconColors[u.$2]!;
                return Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.slate100),
                    boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 24, offset: Offset(0, 8))],
                  ),
                  child: isMobile
                      ? Row(children: [
                          Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(color: colors.$1, borderRadius: BorderRadius.circular(16)),
                            child: Icon(u.$1, color: colors.$2, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(u.$3, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                            const SizedBox(height: 4),
                            Text(u.$4, style: const TextStyle(fontSize: 13, color: AppColors.slate500, height: 1.4)),
                          ])),
                        ])
                      : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(color: colors.$1, borderRadius: BorderRadius.circular(18)),
                            child: Icon(u.$1, color: colors.$2, size: 32),
                          ),
                          const SizedBox(height: 20),
                          Text(u.$3, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.slate900, letterSpacing: -0.3)),
                          const SizedBox(height: 8),
                          Text(u.$4, style: const TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.6, fontWeight: FontWeight.w500)),
                        ]),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

// ─── 3. Trending Locations Section ───────────────────────────────────────────
class _TrendingLocationsSection extends StatelessWidget {
  static const _locations = [
    ('Kokapet',            'PREMIUM LUXURY HUB',   'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=400&q=80'),
    ('Kondapur',           'IT CORRIDOR PRIME',     'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=400&q=80'),
    ('Neopolis',           'FUTURE TECH CITY',      'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=400&q=80'),
    ('Financial District', 'CORPORATE EPICENTER',   'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=400&q=80'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: isMobile ? 40 : 64),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(text: 'Trending ', style: TextStyle(fontSize: isMobile ? 28 : 44, fontWeight: FontWeight.w900, color: AppColors.slate900, letterSpacing: -0.5)),
                          TextSpan(text: 'Locations', style: TextStyle(fontSize: isMobile ? 28 : 44, fontWeight: FontWeight.w900, color: AppColors.indigo600, letterSpacing: -0.5)),
                        ]),
                      ),
                      const SizedBox(height: 8),
                      const Text('Where the world is moving', style: TextStyle(fontSize: 16, color: AppColors.slate500, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('Explore Map', style: TextStyle(color: AppColors.indigo600, fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, color: AppColors.indigo600, size: 18),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _locations.length,
              itemBuilder: (ctx, i) {
                final loc = _locations[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        loc.$3,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                              colors: [Color(0xFF334155), Color(0xFF1E293B)]),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xE60F172A)],
                            stops: [0.4, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.$1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.3)),
                            const SizedBox(height: 4),
                            Text(loc.$2, style: const TextStyle(color: Color(0xFFA5B4FC), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

// ─── 4. Trending Projects Section ────────────────────────────────────────────
class _TrendingProjectsSection extends StatelessWidget {
  static const _projects = [
    ('The Prestige City',  'Luxury Integrated Township', 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=400&q=80'),
    ('My Home Bhooja',     'Premium High-Rise',          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=400&q=80'),
    ('Aparna Sarovar',     'Lakeview Residences',        'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=400&q=80'),
    ('Lodha Bellezza',     'Ultra Luxury Villas',        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=400&q=80'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Container(
        color: AppColors.slate50,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Trending Projects', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.slate900, letterSpacing: -0.3)),
                  const SizedBox(height: 6),
                  const Text('Most searched projects in Hyderabad', style: TextStyle(fontSize: 14, color: AppColors.slate500, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48),
                itemCount: _projects.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (ctx, i) {
                  final proj = _projects[i];
                  return SizedBox(
                    width: 260,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    proj.$3,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(color: AppColors.slate200),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Colors.transparent, Color(0xDD0F172A)],
                                        stops: [0.3, 1.0],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 14,
                                    left: 14,
                                    right: 14,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(proj.$1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15, letterSpacing: -0.2)),
                                        const SizedBox(height: 3),
                                        Text(proj.$2, style: const TextStyle(color: Color(0xFFA5B4FC), fontSize: 11, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─── 5. Trust Stats Section ───────────────────────────────────────────────────
class _TrustStatsSection extends StatelessWidget {
  static const _stats = [
    (Icons.home_rounded,         'Properties Listed',  '10,000+', 'blue'),
    (Icons.people_rounded,       'Happy Customers',    '5,000+',  'emerald'),
    (Icons.star_rounded,         'Average Rating',     '4.8/5',   'amber'),
    (Icons.verified_user_rounded,'Verified Partners',  '1,000+',  'indigo'),
  ];

  static const _iconColors = {
    'blue':    (Color(0xFFEFF6FF), Color(0xFF2563EB)),
    'emerald': (Color(0xFFECFDF5), Color(0xFF059669)),
    'amber':   (Color(0xFFFFFBEB), Color(0xFFD97706)),
    'indigo':  (Color(0xFFEEF2FF), Color(0xFF4F46E5)),
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: isMobile ? 40 : 64),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(text: 'Trusted by ', style: TextStyle(fontSize: isMobile ? 24 : 40, fontWeight: FontWeight.w900, color: AppColors.slate900, letterSpacing: -0.5)),
                TextSpan(text: '5,000+', style: TextStyle(fontSize: isMobile ? 24 : 40, fontWeight: FontWeight.w900, color: AppColors.indigo600, letterSpacing: -0.5)),
                TextSpan(text: ' Home Buyers', style: TextStyle(fontSize: isMobile ? 24 : 40, fontWeight: FontWeight.w900, color: AppColors.slate900, letterSpacing: -0.5)),
              ]),
            ),
            const SizedBox(height: 12),
            const Text(
              'We prioritize transparency and security in every transaction.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.slate500, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: _stats.length,
              itemBuilder: (ctx, i) {
                final s = _stats[i];
                final colors = _iconColors[s.$4]!;
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.slate100),
                    boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 24, offset: Offset(0, 8))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: colors.$1, borderRadius: BorderRadius.circular(16)),
                        child: Icon(s.$1, color: colors.$2, size: 28),
                      ),
                      const SizedBox(height: 16),
                      Text(s.$3, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.slate900, letterSpacing: -0.5)),
                      const SizedBox(height: 4),
                      Text(s.$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.slate500, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

// ─── 6. Testimonials Section ──────────────────────────────────────────────────
class _TestimonialsSection extends StatelessWidget {
  static const _testimonials = [
    ('Rahul Sharma',  'R', Color(0xFF4F46E5), 'Found my dream villa in Cybercity through Howzy. The verification process gave me complete peace of mind.'),
    ('Priya Kumar',   'P', Color(0xFF059669), 'The team helped me navigate all the legal paperwork. Zero brokerage saved me over ₹2 lakhs!'),
    ('Amit Verma',    'A', Color(0xFFD97706), 'As an NRI, investing remotely felt risky. Howzy\'s dedicated team made it seamless and transparent.'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Container(
        color: AppColors.slate900,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: isMobile ? 40 : 64),
        child: Column(
          children: [
            Column(
              children: [
                const Text('What Our Customers Say', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                const SizedBox(height: 8),
                const Text('Real stories from real buyers', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: AppColors.slate400, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 32),
            isMobile
                ? Column(
                    children: _testimonials.map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _TestimonialCard(t: t),
                    )).toList(),
                  )
                : SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _testimonials.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 20),
                      itemBuilder: (ctx, i) => SizedBox(width: 320, child: _TestimonialCard(t: _testimonials[i])),
                    ),
                  ),
          ],
        ),
      );
    });
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({required this.t});
  final (String, String, Color, String) t;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.slate800,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.slate700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            ...List.generate(5, (_) => const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 16)),
          ]),
          const SizedBox(height: 12),
          Text('"${t.$4}"', style: const TextStyle(color: AppColors.slate300, fontSize: 13, height: 1.6, fontStyle: FontStyle.italic)),
          const SizedBox(height: 16),
          Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: t.$3, shape: BoxShape.circle),
              child: Center(child: Text(t.$2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14))),
            ),
            const SizedBox(width: 10),
            Text(t.$1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ]),
        ],
      ),
    );
  }
}



// ─── Footer ───────────────────────────────────────────────────────────────────
class _HomeFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Container(
        color: AppColors.slate900,
        padding: EdgeInsets.all(isMobile ? 24 : 48),
        child: Column(
          children: [
            isMobile
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: _footerCols(context))
                : Row(crossAxisAlignment: CrossAxisAlignment.start, children: _footerCols(context).map((w) => Expanded(child: w)).toList()),
            const SizedBox(height: 32),
            const Divider(color: AppColors.slate800),
            const SizedBox(height: 16),
            const Text('© 2025 Howzy. All rights reserved. | Privacy Policy | Terms of Service',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.slate600, fontSize: 11),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _footerCols(BuildContext context) => [
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const HowzyLogoWidget(dark: true),
      const SizedBox(height: 12),
      const Text('Connecting you with verified\nproperties across India.', style: TextStyle(color: AppColors.slate500, fontSize: 12, height: 1.6)),
      const SizedBox(height: 24),
    ]),
    ...[
      ('Company', ['About Us', 'Careers', 'Blog', 'Press']),
      ('Properties', ['New Projects', 'Villas', 'Plots', 'Farm Lands']),
      ('Services', ['Legal Verification', 'Loan Assistance', 'NRI Desk', 'Property Mgmt']),
    ].map((col) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(col.$1, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...col.$2.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(item, style: const TextStyle(color: AppColors.slate500, fontSize: 12)),
        )),
        const SizedBox(height: 24),
      ],
    )),
  ];
}

// ─── Glowing animated blob ─────────────────────────────────────────────────────
class _GlowBlob extends StatefulWidget {
  const _GlowBlob({required this.color, required this.size, this.delay = 0});
  final Color color;
  final double size;
  final int delay;

  @override
  State<_GlowBlob> createState() => _GlowBlobState();
}

class _GlowBlobState extends State<_GlowBlob> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 5000));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted) _ctrl.repeat(reverse: true); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        final t = Curves.easeInOut.transform(_ctrl.value);
        return Transform.scale(
          scale: 1.0 + 0.1 * t,
          child: Container(
            width: widget.size, height: widget.size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withValues(alpha: 0.12 + 0.06 * t)),
          ),
        );
      },
    );
  }
}

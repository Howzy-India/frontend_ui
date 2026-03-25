import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/howzy_logo.dart';
import '../../data/property_data_standalone.dart';
import '../projects/widgets/property_card.dart';

// ─── Home Screen ─────────────────────────────────────────────────────────────
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
        SliverToBoxAdapter(child: _HeroSection(scrollOffset: _scrollOffset)),
        SliverToBoxAdapter(child: _MarketProblemsSection()),
        SliverToBoxAdapter(child: _SolutionsSection()),
        SliverToBoxAdapter(child: _ProjectsPreviewSection()),
        SliverToBoxAdapter(child: _WhyUsSection()),
        SliverToBoxAdapter(child: _ServicesPreviewSection()),
        SliverToBoxAdapter(child: _NriSection()),
        SliverToBoxAdapter(child: _HomeFooter()),
      ],
    );
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

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      final heroH = isMobile ? 480.0 : 580.0;
      // Parallax: background scrolls at 40% speed of foreground
      final parallaxOffset = widget.scrollOffset * 0.4;

      return SizedBox(
        height: heroH,
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Parallax background image
              Transform.translate(
                offset: Offset(0, -parallaxOffset),
                child: Image.network(
                  'https://images.unsplash.com/photo-1486325212027-8081e485255e?w=1200&q=80',
                  fit: BoxFit.cover,
                  height: heroH + 80,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [Color(0xFF1E3A5F), Color(0xFF0F1928)]),
                    ),
                  ),
                ),
              ),
              // Dark gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xCC0F172A), Color(0x991E1B4B)],
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
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: const Text('INDIA\'S TRUSTED REAL ESTATE PLATFORM', style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
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
                              TextSpan(text: 'Invest ', style: TextStyle(color: Colors.white, fontSize: isMobile ? 36 : 60, fontWeight: FontWeight.w900, height: 1.05, letterSpacing: -1.5)),
                              TextSpan(text: 'Smarter', style: TextStyle(color: const Color(0xFF818CF8), fontSize: isMobile ? 36 : 60, fontWeight: FontWeight.w900, height: 1.05, letterSpacing: -1.5)),
                              TextSpan(text: '\nin Real Estate', style: TextStyle(color: Colors.white, fontSize: isMobile ? 36 : 60, fontWeight: FontWeight.w900, height: 1.05, letterSpacing: -1.5)),
                            ]),
                          ),
                        ),
                        SizedBox(height: isMobile ? 12 : 16),
                        // Subtitle
                        AnimatedBuilder(
                          animation: _subAnim,
                          builder: (_, child) => Opacity(opacity: _subAnim.value, child: Transform.translate(offset: Offset(0, 30 * (1 - _subAnim.value)), child: child)),
                          child: Text(
                            'Verified listings. Zero brokerage. Direct connections with trusted developers.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: const Color(0xFFCBD5E1), fontSize: isMobile ? 14 : 19, height: 1.6, fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(height: isMobile ? 24 : 32),
                        // CTAs
                        AnimatedBuilder(
                          animation: _ctaAnim,
                          builder: (_, child) => Opacity(opacity: _ctaAnim.value, child: Transform.translate(offset: Offset(0, 30 * (1 - _ctaAnim.value)), child: child)),
                          child: isMobile
                              ? Column(children: _ctaButtons(context, isMobile))
                              : Row(mainAxisSize: MainAxisSize.min, children: _ctaButtons(context, isMobile)),
                        ),
                        SizedBox(height: isMobile ? 24 : 32),
                        // Stats strip
                        AnimatedBuilder(
                          animation: _ctaAnim,
                          builder: (_, child) => Opacity(opacity: _ctaAnim.value, child: child),
                          child: _StatsStrip(isMobile: isMobile),
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
    });
  }

  List<Widget> _ctaButtons(BuildContext context, bool isMobile) => [
    GestureDetector(
      onTap: () => context.go(AppRoutes.projects),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 28, vertical: 14),
        decoration: BoxDecoration(color: AppColors.indigo600, borderRadius: BorderRadius.circular(12)),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Text('Explore Properties', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
        ]),
      ),
    ),
    SizedBox(width: isMobile ? 0 : 12, height: isMobile ? 12 : 0),
    GestureDetector(
      onTap: () => context.go(AppRoutes.services),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 28, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.handshake_outlined, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text('Our Services', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        ]),
      ),
    ),
  ];
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.isMobile});
  final bool isMobile;

  static const _stats = [
    ('500+', 'Verified Properties'),
    ('50+', 'Trusted Developers'),
    ('₹0', 'Brokerage'),
    ('4.8★', 'Customer Rating'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 28, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _stats.map((s) => Column(
          children: [
            Text(s.$1, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(s.$2, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        )).toList(),
      ),
    );
  }
}

// ─── 2. Market Problems Section ───────────────────────────────────────────────
class _MarketProblemsSection extends StatelessWidget {
  static const _problems = [
    (Icons.warning_amber_rounded, 'Fake Listings', 'Thousands of fake properties waste your time and money.', Color(0xFFEF4444), Color(0xFFFEE2E2)),
    (Icons.gavel_rounded, 'Legal Risks', 'Unclear titles and disputes ruin investments.', Color(0xFFF97316), Color(0xFFFEF3C7)),
    (Icons.money_off_rounded, 'Hidden Charges', 'Surprise fees can cost you lakhs beyond the listed price.', Color(0xFF8B5CF6), Color(0xFFEDE9FE)),
    (Icons.person_off_rounded, 'No Transparency', 'Developers hide project status and delays.', Color(0xFF0EA5E9), Color(0xFFE0F2FE)),
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
            _SectionHeader(
              eyebrow: 'THE PROBLEM',
              title: 'Real Estate is Broken',
              subtitle: 'The traditional property market is plagued with issues that cost buyers dearly.',
              light: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _problems.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (ctx, i) {
                  final p = _problems[i];
                  return SizedBox(
                    width: 260,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.slate800,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.slate700),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: p.$5, borderRadius: BorderRadius.circular(12)),
                            child: Icon(p.$1, color: p.$4, size: 24),
                          ),
                          const SizedBox(height: 14),
                          Text(p.$2, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Text(p.$3, style: const TextStyle(color: AppColors.slate400, fontSize: 13, height: 1.5)),
                        ],
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

// ─── 3. Solutions Section ─────────────────────────────────────────────────────
class _SolutionsSection extends StatelessWidget {
  static const _solutions = [
    (Icons.verified_rounded,       'Verified Properties',  'Every listing personally verified by our team before it goes live.',           AppColors.indigo600,  AppColors.indigoLight),
    (Icons.gavel_rounded,          'Legal Verification',   'Full title check, encumbrance certificate, and RERA validation.',              AppColors.emerald500, AppColors.emerald100),
    (Icons.account_balance_rounded,'Loan Assistance',      'Get pre-approved loans from 15+ partner banks at the best rates.',            AppColors.amber500,   AppColors.amber100),
    (Icons.flight_rounded,         'NRI Investments',      'Dedicated NRI desk for seamless remote property investments.',                 Color(0xFF8B5CF6),    Color(0xFFEDE9FE)),
    (Icons.support_agent_rounded,  'Expert Guidance',      '1-on-1 support from certified real estate consultants.',                      AppColors.blue500,    AppColors.blue100),
    (Icons.savings_rounded,        'Zero Brokerage',       'No hidden commissions. What you see is what you pay.',                        Color(0xFF10B981),    AppColors.green100),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final isMobile = w.isMobile;
      final cols = isMobile ? 1 : (w.isTablet ? 2 : 3);
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: isMobile ? 40 : 64),
        child: Column(
          children: [
            _SectionHeader(
              eyebrow: 'OUR SOLUTION',
              title: 'Why Howzy is Different',
              subtitle: 'We built the platform we wished existed — transparent, verified, and effortless.',
            ),
            const SizedBox(height: 40),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isMobile ? 3.5 : 1.6,
              ),
              itemCount: _solutions.length,
              itemBuilder: (ctx, i) {
                final s = _solutions[i];
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.slate100),
                    boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 16, offset: Offset(0, 4))],
                  ),
                  child: isMobile
                      ? Row(children: [
                          Container(width: 44, height: 44, decoration: BoxDecoration(color: s.$5, borderRadius: BorderRadius.circular(12)), child: Icon(s.$1, color: s.$4, size: 22)),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(s.$2, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                            const SizedBox(height: 4),
                            Text(s.$3, style: const TextStyle(fontSize: 12, color: AppColors.slate500, height: 1.4)),
                          ])),
                        ])
                      : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(width: 48, height: 48, decoration: BoxDecoration(color: s.$5, borderRadius: BorderRadius.circular(12)), child: Icon(s.$1, color: s.$4, size: 24)),
                          const SizedBox(height: 14),
                          Text(s.$2, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                          const SizedBox(height: 6),
                          Text(s.$3, style: const TextStyle(fontSize: 13, color: AppColors.slate500, height: 1.5)),
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

// ─── 4. Projects Preview Section ─────────────────────────────────────────────
class _ProjectsPreviewSection extends ConsumerWidget {
  static const _categories = ['All', 'Villas', 'Plots', 'Farm Lands', 'Projects', 'Commercial'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.slate100,
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _SectionHeader(
              eyebrow: 'FEATURED LISTINGS',
              title: 'Handpicked Properties',
              subtitle: 'Explore our curated selection of premium verified real estate.',
              action: TextButton(
                onPressed: () => context.go(AppRoutes.projects),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('View All', style: TextStyle(color: AppColors.indigo600, fontWeight: FontWeight.w700)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 14, color: AppColors.indigo600),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Category pills
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final isActive = i == 0;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.indigo600 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isActive ? AppColors.indigo600 : AppColors.slate200),
                  ),
                  child: Text(_categories[i], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isActive ? Colors.white : AppColors.slate600)),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Property cards horizontal slider
          SizedBox(
            height: 320,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: mockProperties.take(6).length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (ctx, i) {
                final p = mockProperties[i];
                return SizedBox(
                  width: 260,
                  child: PropertyCard(property: p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 5. Why Buy With Us ───────────────────────────────────────────────────────
class _WhyUsSection extends StatelessWidget {
  static const _stats = [
    (Icons.verified_user_rounded, '500+', 'Verified Listings', AppColors.indigo600),
    (Icons.business_rounded,      '50+',  'Top Developers',    AppColors.emerald500),
    (Icons.people_rounded,        '10K+', 'Happy Buyers',      AppColors.amber500),
    (Icons.star_rounded,          '4.8',  'Average Rating',    Color(0xFF8B5CF6)),
    (Icons.account_balance_rounded,'15+', 'Partner Banks',     AppColors.blue500),
    (Icons.location_city_rounded,  '6+',  'Cities Covered',    Color(0xFFEC4899)),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      final cols = isMobile ? 2 : 3;
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF312E81), Color(0xFF1E1B4B)]),
        ),
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: isMobile ? 40 : 64),
        child: Column(
          children: [
            _SectionHeader(
              eyebrow: 'BY THE NUMBERS',
              title: 'Why 10,000+ Buyers\nTrust Howzy',
              light: true,
            ),
            const SizedBox(height: 40),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.4,
              ),
              itemCount: _stats.length,
              itemBuilder: (ctx, i) {
                final s = _stats[i];
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 44, height: 44, decoration: BoxDecoration(color: s.$4.withValues(alpha: 0.2), shape: BoxShape.circle), child: Icon(s.$1, color: s.$4, size: 22)),
                      const SizedBox(height: 10),
                      Text(s.$2, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text(s.$3, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.slate400, fontSize: 11, fontWeight: FontWeight.w500)),
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

// ─── 6. Services Preview ──────────────────────────────────────────────────────
class _ServicesPreviewSection extends StatelessWidget {
  static const _services = [
    (Icons.gavel_rounded,           'Legal Verification',   'Complete title check, legal due diligence, and RERA validation by certified lawyers.',   AppColors.emerald500, AppColors.emerald100),
    (Icons.account_balance_rounded, 'Loan Assistance',      'Compare rates from 15+ banks and NBFCs. Get pre-approved with instant eligibility check.', AppColors.blue500,    AppColors.blue100),
    (Icons.home_work_rounded,       'Property Management',  'End-to-end property management for NRIs and landlords.',                                   AppColors.amber500,   AppColors.amber100),
    (Icons.flight_rounded,          'NRI Services',         'Dedicated NRI investment desk, POA assistance, and virtual site tours.',                   Color(0xFF8B5CF6),    Color(0xFFEDE9FE)),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      final cols = isMobile ? 1 : 2;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48, vertical: isMobile ? 40 : 64),
        child: Column(
          children: [
            _SectionHeader(
              eyebrow: 'OUR SERVICES',
              title: 'Everything You Need,\nUnder One Roof',
              subtitle: 'From property search to loan closure, we handle it all.',
              action: TextButton(
                onPressed: () => context.go(AppRoutes.services),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('See All Services', style: TextStyle(color: AppColors.indigo600, fontWeight: FontWeight.w700)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 14, color: AppColors.indigo600),
                ]),
              ),
            ),
            const SizedBox(height: 40),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: isMobile ? 2.8 : 2.2,
              ),
              itemCount: _services.length,
              itemBuilder: (ctx, i) {
                final s = _services[i];
                return Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.slate100),
                    boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 16, offset: Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Container(width: 52, height: 52, decoration: BoxDecoration(color: s.$5, borderRadius: BorderRadius.circular(14)), child: Icon(s.$1, color: s.$4, size: 26)),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s.$2, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                        const SizedBox(height: 5),
                        Text(s.$3, style: const TextStyle(fontSize: 12, color: AppColors.slate500, height: 1.4)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.services),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('Learn More', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: s.$4)),
                            const SizedBox(width: 3),
                            Icon(Icons.arrow_forward, size: 12, color: s.$4),
                          ]),
                        ),
                      ])),
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

// ─── 7. NRI Section ──────────────────────────────────────────────────────────
class _NriSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Container(
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48, vertical: 8),
        padding: EdgeInsets.all(isMobile ? 24 : 40),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: AppColors.indigo600.withValues(alpha: 0.4), blurRadius: 40, offset: const Offset(0, 12))],
        ),
        child: isMobile
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: _nriContent(context, isMobile))
            : Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _nriContent(context, isMobile))),
                const SizedBox(width: 32),
                _NriStats(),
              ]),
      );
    });
  }

  List<Widget> _nriContent(BuildContext context, bool isMobile) => [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: const Text('NRI INVESTMENT DESK', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
    ),
    const SizedBox(height: 16),
    const Text('Invest in India\nFrom Anywhere', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1)),
    const SizedBox(height: 12),
    const Text('We handle all the paperwork, legal checks, and site visits on your behalf. Dedicated NRI relationship manager for every client.', style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.6)),
    const SizedBox(height: 24),
    Wrap(
      spacing: 10, runSpacing: 10,
      children: ['Virtual Tours', 'POA Assistance', 'FEMA Compliance', 'Repatriation Help']
          .map((f) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
        child: Text(f, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      )).toList(),
    ),
    const SizedBox(height: 24),
    GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: const Text('Talk to NRI Advisor', style: TextStyle(color: AppColors.indigo600, fontSize: 14, fontWeight: FontWeight.w800)),
      ),
    ),
  ];
}

class _NriStats extends StatelessWidget {
  static const _stats = [
    ('₹500Cr+', 'NRI Transactions'),
    ('2,000+', 'NRI Clients'),
    ('15+', 'Countries Served'),
    ('48hr', 'Response Time'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: List.generate(_stats.length, (i) => Padding(
          padding: EdgeInsets.only(bottom: i < _stats.length - 1 ? 20 : 0),
          child: Column(children: [
            Text(_stats[i].$1, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(_stats[i].$2, style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w500)),
          ]),
        )),
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

// ─── Shared Section Header ────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.eyebrow, this.subtitle, this.light = false, this.action});
  final String title;
  final String? eyebrow, subtitle;
  final bool light;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!,
            style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2,
              color: light ? AppColors.indigo400 : AppColors.indigo600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w900, color: light ? Colors.white : AppColors.slate900,
                  height: 1.15, letterSpacing: -0.5,
                ),
              ),
            ),
            if (action != null) action!,
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: TextStyle(fontSize: 15, color: light ? AppColors.slate400 : AppColors.slate500, height: 1.5)),
        ],
      ],
    );
  }
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
      builder: (_, __) {
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

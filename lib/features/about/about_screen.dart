import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _AboutHero()),
        SliverToBoxAdapter(child: _IntroSection()),
        SliverToBoxAdapter(child: _MarketProblemsSection()),
        SliverToBoxAdapter(child: _OurSolutionSection()),
        SliverToBoxAdapter(child: _NRISection()),
        SliverToBoxAdapter(child: _StatsSection()),
        SliverToBoxAdapter(child: _BecomePartnerSection()),
        SliverToBoxAdapter(child: _CareersSection()),
      ],
    );
  }
}

class _AboutHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.indigo600, Color(0xFF4C1D95)]),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
            child: const Text('ABOUT HOWZY', style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
          ),
          const SizedBox(height: 18),
          const Text('Transforming Indian Real Estate', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, height: 1.1)),
          const SizedBox(height: 14),
          const Text('We exist to make property buying transparent, legal, and simple for every Indian, wherever they live.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.7)),
        ],
      ),
    );
  }
}

class _IntroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Padding(
        padding: EdgeInsets.all(isMobile ? 20 : 56),
        child: isMobile
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_IntroText(), const SizedBox(height: 24), _IntroImage()])
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: _IntroText()),
                const SizedBox(width: 40),
                Expanded(child: _IntroImage()),
              ]),
      );
    });
  }
}

class _IntroText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Who We Are', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.slate900)),
        const SizedBox(height: 14),
        const Text('Howzy was founded in 2023 with a singular mission: to fix a broken real estate market. India has one of the most complex property ecosystems in the world — hundreds of micro-markets, opaque pricing, rampant litigation, and an overwhelming lack of verified data.', style: TextStyle(fontSize: 14, color: AppColors.slate600, height: 1.8)),
        const SizedBox(height: 12),
        const Text('We built Howzy to be the trust layer that every property seeker deserves — a platform where every listing is verified, every transaction is supported end-to-end, and every buyer walks away confident.', style: TextStyle(fontSize: 14, color: AppColors.slate600, height: 1.8)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _Pill(label: '🏙️ 15+ Cities'),
            _Pill(label: '✅ Verified Listings'),
            _Pill(label: '⚖️ Legal Experts'),
            _Pill(label: '💼 NRI Friendly'),
          ],
        ),
      ],
    );
  }
}

class _IntroImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 280,
        color: AppColors.indigoLight,
        child: const Center(child: Icon(Icons.apartment_rounded, size: 80, color: AppColors.indigo600)),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(color: AppColors.indigoLight, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.indigo600.withValues(alpha: 0.2))),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.indigo600)),
    );
  }
}

class _MarketProblemsSection extends StatelessWidget {
  static const _problems = [
    (Icons.warning_rounded,           'Fake Listings',      'Millions of unverified listings flood portals, leading buyers down costly dead ends.',               Color(0xFFEF4444), Color(0xFFFEF2F2)),
    (Icons.gavel_rounded,             'Legal Pitfalls',     'Property disputes, unclear titles, and encumbrances cause buyers to lose their life savings.',        Color(0xFFF59E0B), Color(0xFFFFFBEB)),
    (Icons.money_off_rounded,         'Hidden Charges',     'Undisclosed amenity fees, maintenance deposits, and stamp duty surprises inflate final costs.',        Color(0xFF8B5CF6), Color(0xFFF5F3FF)),
    (Icons.visibility_off_rounded,    'Opaque Pricing',     'Market rates vary wildly. Without data, buyers overpay or miss out on better deals nearby.',          Color(0xFF3B82F6), Color(0xFFEFF6FF)),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Container(
        color: AppColors.slate50,
        padding: EdgeInsets.all(isMobile ? 20 : 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('The Problem', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.slate900)),
            const SizedBox(height: 6),
            const Text('Why real estate in India needs fixing', style: TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.5)),
            const SizedBox(height: 28),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: isMobile ? 3 : 2.5,
              ),
              itemCount: _problems.length,
              itemBuilder: (ctx, i) {
                final p = _problems[i];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.slate100)),
                  child: Row(children: [
                    Container(width: 50, height: 50, decoration: BoxDecoration(color: p.$5, borderRadius: BorderRadius.circular(14)), child: Icon(p.$1, color: p.$4, size: 26)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.$2, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                      const SizedBox(height: 4),
                      Text(p.$3, style: const TextStyle(fontSize: 12, color: AppColors.slate500, height: 1.4)),
                    ])),
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

class _OurSolutionSection extends StatelessWidget {
  static const _solutions = [
    (Icons.verified_rounded,           'Verified Listings',       'Every property on Howzy is physically verified and legally vetted.'),
    (Icons.balance_rounded,            'Legal Due Diligence',     'Our in-house legal team checks title, RERA status, and encumbrances.'),
    (Icons.price_check_rounded,        'Transparent Pricing',     'We show market benchmarks alongside listing prices — no surprises.'),
    (Icons.support_agent_rounded,      'Dedicated Advisor',       'Every buyer gets a dedicated relationship manager from search to registration.'),
    (Icons.account_balance_rounded,    'Loan Facilitation',       'Pre-approved loans from 15+ banks with the best rates in the market.'),
    (Icons.home_work_rounded,          'Post-Sale Support',       'Interior design, property management, and maintenance — all under one roof.'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Padding(
        padding: EdgeInsets.all(isMobile ? 20 : 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Our Solution', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.slate900)),
            const SizedBox(height: 6),
            const Text('How Howzy makes property buying right', style: TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.5)),
            const SizedBox(height: 28),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 3,
                crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: isMobile ? 4 : 2.2,
              ),
              itemCount: _solutions.length,
              itemBuilder: (ctx, i) {
                final s = _solutions[i];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.slate100),
                    boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 12, offset: Offset(0, 3))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.indigoLight, borderRadius: BorderRadius.circular(12)), child: Icon(s.$1, color: AppColors.indigo600, size: 22)),
                    const SizedBox(height: 10),
                    Text(s.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                    const SizedBox(height: 4),
                    Text(s.$3, style: const TextStyle(fontSize: 12, color: AppColors.slate500, height: 1.4)),
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

class _NRISection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Text('🌍 ', style: TextStyle(fontSize: 22)),
            Text('For NRIs', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 8),
          const Text('Invest in India from anywhere in the world. Our NRI desk handles everything — FEMA compliance, virtual tours, POA, and repatriation.', style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.7)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _DarkPill('Virtual Tours'),
              _DarkPill('POA Assistance'),
              _DarkPill('FEMA Compliance'),
              _DarkPill('Repatriation'),
              _DarkPill('NRI Loans'),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFA5B4FC), foregroundColor: const Color(0xFF1E1B4B), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            child: const Text('Contact NRI Desk', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _DarkPill extends StatelessWidget {
  const _DarkPill(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _StatsSection extends StatelessWidget {
  static const _stats = [
    ('₹2,400 Cr+',  'Property Value Listed'),
    ('10,000+',     'Happy Families'),
    ('500+',        'Verified Projects'),
    ('15+',         'Cities Covered'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Container(
        color: AppColors.indigoLight,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 56, vertical: 40),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: isMobile ? 2 : 2.4,
          ),
          itemCount: _stats.length,
          itemBuilder: (ctx, i) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(_stats[i].$1, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.indigo600)),
            const SizedBox(height: 4),
            Text(_stats[i].$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slate700)),
          ]),
        ),
      );
    });
  }
}

class _BecomePartnerSection extends StatelessWidget {
  static const _partners = [
    (Icons.business_center_rounded, 'Builders & Developers',  'List your projects and reach verified, serious buyers.'),
    (Icons.person_pin_circle_rounded,'Real Estate Agents',    'Earn commissions and access exclusive listings in your area.'),
    (Icons.account_balance_rounded,  'Banks & NBFCs',         'Offer competitive loans to Howzy\'s verified buyer community.'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Padding(
        padding: EdgeInsets.all(isMobile ? 20 : 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Become a Partner', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.slate900)),
            const SizedBox(height: 6),
            const Text('Grow your business with Howzy\'s trusted ecosystem', style: TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.5)),
            const SizedBox(height: 28),
            Column(
              children: _partners.map((p) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.slate100), boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 3))]),
                child: Row(children: [
                  Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.indigoLight, borderRadius: BorderRadius.circular(14)), child: Icon(p.$1, color: AppColors.indigo600, size: 26)),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.$2, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                    const SizedBox(height: 4),
                    Text(p.$3, style: const TextStyle(fontSize: 13, color: AppColors.slate500, height: 1.4)),
                  ])),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(backgroundColor: AppColors.indigo600, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: const Text('Join', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ]),
              )).toList(),
            ),
          ],
        ),
      );
    });
  }
}

class _CareersSection extends StatelessWidget {
  static const _roles = [
    ('Senior Flutter Developer',  'Hyderabad / Remote',    'Full-time'),
    ('Product Manager',           'Hyderabad',             'Full-time'),
    ('Legal Research Analyst',    'Hyderabad',             'Full-time'),
    ('Growth Marketing Manager',  'Hyderabad / Remote',    'Full-time'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Container(
        color: AppColors.slate50,
        padding: EdgeInsets.all(isMobile ? 20 : 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Careers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.slate900)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20)),
                  child: const Text('4 Open Roles', style: TextStyle(color: Color(0xFF15803D), fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Join us in building the future of Indian real estate', style: TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.5)),
            const SizedBox(height: 24),
            Column(
              children: _roles.map((r) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.slate200)),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.$1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                    const SizedBox(height: 3),
                    Row(children: [
                      Icon(Icons.location_on_rounded, size: 12, color: AppColors.slate400),
                      const SizedBox(width: 3),
                      Text(r.$2, style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.indigoLight, borderRadius: BorderRadius.circular(10)),
                        child: Text(r.$3, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.indigo600)),
                      ),
                    ]),
                  ])),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.indigo600, side: const BorderSide(color: AppColors.indigo600), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: const Text('Apply', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ]),
              )).toList(),
            ),
          ],
        ),
      );
    });
  }
}

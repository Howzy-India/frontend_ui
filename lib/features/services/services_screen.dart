import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _ServicesHero()),
        SliverToBoxAdapter(child: _LegalVerificationSection()),
        SliverToBoxAdapter(child: _LoanServicesSection()),
        SliverToBoxAdapter(child: _OtherServicesSection()),
        SliverToBoxAdapter(child: _ServicesCTA()),
      ],
    );
  }
}

// ─── Hero ────────────────────────────────────────────────────────────────────
class _ServicesHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1E3A5F), Color(0xFF312E81)]),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
            child: const Text('END-TO-END SERVICES', style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
          ),
          const SizedBox(height: 16),
          const Text('Everything You Need\nfor Your Property Journey', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1)),
          const SizedBox(height: 12),
          const Text('From legal verification to loan approval and beyond — Howzy handles it all.', style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.6)),
        ],
      ),
    );
  }
}

// ─── Legal Verification ───────────────────────────────────────────────────────
class _LegalVerificationSection extends StatelessWidget {
  static const _steps = [
    (Icons.search_rounded,        '1. Title Search',          'We pull all historical ownership records and verify the chain of title.'),
    (Icons.description_rounded,   '2. Document Verification', 'All property documents — sale deed, EC, CC — verified by our legal team.'),
    (Icons.verified_rounded,      '3. RERA Check',            'Confirm RERA registration status and check for any complaints filed.'),
    (Icons.handshake_rounded,     '4. Clear Report',          'Receive a comprehensive legal report within 72 hours.'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Padding(
        padding: EdgeInsets.all(isMobile ? 20 : 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(width: 4, height: 28, color: AppColors.emerald500),
              const SizedBox(width: 12),
              const Text('Legal Verification', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.slate900)),
            ]),
            const SizedBox(height: 8),
            const Text('Property title disputes can cost you everything. Our legal team conducts a thorough due diligence so you buy with complete confidence.', style: TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.6)),
            const SizedBox(height: 28),
            isMobile
                ? Column(children: _steps.map((s) => _LegalStepCard(step: s)).toList())
                : GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.5,
                    children: _steps.map((s) => _LegalStepCard(step: s)).toList(),
                  ),
            const SizedBox(height: 28),
            _PricingCard(
              icon: Icons.gavel_rounded,
              title: 'Legal Verification Package',
              features: const ['Title Search', 'Document Check', 'RERA Verification', 'Encumbrance Certificate', 'Legal Opinion Letter'],
              price: '₹4,999',
              color: AppColors.emerald500,
            ),
          ],
        ),
      );
    });
  }
}

class _LegalStepCard extends StatelessWidget {
  const _LegalStepCard({required this.step});
  final (IconData, String, String) step;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.slate100),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.emerald100, borderRadius: BorderRadius.circular(12)), child: Icon(step.$1, color: AppColors.emerald500, size: 22)),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(step.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.slate900)),
              const SizedBox(height: 3),
              Text(step.$3, style: const TextStyle(fontSize: 12, color: AppColors.slate500, height: 1.4)),
            ],
          )),
        ],
      ),
    );
  }
}

// ─── Loan Services ────────────────────────────────────────────────────────────
class _LoanServicesSection extends StatelessWidget {
  static const _banks = [
    ('SBI', 'from 8.50% p.a.'),
    ('HDFC', 'from 8.70% p.a.'),
    ('ICICI', 'from 8.75% p.a.'),
    ('Axis Bank', 'from 8.85% p.a.'),
    ('LIC HFL', 'from 8.65% p.a.'),
    ('Bajaj Finance', 'from 9.00% p.a.'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Container(
        color: AppColors.slate50,
        padding: EdgeInsets.all(isMobile ? 20 : 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(width: 4, height: 28, color: AppColors.blue500),
              const SizedBox(width: 12),
              const Text('Loan Assistance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.slate900)),
            ]),
            const SizedBox(height: 8),
            const Text('Compare home loan offers from 15+ banks and NBFCs. Get pre-approved in 48 hours.', style: TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.6)),
            const SizedBox(height: 28),
            // Partner banks grid
            const Text('PARTNER BANKS & NBFCS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppColors.slate400)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isMobile ? 2.2 : 2.8,
              ),
              itemCount: _banks.length,
              itemBuilder: (ctx, i) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.slate200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_banks[i].$1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                    const SizedBox(height: 3),
                    Text(_banks[i].$2, style: const TextStyle(fontSize: 12, color: AppColors.emerald500, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            // EMI Calculator teaser
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.blue100, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('EMI Calculator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                      const SizedBox(height: 4),
                      const Text('Calculate your monthly EMI and total interest payable instantly.', style: TextStyle(fontSize: 13, color: AppColors.slate600, height: 1.4)),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(backgroundColor: AppColors.blue500, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: const Text('Calculate Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  )),
                  const SizedBox(width: 16),
                  const Icon(Icons.calculate_rounded, size: 56, color: AppColors.blue500),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _PricingCard(
              icon: Icons.account_balance_rounded,
              title: 'Loan Assistance Package',
              features: const ['Eligibility Check', 'Bank Comparison', 'Document Prep', 'Application Tracking', 'Disbursement Support'],
              price: 'Free',
              color: AppColors.blue500,
            ),
          ],
        ),
      );
    });
  }
}

// ─── Other Services ───────────────────────────────────────────────────────────
class _OtherServicesSection extends StatelessWidget {
  static const _services = [
    (Icons.home_work_rounded,   'Property Management',  'Rent collection, maintenance, and tenant management for landlords and NRIs.',   AppColors.amber500, AppColors.amber100),
    (Icons.flight_rounded,      'NRI Investment Desk',  'Virtual tours, POA, FEMA compliance, and repatriation for overseas buyers.',     Color(0xFF8B5CF6), Color(0xFFEDE9FE)),
    (Icons.key_rounded,         'Resale & Rentals',     'List your property for resale or rent with professional photography and listing.', Color(0xFFEC4899), Color(0xFFFCE7F3)),
    (Icons.architecture_rounded,'Interior Design',      'Connect with vetted interior designers who understand your vision and budget.',  Color(0xFF10B981), AppColors.emerald100),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth.isMobile;
      return Padding(
        padding: EdgeInsets.all(isMobile ? 20 : 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MORE SERVICES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppColors.slate400)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: isMobile ? 3 : 2.8,
              ),
              itemCount: _services.length,
              itemBuilder: (ctx, i) {
                final s = _services[i];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.slate100), boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 12, offset: Offset(0, 3))]),
                  child: Row(children: [
                    Container(width: 52, height: 52, decoration: BoxDecoration(color: s.$5, borderRadius: BorderRadius.circular(14)), child: Icon(s.$1, color: s.$4, size: 26)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.$2, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.slate900)),
                      const SizedBox(height: 5),
                      Text(s.$3, style: const TextStyle(fontSize: 12, color: AppColors.slate500, height: 1.4)),
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

class _PricingCard extends StatelessWidget {
  const _PricingCard({required this.icon, required this.title, required this.features, required this.price, required this.color});
  final IconData icon;
  final String title, price;
  final List<String> features;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 16, offset: Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.slate900)),
              ]),
              const SizedBox(height: 10),
              ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(children: [
                  Icon(Icons.check_circle_rounded, size: 14, color: color),
                  const SizedBox(width: 6),
                  Text(f, style: const TextStyle(fontSize: 13, color: AppColors.slate600)),
                ]),
              )),
            ],
          )),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('Get Started', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServicesCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.indigo600, Color(0xFF7C3AED)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text('Not sure where to start?', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Talk to a Howzy advisor — free of charge.', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.support_agent_rounded, size: 18),
            label: const Text('Talk to an Advisor', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.indigo600, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)),
          ),
        ],
      ),
    );
  }
}

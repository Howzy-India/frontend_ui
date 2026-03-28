part of '../main.dart';

class PilotDashboard extends StatefulWidget {
  const PilotDashboard({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<PilotDashboard> createState() => _PilotDashboardState();
}

class _PilotDashboardState extends State<PilotDashboard> {
  final BuilderService _builderService = BuilderService();
  int _tab = 0;
  final List<String> _tabs = const [
    'Listed Projects',
    'Listed Plots',
    'Listed Farm Lands',
    'Upcoming Projects',
    'Leads',
    'Site Visited Clients',
    'Booked Clients',
    'Earnings',
    'Calendar',
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Partner Dashboard',
      tabs: _tabs,
      currentTab: _tab,
      onSelectTab: (value) => setState(() => _tab = value),
      onLogout: widget.onLogout,
      body: switch (_tab) {
        0 => ApprovedProjectsView(builderService: _builderService),
        1 => EntityListView(items: listedPlots.map((e) => e.name).toList()),
        2 => EntityListView(items: listedFarmLands.map((e) => e.name).toList()),
        3 => EntityListView(
          items: upcomingProjects.map((e) => e.teaser).toList(),
        ),
        4 => LeadsView(leads: leads),
        5 => LeadsView(
          leads: leads
              .where((lead) => lead.milestone.toLowerCase().contains('site'))
              .toList(),
        ),
        6 => LeadsView(
          leads: leads
              .where((lead) => lead.milestone.toLowerCase().contains('booking'))
              .toList(),
        ),
        7 => EarningsView(data: earnings),
        _ => const Center(
          child: Text(
            'Calendar integration is available in web dashboard flow.',
          ),
        ),
      },
    );
  }
}

class PartnerDashboard extends StatefulWidget {
  const PartnerDashboard({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<PartnerDashboard> createState() => _PartnerDashboardState();
}

class _PartnerDashboardState extends State<PartnerDashboard> {
  final BuilderService _builderService = BuilderService();
  int _tab = 0;

  final List<String> _tabs = const [
    'Overview',
    'Builder Onboarding',
    'My Builders',
    'Listed Projects',
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Admin Dashboard',
      tabs: _tabs,
      currentTab: _tab,
      onSelectTab: (value) => setState(() => _tab = value),
      onLogout: widget.onLogout,
      body: switch (_tab) {
        0 => GridView.count(
          crossAxisCount: MediaQuery.sizeOf(context).width > 900 ? 4 : 2,
          childAspectRatio: 1.7,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: const [
            StatTile(title: 'Partners Onboarded', value: '124', trend: '+12'),
            StatTile(title: 'Builders Onboarded', value: '42', trend: '+3'),
            StatTile(title: 'Projects Listed', value: '156', trend: '+24'),
            StatTile(title: 'Pending Approvals', value: '18', trend: '-2'),
          ],
        ),
        1 => BuilderOnboardingView(builderService: _builderService),
        2 => AdminBuilderListView(builderService: _builderService),
        _ => ApprovedProjectsView(builderService: _builderService),
      },
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final BuilderService _builderService = BuilderService();
  final UserManagementService _userManagementService = UserManagementService();
  int _tab = 0;
  final List<String> _tabs = const [
    'Overview',
    'Admin/Agent Users',
    'Builder Approvals',
    'All Projects',
    'All Plots',
    'All Farm Lands',
    'Global Leads',
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Super Admin Dashboard',
      tabs: _tabs,
      currentTab: _tab,
      onSelectTab: (value) => setState(() => _tab = value),
      onLogout: widget.onLogout,
      body: switch (_tab) {
        0 => const AdminOverview(),
        1 => SuperAdminUserManagementView(service: _userManagementService),
        2 => BuilderApprovalQueueView(builderService: _builderService),
        3 => ApprovedProjectsView(builderService: _builderService),
        4 => EntityListView(items: listedPlots.map((e) => e.name).toList()),
        5 => EntityListView(items: listedFarmLands.map((e) => e.name).toList()),
        _ => LeadsView(leads: leads),
      },
    );
  }
}

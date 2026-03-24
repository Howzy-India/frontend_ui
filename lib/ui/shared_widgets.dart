part of '../main.dart';

class DashboardScaffold extends StatelessWidget {
  const DashboardScaffold({
    super.key,
    required this.title,
    required this.tabs,
    required this.currentTab,
    required this.onSelectTab,
    required this.body,
    required this.onLogout,
  });

  final String title;
  final List<String> tabs;
  final int currentTab;
  final ValueChanged<int> onSelectTab;
  final Widget body;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 860;

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
              child: IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu),
                style: IconButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2563EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          title: Text(tabs[currentTab]),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(Icons.notifications_none_outlined),
            ),
          ],
        ),
        drawer: Drawer(
          width: MediaQuery.sizeOf(context).width * 0.72,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF2563EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const HowzyLogo(),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          _badgeLabelFor(title),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: tabs.length,
                    itemBuilder: (context, index) {
                      final label = tabs[index];
                      final selected = index == currentTab;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        child: ListTile(
                          dense: true,
                          minLeadingWidth: 22,
                          onTap: () {
                            onSelectTab(index);
                            Navigator.of(context).pop();
                          },
                          leading: Icon(
                            _menuIconFor(label),
                            color: selected
                                ? const Color(0xFF4338CA)
                                : const Color(0xFF475569),
                          ),
                          title: Text(
                            label,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? const Color(0xFF4338CA)
                                  : const Color(0xFF334155),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          tileColor: selected
                              ? const Color(0xFFE0E7FF)
                              : Colors.transparent,
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListTile(
                    dense: true,
                    onTap: onLogout,
                    leading: const Icon(Icons.logout, color: Color(0xFF475569)),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(padding: const EdgeInsets.all(16), child: body),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentTab,
            onDestinationSelected: onSelectTab,
            labelType: NavigationRailLabelType.all,
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: IconButton(
                onPressed: onLogout,
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
              ),
            ),
            destinations: tabs
                .map(
                  (label) => NavigationRailDestination(
                    icon: Icon(_menuIconFor(label)),
                    selectedIcon: Icon(_menuIconFor(label)),
                    label: Text(label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(padding: const EdgeInsets.all(16), child: body),
          ),
        ],
      ),
    );
  }

  String _badgeLabelFor(String heading) {
    if (heading.toLowerCase().contains('super admin')) {
      return 'SUPER ADMIN';
    }
    if (heading.toLowerCase().contains('admin')) {
      return 'ADMIN';
    }
    return 'PARTNER';
  }

  IconData _menuIconFor(String label) {
    switch (label) {
      case 'Listed Projects':
      case 'All Projects':
        return Icons.apartment_outlined;
      case 'Listed Plots':
      case 'All Plots':
        return Icons.map_outlined;
      case 'Listed Farm Lands':
      case 'All Farm Lands':
        return Icons.park_outlined;
      case 'Upcoming Projects':
        return Icons.auto_awesome_outlined;
      case 'Leads':
      case 'Global Leads':
        return Icons.groups_2_outlined;
      case 'Site Visited Clients':
        return Icons.pin_drop_outlined;
      case 'Booked Clients':
        return Icons.task_alt_outlined;
      case 'Earnings':
        return Icons.account_balance_wallet_outlined;
      case 'Calendar':
        return Icons.calendar_month_outlined;
      case 'Admin/Agent Users':
        return Icons.manage_accounts_outlined;
      case 'Builder Approvals':
        return Icons.verified_outlined;
      default:
        return Icons.dashboard_outlined;
    }
  }
}

class EntityListView extends StatelessWidget {
  const EntityListView({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text(items[index]),
          subtitle: const Text('Converted from React mock data'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class LeadsView extends StatelessWidget {
  const LeadsView({super.key, required this.leads});

  final List<Lead> leads;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(lead.name),
            subtitle: Text('${lead.lookingBhk} | ${lead.milestone}'),
            trailing: Icon(
              lead.documentUploaded
                  ? Icons.check_circle
                  : Icons.pending_outlined,
              color: lead.documentUploaded ? Colors.green : Colors.orange,
            ),
          ),
        );
      },
    );
  }
}

class EarningsView extends StatelessWidget {
  const EarningsView({super.key, required this.data});

  final Earnings data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Bookings This Month: ${data.totalBookingsMonth}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          'Total Earnings: ${data.totalEarningValue}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: data.bookings.length,
            itemBuilder: (context, index) {
              final booking = data.bookings[index];
              return Card(
                child: ListTile(
                  title: Text(booking.clientName),
                  subtitle: Text(
                    '${booking.propertyName} | ${booking.ticketValue}',
                  ),
                  trailing: Text(booking.invoiceStage),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AdminOverview extends StatelessWidget {
  const AdminOverview({super.key});

  @override
  Widget build(BuildContext context) {
    const stats = [
      ('Total Revenue', 'INR 12.4 Cr', '+15.2%'),
      ('Total Partners', '1,240', '+42'),
      ('Active Projects', '86', '+4'),
      ('Total Leads', '4,820', '+124'),
    ];

    return GridView.builder(
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final item = stats[index];
        return StatTile(title: item.$1, value: item.$2, trend: item.$3);
      },
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.title,
    required this.value,
    required this.trend,
  });

  final String title;
  final String value;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              trend,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HowzyLogo extends StatelessWidget {
  const HowzyLogo({super.key, this.tagline = false, this.large = false});

  final bool tagline;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final titleStyle =
        (large
                ? Theme.of(context).textTheme.displaySmall
                : Theme.of(context).textTheme.headlineSmall)
            ?.copyWith(fontWeight: FontWeight.w900);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.home_work_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: large ? 44 : 30,
            ),
            const SizedBox(width: 8),
            Text('howzy', style: titleStyle),
            Text(
              '.in',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (tagline) ...[
          const SizedBox(height: 8),
          const Text(
            'GROW BIG EARN BIG',
            style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }
}

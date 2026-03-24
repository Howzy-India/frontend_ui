part of '../main.dart';

class Tutorial {
  const Tutorial({required this.title, required this.duration});

  final String title;
  final String duration;
}

class PropertyItem {
  const PropertyItem({required this.id, required this.name});

  final String id;
  final String name;
}

class UpcomingProject {
  const UpcomingProject({required this.id, required this.teaser});

  final String id;
  final String teaser;
}

class Lead {
  const Lead({
    required this.id,
    required this.name,
    required this.lookingBhk,
    required this.milestone,
    required this.documentUploaded,
  });

  final String id;
  final String name;
  final String lookingBhk;
  final String milestone;
  final bool documentUploaded;
}

class Booking {
  const Booking({
    required this.id,
    required this.clientName,
    required this.propertyName,
    required this.ticketValue,
    required this.invoiceStage,
  });

  final String id;
  final String clientName;
  final String propertyName;
  final String ticketValue;
  final String invoiceStage;
}

class Earnings {
  const Earnings({
    required this.totalBookingsMonth,
    required this.totalEarningValue,
    required this.bookings,
  });

  final int totalBookingsMonth;
  final String totalEarningValue;
  final List<Booking> bookings;
}

const tutorials = [
  Tutorial(title: 'How to register a lead with builders', duration: '5:20'),
  Tutorial(title: 'Navigating the new Howzy Dashboard', duration: '8:45'),
  Tutorial(title: 'Uploading 10% advance documents', duration: '3:15'),
];

const listedProjects = [
  PropertyItem(id: 'p1', name: 'Skyline Residencies'),
  PropertyItem(id: 'p2', name: 'Green Valley Estates'),
  PropertyItem(id: 'p3', name: 'Neon Heights'),
];

const listedPlots = [
  PropertyItem(id: 'pl1', name: 'Sunrise Meadows'),
  PropertyItem(id: 'pl2', name: 'Golden Acres'),
];

const listedFarmLands = [
  PropertyItem(id: 'fl1', name: 'Nature\'s Bounty Farms'),
  PropertyItem(id: 'fl2', name: 'Serene Valley Farms'),
];

const upcomingProjects = [
  UpcomingProject(id: 'u1', teaser: 'Something Big is coming'),
  UpcomingProject(id: 'u2', teaser: 'Redefining Luxury'),
];

const leads = [
  Lead(
    id: 'l1',
    name: 'Alice Smith',
    lookingBhk: '2BHK',
    milestone: 'Site visit',
    documentUploaded: false,
  ),
  Lead(
    id: 'l2',
    name: 'Bob Johnson',
    lookingBhk: '3BHK',
    milestone: 'Booking done',
    documentUploaded: true,
  ),
  Lead(
    id: 'l3',
    name: 'Charlie Davis',
    lookingBhk: '2BHK',
    milestone: 'Briefing call',
    documentUploaded: false,
  ),
  Lead(
    id: 'l4',
    name: 'Diana Prince',
    lookingBhk: '3BHK',
    milestone: '10% advance stage',
    documentUploaded: false,
  ),
];

const earnings = Earnings(
  totalBookingsMonth: 3,
  totalEarningValue: 'USD 45,000',
  bookings: [
    Booking(
      id: 'b1',
      clientName: 'Bob Johnson',
      propertyName: 'Green Valley Estates',
      ticketValue: 'USD 950,000',
      invoiceStage: 'Successful',
    ),
    Booking(
      id: 'b2',
      clientName: 'Charlie Davis',
      propertyName: 'Skyline Residencies',
      ticketValue: 'USD 600,000',
      invoiceStage: 'Invoice released',
    ),
    Booking(
      id: 'b3',
      clientName: 'Diana Prince',
      propertyName: 'Skyline Residencies',
      ticketValue: 'USD 720,000',
      invoiceStage: 'Auditing',
    ),
  ],
);

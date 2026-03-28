part of '../main.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────

enum PropertyCategory { project, villa, plot, farmland }

extension PropertyCategoryLabel on PropertyCategory {
  String get label {
    switch (this) {
      case PropertyCategory.project:  return 'Project';
      case PropertyCategory.villa:    return 'Villa';
      case PropertyCategory.plot:     return 'Plot';
      case PropertyCategory.farmland: return 'Farm Land';
    }
  }

  static PropertyCategory fromString(String? s) {
    switch (s?.toLowerCase()) {
      case 'villa':    return PropertyCategory.villa;
      case 'plot':     return PropertyCategory.plot;
      case 'farmland':
      case 'farm land':
      case 'farm_land': return PropertyCategory.farmland;
      default:         return PropertyCategory.project;
    }
  }
}

class PropertyListing {
  const PropertyListing({
    required this.id,
    required this.name,
    required this.developer,
    required this.category,
    required this.city,
    required this.location,
    required this.price,
    required this.priceRangeKey,
    required this.usp,
    required this.reraNumber,
    this.pricePerSqft,
    this.possession,
    this.segment,
    this.bhkOptions,
    this.bhkKey,
    this.area,
    this.plotSize,
    this.farmAcres,
    this.amenities = const [],
    this.tags = const [],
    this.imageUrl,
    this.gatedCommunity,
    this.approvalType,
    this.isNew = false,
    this.isTrending = false,
    this.mapLink,
  });

  final String id;
  final String name;
  final String developer;
  final PropertyCategory category;
  final String city;
  final String location;
  final String price;
  final String priceRangeKey;
  final String usp;
  final String reraNumber;
  final String? pricePerSqft;
  final String? possession;
  final String? segment;
  final List<String>? bhkOptions;
  final String? bhkKey;
  final String? area;
  final String? plotSize;
  final String? farmAcres;
  final List<String> amenities;
  final List<String> tags;
  final String? imageUrl;
  final bool? gatedCommunity;
  final String? approvalType;
  final bool isNew;
  final bool isTrending;
  final String? mapLink;

  /// Create from a Firestore document snapshot
  factory PropertyListing.fromFirestore(Map<String, dynamic> data, String id) {
    List<String> strings(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : const [];

    return PropertyListing(
      id:            id,
      name:          data['name']          as String? ?? '',
      developer:     data['developer']     as String? ?? '',
      category:      PropertyCategoryLabel.fromString(data['category'] as String?),
      city:          data['city']          as String? ?? '',
      location:      data['location']      as String? ?? '',
      price:         data['price']         as String? ?? '',
      priceRangeKey: data['priceRangeKey'] as String? ?? '',
      usp:           data['usp']           as String? ?? '',
      reraNumber:    data['reraNumber']    as String? ?? '',
      pricePerSqft:  data['pricePerSqft']  as String?,
      possession:    data['possession']    as String?,
      segment:       data['segment']       as String?,
      bhkOptions:    strings(data['bhkOptions']),
      bhkKey:        data['bhkKey']        as String?,
      area:          data['area']          as String?,
      plotSize:      data['plotSize']      as String?,
      farmAcres:     data['farmAcres']     as String?,
      amenities:     strings(data['amenities']),
      tags:          strings(data['tags']),
      imageUrl:      data['imageUrl']      as String?,
      gatedCommunity: data['gatedCommunity'] as bool?,
      approvalType:  data['approvalType']  as String?,
      isNew:         data['isNew']         as bool? ?? false,
      isTrending:    data['isTrending']    as bool? ?? false,
      mapLink:       data['mapLink']       as String?,
    );
  }

  /// Convert to Firestore document map
  Map<String, dynamic> toFirestore() => {
    'name':          name,
    'developer':     developer,
    'category':      category.label,
    'city':          city,
    'location':      location,
    'price':         price,
    'priceRangeKey': priceRangeKey,
    'usp':           usp,
    'reraNumber':    reraNumber,
    if (pricePerSqft  != null) 'pricePerSqft':  pricePerSqft,
    if (possession    != null) 'possession':    possession,
    if (segment       != null) 'segment':       segment,
    if (bhkOptions    != null) 'bhkOptions':    bhkOptions,
    if (bhkKey        != null) 'bhkKey':        bhkKey,
    if (area          != null) 'area':          area,
    if (plotSize      != null) 'plotSize':      plotSize,
    if (farmAcres     != null) 'farmAcres':     farmAcres,
    'amenities':     amenities,
    'tags':          tags,
    if (imageUrl      != null) 'imageUrl':      imageUrl,
    if (gatedCommunity != null) 'gatedCommunity': gatedCommunity,
    if (approvalType  != null) 'approvalType':  approvalType,
    'isNew':         isNew,
    'isTrending':    isTrending,
    if (mapLink       != null) 'mapLink':       mapLink,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock Data
// ─────────────────────────────────────────────────────────────────────────────

const _projectImg =
    'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&q=80';
const _villaImg =
    'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=600&q=80';
const _plotImg =
    'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600&q=80';
const _farmImg =
    'https://images.unsplash.com/photo-1500076656116-558758c991c1?w=600&q=80';

const allProperties = <PropertyListing>[
  // ── Projects ──────────────────────────────────────────────
  PropertyListing(
    id: 'proj-1',
    name: 'Skyline Residencies',
    developer: 'Apex Developers',
    category: PropertyCategory.project,
    city: 'Hyderabad',
    location: 'Kokapet',
    price: '₹1.2 Cr – ₹2.4 Cr',
    pricePerSqft: '₹8,500/sq.ft',
    priceRangeKey: '1Cr-3Cr',
    possession: 'Under Construction',
    segment: 'Luxury',
    usp: 'Infinity Pool & Smart Home Integration',
    reraNumber: 'P02400001234',
    bhkOptions: ['2 BHK', '3 BHK', '4 BHK'],
    bhkKey: '2,3,4',
    area: '1,450 – 3,200 sq.ft',
    amenities: ['Swimming Pool', 'Gym', 'Clubhouse', 'EV Charging', 'Concierge'],
    tags: ['Trending', 'RERA Approved'],
    imageUrl: _projectImg,
    gatedCommunity: true,
    isTrending: true,
    mapLink: 'https://maps.google.com/?q=17.3850,78.4867',
  ),
  PropertyListing(
    id: 'proj-2',
    name: 'Green Valley Estates',
    developer: 'Zenith Constructions',
    category: PropertyCategory.project,
    city: 'Hyderabad',
    location: 'Tellapur',
    price: '₹85 L – ₹1.5 Cr',
    pricePerSqft: '₹6,200/sq.ft',
    priceRangeKey: '50L-1Cr',
    possession: 'Ready to Move',
    segment: 'Premium',
    usp: 'Eco-friendly living with 50% open green space',
    reraNumber: 'P02400005678',
    bhkOptions: ['2 BHK', '3 BHK'],
    bhkKey: '2,3',
    area: '1,100 – 1,950 sq.ft',
    amenities: ['Jogging Track', 'Children Play Area', 'Gym', 'Amphitheatre'],
    tags: ['Ready to Move', 'Eco-friendly'],
    imageUrl: _projectImg,
    gatedCommunity: true,
    mapLink: 'https://maps.google.com/?q=17.4400,78.3489',
  ),
  PropertyListing(
    id: 'proj-3',
    name: 'Neon Heights',
    developer: 'Cyber BuildCorp',
    category: PropertyCategory.project,
    city: 'Bangalore',
    location: 'Whitefield',
    price: '₹95 L – ₹1.8 Cr',
    pricePerSqft: '₹7,800/sq.ft',
    priceRangeKey: '50L-1Cr',
    possession: 'New Launch',
    segment: 'Luxury',
    usp: 'Futuristic architecture with AI concierge',
    reraNumber: 'P02400009012',
    bhkOptions: ['2 BHK', '3 BHK'],
    bhkKey: '2,3',
    area: '1,200 – 2,100 sq.ft',
    amenities: ['Rooftop Pool', 'Co-working Space', 'Sky Garden', 'Smart Security'],
    tags: ['New Launch', 'Smart Homes'],
    imageUrl: _projectImg,
    isNew: true,
    gatedCommunity: true,
    mapLink: 'https://maps.google.com/?q=12.9698,77.7500',
  ),
  PropertyListing(
    id: 'proj-4',
    name: 'Serene Heights',
    developer: 'Prestige Group',
    category: PropertyCategory.project,
    city: 'Hyderabad',
    location: 'Kondapur',
    price: '₹1.5 Cr – ₹2.8 Cr',
    pricePerSqft: '₹9,200/sq.ft',
    priceRangeKey: '1Cr-3Cr',
    possession: 'Under Construction',
    segment: 'Luxury',
    usp: '360° city views & imported marble finishes',
    reraNumber: 'P02400007890',
    bhkOptions: ['3 BHK', '4 BHK', '5 BHK'],
    bhkKey: '3,4,5',
    area: '2,200 – 4,800 sq.ft',
    amenities: ['Infinity Pool', 'Spa', 'Private Theatre', 'Wine Cellar'],
    tags: ['Ultra-Luxury', 'Limited Units'],
    imageUrl: _projectImg,
    gatedCommunity: true,
    isTrending: true,
    mapLink: 'https://maps.google.com/?q=17.4600,78.3600',
  ),
  // ── Villas ────────────────────────────────────────────────
  PropertyListing(
    id: 'villa-1',
    name: 'The Magnolia Villas',
    developer: 'Green Earth Developers',
    category: PropertyCategory.villa,
    city: 'Hyderabad',
    location: 'Shamirpet',
    price: '₹2.5 Cr – ₹4.2 Cr',
    priceRangeKey: '1Cr-3Cr',
    possession: 'Ready to Move',
    segment: 'Luxury',
    usp: 'Duplex villas with private pools & lush gardens',
    reraNumber: 'P02400011111',
    bhkOptions: ['4 BHK', '5 BHK'],
    bhkKey: '4,5',
    area: '3,500 – 5,200 sq.ft',
    amenities: ['Private Pool', 'Clubhouse', 'Gym', 'Tennis Court', 'Organic Garden'],
    tags: ['Trending', 'Private Pool'],
    imageUrl: _villaImg,
    gatedCommunity: true,
    isTrending: true,
    mapLink: 'https://maps.google.com/?q=17.5700,78.5500',
  ),
  PropertyListing(
    id: 'villa-2',
    name: 'Palm Grove Residences',
    developer: 'Aditya Constructions',
    category: PropertyCategory.villa,
    city: 'Hyderabad',
    location: 'Narsingi',
    price: '₹1.8 Cr – ₹3.2 Cr',
    priceRangeKey: '1Cr-3Cr',
    possession: 'Under Construction',
    segment: 'Premium',
    usp: 'Gated villa community with world-class clubhouse',
    reraNumber: 'P02400022222',
    bhkOptions: ['3 BHK', '4 BHK'],
    bhkKey: '3,4',
    area: '2,800 – 4,000 sq.ft',
    amenities: ['Clubhouse', 'Jogging Track', 'Kids Pool', 'Indoor Sports'],
    tags: ['Gated Community'],
    imageUrl: _villaImg,
    gatedCommunity: true,
    mapLink: 'https://maps.google.com/?q=17.3900,78.3600',
  ),
  PropertyListing(
    id: 'villa-3',
    name: 'Elite Meadows',
    developer: 'Ramky Group',
    category: PropertyCategory.villa,
    city: 'Bangalore',
    location: 'Sarjapur Road',
    price: '₹3.5 Cr – ₹6 Cr',
    priceRangeKey: '3Cr+',
    possession: 'Ready to Move',
    segment: 'Luxury',
    usp: 'RERA-certified villas with vastu compliance',
    reraNumber: 'P02400033333',
    bhkOptions: ['4 BHK', '5 BHK', '6 BHK'],
    bhkKey: '4,5,6',
    area: '4,200 – 6,800 sq.ft',
    amenities: ['Grand Clubhouse', 'Golf Putting', 'Amphitheatre'],
    tags: ['Ultra-Luxury', 'Ready to Move'],
    imageUrl: _villaImg,
    gatedCommunity: true,
    mapLink: 'https://maps.google.com/?q=12.8845,77.7052',
  ),
  // ── Plots ─────────────────────────────────────────────────
  PropertyListing(
    id: 'plot-1',
    name: 'Sunrise Meadows',
    developer: 'Green Earth Developers',
    category: PropertyCategory.plot,
    city: 'Hyderabad',
    location: 'Shadnagar',
    price: '₹45 L – ₹1.2 Cr',
    priceRangeKey: '0-50L',
    segment: 'Mid Range',
    usp: '100% Vastu Compliant Gated Plotted Development',
    reraNumber: 'P02400002222',
    plotSize: '150 – 400 sq.yd',
    amenities: ['Club House', 'Compound Wall', '24/7 Security', 'Wide Roads'],
    tags: ['HMDA Approved', 'RERA Approved'],
    imageUrl: _plotImg,
    approvalType: 'HMDA',
    isTrending: true,
    mapLink: 'https://maps.google.com/?q=17.0700,78.1200',
  ),
  PropertyListing(
    id: 'plot-2',
    name: 'Golden Acres',
    developer: 'Prime Lands',
    category: PropertyCategory.plot,
    city: 'Bangalore',
    location: 'Devanahalli',
    price: '₹55 L – ₹90 L',
    priceRangeKey: '50L-1Cr',
    segment: 'Premium',
    usp: 'Airport corridor with 24/7 secured gated community',
    reraNumber: 'P02400002223',
    plotSize: '200 – 500 sq.yd',
    amenities: ['Avenue Plantation', 'Rainwater Harvesting', 'Underground Utilities'],
    tags: ['Airport Corridor', 'DTCP Approved'],
    imageUrl: _plotImg,
    approvalType: 'DTCP',
    mapLink: 'https://maps.google.com/?q=13.2257,77.7173',
  ),
  PropertyListing(
    id: 'plot-3',
    name: 'Harmony Township',
    developer: 'Sattva Group',
    category: PropertyCategory.plot,
    city: 'Hyderabad',
    location: 'Sadashivpet',
    price: '₹30 L – ₹60 L',
    priceRangeKey: '0-50L',
    segment: 'Affordable',
    usp: 'Large open plots with lake frontage & mountain views',
    reraNumber: 'P02400044444',
    plotSize: '100 – 300 sq.yd',
    amenities: ['Club House', 'Swimming Pool', 'Park', 'Shopping Centre'],
    tags: ['Lake View', 'Affordable'],
    imageUrl: _plotImg,
    approvalType: 'RERA',
    isNew: true,
    mapLink: 'https://maps.google.com/?q=17.6200,77.9500',
  ),
  // ── Farm Lands ────────────────────────────────────────────
  PropertyListing(
    id: 'farm-1',
    name: "Nature's Bounty Farms",
    developer: 'Agri Estates',
    category: PropertyCategory.farmland,
    city: 'Hyderabad',
    location: 'Moinabad',
    price: '₹25 L – ₹80 L',
    priceRangeKey: '0-50L',
    segment: 'Mid Range',
    usp: 'Organic farming & weekend retreat homes',
    reraNumber: 'P02400003333',
    farmAcres: '0.5 – 2 Acres',
    amenities: ['Drip Irrigation', 'Bore Well', 'Farm House', 'Organic Soil Certificate'],
    tags: ['Organic', 'Weekend Retreat'],
    imageUrl: _farmImg,
    isTrending: true,
    mapLink: 'https://maps.google.com/?q=17.2800,78.0000',
  ),
  PropertyListing(
    id: 'farm-2',
    name: 'Serene Valley Farms',
    developer: 'Eco Lands',
    category: PropertyCategory.farmland,
    city: 'Hyderabad',
    location: 'Chevella',
    price: '₹40 L – ₹1.2 Cr',
    priceRangeKey: '0-50L',
    segment: 'Premium',
    usp: 'Fruit orchards, drip irrigation & managed farmlands',
    reraNumber: 'P02400003334',
    farmAcres: '1 – 5 Acres',
    amenities: ['Fruit Orchards', 'Drip Irrigation', 'Solar Power', 'Caretaker'],
    tags: ['Managed Farms', 'Fruit Orchards'],
    imageUrl: _farmImg,
    mapLink: 'https://maps.google.com/?q=17.2400,77.9100',
  ),
  PropertyListing(
    id: 'farm-3',
    name: 'Green Horizons Estate',
    developer: 'Nature Realty',
    category: PropertyCategory.farmland,
    city: 'Bangalore',
    location: 'Kanakapura Road',
    price: '₹60 L – ₹2 Cr',
    priceRangeKey: '50L-1Cr',
    segment: 'Premium',
    usp: 'Agri tourism resort concept with managed eco-stays',
    reraNumber: 'P02400055555',
    farmAcres: '2 – 10 Acres',
    amenities: ['Eco Cottages', 'Trekking Trails', 'Organic Farm', 'Yoga Deck'],
    tags: ['Agri Tourism', 'Eco Living'],
    imageUrl: _farmImg,
    isNew: true,
    mapLink: 'https://maps.google.com/?q=12.6500,77.5800',
  ),
];

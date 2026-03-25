// Standalone property model (not a `part` file) used by new feature screens.
// The legacy PropertyListing model lives in lib/data/property_data.dart (part of main.dart).

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

// ─── Model ────────────────────────────────────────────────────────────────────
class HowzyProperty {
  const HowzyProperty({
    required this.id,
    required this.name,
    required this.developer,
    required this.category,
    required this.city,
    required this.location,
    required this.price,
    required this.priceValue,
    required this.budgetRange,
    required this.usp,
    required this.rating,
    this.imageUrl,
    this.bhkOptions = const [],
    this.amenities = const [],
    this.tags = const [],
    this.possession,
    this.plotSize,
    this.farmAcres,
    this.area,
    this.reraNumber = 'RERA/TG/2024/001',
    this.isNew = false,
    this.isTrending = false,
    this.isVerified = true,
  });

  final String id;
  final String name;
  final String developer;
  final String category; // 'project' | 'villa' | 'plot' | 'farmland' | 'commercial'
  final String city;
  final String location;
  final String price;        // display string e.g. "₹45L – ₹2.5Cr"
  final int priceValue;      // numeric for sorting (in lakhs)
  final String budgetRange;  // 'Under 50L' | '50L-1Cr' | '1Cr-2Cr' | '2Cr-5Cr' | 'Above 5Cr'
  final String usp;
  final double rating;
  final String? imageUrl;
  final List<String> bhkOptions;
  final List<String> amenities;
  final List<String> tags;
  final String? possession;
  final String? plotSize;
  final String? farmAcres;
  final String? area;
  final String reraNumber;
  final bool isNew;
  final bool isTrending;
  final bool isVerified;

  // Category color/icon helpers
  Color get categoryColor {
    switch (category) {
      case 'project': return AppColors.blue100;
      case 'villa':   return AppColors.emerald100;
      case 'plot':    return AppColors.amber100;
      case 'farmland':return AppColors.green100;
      default:        return AppColors.indigoLight;
    }
  }

  Color get categoryTextColor {
    switch (category) {
      case 'project': return AppColors.blue500;
      case 'villa':   return AppColors.emerald500;
      case 'plot':    return AppColors.amber500;
      case 'farmland':return AppColors.green700;
      default:        return AppColors.indigo600;
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case 'project': return Icons.apartment_rounded;
      case 'villa':   return Icons.villa_rounded;
      case 'plot':    return Icons.map_outlined;
      case 'farmland':return Icons.eco_rounded;
      default:        return Icons.business_rounded;
    }
  }

  String get categoryLabel {
    switch (category) {
      case 'project': return 'New Project';
      case 'villa':   return 'Villa';
      case 'plot':    return 'Plot';
      case 'farmland':return 'Farm Land';
      default:        return 'Commercial';
    }
  }
}

// ─── Mock Data ────────────────────────────────────────────────────────────────
const mockProperties = <HowzyProperty>[
  HowzyProperty(
    id: 'p001', name: 'Prestige Lakeside Habitat',
    developer: 'Prestige Group', category: 'project',
    city: 'Bengaluru', location: 'Whitefield',
    price: '₹55L – ₹1.8Cr', priceValue: 55, budgetRange: '50L-1Cr',
    usp: 'Lakeside luxury living with world-class amenities',
    rating: 4.8, imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600&q=80',
    bhkOptions: ['2 BHK', '3 BHK', '4 BHK'],
    amenities: ['Clubhouse', 'Swimming Pool', 'Gym', 'Park', 'Security'],
    tags: ['Verified', 'RERA Approved'], possession: 'Dec 2025',
    area: '1,250 – 2,800 sq.ft', isNew: true, isTrending: true,
  ),
  HowzyProperty(
    id: 'p002', name: 'Sobha HRC Pristine',
    developer: 'Sobha Developers', category: 'project',
    city: 'Bengaluru', location: 'Marathahalli',
    price: '₹85L – ₹2.2Cr', priceValue: 85, budgetRange: '1Cr-2Cr',
    usp: 'Premium residences in the heart of Bengaluru',
    rating: 4.7, imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=600&q=80',
    bhkOptions: ['3 BHK', '4 BHK'],
    amenities: ['Rooftop Pool', 'Gym', 'Co-working', 'Kids Zone'],
    tags: ['Verified', 'Hot Deal'], possession: 'Mar 2026',
    area: '1,850 – 3,200 sq.ft', isTrending: true,
  ),
  HowzyProperty(
    id: 'p003', name: 'Lotus Grand Villas',
    developer: 'Lotus Constructions', category: 'villa',
    city: 'Hyderabad', location: 'Mokila',
    price: '₹1.2Cr – ₹2.8Cr', priceValue: 120, budgetRange: '1Cr-2Cr',
    usp: 'Gated community villas with private gardens',
    rating: 4.6, imageUrl: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=600&q=80',
    bhkOptions: ['3 BHK', '4 BHK', '5 BHK'],
    amenities: ['Private Pool', 'Garden', 'Club House', '24/7 Security'],
    tags: ['Verified', 'Gated Community'], possession: 'Ready to Move',
    area: '2,800 – 4,500 sq.ft', isNew: false, isTrending: true,
  ),
  HowzyProperty(
    id: 'p004', name: 'Green Valley Plots',
    developer: 'Greenfield Estates', category: 'plot',
    city: 'Hyderabad', location: 'Shamshabad',
    price: '₹18L – ₹65L', priceValue: 18, budgetRange: 'Under 50L',
    usp: 'DTCP approved open plots near Rajiv Gandhi Airport',
    rating: 4.5, imageUrl: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600&q=80',
    amenities: ['DTCP Approved', 'Wide Roads', 'Underground Drainage'],
    tags: ['Verified', 'DTCP Approved'], possession: 'Immediate',
    plotSize: '150 – 500 sq.yd', isNew: true,
  ),
  HowzyProperty(
    id: 'p005', name: 'Serene Farm Lands',
    developer: 'Nature Farms', category: 'farmland',
    city: 'Hyderabad', location: 'Mahabubnagar',
    price: '₹8L – ₹35L per acre', priceValue: 8, budgetRange: 'Under 50L',
    usp: 'Fertile agricultural land with water source',
    rating: 4.4, imageUrl: 'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=600&q=80',
    amenities: ['Borewell', 'Farm Road', 'Electricity'],
    tags: ['Verified', 'Agricultural'], possession: 'Immediate',
    farmAcres: '1 – 10 acres',
  ),
  HowzyProperty(
    id: 'p006', name: 'My Home Jewel',
    developer: 'My Home Constructions', category: 'project',
    city: 'Hyderabad', location: 'Kokapet',
    price: '₹1.5Cr – ₹4.2Cr', priceValue: 150, budgetRange: '2Cr-5Cr',
    usp: 'Ultra-luxury high-rise with panoramic city views',
    rating: 4.9, imageUrl: 'https://images.unsplash.com/photo-1567767292278-a4f21aa2d36e?w=600&q=80',
    bhkOptions: ['3 BHK', '4 BHK', 'Penthouse'],
    amenities: ['Sky Lounge', 'Olympic Pool', 'Concierge', 'Smart Home'],
    tags: ['Verified', 'Luxury', 'RERA Approved'], possession: 'Jun 2026',
    area: '2,200 – 6,000 sq.ft', isTrending: true, isNew: true,
  ),
  HowzyProperty(
    id: 'p007', name: 'Vasavi Signature',
    developer: 'Vasavi Group', category: 'villa',
    city: 'Hyderabad', location: 'Narsingi',
    price: '₹90L – ₹1.8Cr', priceValue: 90, budgetRange: '1Cr-2Cr',
    usp: 'Independent villas with rooftop terrace',
    rating: 4.5, imageUrl: 'https://images.unsplash.com/photo-1576941089067-2de3c901e126?w=600&q=80',
    bhkOptions: ['3 BHK', '4 BHK'],
    amenities: ['Rooftop Terrace', 'Modular Kitchen', 'Solar Power'],
    tags: ['Verified', 'Eco-Friendly'], possession: 'Ready to Move',
    area: '2,000 – 3,200 sq.ft',
  ),
  HowzyProperty(
    id: 'p008', name: 'Brigade Horizon',
    developer: 'Brigade Group', category: 'project',
    city: 'Bengaluru', location: 'Electronic City',
    price: '₹42L – ₹95L', priceValue: 42, budgetRange: '50L-1Cr',
    usp: 'Affordable premium homes near IT corridor',
    rating: 4.6, imageUrl: 'https://images.unsplash.com/photo-1486325212027-8081e485255e?w=600&q=80',
    bhkOptions: ['1 BHK', '2 BHK', '3 BHK'],
    amenities: ['Gym', 'Play Area', 'Gardens', 'EV Charging'],
    tags: ['Verified', 'Affordable Luxury'], possession: 'Sep 2025',
    area: '650 – 1,650 sq.ft', isNew: true,
  ),
  HowzyProperty(
    id: 'p009', name: 'Mantri Serene',
    developer: 'Mantri Developers', category: 'project',
    city: 'Bengaluru', location: 'Sarjapur Road',
    price: '₹65L – ₹1.4Cr', priceValue: 65, budgetRange: '1Cr-2Cr',
    usp: 'Green certified township with 60% open space',
    rating: 4.7, imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600&q=80',
    bhkOptions: ['2 BHK', '3 BHK'],
    amenities: ['Tennis Court', 'Amphitheatre', 'Jogging Track', 'Pool'],
    tags: ['Verified', 'Green Certified'], possession: 'Dec 2025',
    area: '1,100 – 2,200 sq.ft',
  ),
  HowzyProperty(
    id: 'p010', name: 'NCC Urban One',
    developer: 'NCC Urban', category: 'commercial',
    city: 'Hyderabad', location: 'Gachibowli',
    price: '₹80L – ₹5Cr', priceValue: 80, budgetRange: '1Cr-2Cr',
    usp: 'Grade A commercial spaces in the financial hub',
    rating: 4.5, imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600&q=80',
    amenities: ['High-Speed Lifts', 'Power Backup', 'Parking', 'Cafeteria'],
    tags: ['Verified', 'Grade A'], possession: 'Ready',
    area: '500 – 10,000 sq.ft',
  ),
  HowzyProperty(
    id: 'p011', name: 'Aparna HillPark',
    developer: 'Aparna Constructions', category: 'project',
    city: 'Hyderabad', location: 'Miyapur',
    price: '₹38L – ₹85L', priceValue: 38, budgetRange: 'Under 50L',
    usp: 'Value homes in a fast-growing location',
    rating: 4.3, imageUrl: 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=600&q=80',
    bhkOptions: ['2 BHK', '3 BHK'],
    amenities: ['Gym', 'Park', 'Swimming Pool'],
    tags: ['Verified', 'Best Value'], possession: 'Ready to Move',
    area: '1,000 – 1,650 sq.ft',
  ),
  HowzyProperty(
    id: 'p012', name: 'Ramky One Kosmos',
    developer: 'Ramky Group', category: 'project',
    city: 'Hyderabad', location: 'Bachupally',
    price: '₹55L – ₹1.1Cr', priceValue: 55, budgetRange: '50L-1Cr',
    usp: 'Smart homes with IoT-enabled features',
    rating: 4.6, imageUrl: 'https://images.unsplash.com/photo-1560185007-cde436f6a4d0?w=600&q=80',
    bhkOptions: ['2 BHK', '3 BHK', '4 BHK'],
    amenities: ['Smart Home', 'EV Charging', 'Co-working', 'Rooftop Garden'],
    tags: ['Verified', 'Smart Home', 'RERA Approved'], possession: 'Mar 2026',
    area: '1,200 – 2,400 sq.ft', isNew: true, isTrending: true,
  ),
];

// Categories for filter
const propertyCategories = ['project', 'villa', 'plot', 'farmland', 'commercial'];
const propertyCities = ['Hyderabad', 'Bengaluru', 'Mumbai', 'Chennai', 'Pune'];
const budgetRanges = ['Under 50L', '50L-1Cr', '1Cr-2Cr', '2Cr-5Cr', 'Above 5Cr'];
const moveInOptions = ['Ready to Move', 'Within 6 Months', '6–12 Months', '1–2 Years', 'Under Construction'];
const sortOptions = ['Recommended', 'Price: Low to High', 'Price: High to Low', 'Rating'];

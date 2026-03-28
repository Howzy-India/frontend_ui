import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// property_data.dart is a `part of main.dart` — import via the barrel
import '../../main.dart' show PropertyListing, allProperties;

/// Firestore collection name for properties.
const _kCollection = 'properties';

class PropertyService {
  PropertyService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  // ── Read ─────────────────────────────────────────────────────────────────

  /// Live stream of all active properties, ordered by createdAt desc.
  /// Falls back to [allProperties] mock data if Firestore is unreachable.
  Stream<List<PropertyListing>> watchProperties() {
    return _db
        .collection(_kCollection)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
          if (snap.docs.isEmpty) return allProperties;
          return snap.docs
              .map((d) => PropertyListing.fromFirestore(d.data(), d.id))
              .toList();
        })
        .handleError((Object e) {
          debugPrint('[PropertyService] Firestore error: $e — using mock data');
          return allProperties;
        });
  }

  /// One-shot fetch (used for initial fast load).
  Future<List<PropertyListing>> fetchProperties() async {
    try {
      final snap = await _db
          .collection(_kCollection)
          .where('status', isEqualTo: 'active')
          .orderBy('createdAt', descending: true)
          .get();
      if (snap.docs.isEmpty) return allProperties;
      return snap.docs
          .map((d) => PropertyListing.fromFirestore(d.data(), d.id))
          .toList();
    } catch (e) {
      debugPrint('[PropertyService] fetch error: $e — using mock data');
      return allProperties;
    }
  }

  // ── Write ────────────────────────────────────────────────────────────────

  /// Add a new property listing (for admin/builder use).
  Future<String> addProperty(PropertyListing p) async {
    final data = p.toFirestore()
      ..['status']    = 'active'
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();
    final ref = await _db.collection(_kCollection).add(data);
    return ref.id;
  }

  /// Update an existing property by id.
  Future<void> updateProperty(String id, Map<String, dynamic> updates) {
    return _db.collection(_kCollection).doc(id).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Soft-delete: marks status as 'inactive'.
  Future<void> deactivateProperty(String id) {
    return _db.collection(_kCollection).doc(id).update({
      'status':    'inactive',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Seed (dev only) ──────────────────────────────────────────────────────

  /// Seeds mock data into Firestore. Call once from admin console or dev tool.
  Future<void> seedMockData() async {
    final batch = _db.batch();
    final now   = FieldValue.serverTimestamp();
    for (final p in allProperties) {
      final ref  = _db.collection(_kCollection).doc(p.id);
      final data = p.toFirestore()
        ..['status']    = 'active'
        ..['createdAt'] = now
        ..['updatedAt'] = now;
      batch.set(ref, data, SetOptions(merge: true));
    }
    await batch.commit();
    debugPrint('[PropertyService] Seeded ${allProperties.length} properties');
  }
}

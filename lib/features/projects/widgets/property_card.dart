import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/property_data_standalone.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/property_providers.dart';

// ─── Property Card ─────────────────────────────────────────────────────────
// Adaptive: compact list-tile on mobile, grid card on desktop
class PropertyCard extends ConsumerWidget {
  const PropertyCard({
    super.key,
    required this.property,
    this.compact = false,
    this.onTap,
  });

  final HowzyProperty property;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(savedPropertiesProvider).contains(property.id);

    return GestureDetector(
      onTap: onTap ?? () => _showDetail(context, ref),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate100),
          boxShadow: const [
            BoxShadow(color: Color(0x06000000), blurRadius: 16, offset: Offset(0, 4)),
          ],
        ),
        child: compact ? _CompactLayout(property: property, isSaved: isSaved, ref: ref) : _GridLayout(property: property, isSaved: isSaved, ref: ref),
      ),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PropertyDetailSheet(property: property),
    );
  }
}

// ─── Grid layout (web / tablet) ───────────────────────────────────────────────
class _GridLayout extends StatelessWidget {
  const _GridLayout({required this.property, required this.isSaved, required this.ref});
  final HowzyProperty property;
  final bool isSaved;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _PropertyImage(property: property),
                // Gradient overlay
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x55000000)],
                    ),
                  ),
                ),
                // Badges top-left
                Positioned(
                  top: 8, left: 8,
                  child: Row(
                    children: [
                      if (property.isNew) _Badge('New', AppColors.indigo600),
                      if (property.isTrending) ...[
                        if (property.isNew) const SizedBox(width: 4),
                        _Badge('🔥 Hot', const Color(0xFFEA580C)),
                      ],
                    ],
                  ),
                ),
                // Save button top-right
                Positioned(
                  top: 6, right: 6,
                  child: _SaveButton(
                    isSaved: isSaved,
                    onTap: () => ref.read(savedPropertiesProvider.notifier).toggle(property.id),
                  ),
                ),
                // Rating bottom-left
                Positioned(
                  bottom: 6, left: 8,
                  child: _RatingBadge(rating: property.rating),
                ),
                // Possession bottom-right
                if (property.possession != null)
                  Positioned(
                    bottom: 6, right: 8,
                    child: _PossessionBadge(possession: property.possession!),
                  ),
              ],
            ),
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category chip
              _CategoryChip(property: property),
              const SizedBox(height: 6),
              Text(property.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.slate900, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 11, color: AppColors.slate400),
                  const SizedBox(width: 2),
                  Expanded(child: Text('${property.location}, ${property.city}', style: const TextStyle(fontSize: 11, color: AppColors.slate500), overflow: TextOverflow.ellipsis)),
                ],
              ),
              if (property.bhkOptions.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4, runSpacing: 2,
                  children: property.bhkOptions.take(3).map((b) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(4)),
                    child: Text(b, style: const TextStyle(fontSize: 10, color: AppColors.slate600, fontWeight: FontWeight.w500)),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 8),
              Text(property.price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.indigo600)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Compact list layout (mobile) ─────────────────────────────────────────────
class _CompactLayout extends StatelessWidget {
  const _CompactLayout({required this.property, required this.isSaved, required this.ref});
  final HowzyProperty property;
  final bool isSaved;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          child: SizedBox(
            width: 110, height: 110,
            child: _PropertyImage(property: property),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  _CategoryChip(property: property),
                  const Spacer(),
                  _SaveButton(isSaved: isSaved, onTap: () => ref.read(savedPropertiesProvider.notifier).toggle(property.id), small: true),
                ]),
                const SizedBox(height: 5),
                Text(property.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.slate900), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.location_on, size: 10, color: AppColors.slate400),
                  const SizedBox(width: 2),
                  Expanded(child: Text('${property.location}, ${property.city}', style: const TextStyle(fontSize: 10, color: AppColors.slate500), overflow: TextOverflow.ellipsis)),
                ]),
                const SizedBox(height: 5),
                Row(children: [
                  Text(property.price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.indigo600)),
                  const Spacer(),
                  _RatingBadge(rating: property.rating, small: true),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _PropertyImage extends StatelessWidget {
  const _PropertyImage({required this.property});
  final HowzyProperty property;

  @override
  Widget build(BuildContext context) {
    if (property.imageUrl == null) {
      return Container(
        color: property.categoryColor,
        child: Center(child: Icon(property.categoryIcon, size: 40, color: property.categoryTextColor.withValues(alpha: 0.5))),
      );
    }
    return CachedNetworkImage(
      imageUrl: property.imageUrl!,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(
        color: property.categoryColor,
        child: Center(child: Icon(property.categoryIcon, size: 40, color: property.categoryTextColor.withValues(alpha: 0.3))),
      ),
      errorWidget: (_, _, _) => Container(
        color: property.categoryColor,
        child: Center(child: Icon(property.categoryIcon, size: 40, color: property.categoryTextColor.withValues(alpha: 0.4))),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.property});
  final HowzyProperty property;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: property.categoryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(property.categoryIcon, size: 10, color: property.categoryTextColor),
          const SizedBox(width: 3),
          Text(property.categoryLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: property.categoryTextColor)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaved, required this.onTap, this.small = false});
  final bool isSaved, small;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sz = small ? 26.0 : 30.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sz, height: sz,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(isSaved ? Icons.favorite : Icons.favorite_border, size: sz * 0.5, color: isSaved ? Colors.red : AppColors.slate500),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating, this.small = false});
  final double rating;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 5 : 7, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 10, color: Color(0xFFFBBF24)),
          const SizedBox(width: 2),
          Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _PossessionBadge extends StatelessWidget {
  const _PossessionBadge({required this.possession});
  final String possession;

  @override
  Widget build(BuildContext context) {
    final isReady = possession.toLowerCase().contains('ready');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isReady ? const Color(0xFF10B981) : const Color(0xFFD97706),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(possession, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }
}

// ─── Property Detail Sheet ─────────────────────────────────────────────────
class PropertyDetailSheet extends StatelessWidget {
  const PropertyDetailSheet({super.key, required this.property});
  final HowzyProperty property;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.97,
      minChildSize: 0.5,
      builder: (ctx, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: scrollCtrl,
          padding: EdgeInsets.zero,
          children: [
            // Handle
            Center(child: Container(margin: const EdgeInsets.only(top: 10, bottom: 4), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.slate200, borderRadius: BorderRadius.circular(2)))),
            // Hero image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Stack(
                children: [
                  SizedBox(height: 220, width: double.infinity, child: _PropertyImage(property: property)),
                  Container(height: 220, decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0x66000000)]))),
                  Positioned(top: 12, right: 12, child: GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(width: 34, height: 34, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.close, size: 16, color: AppColors.slate700)),
                  )),
                  Positioned(bottom: 12, left: 16, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(property.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                      const SizedBox(height: 3),
                      Row(children: [
                        const Icon(Icons.location_on, size: 13, color: Colors.white70),
                        const SizedBox(width: 2),
                        Text('${property.location}, ${property.city}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ]),
                    ],
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('PRICE RANGE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.slate400, letterSpacing: 1)),
                        const SizedBox(height: 2),
                        Text(property.price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.indigo600)),
                      ])),
                      _RatingBadge(rating: property.rating),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.indigoLight, borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      const Icon(Icons.auto_awesome, size: 15, color: AppColors.indigo600),
                      const SizedBox(width: 8),
                      Expanded(child: Text(property.usp, style: const TextStyle(fontSize: 13, color: Color(0xFF3730A3), fontWeight: FontWeight.w600))),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  if (property.bhkOptions.isNotEmpty) ...[
                    const Text('CONFIGURATIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.slate400, letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, children: property.bhkOptions.map((b) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(color: AppColors.indigoLight, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFC7D2FE))),
                      child: Text(b, style: const TextStyle(color: AppColors.indigo600, fontWeight: FontWeight.w700, fontSize: 13)),
                    )).toList()),
                    const SizedBox(height: 16),
                  ],
                  if (property.amenities.isNotEmpty) ...[
                    const Text('AMENITIES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.slate400, letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, children: property.amenities.map((a) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(20)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.check_circle, size: 12, color: AppColors.emerald500),
                        const SizedBox(width: 4),
                        Text(a, style: const TextStyle(fontSize: 12, color: AppColors.slate700, fontWeight: FontWeight.w500)),
                      ]),
                    )).toList()),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text('Enquire Now', style: TextStyle(fontWeight: FontWeight.w800)),
                      style: FilledButton.styleFrom(backgroundColor: AppColors.indigo600, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    )),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone_outlined, size: 16),
                      label: const Text('Call'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.slate700, padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20)),
                    ),
                  ]),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

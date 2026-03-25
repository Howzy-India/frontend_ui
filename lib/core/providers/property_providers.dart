import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/property_data_standalone.dart';

// ─── Filter state ─────────────────────────────────────────────────────────────
class PropertyFilterState {
  const PropertyFilterState({
    this.search = '',
    this.city = '',
    this.location = '',
    this.type = '',
    this.budget = '',
    this.moveIn = '',
    this.sort = '',
  });

  final String search;
  final String city;
  final String location;
  final String type;
  final String budget;
  final String moveIn;
  final String sort;

  PropertyFilterState copyWith({
    String? search, String? city, String? location,
    String? type, String? budget, String? moveIn, String? sort,
  }) => PropertyFilterState(
    search:   search   ?? this.search,
    city:     city     ?? this.city,
    location: location ?? this.location,
    type:     type     ?? this.type,
    budget:   budget   ?? this.budget,
    moveIn:   moveIn   ?? this.moveIn,
    sort:     sort     ?? this.sort,
  );

  bool get hasFilters =>
      search.isNotEmpty || city.isNotEmpty || location.isNotEmpty ||
      type.isNotEmpty || budget.isNotEmpty || moveIn.isNotEmpty;
}

// ─── Filter notifier ─────────────────────────────────────────────────────────
class PropertyFilterNotifier extends Notifier<PropertyFilterState> {
  @override
  PropertyFilterState build() => const PropertyFilterState();

  void setSearch(String v)   => state = state.copyWith(search: v);
  void setCity(String v)     => state = state.copyWith(city: v);
  void setLocation(String v) => state = state.copyWith(location: v);
  void setType(String v)     => state = state.copyWith(type: v);
  void setBudget(String v)   => state = state.copyWith(budget: v);
  void setMoveIn(String v)   => state = state.copyWith(moveIn: v);
  void setSort(String v)     => state = state.copyWith(sort: v);
  void clear()               => state = const PropertyFilterState();
}

final propertyFilterProvider =
    NotifierProvider<PropertyFilterNotifier, PropertyFilterState>(
        PropertyFilterNotifier.new);

// ─── Saved properties ─────────────────────────────────────────────────────────
class SavedPropertiesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  bool isSaved(String id) => state.contains(id);
}

final savedPropertiesProvider =
    NotifierProvider<SavedPropertiesNotifier, Set<String>>(
        SavedPropertiesNotifier.new);

// ─── Filtered properties provider ────────────────────────────────────────────
final filteredPropertiesProvider = Provider<List<HowzyProperty>>((ref) {
  final filters = ref.watch(propertyFilterProvider);
  var list = mockProperties;

  if (filters.search.isNotEmpty) {
    final q = filters.search.toLowerCase();
    list = list.where((p) =>
      p.name.toLowerCase().contains(q) ||
      p.location.toLowerCase().contains(q) ||
      p.city.toLowerCase().contains(q) ||
      p.developer.toLowerCase().contains(q)).toList();
  }
  if (filters.city.isNotEmpty) {
    list = list.where((p) => p.city.toLowerCase() == filters.city.toLowerCase()).toList();
  }
  if (filters.type.isNotEmpty) {
    list = list.where((p) => p.category.toLowerCase() == filters.type.toLowerCase()).toList();
  }
  if (filters.budget.isNotEmpty) {
    list = list.where((p) => p.budgetRange == filters.budget).toList();
  }

  // Sort
  switch (filters.sort) {
    case 'Price: Low to High':
      list = [...list]..sort((a, b) => a.priceValue.compareTo(b.priceValue));
    case 'Price: High to Low':
      list = [...list]..sort((a, b) => b.priceValue.compareTo(a.priceValue));
    case 'Rating':
      list = [...list]..sort((a, b) => b.rating.compareTo(a.rating));
    default:
      break;
  }

  return list;
});

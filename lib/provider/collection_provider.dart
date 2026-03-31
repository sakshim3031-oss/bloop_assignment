import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../services/collection_cache_service.dart';
import '../models/collection.dart';


// BUG: Original code directly modified Firestore document data by adding fields,
// which can lead to unexpected side effects since the map may be reused internally.
//
// FIX: Although I used mocked data instead of Firestore in my implementation,
// the correct approach is to create a copy of the map using
// Map<String, dynamic>.from(data) before modifying it to ensure safe behavior.


final collectionListProvider =
AsyncNotifierProvider<CollectionListNotifier, List<Collection>>(
  CollectionListNotifier.new,
);

class CollectionListNotifier extends AsyncNotifier<List<Collection>> {
  final _cacheService = CollectionCacheService();
  static const String _cacheKey = 'collections';

  @override
  Future<List<Collection>> build() async {
    await _cacheService.init();

    final cached = await _cacheService.getCollections(_cacheKey);
    if (cached != null && cached.isNotEmpty) {
      state = AsyncData(cached);
    }

    unawaited(_fetchAndCacheFreshData());

    return cached ?? [];
  }

  Future<void> _fetchAndCacheFreshData() async {
    try {
      final freshData = await _mockFetchFromFirestore();
      await _cacheService.saveCollections(_cacheKey, freshData);
      state = AsyncData(freshData);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<List<Collection>> _mockFetchFromFirestore() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Collection(
        id: '1',
        title: 'Physics Fundamentals',
        description: 'Mechanics, thermodynamics aur waves ke interactive lessons.',
        coverImageUrl: 'https://picsum.photos/id/1015/800/600',
        creatorId: 'creator1',
        isPremium: false,
        sectionCount: 15,
        createdAt: DateTime(2024, 1, 15),
      ),
      Collection(
        id: '2',
        title: 'Advanced Mathematics',
        description: 'Calculus, linear algebra aur differential equations.',
        coverImageUrl: 'https://picsum.photos/id/201/800/600',
        creatorId: 'creator2',
        isPremium: true,
        sectionCount: 12,
        createdAt: DateTime(2024, 2, 10),
      ),
      Collection(
        id: '3',
        title: 'Organic Chemistry',
        description: 'Carbon compounds, reactions aur mechanisms.',
        coverImageUrl: 'https://picsum.photos/id/301/800/600',
        creatorId: 'creator1',
        isPremium: false,
        sectionCount: 18,
        createdAt: DateTime(2024, 1, 5),
      ),
      Collection(
        id: '4',
        title: 'Biology Essentials',
        description: 'Cell biology, genetics aur human physiology.',
        coverImageUrl: 'https://picsum.photos/id/401/800/600',
        creatorId: 'creator3',
        isPremium: false,
        sectionCount: 14,
        createdAt: DateTime(2024, 3, 1),
      ),
      Collection(
        id: '5',
        title: 'Computer Science Fundamentals',
        description: 'Algorithms, data structures aur programming basics.',
        coverImageUrl: 'https://picsum.photos/id/501/800/600',
        creatorId: 'creator4',
        isPremium: false,
        sectionCount: 20,
        createdAt: DateTime(2024, 2, 20),
      ),
      Collection(
        id: '6',
        title: 'Quantum Physics',
        description: 'Advanced quantum mechanics aur wave-particle duality.',
        coverImageUrl: 'https://picsum.photos/id/29/800/600',
        creatorId: 'creator2',
        isPremium: true,
        sectionCount: 10,
        createdAt: DateTime(2024, 3, 15),
      ),
    ];
  }

  // Public refresh method
  Future<void> refresh() async {
    state = const AsyncLoading();
    await _fetchAndCacheFreshData();
  }
}
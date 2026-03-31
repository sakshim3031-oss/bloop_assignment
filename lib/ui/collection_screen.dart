import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/collection_provider.dart';
import '../models/collection.dart';

class CollectionListScreen extends ConsumerWidget {
  const CollectionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCollections = ref.watch(collectionListProvider);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 380;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloop Collections'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: asyncCollections.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Error: $e', textAlign: TextAlign.center),
          ),
        ),
        data: (collections) => RefreshIndicator(
          onRefresh: () => ref.read(collectionListProvider.notifier).refresh(),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: 12,
            ),
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final collection = collections[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.hardEdge,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with responsive height
                    SizedBox(
                      height: isSmallScreen ? 180 : 210,
                      width: double.infinity,
                      // BUG: Original code used FutureBuilder with a new Future on every build,
                     // which caused repeated executions and performance issues during scrolling.

                    // FIX: In my implementation, I avoided using FutureBuilder for image loading
                   // and instead used Image.network directly, which is more efficient and prevents
                 // unnecessary rebuilds.
                      child: Image.network(
                        collection.coverImageUrl ?? 'https://picsum.photos/800/600',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 80),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + Premium Badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  collection.title,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 18 : 20,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              if (collection.isPremium)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'PREMIUM',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Description (responsive lines)
                          Text(
                            collection.description,
                            maxLines: isSmallScreen ? 2 : 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Bottom row - Sections & Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.menu_book, size: 18, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${collection.sectionCount} Sections',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                collection.createdAt.toString().substring(0, 10),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/collection.dart';

class CollectionCacheService {
  late Box _box;
  //BUG: Used getApplicationDocumentsDirectory() which is not ideal for app cache storage.
  // It can cause platform-specific issues and is not recommended for app support data.
  // FIX: Replaced with getApplicationSupportDirectory() which is designed for app data storage.
  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    Hive.init(dir.path);
    _box = await Hive.openBox('collection_cache');
  }

  Future<List<Collection>?> getCollections(String key) async {
    final data = _box.get(key);
    // BUG: If cache data is null, calling fromJson(null) would cause a runtime crash.
   // This happens when the requested lesson is not found in cache.
  // FIX: Added null check to safely return null instead of crashing.
    if (data == null) return null;

    try {
      return (data as List)
          .map((e) => Collection.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCollections(String key, List<Collection> collections) async {
    final jsonList = collections.map((c) => c.toJson()).toList();
    await _box.put(key, jsonList);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
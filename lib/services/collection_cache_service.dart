import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/collection.dart';

class CollectionCacheService {
  late Box _box;

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    Hive.init(dir.path);
    _box = await Hive.openBox('collection_cache');
  }

  /// Cache miss gracefully return null (no throw)
  Future<List<Collection>?> getCollections(String key) async {
    final data = _box.get(key);
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
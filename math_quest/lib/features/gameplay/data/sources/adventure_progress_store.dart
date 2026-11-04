import 'package:hive/hive.dart';

abstract interface class AdventureProgressStore {
  Object? read(String key);

  Future<void> write(String key, Object value);

  Future<void> delete(String key);
}

class HiveAdventureProgressStore implements AdventureProgressStore {
  final Box<dynamic> _box;

  HiveAdventureProgressStore(this._box);

  @override
  Object? read(String key) => _box.get(key);

  @override
  Future<void> write(String key, Object value) => _box.put(key, value);

  @override
  Future<void> delete(String key) => _box.delete(key);
}

import 'package:hive_flutter/hive_flutter.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/domain/repositories/i_profile_repository.dart';
import 'package:math_quest/features/profile_and_stats/data/models/user_profile_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final Box<UserProfileModel> _profileBox;
  final Box _settingsBox;

  ProfileRepositoryImpl({
    required this._profileBox,
    required this._settingsBox,
  });

  @override
  Future<UserProfile?> getActiveProfile() async {
    final activeId = _settingsBox.get('active_profile_id') as String?;
    if (activeId == null) return null;
    final model = _profileBox.get(activeId);
    return model?.toDomain();
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    final model = UserProfileModel.fromDomain(profile);
    await _profileBox.put(profile.id, model);
  }

  @override
  Future<List<UserProfile>> getAllProfiles() async {
    return _profileBox.values.map((m) => m.toDomain()).toList();
  }

  @override
  Future<void> setActiveProfileId(String id) async {
    await _settingsBox.put('active_profile_id', id);
  }
}

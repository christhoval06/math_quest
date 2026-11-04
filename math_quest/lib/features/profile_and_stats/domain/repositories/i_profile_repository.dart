import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';

abstract class IProfileRepository {
  Future<UserProfile?> getActiveProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<List<UserProfile>> getAllProfiles();
  Future<void> setActiveProfileId(String id);
}

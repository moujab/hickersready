import 'package:hive_flutter/hive_flutter.dart';

import '../models/account.dart';
import '../models/contributor.dart';
import '../models/guide.dart';
import '../models/invitation.dart';
import '../models/town.dart';
import '../models/upcoming_hike.dart';
import '../models/user_profile.dart';
import 'mock_data.dart';

/// On-device persistence backed by Hive. Boxes are seeded once from
/// [MockData] the first time the app runs, then read/written directly —
/// this is the local stand-in for the future Spring Boot/MySQL backend.
class LocalStore {
  static const _invitationsBox = 'invitations';
  static const _townsBox = 'towns';
  static const _guidesBox = 'guides';
  static const _contributorsBox = 'contributors';
  static const _upcomingHikesBox = 'upcomingHikes';
  static const _userProfileBox = 'userProfile';
  static const _userProfileKey = 'profile';
  static const _accountsBox = 'accounts';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<Map>(_invitationsBox),
      Hive.openBox<Map>(_townsBox),
      Hive.openBox<Map>(_guidesBox),
      Hive.openBox<Map>(_contributorsBox),
      Hive.openBox<Map>(_upcomingHikesBox),
      Hive.openBox<Map>(_userProfileBox),
      Hive.openBox<Map>(_accountsBox),
    ]);
    await _seedIfEmpty();
  }

  static Future<void> _seedIfEmpty() async {
    final invitations = Hive.box<Map>(_invitationsBox);
    if (invitations.isEmpty) {
      for (final item in MockData.invitations) {
        await invitations.put(item.id, item.toMap());
      }
    }

    final towns = Hive.box<Map>(_townsBox);
    if (towns.isEmpty) {
      for (final item in MockData.towns) {
        await towns.put(item.id, item.toMap());
      }
    }

    final guides = Hive.box<Map>(_guidesBox);
    if (guides.isEmpty) {
      for (final item in MockData.guides) {
        await guides.put(item.id, item.toMap());
      }
    }

    final contributors = Hive.box<Map>(_contributorsBox);
    if (contributors.isEmpty) {
      for (final item in MockData.contributors) {
        await contributors.put(item.id, item.toMap());
      }
    }

    final upcomingHikes = Hive.box<Map>(_upcomingHikesBox);
    if (upcomingHikes.isEmpty) {
      for (final item in MockData.upcomingHikes) {
        await upcomingHikes.put(item.id, item.toMap());
      }
    }
  }

  static List<Invitation> get invitations => Hive
      .box<Map>(_invitationsBox)
      .values
      .map((map) => Invitation.fromMap(Map<String, dynamic>.from(map)))
      .toList();

  static List<Town> get towns => Hive
      .box<Map>(_townsBox)
      .values
      .map((map) => Town.fromMap(Map<String, dynamic>.from(map)))
      .toList();

  static List<Guide> get guides => Hive
      .box<Map>(_guidesBox)
      .values
      .map((map) => Guide.fromMap(Map<String, dynamic>.from(map)))
      .toList();

  static List<Contributor> get contributors => Hive
      .box<Map>(_contributorsBox)
      .values
      .map((map) => Contributor.fromMap(Map<String, dynamic>.from(map)))
      .toList();

  static List<UpcomingHike> get upcomingHikes => Hive
      .box<Map>(_upcomingHikesBox)
      .values
      .map((map) => UpcomingHike.fromMap(Map<String, dynamic>.from(map)))
      .toList();

  static Future<void> putInvitation(Invitation invitation) =>
      Hive.box<Map>(_invitationsBox).put(invitation.id, invitation.toMap());

  static Future<void> deleteInvitation(String id) => Hive.box<Map>(_invitationsBox).delete(id);

  static Future<void> putTown(Town town) => Hive.box<Map>(_townsBox).put(town.id, town.toMap());

  static Future<void> deleteTown(String id) => Hive.box<Map>(_townsBox).delete(id);

  static Future<void> putGuide(Guide guide) => Hive.box<Map>(_guidesBox).put(guide.id, guide.toMap());

  static Future<void> deleteGuide(String id) => Hive.box<Map>(_guidesBox).delete(id);

  static Future<void> putContributor(Contributor contributor) =>
      Hive.box<Map>(_contributorsBox).put(contributor.id, contributor.toMap());

  static Future<void> deleteContributor(String id) => Hive.box<Map>(_contributorsBox).delete(id);

  static UserProfile get userProfile {
    final map = Hive.box<Map>(_userProfileBox).get(_userProfileKey);
    return map == null ? UserProfile.empty : UserProfile.fromMap(Map<String, dynamic>.from(map));
  }

  static Future<void> putUserProfile(UserProfile profile) =>
      Hive.box<Map>(_userProfileBox).put(_userProfileKey, profile.toMap());

  static Account? getAccount(String email) {
    final map = Hive.box<Map>(_accountsBox).get(email);
    return map == null ? null : Account.fromMap(Map<String, dynamic>.from(map));
  }

  static Future<void> putAccount(Account account) =>
      Hive.box<Map>(_accountsBox).put(account.email, account.toMap());
}

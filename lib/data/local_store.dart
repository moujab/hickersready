import 'package:hive_flutter/hive_flutter.dart';

import '../models/contributor.dart';
import '../models/guide.dart';
import '../models/invitation.dart';
import '../models/town.dart';
import '../models/upcoming_hike.dart';
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

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<Map>(_invitationsBox),
      Hive.openBox<Map>(_townsBox),
      Hive.openBox<Map>(_guidesBox),
      Hive.openBox<Map>(_contributorsBox),
      Hive.openBox<Map>(_upcomingHikesBox),
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
}

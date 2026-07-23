import '../models/admin_user.dart';
import '../models/contributor.dart';
import '../models/guide.dart';
import '../models/invitation.dart';
import '../models/town.dart';
import '../models/upcoming_hike.dart';
import '../models/user_profile.dart';
import 'api_client.dart';

/// Talks to the Spring Boot/MySQL backend for all app data. Was previously
/// backed by on-device Hive storage; the method names/shapes are kept the
/// same as that version to minimize churn at call sites, but every call is
/// now a network request.
class LocalStore {
  static Future<List<Invitation>> get invitations async {
    final list = await ApiClient.getList('/invitations');
    return list.map((m) => Invitation.fromMap(Map<String, dynamic>.from(m as Map))).toList();
  }

  static Future<List<Town>> get towns async {
    final list = await ApiClient.getList('/towns');
    return list.map((m) => Town.fromMap(Map<String, dynamic>.from(m as Map))).toList();
  }

  static Future<List<Guide>> get guides async {
    final list = await ApiClient.getList('/guides');
    return list.map((m) => Guide.fromMap(Map<String, dynamic>.from(m as Map))).toList();
  }

  static Future<List<Contributor>> get contributors async {
    final list = await ApiClient.getList('/contributors');
    return list.map((m) => Contributor.fromMap(Map<String, dynamic>.from(m as Map))).toList();
  }

  static Future<List<UpcomingHike>> get upcomingHikes async {
    final list = await ApiClient.getList('/upcoming-hikes');
    return list.map((m) => UpcomingHike.fromMap(Map<String, dynamic>.from(m as Map))).toList();
  }

  static Future<void> putInvitation(Invitation invitation) =>
      ApiClient.put('/invitations/${invitation.id}', invitation.toMap());

  static Future<void> deleteInvitation(String id) => ApiClient.delete('/invitations/$id');

  static Future<void> putTown(Town town) => ApiClient.put('/towns/${town.id}', town.toMap());

  static Future<void> deleteTown(String id) => ApiClient.delete('/towns/$id');

  static Future<void> putGuide(Guide guide) => ApiClient.put('/guides/${guide.id}', guide.toMap());

  static Future<void> deleteGuide(String id) => ApiClient.delete('/guides/$id');

  static Future<void> putContributor(Contributor contributor) =>
      ApiClient.put('/contributors/${contributor.id}', contributor.toMap());

  static Future<void> deleteContributor(String id) => ApiClient.delete('/contributors/$id');

  /// Keyed by the given account email (the logged-in user), not the
  /// [UserProfile.email] form field.
  static Future<UserProfile> getUserProfile(String accountEmail) async {
    final map = await ApiClient.getObject('/profile/$accountEmail');
    return UserProfile.fromMap(map);
  }

  static Future<void> putUserProfile(String accountEmail, UserProfile profile) =>
      ApiClient.put('/profile/$accountEmail', profile.toMap());

  // --- Admin: registered-user management ---

  static Future<List<AdminUser>> get adminUsers async {
    final list = await ApiClient.getList('/admin/users');
    return list.map((m) => AdminUser.fromMap(Map<String, dynamic>.from(m as Map))).toList();
  }

  /// Creates a new account + profile. Returns 'success', or 'emailTaken' if an
  /// account with that email already exists, or 'error' on any other failure.
  static Future<String> createAdminUser({
    required String email,
    required String password,
    required String name,
    required String father,
    required String family,
    required String phone,
  }) async {
    final response = await ApiClient.post('/admin/users', {
      'email': email,
      'password': password,
      'name': name,
      'father': father,
      'family': family,
      'phone': phone,
    });
    if (response.statusCode == 200) return 'success';
    if (response.statusCode == 409) return 'emailTaken';
    return 'error';
  }

  /// Updates an existing user's profile fields; a non-empty [password] resets
  /// their password, an empty one leaves it unchanged.
  static Future<void> updateAdminUser({
    required String email,
    required String password,
    required String name,
    required String father,
    required String family,
    required String phone,
  }) =>
      ApiClient.put('/admin/users/$email', {
        'email': email,
        'password': password,
        'name': name,
        'father': father,
        'family': family,
        'phone': phone,
      });

  static Future<void> deleteAdminUser(String email) => ApiClient.delete('/admin/users/$email');
}

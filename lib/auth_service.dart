import 'package:pocketbase/pocketbase.dart';

import 'pocketbase_service.dart';

/// PocketBase `users` auth (DharmaCore parity).
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  PocketBase get _pb => PocketBaseService().pb;

  bool get isLoggedIn => _pb.authStore.isValid;

  RecordModel? get user => _pb.authStore.record;

  String? get userId => user?.id;

  String? get email => user?.getStringValue('email');

  /// `full`, `jobs_only`, or null/empty (treated as full).
  String get role {
    final r = user?.getStringValue('role')?.trim();
    if (r == null || r.isEmpty) return 'full';
    return r;
  }

  bool get isJobsOnly => role == 'jobs_only';

  Future<void> login({required String email, required String password}) async {
    await _pb.collection('users').authWithPassword(email.trim(), password);
  }

  void logout() => _pb.authStore.clear();
}

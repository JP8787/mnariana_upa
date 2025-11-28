import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final userProvider = StateProvider<User?>((ref) => null);

// Simple user update helpers
final userUpdaterProvider = Provider((ref) => UserUpdater(ref));

class UserUpdater {
  final Ref ref;
  UserUpdater(this.ref);

  void updateProfile(User newUser) {
    ref.read(userProvider.notifier).state = newUser;
  }

  void changeEmail(String newEmail) {
    final u = ref.read(userProvider);
    if (u != null) {
      u.email = newEmail;
      ref.read(userProvider.notifier).state = u;
    }
  }
}

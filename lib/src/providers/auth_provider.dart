import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class AuthState {
  final bool loading;
  final String? token;
  final User? user;
  AuthState({this.loading = false, this.token, this.user});

  AuthState copyWith({bool? loading, String? token, User? user}) => AuthState(
      loading: loading ?? this.loading,
      token: token ?? this.token,
      user: user ?? this.user);
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(seconds: 1));
    // mock auth success
    if (email.contains('@') && password.length >= 6) {
      final u = User(id: 'u1', name: 'Juan Perez', email: email);
      state = AuthState(loading: false, token: 'mock-token', user: u);
    } else {
      state = state.copyWith(loading: false);
      throw Exception('Credenciales inválidas');
    }
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

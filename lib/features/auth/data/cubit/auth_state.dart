abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final bool hasRole;

  AuthSuccess({required this.hasRole});
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final bool hasRole;
  final Map<String, dynamic>? userData;

  AuthSuccess({required this.hasRole, this.userData});
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

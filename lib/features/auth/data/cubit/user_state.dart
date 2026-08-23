import 'package:flutter/material.dart';

@immutable
sealed class UserCubitState {
  const UserCubitState();
}

class UserCubitInitial extends UserCubitState {
  const UserCubitInitial();
}

class UserDataLoading extends UserCubitState {
  const UserDataLoading();
}

class UserDataLoaded extends UserCubitState {
  final Map<String, dynamic> userData;

  const UserDataLoaded(this.userData);
}

class UserDataFailure extends UserCubitState {
  final String errorMessage;

  const UserDataFailure(this.errorMessage);
}

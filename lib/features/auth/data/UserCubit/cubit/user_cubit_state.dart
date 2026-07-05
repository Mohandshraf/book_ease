import 'package:flutter/material.dart';

@immutable
sealed class UserCubitState {}

class UserCubitInitial extends UserCubitState {}

class UserDataLoading extends UserCubitState {}

class UserDataLoaded extends UserCubitState {
  final Map<String, dynamic> userData;

  UserDataLoaded(this.userData);
}

class UserDataFailure extends UserCubitState {
  final String errorMessage;

  UserDataFailure(this.errorMessage);
}

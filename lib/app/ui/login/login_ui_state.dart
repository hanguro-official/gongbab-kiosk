import 'package:gongbab/domain/entities/auth/login_entity.dart';

abstract class LoginUiState {}

class Initial extends LoginUiState {}

class Loading extends LoginUiState {}

class Success extends LoginUiState {
  final LoginEntity loginEntity;

  Success(this.loginEntity);
}

class Error extends LoginUiState {
  final String message;

  Error(this.message);
}
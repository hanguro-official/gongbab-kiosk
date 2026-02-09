abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String phoneNumber;
  final String password;

  LoginButtonPressed({required this.phoneNumber, required this.password});
}
import 'package:flutter/foundation.dart';
import 'package:gongbab/app/ui/login/login_event.dart';
import 'package:gongbab/app/ui/login/login_ui_state.dart';
import 'package:gongbab/domain/usecases/login_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;

  LoginUiState _uiState = Initial();

  LoginUiState get uiState => _uiState;

  LoginViewModel(this._loginUseCase);

  Future<void> onEvent(LoginEvent event) async {
    if (event is LoginButtonPressed) {
      _uiState = Loading();
      notifyListeners();

      final result = await _loginUseCase.execute(
        code: '${event.phoneNumber}${event.password}',
      );

      result.when(
        success: (loginEntity) {
          _uiState = Success(loginEntity);
        },
        failure: (String success, Map<String, dynamic>? data) {
          _uiState = Error('Login failed with code: $success');
        },
        error: (message) {
          _uiState = Error(message);
        },
      );
      notifyListeners();
    }
  }

  void resetState() {
    _uiState = Initial();
    notifyListeners();
  }
}

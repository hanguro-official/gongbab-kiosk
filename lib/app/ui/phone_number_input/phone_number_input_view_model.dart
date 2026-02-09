import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:gongbab/domain/usecases/get_employee_candidates_usecase.dart';
import 'package:gongbab/domain/usecases/get_kiosk_status_usecase.dart';
import 'package:gongbab/domain/usecases/kiosk_check_in_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_ui_state.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_event.dart';
import 'package:gongbab/domain/entities/lookup/employee_match.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';

@injectable
class PhoneNumberInputViewModel extends ChangeNotifier {
  final GetKioskStatusUseCase _getKioskStatusUseCase;
  final GetEmployeeCandidatesUseCase _getEmployeeCandidatesUseCase;
  final KioskCheckInUseCase _kioskCheckInUseCase;
  final Connectivity _connectivity;
  final AuthTokenManager _authTokenManager;

  PhoneNumberInputViewModel(
    this._getKioskStatusUseCase,
    this._getEmployeeCandidatesUseCase,
    this._kioskCheckInUseCase,
    this._connectivity,
    this._authTokenManager,
  );

  PhoneNumberInputUiState _uiState = Initial();

  PhoneNumberInputUiState get uiState => _uiState;

  void _setUiState(PhoneNumberInputUiState newState) {
    _uiState = newState;
    notifyListeners();
  }

  void onEvent(PhoneNumberInputEvent event) {
    switch (event) {
      case ScreenInitialized():
        _fetchKioskStatus();
        break;
      case PhoneNumberEntered():
        _getEmployeeCandidates(event.phoneNumber);
        break;
      case EmployeeSelected():
        _checkIn(event.employee);
        break;
    }
  }

  Future<void> _fetchKioskStatus() async {
    _setUiState(Loading());

    final int? restaurantId = _authTokenManager.getRestaurantId();
    final String? kioskCode = _authTokenManager.getKioskCode();
    final String clientTime = DateTime.now().toIso8601String();

    if (restaurantId == null || kioskCode == null) {
      _setUiState(Error('Restaurant ID or Kiosk Code not found. Please log in again.'));
      return;
    }

    final connectivityResult = await _connectivity.checkConnectivity();
    final isWifiConnected = connectivityResult.contains(ConnectivityResult.wifi);

    final result = await _getKioskStatusUseCase.execute(
      restaurantId: restaurantId,
      kioskCode: kioskCode,
      clientTime: clientTime,
    );

    result.when(
      success: (kioskStatus) {
        _setUiState(KioskStatusLoaded(kioskStatus, isWifiConnected));
      },
      failure: (code, data) {
        _setUiState(Error('Failed to fetch kiosk status: $code'));
      },
      error: (error) {
        _setUiState(Error('Error fetching kiosk status: $error'));
      },
    );
  }

  Future<void> _getEmployeeCandidates(String phoneNumber) async {
    _setUiState(Loading());

    final int? restaurantId = _authTokenManager.getRestaurantId();

    if (restaurantId == null) {
      _setUiState(Error('Restaurant ID not found. Please log in again.'));
      return;
    }

    final result = await _getEmployeeCandidatesUseCase.execute(
      restaurantId: restaurantId,
      phoneLastFour: phoneNumber,
    );

    result.when(
      success: (lookup) {
        if (lookup.matches.isEmpty) {
          _setUiState(Error('해당 번호로 직원을 찾을 수 없습니다.'));
        } else if (lookup.matches.length == 1) {
          _checkIn(lookup.matches.first);
        } else {
          _setUiState(EmployeeCandidatesLoaded(lookup.matches));
        }
      },
      failure: (code, data) {
        _setUiState(Error('직원 조회에 실패했습니다: $code'));
      },
      error: (error) {
        _setUiState(Error('직원 조회 중 오류가 발생했습니다: $error'));
      },
    );
  }

  Future<void> _checkIn(EmployeeMatch employee) async {
    _setUiState(Loading());

    final String clientTime = DateTime.now().toIso8601String();
    final int? restaurantId = _authTokenManager.getRestaurantId();
    final String? kioskCode = _authTokenManager.getKioskCode();

    if (restaurantId == null || kioskCode == null) {
      _setUiState(Error('Restaurant ID or Kiosk Code not found. Please log in again.'));
      return;
    }

    final result = await _kioskCheckInUseCase.execute(
      employeeId: employee.employeeId,
      clientTime: clientTime,
      restaurantId: restaurantId,
      kioskCode: kioskCode,
    );

    result.when(
      success: (checkInResult) {
        if (checkInResult.result == 'LOGGED') {
          _setUiState(CheckInSuccess(checkInResult));
        } else if (checkInResult.result == 'ALREADY_LOGGED') {
          _setUiState(AlreadyLogged(checkInResult.message));
        } else {
          _setUiState(Error(checkInResult.message));
        }
      },
      failure: (code, data) {
        _setUiState(Error('체크인에 실패했습니다: $code'));
      },
      error: (error) {
        _setUiState(Error('체크인 중 오류가 발생했습니다: $error'));
      },
    );
  }
}

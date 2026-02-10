import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_event.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_ui_state.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_view_model.dart';
import 'package:gongbab/domain/entities/check_in/kiosk_check_in.dart';
import 'package:gongbab/domain/entities/lookup/employee_lookup.dart';
import 'package:gongbab/domain/entities/lookup/employee_match.dart';
import 'package:gongbab/domain/entities/status/kiosk_status.dart';
import 'package:gongbab/domain/usecases/get_employee_candidates_usecase.dart';
import 'package:gongbab/domain/usecases/get_kiosk_status_usecase.dart';
import 'package:gongbab/domain/usecases/kiosk_check_in_usecase.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';
import 'package:gongbab/domain/utils/result.dart' hide Error;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../test_helper.dart';
import 'phone_number_input_view_model_test.mocks.dart';

@GenerateMocks([
  GetKioskStatusUseCase,
  GetEmployeeCandidatesUseCase,
  KioskCheckInUseCase,
  Connectivity,
  AuthTokenManager
])
void main() {
  late PhoneNumberInputViewModel viewModel;
  late MockGetKioskStatusUseCase mockGetKioskStatusUseCase;
  late MockGetEmployeeCandidatesUseCase mockGetEmployeeCandidatesUseCase;
  late MockKioskCheckInUseCase mockKioskCheckInUseCase;
  late MockConnectivity mockConnectivity;
  late MockAuthTokenManager mockAuthTokenManager;

  setUpAll(() {
    registerDummyFallbacks();
  });

  setUp(() {
    mockGetKioskStatusUseCase = MockGetKioskStatusUseCase();
    mockGetEmployeeCandidatesUseCase = MockGetEmployeeCandidatesUseCase();
    mockKioskCheckInUseCase = MockKioskCheckInUseCase();
    mockConnectivity = MockConnectivity();
    mockAuthTokenManager = MockAuthTokenManager();

    when(mockAuthTokenManager.getRestaurantId()).thenReturn(1);
    when(mockAuthTokenManager.getKioskCode()).thenReturn('kiosk-001');

    viewModel = PhoneNumberInputViewModel(
      mockGetKioskStatusUseCase,
      mockGetEmployeeCandidatesUseCase,
      mockKioskCheckInUseCase,
      mockConnectivity,
      mockAuthTokenManager,
    );
  });

  group('PhoneNumberInputViewModel', () {
    final kioskStatus = KioskStatus(status: 'ok', serverTime: '2024-01-01');
    final employeeMatch = EmployeeMatch(employeeId: 1, name: 'Test User', companyId: 1, companyName: 'Test Company');
    final checkInSuccess = KioskCheckIn(result: 'LOGGED', message: 'Success', mealLogId: 1, mealType: 'LUNCH', mealDate: '2024-01-01', employee: null, company: null, eatenAt: '2024-01-01');
    final checkInAlreadyLogged = KioskCheckIn(result: 'ALREADY_LOGGED', message: '이미 체크인되었습니다.', mealLogId: 1, mealType: 'LUNCH', mealDate: '2024-01-01', employee: null, company: null, eatenAt: '2024-01-01');

    test('ScreenInitialized event fetches kiosk status and wifi status (connected)', () async {
      // Arrange
      final completer = Completer<void>();
      viewModel.addListener(() {
        if (viewModel.uiState is KioskStatusLoaded) {
          if(!completer.isCompleted) completer.complete();
        }
      });
      when(mockGetKioskStatusUseCase.execute(
        restaurantId: anyNamed('restaurantId'),
        kioskCode: anyNamed('kioskCode'),
        clientTime: anyNamed('clientTime'),
      )).thenAnswer((_) async => Result.success(kioskStatus));
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Act
      viewModel.onEvent(ScreenInitialized());
      await completer.future;

      // Assert
      expect(viewModel.uiState, isA<KioskStatusLoaded>());
      expect((viewModel.uiState as KioskStatusLoaded).kioskStatus, kioskStatus);
      expect((viewModel.uiState as KioskStatusLoaded).isWifiConnected, true);
    });

    test('ScreenInitialized event fetches kiosk status and wifi status (disconnected)', () async {
      // Arrange
      final completer = Completer<void>();
      viewModel.addListener(() {
        if (viewModel.uiState is KioskStatusLoaded) {
          if(!completer.isCompleted) completer.complete();
        }
      });
      when(mockGetKioskStatusUseCase.execute(
        restaurantId: anyNamed('restaurantId'),
        kioskCode: anyNamed('kioskCode'),
        clientTime: anyNamed('clientTime'),
      )).thenAnswer((_) async => Result.success(kioskStatus));
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.none]);

      // Act
      viewModel.onEvent(ScreenInitialized());
      await completer.future;

      // Assert
      expect(viewModel.uiState, isA<KioskStatusLoaded>());
      expect((viewModel.uiState as KioskStatusLoaded).kioskStatus, kioskStatus);
      expect((viewModel.uiState as KioskStatusLoaded).isWifiConnected, false);
    });

    test('PhoneNumberEntered event with 0 candidates returns Error state', () async {
      // Arrange
      final completer = Completer<void>();
      viewModel.addListener(() {
        if (viewModel.uiState is Error) {
          if(!completer.isCompleted) completer.complete();
        }
      });
      final emptyLookup = EmployeeLookup(matches: [], count: 0);
      when(mockGetEmployeeCandidatesUseCase.execute(
        restaurantId: anyNamed('restaurantId'),
        phoneLastFour: anyNamed('phoneLastFour'),
      )).thenAnswer((_) async => Result.success(emptyLookup));

      // Act
      viewModel.onEvent(PhoneNumberEntered('1234'));
      await completer.future;

      // Assert
      expect(viewModel.uiState, isA<Error>());
    });

    test('PhoneNumberEntered event with multiple candidates returns EmployeeCandidatesLoaded state', () async {
      // Arrange
      final completer = Completer<void>();
      viewModel.addListener(() {
        if (viewModel.uiState is EmployeeCandidatesLoaded) {
          if(!completer.isCompleted) completer.complete();
        }
      });
      final multipleLookup = EmployeeLookup(matches: [employeeMatch, employeeMatch], count: 2);
      when(mockGetEmployeeCandidatesUseCase.execute(
        restaurantId: anyNamed('restaurantId'),
        phoneLastFour: anyNamed('phoneLastFour'),
      )).thenAnswer((_) async => Result.success(multipleLookup));

      // Act
      viewModel.onEvent(PhoneNumberEntered('1234'));
      await completer.future;

      // Assert
      expect(viewModel.uiState, isA<EmployeeCandidatesLoaded>());
      expect((viewModel.uiState as EmployeeCandidatesLoaded).employees.length, 2);
    });

    test('PhoneNumberEntered event with one candidate triggers check-in and returns CheckInSuccess', () async {
      // Arrange
      final completer = Completer<void>();
      viewModel.addListener(() {
        if (viewModel.uiState is CheckInSuccess) {
          if(!completer.isCompleted) completer.complete();
        }
      });
      final singleLookup = EmployeeLookup(matches: [employeeMatch], count: 1);
      when(mockGetEmployeeCandidatesUseCase.execute(
        restaurantId: anyNamed('restaurantId'),
        phoneLastFour: anyNamed('phoneLastFour'),
      )).thenAnswer((_) async => Result.success(singleLookup));
      when(mockKioskCheckInUseCase.execute(
        employeeId: anyNamed('employeeId'),
        clientTime: anyNamed('clientTime'),
        restaurantId: anyNamed('restaurantId'),
        kioskCode: anyNamed('kioskCode'),
      )).thenAnswer((_) async => Result.success(checkInSuccess));

      // Act
      viewModel.onEvent(PhoneNumberEntered('1234'));
      await completer.future;

      // Assert
      expect(viewModel.uiState, isA<CheckInSuccess>());
    });
    
    test('PhoneNumberEntered event with one candidate triggers check-in and returns AlreadyLogged', () async {
      // Arrange
      final completer = Completer<void>();
      viewModel.addListener(() {
        if (viewModel.uiState is AlreadyLogged) {
          if(!completer.isCompleted) completer.complete();
        }
      });
      final singleLookup = EmployeeLookup(matches: [employeeMatch], count: 1);
      when(mockGetEmployeeCandidatesUseCase.execute(
        restaurantId: anyNamed('restaurantId'),
        phoneLastFour: anyNamed('phoneLastFour'),
      )).thenAnswer((_) async => Result.success(singleLookup));
      when(mockKioskCheckInUseCase.execute(
        employeeId: anyNamed('employeeId'),
        clientTime: anyNamed('clientTime'),
        restaurantId: anyNamed('restaurantId'),
        kioskCode: anyNamed('kioskCode'),
      )).thenAnswer((_) async => Result.success(checkInAlreadyLogged));

      // Act
      viewModel.onEvent(PhoneNumberEntered('1234'));
      await completer.future;

      // Assert
      expect(viewModel.uiState, isA<AlreadyLogged>());
      expect((viewModel.uiState as AlreadyLogged).message, '이미 체크인되었습니다.');
    });

    test('EmployeeSelected event triggers check-in and returns CheckInSuccess', () async {
      // Arrange
      final completer = Completer<void>();
      viewModel.addListener(() {
        if (viewModel.uiState is CheckInSuccess) {
          if(!completer.isCompleted) completer.complete();
        }
      });
      when(mockKioskCheckInUseCase.execute(
        employeeId: anyNamed('employeeId'),
        clientTime: anyNamed('clientTime'),
        restaurantId: anyNamed('restaurantId'),
        kioskCode: anyNamed('kioskCode'),
      )).thenAnswer((_) async => Result.success(checkInSuccess));

      // Act
      viewModel.onEvent(EmployeeSelected(employeeMatch));
      await completer.future;

      // Assert
      expect(viewModel.uiState, isA<CheckInSuccess>());
    });
  });
}
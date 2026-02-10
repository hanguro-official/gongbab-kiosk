import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:gongbab/app/ui/login/login_view_model.dart';
import 'package:gongbab/app/ui/login/login_ui_state.dart';
import 'package:gongbab/app/ui/login/login_event.dart';
import 'package:gongbab/domain/entities/auth/login_entity.dart';
import 'package:gongbab/domain/entities/auth/restaurant_entity.dart';
import 'package:gongbab/domain/utils/result.dart' as result_util;

import 'mocks.mocks.dart';
import '../../../test_helper.dart';

void main() {
  late LoginViewModel viewModel;
  late MockLoginUseCase mockLoginUseCase;
  late MockAuthTokenManager mockAuthTokenManager;

  const loginEntity = LoginEntity(
    accessToken: 'test_access',
    refreshToken: 'test_refresh',
    restaurant: RestaurantEntity(id: 1, name: 'Test Restaurant'),
  );

  setUpAll(() {
    registerDummyFallbacks();
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockAuthTokenManager = MockAuthTokenManager();
    viewModel = LoginViewModel(mockLoginUseCase, mockAuthTokenManager);
  });

  group('LoginViewModel', () {
    test('initial state is Initial', () {
      expect(viewModel.uiState, isA<Initial>());
    });

    test('successful login updates state to Success and saves info', () async {
      // Arrange
      final completer = Completer<void>();
      viewModel.addListener(() {
        if (viewModel.uiState is Success) {
          if (!completer.isCompleted) completer.complete();
        }
      });
      when(mockLoginUseCase.execute(code: anyNamed('code')))
          .thenAnswer((_) async => result_util.Result.success(loginEntity));
      when(mockAuthTokenManager.saveRestaurantInfo(any, any)).thenAnswer((_) => Future.value());
      when(mockAuthTokenManager.saveTokens(any, any)).thenAnswer((_) => Future.value());

      // Act
      viewModel.onEvent(LoginButtonPressed(phoneNumber: '1234', password: 'A'));
      
      // Assert
      await completer.future.timeout(const Duration(seconds: 1), onTimeout: () => throw 'Test timed out');
      
      expect(viewModel.uiState, isA<Success>());
      expect((viewModel.uiState as Success).loginEntity, loginEntity);
      verify(mockAuthTokenManager.saveRestaurantInfo(loginEntity.restaurant!.id, 'FCT-092')).called(1);
      verify(mockAuthTokenManager.saveTokens(loginEntity.accessToken, loginEntity.refreshToken)).called(1);
    });

    test('failed login (failure) updates state to Error', () async {
      // Arrange
      final completer = Completer<void>();
      viewModel.addListener(() {
        if (viewModel.uiState is Error) {
          if (!completer.isCompleted) completer.complete();
        }
      });
      when(mockLoginUseCase.execute(code: anyNamed('code')))
          .thenAnswer((_) async => result_util.Result.failure('LOGIN_FAILED', null));

      // Act
      viewModel.onEvent(LoginButtonPressed(phoneNumber: '1234', password: 'A'));
      await completer.future.timeout(const Duration(seconds: 1), onTimeout: () => throw 'Test timed out');

      // Assert
      expect(viewModel.uiState, isA<Error>());
      expect((viewModel.uiState as Error).message, 'Login failed with code: LOGIN_FAILED');
      verifyNever(mockAuthTokenManager.saveRestaurantInfo(any, any));
    });

    test('failed login (error) updates state to Error', () async {
      // Arrange
      final completer = Completer<void>();
      viewModel.addListener(() {
        if (viewModel.uiState is Error) {
          if (!completer.isCompleted) completer.complete();
        }
      });
      when(mockLoginUseCase.execute(code: anyNamed('code')))
          .thenAnswer((_) async => result_util.Result.error('Network error'));

      // Act
      viewModel.onEvent(LoginButtonPressed(phoneNumber: '1234', password: 'A'));
      await completer.future.timeout(const Duration(seconds: 1), onTimeout: () => throw 'Test timed out');

      // Assert
      expect(viewModel.uiState, isA<Error>());
      expect((viewModel.uiState as Error).message, 'Network error');
      verifyNever(mockAuthTokenManager.saveRestaurantInfo(any, any));
    });

    test('resetState sets state to Initial', () {
      // Arrange
      when(mockLoginUseCase.execute(code: anyNamed('code')))
          .thenAnswer((_) async => result_util.Result.success(loginEntity));
      when(mockAuthTokenManager.saveRestaurantInfo(any, any)).thenAnswer((_) => Future.value());
      when(mockAuthTokenManager.saveTokens(any, any)).thenAnswer((_) => Future.value());

      // Act
      viewModel.onEvent(LoginButtonPressed(phoneNumber: '1234', password: 'A'));
      viewModel.resetState();

      // Assert
      expect(viewModel.uiState, isA<Initial>());
    });
  });
}
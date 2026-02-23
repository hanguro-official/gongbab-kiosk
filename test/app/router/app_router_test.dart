import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gongbab/app/router/app_router.dart';
import 'package:gongbab/app/router/app_routes.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_router_test.mocks.dart';

@GenerateMocks([AuthTokenManager, GoRouterState])
void main() {
  late MockAuthTokenManager mockAuthTokenManager;
  late AppRouter appRouter;
  late MockGoRouterState mockGoRouterState;

  setUp(() {
    mockAuthTokenManager = MockAuthTokenManager();
    appRouter = AppRouter(mockAuthTokenManager);
    mockGoRouterState = MockGoRouterState();
  });

  final mockContext = MockBuildContext();

  group('AppRouter Redirect Logic', () {
    test('redirects to login if no tokens and trying to access protected route', () async {
      // Arrange
      when(mockAuthTokenManager.getAccessToken()).thenReturn(null);
      when(mockAuthTokenManager.getRefreshToken()).thenReturn(null);
      when(mockGoRouterState.matchedLocation).thenReturn(AppRoutes.phoneNumberInput);

      // Act
      final redirectPath = appRouter.redirectLogic(mockContext, mockGoRouterState);

      // Assert
      expect(redirectPath, AppRoutes.login);
    });

    test('does not redirect if no tokens and already on login route', () async {
      // Arrange
      when(mockAuthTokenManager.getAccessToken()).thenReturn(null);
      when(mockAuthTokenManager.getRefreshToken()).thenReturn(null);
      when(mockGoRouterState.matchedLocation).thenReturn(AppRoutes.login);

      // Act
      final redirectPath = appRouter.redirectLogic(mockContext, mockGoRouterState);

      // Assert
      expect(redirectPath, isNull);
    });

    test('redirects from login to phone number input if tokens exist', () async {
      // Arrange
      when(mockAuthTokenManager.getAccessToken()).thenReturn('token');
      when(mockAuthTokenManager.getRefreshToken()).thenReturn('token');
      when(mockGoRouterState.matchedLocation).thenReturn(AppRoutes.login);

      // Act
      final redirectPath = appRouter.redirectLogic(mockContext, mockGoRouterState);

      // Assert
      expect(redirectPath, AppRoutes.phoneNumberInput);
    });

    test('does not redirect if tokens exist and on a protected route', () async {
      // Arrange
      when(mockAuthTokenManager.getAccessToken()).thenReturn('token');
      when(mockAuthTokenManager.getRefreshToken()).thenReturn('token');
      when(mockGoRouterState.matchedLocation).thenReturn(AppRoutes.phoneNumberInput);

      // Act
      final redirectPath = appRouter.redirectLogic(mockContext, mockGoRouterState);

      // Assert
      expect(redirectPath, isNull);
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
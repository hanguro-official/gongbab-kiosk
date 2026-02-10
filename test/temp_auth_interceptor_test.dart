import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';
import 'package:gongbab/data/network/auth_interceptor.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'temp_auth_interceptor_test.mocks.dart'; // Changed to temp_auth_interceptor_test.mocks.dart

@GenerateMocks([AuthTokenManager, Dio, ErrorInterceptorHandler]) // Added ErrorInterceptorHandler
void main() {
  late AuthInterceptor authInterceptor;
  late MockAuthTokenManager mockAuthTokenManager;
  late MockDio mockDio;
  late MockErrorInterceptorHandler mockErrorHandler; // Added mockErrorHandler

  setUp(() {
    mockAuthTokenManager = MockAuthTokenManager();
    mockDio = MockDio();
    mockErrorHandler = MockErrorInterceptorHandler(); // Initialized mockErrorHandler
    authInterceptor = AuthInterceptor(mockAuthTokenManager, mockDio);
  });

  test('AuthInterceptor should call dio.post with correct arguments', () async {
    // Arrange
    when(mockAuthTokenManager.getRefreshToken()).thenReturn('test_refresh_token');
    when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
      (_) => Future.value(
        Response(
          requestOptions: RequestOptions(path: '/api/v1/auth/refresh'),
          data: {'accessToken': 'new_access_token', 'refreshToken': 'new_refresh_token'},
          statusCode: 200,
        ),
      ),
    );

    final error = DioException(
      requestOptions: RequestOptions(path: '/protected'),
      response: Response(requestOptions: RequestOptions(path: '/protected'), statusCode: 401),
    );

    // Act
    authInterceptor.onError(error, mockErrorHandler); // Removed await
    await Future.microtask(() {}); // Allow async operations to complete

    // Assert
    verify(mockDio.post(
      '/api/v1/auth/refresh',
      data: {'refreshToken': 'test_refresh_token'},
    )).called(1);
  });
}

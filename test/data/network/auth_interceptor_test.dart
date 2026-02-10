import 'package:matcher/matcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';
import 'package:gongbab/data/network/auth_interceptor.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_interceptor_test.mocks.dart';

@GenerateMocks([AuthTokenManager, Dio, ErrorInterceptorHandler, RequestInterceptorHandler])
void main() {
  late AuthInterceptor authInterceptor;
  late MockAuthTokenManager mockAuthTokenManager;
  late MockDio mockDio;
  late MockErrorInterceptorHandler mockErrorHandler;
  late MockRequestInterceptorHandler mockRequestHandler;

  setUp(() {
    mockAuthTokenManager = MockAuthTokenManager();
    mockDio = MockDio();
    mockErrorHandler = MockErrorInterceptorHandler();
    mockRequestHandler = MockRequestInterceptorHandler();
    authInterceptor = AuthInterceptor(mockAuthTokenManager, mockDio);
  });

  group('AuthInterceptor: onRequest', () {
    test(
        'should add Authorization header if access token exists and not a refresh request',
        () {
      // Arrange
      when(mockAuthTokenManager.getAccessToken()).thenReturn('test_access_token');
      final options = RequestOptions(path: '/some/api');

      // Act
      authInterceptor.onRequest(options, mockRequestHandler);

      // Assert
      expect(options.headers['Authorization'], 'Bearer test_access_token');
      verify(mockRequestHandler.next(options)).called(1);
    });

    test('should not add Authorization header if access token is null',
        () {
      // Arrange
      when(mockAuthTokenManager.getAccessToken()).thenReturn(null);
      final options = RequestOptions(path: '/some/api');

      // Act
      authInterceptor.onRequest(options, mockRequestHandler);

      // Assert
      expect(options.headers['Authorization'], isNull);
      verify(mockRequestHandler.next(options)).called(1);
    });

    test('should not add Authorization header if it is a refresh request',
        () {
      // Arrange
      when(mockAuthTokenManager.getAccessToken()).thenReturn('test_access_token');
      final options = RequestOptions(path: '/api/v1/auth/refresh');

      // Act
      authInterceptor.onRequest(options, mockRequestHandler);

      // Assert
      expect(options.headers['Authorization'], isNull);
      verify(mockRequestHandler.next(options)).called(1);
    });
  });

  group('AuthInterceptor: onError', () {
    group('when status code is 401 (Unauthorized)', () {
      test('should successfully refresh token and retry original request',
          () async {
        // Arrange
        final originalRequestOptions =
            RequestOptions(path: '/protected/resource');
        final error = DioException(
          requestOptions: originalRequestOptions,
          response:
              Response(requestOptions: originalRequestOptions, statusCode: 401),
        );

        final newTokensResponse = {
          'accessToken': 'new_access_token',
          'refreshToken': 'new_refresh_token',
          'restaurant': {'id': 1, 'name': 'Test Restaurant'}
        };
        final retriedResponse = Response(
            requestOptions: originalRequestOptions,
            data: 'retried_data',
            statusCode: 200);

        when(mockAuthTokenManager.getRefreshToken()).thenReturn('old_refresh_token');
        when(mockDio.post(
          '/api/v1/auth/refresh',
          data: anyNamed('data'),
        )).thenAnswer((_) => Future.value(Response(
              requestOptions: RequestOptions(path: '/api/v1/auth/refresh'),
              data: newTokensResponse,
              statusCode: 200,
            )));
        when(mockAuthTokenManager.saveTokens(any, any))
            .thenAnswer((_) => Future.value());
        when(mockAuthTokenManager.getAccessToken()).thenReturn('new_access_token');
        when(mockDio.fetch(any)).thenAnswer((_) => Future.value(retriedResponse));

        // Act
        authInterceptor.onError(error, mockErrorHandler);
        await Future.microtask(() {}); // Allow async operations to complete

        // Assert
        verify(mockAuthTokenManager.saveTokens(
                'new_access_token', 'new_refresh_token'))
            .called(1);

        final verification = verify(mockDio.fetch(captureAny));
        verification.called(1);
        expect(verification.captured.first.headers['Authorization'], 'Bearer new_access_token');

        verify(mockErrorHandler.resolve(retriedResponse)).called(1);
        verifyNever(mockErrorHandler.next(any));

        // Capture the arguments passed to mockDio.post
        verify(mockDio.post(any, data: any)).called(1);
      });

      test(
          'should clear tokens and propagate error if no refresh token is available',
          () async {
        // Arrange
        final error = DioException(
          requestOptions: RequestOptions(path: '/protected'),
          response: Response(
              requestOptions: RequestOptions(path: '/protected'),
              statusCode: 401),
        );
        when(mockAuthTokenManager.getRefreshToken()).thenReturn(null);
        when(mockAuthTokenManager.clearTokens()).thenAnswer((_) => Future.value());

        // Act
        authInterceptor.onError(error, mockErrorHandler);
        await Future.microtask(() {}); // Allow async operations to complete

        // Assert
        verify(mockAuthTokenManager.clearTokens()).called(1);
        verify(mockErrorHandler.next(error)).called(1);
        verifyNever(mockErrorHandler.resolve(any));
      });

      test('should clear tokens and propagate error if refresh API call fails',
          () async {
        // Arrange
        final error = DioException(
          requestOptions: RequestOptions(path: '/protected'),
          response: Response(
              requestOptions: RequestOptions(path: '/protected'),
              statusCode: 401),
        );
        final refreshError =
            DioException(requestOptions: RequestOptions(path: '...'));

        when(mockAuthTokenManager.getRefreshToken()).thenReturn('old_refresh_token');
        when(mockDio.post(any, data: anyNamed('data')))
            .thenThrow(refreshError);
        when(mockAuthTokenManager.clearTokens()).thenAnswer((_) => Future.value());

        // Act
        authInterceptor.onError(error, mockErrorHandler);
        await Future.microtask(() {}); // Allow async operations to complete

        // Assert
        verify(mockAuthTokenManager.clearTokens()).called(1);
        verify(mockErrorHandler.next(error)).called(1);
        verifyNever(mockErrorHandler.resolve(any));
      });

      test(
          'should clear tokens and propagate error if refresh token request itself returns 401',
          () async {
        // Arrange
        final refreshRequestOptions =
            RequestOptions(path: '/api/v1/auth/refresh');
        final error = DioException(
          requestOptions: refreshRequestOptions,
          response:
              Response(requestOptions: refreshRequestOptions, statusCode: 401),
        );
        when(mockAuthTokenManager.clearTokens()).thenAnswer((_) => Future.value());

        // Act
        authInterceptor.onError(error, mockErrorHandler);
        await Future.microtask(() {}); // Allow async operations to complete

        // Assert
        verify(mockAuthTokenManager.clearTokens()).called(1);
        verifyNever(mockAuthTokenManager.getRefreshToken());
        verify(mockErrorHandler.next(error)).called(1);
        verifyNever(mockErrorHandler.resolve(any));
      });
    });

    group('when status code is not 401', () {
      test('should just pass the error through for other status codes like 403',
          () async {
        // Arrange
        final error = DioException(
          requestOptions: RequestOptions(path: '/any'),
          response: Response(
              requestOptions: RequestOptions(path: '/any'), statusCode: 403),
        );

        // Act
        authInterceptor.onError(error, mockErrorHandler);
        await Future.microtask(() {}); // Allow async operations to complete

        // Assert
        verifyZeroInteractions(mockAuthTokenManager);
        verifyZeroInteractions(mockDio);
        verify(mockErrorHandler.next(error)).called(1);
        verifyNever(mockErrorHandler.resolve(any));
      });

      test('should just pass the error through for other status codes like 500',
          () async {
        // Arrange
        final error = DioException(
          requestOptions: RequestOptions(path: '/any'),
          response: Response(
              requestOptions: RequestOptions(path: '/any'), statusCode: 500),
        );

        // Act
        authInterceptor.onError(error, mockErrorHandler);
        await Future.microtask(() {}); // Allow async operations to complete

        // Assert
        verifyZeroInteractions(mockAuthTokenManager);
        verifyZeroInteractions(mockDio);
        verify(mockErrorHandler.next(error)).called(1);
        verifyNever(mockErrorHandler.resolve(any));
      });
    });
  });
}
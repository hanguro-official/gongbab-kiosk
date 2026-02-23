import 'package:dio/dio.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';
import 'package:gongbab/data/models/auth/login_model.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final AuthTokenManager _authTokenManager;
  final Dio _dio;
  late final Dio _tokenDio;


  AuthInterceptor(this._authTokenManager, this._dio) {
    // Create a new Dio instance for token refresh.
    // It shares the same base options but won't be affected by the main instance's interceptors.
    _tokenDio = Dio(BaseOptions(
      baseUrl: _dio.options.baseUrl,
      connectTimeout: _dio.options.connectTimeout,
      receiveTimeout: _dio.options.receiveTimeout,
      contentType: 'application/json',
      headers: {'Accept': 'application/json'},
    ));
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final accessToken = _authTokenManager.getAccessToken();
    if (accessToken != null && !options.path.contains('/auth/refresh')) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the error is a 401 Unauthorized error
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // If the failed request was the token refresh itself, clear tokens and log out.
    if (err.requestOptions.path.contains('/auth/refresh')) {
      await _authTokenManager.clearTokens();
      return handler.next(err);
    }

    final refreshToken = _authTokenManager.getRefreshToken();
    if (refreshToken == null) {
      await _authTokenManager.clearTokens();
      return handler.next(err);
    }

    try {
      final response = await _tokenDio.post(
        '/api/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      Logger().d(
          'uri:${response.realUri}\nstatusCode: ${response.statusCode}\ndata: ${response.data}');
      final loginModel = LoginModel.fromJson(response.data);
      await _authTokenManager.saveTokens(
        loginModel.accessToken,
        loginModel.refreshToken,
      );

      // Retry the original request with the new access token.
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer ${loginModel.accessToken}';

      final retryResponse = await _dio.fetch(options);
      return handler.resolve(retryResponse);
    } on DioException {
      // If the refresh token is invalid, clear tokens and proceed with the error.
      await _authTokenManager.clearTokens();
      return handler.next(err);
    }
  }
}

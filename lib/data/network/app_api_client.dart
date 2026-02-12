import 'package:dio/dio.dart';
import 'package:gongbab/config/api_config.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';
import 'package:gongbab/data/network/auth_interceptor.dart';
import 'package:gongbab/data/network/rest_api_client.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@singleton
class AppApiClient extends RestApiClient {
  AppApiClient(AuthTokenManager authTokenManager, Dio dio) : super(dio: dio) {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);
    dio.options.contentType = 'application/json';
    dio.options.headers = {
      'Accept': 'application/json',
    };

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 130,
    ));
    dio.interceptors.add(AuthInterceptor(authTokenManager, dio));
  }
}

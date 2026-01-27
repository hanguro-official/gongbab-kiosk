import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio() {
    _dio.options.baseUrl = 'YOUR_BASE_API_URL'; // 실제 API 기본 URL로 변경 필요
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);

    // 개발 환경에서 API 요청/응답 로깅을 위한 인터셉터 추가
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  // 예시: 키오스크 상태를 가져오는 API 호출
  Future<Map<String, dynamic>> getKioskStatus() async {
    try {
      final response = await _dio.get('/kiosk/status'); // 실제 엔드포인트로 변경 필요
      return response.data;
    } on DioException catch (e) {
      // Dio 에러 처리
      throw Exception('Failed to load kiosk status: ${e.message}');
    } catch (e) {
      // 일반 에러 처리
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // 예시: 식권 체크인 API 호출
  Future<Map<String, dynamic>> checkTicket(String ticketId) async {
    try {
      final response = await _dio.post(
        '/ticket/checkin', // 실제 엔드포인트로 변경 필요
        data: {'ticketId': ticketId},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to check ticket: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}

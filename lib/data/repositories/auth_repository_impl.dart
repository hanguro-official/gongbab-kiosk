import 'package:gongbab/data/network/api_service.dart';
import 'package:gongbab/domain/entities/auth/login_entity.dart'; // Import new entity
import 'package:gongbab/domain/repositories/auth_repository.dart';
import 'package:gongbab/domain/utils/result.dart';
import 'package:injectable/injectable.dart'; // injectable 임포트

@LazySingleton(as: AuthRepository) // AuthRepository 인터페이스의 구현체로 지연 로딩 싱글톤 등록
class AuthRepositoryImpl implements AuthRepository { // AuthRepository 인터페이스 구현
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<Result<LoginEntity>> login({
    required String code,
  }) async {
    final result = await _apiService.login(code: code);
    return result.when(
      success: (model) => Result.success(model.toEntity()),
      failure: (code, data) => Result.failure(code, data),
      error: (error) => Result.error(error),
    );
  }

  @override
  Future<Result<LoginEntity>> refreshToken({
    required String refreshToken,
  }) async {
    final result = await _apiService.refreshToken(refreshToken: refreshToken);
    return result.when(
      success: (model) => Result.success(model.toEntity()),
      failure: (code, data) => Result.failure(code, data),
      error: (error) => Result.error(error),
    );
  }
}

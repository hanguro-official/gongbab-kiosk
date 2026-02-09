import 'package:gongbab/data/auth/auth_token_manager.dart';
import 'package:gongbab/domain/entities/auth/login_entity.dart';
import 'package:gongbab/domain/repositories/kiosk_repository.dart';
import 'package:gongbab/domain/utils/result.dart';

class LoginUseCase {
  final KioskRepository repository;
  final AuthTokenManager authTokenManager;

  LoginUseCase(this.repository, this.authTokenManager);

  Future<Result<LoginEntity>> execute({
    required String code,
  }) async {
    final result = await repository.login(code: code);
    return result.when(
      success: (loginEntity) async {
        await authTokenManager.saveTokens(loginEntity.accessToken, loginEntity.refreshToken);
        return Result.success(loginEntity);
      },
      failure: (code, data) => Result.failure(code, data),
      error: (error) => Result.error(error),
    );
  }
}

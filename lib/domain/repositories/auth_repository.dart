import 'package:gongbab/domain/entities/auth/login_entity.dart';
import 'package:gongbab/domain/utils/result.dart';

abstract class AuthRepository {
  Future<Result<LoginEntity>> login({
    required String code,
  });

  Future<Result<LoginEntity>> refreshToken({
    required String refreshToken,
  });
}
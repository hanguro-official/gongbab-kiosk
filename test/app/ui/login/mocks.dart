import 'package:mockito/annotations.dart';
import 'package:gongbab/domain/usecases/login_usecase.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';

@GenerateMocks([
  LoginUseCase,
  AuthTokenManager,
])
void main() {}

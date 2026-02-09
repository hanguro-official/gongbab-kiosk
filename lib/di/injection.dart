import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../domain/repositories/auth_repository.dart';
import 'injection.config.dart'; // 코드 생성기가 생성할 파일
import 'package:gongbab/domain/repositories/kiosk_repository.dart';
import 'package:gongbab/domain/usecases/get_kiosk_status_usecase.dart';
import 'package:gongbab/domain/usecases/get_employee_candidates_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gongbab/domain/usecases/kiosk_check_in_usecase.dart'; // Import new use case
import 'package:gongbab/domain/usecases/login_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';
import 'package:dio/dio.dart'; // New import

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  await getIt.init();
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton // Use lazySingleton for use cases
  GetKioskStatusUseCase getKioskStatusUseCase(KioskRepository repository) {
    return GetKioskStatusUseCase(repository);
  }

  @lazySingleton
  GetEmployeeCandidatesUseCase getEmployeeCandidatesUseCase(KioskRepository repository) {
    return GetEmployeeCandidatesUseCase(repository);
  }

  @lazySingleton
  KioskCheckInUseCase kioskCheckInUseCase(KioskRepository repository) {
    return KioskCheckInUseCase(repository);
  }

  @lazySingleton
  LoginUseCase loginUseCase(AuthRepository repository, AuthTokenManager authTokenManager) {
    return LoginUseCase(repository, authTokenManager);
  }

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton // Provide Dio instance
  Dio get dio => Dio();
}
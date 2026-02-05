import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart'; // 코드 생성기가 생성할 파일
import 'package:gongbab/domain/repositories/kiosk_repository.dart';
import 'package:gongbab/domain/usecases/get_kiosk_status_usecase.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  getIt.init();
}

@module
abstract class RegisterModule {
  @lazySingleton // Use lazySingleton for use cases
  GetKioskStatusUseCase getKioskStatusUseCase(KioskRepository repository) {
    return GetKioskStatusUseCase(repository);
  }
}
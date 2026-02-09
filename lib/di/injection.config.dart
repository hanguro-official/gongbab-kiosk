// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../app/ui/phone_number_input/phone_number_input_view_model.dart'
    as _i513;
import '../data/auth/auth_token_manager.dart' as _i702;
import '../data/network/api_service.dart' as _i589;
import '../data/network/app_api_client.dart' as _i133;
import '../data/repositories/auth_repository_impl.dart' as _i74;
import '../data/repositories/kiosk_repository_impl.dart' as _i400;
import '../domain/repositories/auth_repository.dart' as _i800;
import '../domain/repositories/kiosk_repository.dart' as _i587;
import '../domain/usecases/get_employee_candidates_usecase.dart' as _i649;
import '../domain/usecases/get_kiosk_status_usecase.dart' as _i5;
import '../domain/usecases/kiosk_check_in_usecase.dart' as _i440;
import '../domain/usecases/login_usecase.dart' as _i634;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i133.AppApiClient>(() => _i133.AppApiClient());
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.singleton<_i589.ApiService>(
        () => _i589.ApiService(gh<_i133.AppApiClient>()));
    gh.lazySingleton<_i702.AuthTokenManager>(
        () => _i702.AuthTokenManager(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i800.AuthRepository>(
        () => _i74.AuthRepositoryImpl(gh<_i589.ApiService>()));
    gh.lazySingleton<_i587.KioskRepository>(
        () => _i400.KioskRepositoryImpl(gh<_i589.ApiService>()));
    gh.lazySingleton<_i634.LoginUseCase>(() => registerModule.loginUseCase(
          gh<_i800.AuthRepository>(),
          gh<_i702.AuthTokenManager>(),
        ));
    gh.lazySingleton<_i5.GetKioskStatusUseCase>(() =>
        registerModule.getKioskStatusUseCase(gh<_i587.KioskRepository>()));
    gh.lazySingleton<_i649.GetEmployeeCandidatesUseCase>(() => registerModule
        .getEmployeeCandidatesUseCase(gh<_i587.KioskRepository>()));
    gh.lazySingleton<_i440.KioskCheckInUseCase>(
        () => registerModule.kioskCheckInUseCase(gh<_i587.KioskRepository>()));
    gh.factory<_i513.PhoneNumberInputViewModel>(
        () => _i513.PhoneNumberInputViewModel(
              gh<_i5.GetKioskStatusUseCase>(),
              gh<_i649.GetEmployeeCandidatesUseCase>(),
              gh<_i440.KioskCheckInUseCase>(),
              gh<_i895.Connectivity>(),
            ));
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}

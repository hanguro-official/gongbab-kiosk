// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../app/ui/phone_number_input/phone_number_input_view_model.dart'
    as _i513;
import '../data/network/api_service.dart' as _i589;
import '../data/network/app_api_client.dart' as _i133;
import '../data/repositories/kiosk_repository_impl.dart' as _i400;
import '../domain/repositories/kiosk_repository.dart' as _i587;
import '../domain/usecases/get_kiosk_status_usecase.dart' as _i5;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i133.AppApiClient>(() => _i133.AppApiClient());
    gh.singleton<_i589.ApiService>(
        () => _i589.ApiService(gh<_i133.AppApiClient>()));
    gh.lazySingleton<_i587.KioskRepository>(
        () => _i400.KioskRepositoryImpl(gh<_i589.ApiService>()));
    gh.lazySingleton<_i5.GetKioskStatusUseCase>(() =>
        registerModule.getKioskStatusUseCase(gh<_i587.KioskRepository>()));
    gh.factory<_i513.PhoneNumberInputViewModel>(
        () => _i513.PhoneNumberInputViewModel(gh<_i5.GetKioskStatusUseCase>()));
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}

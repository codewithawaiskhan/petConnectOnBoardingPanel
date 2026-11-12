import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/commission_settings_remote_data_source.dart';
import '../data/repositories/commission_settings_repository_impl.dart';
import '../domain/repositories/commission_settings_repository.dart';
import '../domain/usecases/commission_settings_usecases.dart';
import '../presentation/providers/commission_settings_provider.dart';

void initCommissionSettingsDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<CommissionSettingsRemoteDataSource>(
    () => CommissionSettingsRemoteDataSourceImpl(
      apiServices: sl<ApiServices>(),
    ),
  );

  sl.registerLazySingleton<CommissionSettingsRepository>(
    () => CommissionSettingsRepositoryImpl(
      remoteDataSource: sl<CommissionSettingsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetCompanyCommissionPoliciesUseCase>(
    () => GetCompanyCommissionPoliciesUseCase(
      repository: sl<CommissionSettingsRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateCompanyCommissionPolicyUseCase>(
    () => CreateCompanyCommissionPolicyUseCase(
      repository: sl<CommissionSettingsRepository>(),
    ),
  );

  sl.registerLazySingleton<GetRenewalCommissionSettingsUseCase>(
    () => GetRenewalCommissionSettingsUseCase(
      repository: sl<CommissionSettingsRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateRenewalCommissionSettingsUseCase>(
    () => CreateRenewalCommissionSettingsUseCase(
      repository: sl<CommissionSettingsRepository>(),
    ),
  );

  sl.registerFactory<CommissionSettingsProvider>(
    () => CommissionSettingsProvider(
      getCompanyCommissionPoliciesUseCase:
          sl<GetCompanyCommissionPoliciesUseCase>(),
      createCompanyCommissionPolicyUseCase:
          sl<CreateCompanyCommissionPolicyUseCase>(),
      getRenewalCommissionSettingsUseCase:
          sl<GetRenewalCommissionSettingsUseCase>(),
      createRenewalCommissionSettingsUseCase:
          sl<CreateRenewalCommissionSettingsUseCase>(),
    ),
  );
}


import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/taxonomy_remote_data_source.dart';
import '../data/repositories/taxonomy_repository_impl.dart';
import '../domain/repositories/taxonomy_repository.dart';
import '../domain/usecases/taxonomy_usecases.dart';

void initTaxonomyDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<TaxonomyRemoteDataSource>(
    () => TaxonomyRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<TaxonomyRepository>(
    () => TaxonomyRepositoryImpl(
      remoteDataSource: sl<TaxonomyRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<TaxonomyUseCases>(
    () => TaxonomyUseCases(repository: sl<TaxonomyRepository>()),
  );
}

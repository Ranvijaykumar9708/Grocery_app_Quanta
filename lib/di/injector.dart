import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../core/services/local_storage.dart';
import '../data/datasources/local/auth_local_datasource.dart';
import '../data/datasources/remote/auth_remote_datasource.dart';
import '../data/repositories/auth/auth_repository_impl.dart';
import '../domain/repositories/auth/auth_repository.dart';
import '../domain/usecases/auth/login_usecase.dart';
import '../domain/usecases/auth/register_usecase.dart';
import '../presentation/viewmodels/auth/auth_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => ApiClient(client: sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(sharedPreferences: sl()),
  );

  // Features - Auth
  // ViewModels
  sl.registerFactory(
    () => AuthProvider(
      loginUseCase: sl(),
      registerUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(localStorage: sl()),
  );
}


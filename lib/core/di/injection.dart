import 'package:get_it/get_it.dart';

import '../../presentation/cubit/user_cubit.dart';
import '../database/app_database.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Database
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Repository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<AppDatabase>()),
  );

  // Cubit
  getIt.registerFactory<UserCubit>(() => UserCubit(getIt<UserRepository>()));
}

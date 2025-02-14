import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/register_user.dart';
import '../../infrastructure/datasources/firebase_auth_datasource.dart';
import '../../infrastructure/repositories/auth_repository_impl.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(
        () => AuthBloc(
      signIn: sl(),
      registerUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  // Repositories
  sl.registerLazySingleton<IAuthRepository>(
        () => AuthRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton(
        () => FirebaseAuthDatasource(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
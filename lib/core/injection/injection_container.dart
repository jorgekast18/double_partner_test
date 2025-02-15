import 'package:double_partner_test/domain/repositories/i_address_repository.dart';
import 'package:double_partner_test/domain/usecases/authenticated.dart';
import 'package:double_partner_test/domain/usecases/create_address.dart';
import 'package:double_partner_test/domain/usecases/get_addresses.dart';
import 'package:double_partner_test/domain/usecases/sign_out.dart';
import 'package:double_partner_test/infrastructure/datasources/firebase_addresses_datasource.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_partner_test/domain/repositories/i_auth_repository.dart';
import 'package:double_partner_test/domain/usecases/sign_in.dart';
import 'package:double_partner_test/domain/usecases/register_user.dart';
import 'package:double_partner_test/infrastructure/datasources/firebase_auth_datasource.dart';
import 'package:double_partner_test/infrastructure/repositories/auth_repository_impl.dart';
import 'package:double_partner_test/presentation/blocs/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(
        () => AuthBloc(
      signIn: sl(),
      registerUser: sl(),
      signOut: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => IsAuth(sl()));
  sl.registerLazySingleton(() => CreateAddress(sl(), sl()));
  sl.registerLazySingleton(() => GetAllAddresses(sl(), sl()));

  // Repositories
  sl.registerLazySingleton<IAuthRepository>(
        () => AuthRepositoryImpl(sl()),
  );
  // sl.registerLazySingleton<IAddressRepository>(
  //       () => AuthRepositoryImpl(sl()),
  // );

  // Data sources
  sl.registerLazySingleton(
        () => FirebaseAuthDatasource(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton(
        () => FirebaseAddressDatasource(
      firestore: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
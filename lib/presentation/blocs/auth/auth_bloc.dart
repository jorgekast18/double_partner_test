import 'dart:async';
import 'package:double_partner_test/infrastructure/repositories/auth_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:double_partner_test/domain/entities/user.dart';
import 'package:double_partner_test/domain/usecases/sign_out.dart';
import 'package:double_partner_test/domain/usecases/sign_in.dart';
import 'package:double_partner_test/domain/usecases/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final RegisterUser _registerUser;
  final SignOut _signOut;
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc({
    required SignIn signIn,
    required RegisterUser registerUser,
    required SignOut signOut
  })  : _signIn = signIn,
        _registerUser = registerUser,
        _signOut = signOut,
        super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<SignOutRequested>(_onSignOutRequested);

  }

  Future<void> _onSignInRequested(
      SignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final user = User(
      id: '',
      name: event.name,
      lastName: event.lastName,
      birthDate: event.birthDate,
      email: event.email,
    );

    final result = await _registerUser(
      RegisterUserParams(
        user: user,
        password: event.password,
      ),
    );

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await _signOut();

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(Unauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
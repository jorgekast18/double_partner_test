import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({
    required this.email,
    required this.password
  });
}

class AuthLogoutEvent extends AuthEvent {}

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {

  final User user;

  AuthSuccessState({ required this.user });
}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState({ required this.message});
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitialState()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoadingState());

      try {
        final userCredentials = await _auth.signInWithEmailAndPassword(
            email: event.email,
            password: event.password
        );

        emit(AuthSuccessState(user: userCredentials.user!));
      } catch (error) {
        emit(AuthErrorState(message: error.toString()));
      }
    });

    on<AuthLogoutEvent>((event, emit) async {
      await _auth.signOut();
      emit(AuthInitialState());
    });
  }
}
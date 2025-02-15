import 'package:double_partner_test/domain/entities/address.dart';
import 'package:double_partner_test/domain/repositories/i_address_repository.dart';
import 'package:double_partner_test/domain/usecases/authenticated.dart';
import 'package:double_partner_test/domain/usecases/get_current_user.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:double_partner_test/core/errors/failures.dart';
import 'package:double_partner_test/core/usecases/usecase.dart';

class CreateAddress implements UseCase<Address, CreateAddressParams> {
  final IAddressRepository repository;
  final IsAuth _isAuth;
  final GetCurrentUser _getCurrentUser;

  @override
  Future<Either<Failure, Address>> call(CreateAddressParams params) async {

    final authStatus = await _isAuth();
    final currentUser = await _getCurrentUser();

    return authStatus.fold(
        (failure) {
          return const  Left(ServerFailure('Error al verificar el estado de autenticación.'));
        }, (isAuthenticated) {
          if(isAuthenticated){
            return currentUser.fold((failure) {
              return const  Left(ServerFailure('Error obteniendo el usuario.'));
            }, (user) async {
              return await repository.create(params.address, user.uid);
            });
          } else {
            return const Left(AuthFailure('El usuario no está autenticado'));
          }

      }
    );
  }

  CreateAddress(this.repository, this._isAuth, this._getCurrentUser);
}

class CreateAddressParams extends Equatable {
  final Address address;

  const CreateAddressParams({
    required this.address,
  });

  @override
  List<Object> get props => [address];
}
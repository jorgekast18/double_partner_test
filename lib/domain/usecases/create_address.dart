import 'package:double_partner_test/domain/entities/address.dart';
import 'package:double_partner_test/domain/repositories/i_address_repository.dart';
import 'package:double_partner_test/domain/usecases/authenticated.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:double_partner_test/core/errors/failures.dart';
import 'package:double_partner_test/core/usecases/usecase.dart';

class CreateAddress implements UseCase<Address, CreateAddressParams> {
  final IAddressRepository repository;
  final IsAuth _isAuth;

  CreateAddress(this.repository, this._isAuth);

  @override
  Future<Either<Failure, Address>> call(CreateAddressParams params) async {

    final authStatus = await _isAuth();

    return authStatus.fold(
        (failure) {
          return const  Left(ServerFailure('Error al verificar el estado de autenticación.'));
        }, (isAuthenticated) async {
          if(isAuthenticated){
            return await repository.create(params.address);
          } else {
            return const Left(AuthFailure('El usuario no está autenticado'));
          }

      }
    );
  }
}

class CreateAddressParams extends Equatable {
  final Address address;

  const CreateAddressParams({
    required this.address,
  });

  @override
  List<Object> get props => [address];
}
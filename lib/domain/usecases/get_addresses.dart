import 'package:dartz/dartz.dart';
import 'package:double_partner_test/core/errors/failures.dart';
import 'package:double_partner_test/core/usecases/usecase.dart';
import 'package:double_partner_test/domain/entities/address.dart';
import 'package:double_partner_test/domain/repositories/i_address_repository.dart';
import 'package:double_partner_test/domain/usecases/authenticated.dart';

class GetAllAddresses implements NoParamsUseCase<List<Address>> {
  final IAddressRepository repository;
  final IsAuth _isAuth;

  GetAllAddresses(this.repository, this._isAuth);

  @override
  Future<Either<Failure, List<Address>>> call() async {
      final authStatus = await _isAuth();

      return authStatus.fold(
          (failure) {
            return const  Left(ServerFailure('Error al verificar el estado de autenticación.'));
          }, (isAuthenticated) async {
        if(isAuthenticated){
          final result = await repository.getAll();
          return Right(result as List<Address>);
        } else {
          return const Left(AuthFailure('El usuario no está autenticado'));
        }

      }
      );
  }
}

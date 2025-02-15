import 'package:dartz/dartz.dart';
import 'package:double_partner_test/core/errors/failures.dart';
import 'package:double_partner_test/core/usecases/usecase.dart';
import 'package:double_partner_test/domain/entities/address.dart';
import 'package:double_partner_test/domain/repositories/i_address_repository.dart';
import 'package:double_partner_test/domain/usecases/authenticated.dart';
import 'package:double_partner_test/domain/usecases/get_current_user.dart';

class GetAllAddresses implements NoParamsUseCase<List<Address>> {
  final IAddressRepository repository;
  final IsAuth _isAuth;
  final GetCurrentUser _getCurrentUser;

  GetAllAddresses(this.repository, this._isAuth, this._getCurrentUser);

  @override
  Future<Either<Failure, List<Address>>> call() async {
      final authStatus = await _isAuth();
      final currentUser = await _getCurrentUser();

      return authStatus.fold(
          (failure) {
            return const  Left(ServerFailure('Error al verificar el estado de autenticación.'));
          }, (isAuthenticated) async {
            if(isAuthenticated){
              return currentUser.fold((failure) {
                return const  Left(ServerFailure('Error obteniendo el usuario.'));
              }, (user) async {
                final result = await repository.getAll(user.uid);
                return result.fold(
                  (failure) {
                      return Left(failure);
                  },
                  (addresses) {
                      return Right(addresses);
                  }
                );
              });
            } else {
              return const Left(AuthFailure('El usuario no está autenticado'));
            }
      }
      );
  }
}

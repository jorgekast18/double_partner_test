import 'package:dartz/dartz.dart';
import 'package:double_partner_test/core/errors/failures.dart';
import 'package:double_partner_test/core/usecases/usecase.dart';
import 'package:double_partner_test/domain/entities/address.dart';
import 'package:double_partner_test/domain/repositories/i_address_repository.dart';

class GetAllAddresses implements NoParamsUseCase<List<Address>> {
  final IAddressRepository repository;

  GetAllAddresses(this.repository);

  @override
  Future<Either<Failure, List<Address>>> call() async {
      final result = await repository.getAll();
      return Right(result as List<Address>);
  }
}

import 'package:double_partner_test/domain/entities/address.dart';
import 'package:double_partner_test/domain/repositories/i_address_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:double_partner_test/core/errors/failures.dart';
import 'package:double_partner_test/core/usecases/usecase.dart';

class CreateAddress implements UseCase<Address, CreateAddressParams> {
  final IAddressRepository repository;

  CreateAddress(this.repository);

  @override
  Future<Either<Failure, Address>> call(CreateAddressParams params) async {
    return await repository.create(params.address);
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
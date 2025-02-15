import 'package:dartz/dartz.dart';
import 'package:double_partner_test/domain/entities/address.dart';

import '../../core/errors/failures.dart';

abstract class IAddressRepository {
  Future<Either<Failure, Address>> create(Address address, String userId);
  Future<Either<Failure, List<Address>>> getAll();
}
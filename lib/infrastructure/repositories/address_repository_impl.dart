import 'package:dartz/dartz.dart';
import 'package:double_partner_test/domain/entities/address.dart';
import 'package:double_partner_test/domain/repositories/i_address_repository.dart';
import 'package:double_partner_test/infrastructure/datasources/firebase_addresses_datasource.dart';
import 'package:double_partner_test/infrastructure/models/address_model.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';

class AddressRepositoryImpl implements IAddressRepository {
  final FirebaseAddressDatasource _addressDatasource;

  AddressRepositoryImpl(this._addressDatasource);

  @override
  Future<Either<Failure, Address>> create(Address data, String userId) async {
    try {
      final addressData = await _addressDatasource.createAddress(
          AddressModel.fromDomain(data).toMap(), userId);
      final addressCreated = AddressModel.fromMap(addressData).toDomain();
      return Right(addressCreated);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Address>>> getAll(String userId) async {
    try {
      final userData = await _addressDatasource.getAllAddresses(userId);
      return Right(userData);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

}
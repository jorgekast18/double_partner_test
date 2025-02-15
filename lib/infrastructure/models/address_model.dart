import 'package:double_partner_test/domain/entities/address.dart';


class AddressModel extends Address {
  AddressModel({
    required super.id,
    required super.userId,
    required super.street,
    required super.city,
    required super.state,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      street: map['street'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'street': street,
      'city': city,
      'state': state,
    };
  }

  factory AddressModel.fromDomain(Address address) {
    return AddressModel(
      id: address.id,
      userId: address.userId,
      street: address.street,
      city: address.city,
      state: address.state,
    );
  }

  Address toDomain() {
    return Address(
      id: id,
      userId: userId,
      street: street,
      city: city,
      state: state,
    );
  }
}
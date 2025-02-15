import 'package:double_partner_test/domain/entities/address.dart';
import 'package:equatable/equatable.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class LoadAddresses extends AddressEvent {}

class CreateRequested extends AddressEvent {
  final String street;
  final String city;
  final String state;

  const CreateRequested({
    required this.street,
    required this.city,
    required this.state
  });

  @override
  List<Object> get props => [street, city, state];
}

class GetAllAddressesRequested extends AddressEvent {
  const GetAllAddressesRequested();

  @override
  List<Object> get props => [];
}
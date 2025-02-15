import 'package:double_partner_test/domain/entities/address.dart';
import 'package:equatable/equatable.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressesLoading extends AddressState {}

class AddressesLoaded extends AddressState {
  final List<Address> addresses;
  const AddressesLoaded(this.addresses);
}

class AddressesEmpty extends AddressState {
  final String message;
  const AddressesEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class AddressCreated extends AddressState {
  final Address address;
  const AddressCreated(this.address);
}

class AddressError extends AddressState {
  final String message;
  const AddressError(this.message);

  @override
  List<Object> get props => [message];
}
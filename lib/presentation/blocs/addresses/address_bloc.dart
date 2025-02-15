import 'package:double_partner_test/domain/entities/address.dart';
import 'package:double_partner_test/domain/usecases/create_address.dart';
import 'package:double_partner_test/domain/usecases/get_addresses.dart';
import 'package:double_partner_test/presentation/blocs/addresses/address_event.dart';
import 'package:double_partner_test/presentation/blocs/addresses/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {

  final CreateAddress _createAddress;
  final GetAllAddresses _getAllAddresses;

  AddressBloc({
    required CreateAddress createAddress,
    required GetAllAddresses getAllAddress
  }) : _createAddress = createAddress,
       _getAllAddresses = getAllAddress,
  super(AddressInitial()) {
    on<CreateRequested>(_createAddressRequested);
    on<GetAllAddressesRequested>(_getAllAddressesRequested);
  }

  Future<void> _createAddressRequested(
      CreateRequested event,
      Emitter<AddressState> emit
      ) async {
    try {
      emit(AddressesLoading());

      final Address data = Address.create(
          street: event.street,
          city: event.city,
          state: event.state
      );

      final result = await _createAddress(
          CreateAddressParams(address: data)
      );

      await result.fold(
        (failure) async {
            emit(AddressError(failure.message));
          },
        (address) async {
          emit(AddressCreated(address));

          final allAddressesResult = await _getAllAddresses();

          await allAddressesResult.fold(
            (failure) async {
                if (!emit.isDone) {
                  emit(AddressError(failure.message));
                }
            },
            (addresses) async {
              if (!emit.isDone) {
                if (addresses.isEmpty) {
                  emit(const AddressesEmpty('No tienes direcciones guardadas.'));
                } else {
                  emit(AddressesLoaded(addresses));
                }
              }
            }
          );
        }
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(AddressError(e.toString()));
      }
    }
  }

  Future<void> _getAllAddressesRequested(
      GetAllAddressesRequested event,
      Emitter<AddressState> emit
    ) async {

    final result = await _getAllAddresses();

    result.fold(
        (failure) => emit(AddressError(failure.message)),
        (addresses) {
          if(addresses.isEmpty){
            emit(const AddressesEmpty('No tienes direcciones guardadas.'));
          } else {
            emit(AddressesLoaded(addresses));
          };
        }
    );
  }
}
import 'package:double_partner_test/domain/entities/address.dart';
import 'package:double_partner_test/presentation/blocs/addresses/address_bloc.dart';
import 'package:double_partner_test/presentation/blocs/addresses/address_event.dart';
import 'package:double_partner_test/presentation/blocs/addresses/address_state.dart';
import 'package:double_partner_test/presentation/widgets/card_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:double_partner_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:double_partner_test/presentation/blocs/auth/auth_event.dart';
import 'package:double_partner_test/presentation/blocs/auth/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if(state is Unauthenticated) {
            Navigator.of(context).pushReplacementNamed('/');
          }
        },
        builder: (context, authState) {
          if (authState is Authenticated) {
            context.read<AddressBloc>().add(const GetAllAddressesRequested());

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Direcciones de ${authState.user.name}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BlocBuilder<AddressBloc, AddressState>(
                      builder: (context, addressState) {
                        if (addressState is AddressesLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (addressState is AddressError) {
                          return Center(
                            child: Text(
                              addressState.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        if (addressState is AddressesEmpty) {
                          return Center(
                            child: Text(
                              addressState.message,
                              style: const TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          );
                        }

                        if (addressState is AddressesLoaded) {
                          if (addressState.addresses.isEmpty) {
                            return const Center(
                              child: Text(
                                'No tienes direcciones guardadas.',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: addressState.addresses.length,
                            itemBuilder: (context, index) {
                              final address = addressState.addresses[index];
                              return CardAddress(address: address);
                            },
                          );
                        }

                        return const Center(
                          child: Text('Cargando direcciones...'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (authState is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (authState is AuthError) {
            return Center(
              child: Text(
                authState.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(
              child: Text('Por favor inicia sesión'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAddressDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void _showAddAddressDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final TextEditingController streetController = TextEditingController();
      final TextEditingController cityController = TextEditingController();
      final TextEditingController stateController = TextEditingController();

      return AlertDialog(
        title: const Text('Agregar Nueva Dirección'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: streetController,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'Ciudad'),
            ),
            TextField(
              controller: stateController,
              decoration: const InputDecoration(labelText: 'Departamento'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final String street = streetController.text;
              final String city = cityController.text;
              final String state = stateController.text;
              context.read<AddressBloc>().add(CreateRequested(
                street: street,
                city: city,
                state: state,
              ));
              Navigator.of(context).pop();
            },
            child: const Text('Agregar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

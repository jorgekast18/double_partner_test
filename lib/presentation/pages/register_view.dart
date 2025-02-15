import 'package:double_partner_test/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../utils/fields_validations.dart';


class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor ingrese su apellido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Fecha de nacimiento',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                            : 'Seleccione una fecha',
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Ingresa tu email',
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    hint: 'Ingresa tu contraseña',
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: validatePassword,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Por favor seleccione su fecha de nacimiento',
                              ),
                            ),
                          );
                          return;
                        }
                        context.read<AuthBloc>().add(
                          RegisterRequested(
                            name: _nameController.text,
                            lastName: _lastNameController.text,
                            birthDate: _selectedDate!,
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      }
                    },
                    child: state is AuthLoading
                        ? CircularProgressIndicator()
                        : Text('Registrar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
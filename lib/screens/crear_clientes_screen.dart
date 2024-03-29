
import 'package:development_as_alison/screens/clientes_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrearClientesScreen extends StatefulWidget {
  const CrearClientesScreen({super.key});

  @override
  State<CrearClientesScreen> createState() => _CrearClientesScreenState();
}

class _CrearClientesScreenState extends State<CrearClientesScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final estadoController = TextEditingController();

  String? nameError;
  String? emailError;
  String? apellidoError;
  String? direccionError;
  String? telefonoError;
  String? estadoError;

  // Link API para crear clientes
  final url =
      Uri.parse('https://apiusuarios-copia.onrender.com/api/routes/clientes');

  void crearCliente(Map<String, dynamic> clientes) async {
    var response = await http.post(url, body: clientes);
    if (response.statusCode == 200) {
      // Redirigir al usuario a la pantalla de clientes
      final route = MaterialPageRoute(builder: (context) => const ClientesScreen());
      // ignore: use_build_context_synchronously
      Navigator.push(context, route);
    } else {
      // Mostrar un mensaje de error si la petición falla
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al crear el cliente'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Clientes'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Crear Clientes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: const Icon(Icons.person),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    errorText:
                        nameError, // Mostrar mensaje de error debajo del campo
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() {
                        nameError = 'Por favor ingrese su nombre';
                      });
                      return null; // No devolver un mensaje de error aquí
                    }
                    if (value.length < 6) {
                      nameError = 'El nombre debe tener al menos 6 caracteres';
                    }
                    setState(() {
                      nameError =
                          null; // Limpiar el error si la validación es exitosa
                    });
                    return null; // Validación exitosa
                  },
                ),
              ),
              if (nameError != null) const SizedBox(height: 5.0),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: apellidoController,
                  decoration: InputDecoration(
                    labelText: 'Apellido',
                    prefixIcon: const Icon(Icons.person),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    errorText:
                        apellidoError, // Mostrar mensaje de error debajo del campo
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() {
                        apellidoError = 'Por favor ingrese su apellido';
                      });
                      return null; // No devolver un mensaje de error aquí
                    }
                    if (value.length < 6) {
                      apellidoError =
                          'El apellido debe tener al menos 6 caracteres';
                    }
                    setState(() {
                      apellidoError =
                          null; // Limpiar el error si la validación es exitosa
                    });
                    return null; // Validación exitosa
                  },
                ),
              ),
              if (apellidoError != null) const SizedBox(height: 5.0),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    prefixIcon: const Icon(Icons.alternate_email),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    errorText:
                        emailError, // Mostrar mensaje de error debajo del campo
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() {
                        emailError = 'Por favor ingrese su correo';
                      });
                      return null; // No devolver un mensaje de error aquí
                    }
                    if (!value.contains('@')) {
                      setState(() {
                        emailError = 'Por favor ingrese un correo valido';
                      });
                      return null;
                    }
                    if (value.length < 6) {
                      emailError = 'El correo debe tener al menos 6 caracteres';
                    }
                    setState(() {
                      emailError =
                          null; // Limpiar el error si la validación es exitosa
                    });
                    return null; // Validación exitosa
                  },
                ),
              ),
              if (emailError != null) const SizedBox(height: 5.0),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: direccionController,
                  decoration: InputDecoration(
                    labelText: 'Dirección',
                    prefixIcon: const Icon(Icons.location_on),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    errorText:
                        direccionError, // Mostrar mensaje de error debajo del campo
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() {
                        direccionError = 'Por favor ingrese su dirección';
                      });
                      return null; // No devolver un mensaje de error aquí
                    }
                    if (value.length < 6) {
                      direccionError =
                          'La dirección debe tener al menos 6 caracteres';
                    }
                    setState(() {
                      direccionError =
                          null; // Limpiar el error si la validación es exitosa
                    });
                    return null; // Validación exitosa
                  },
                ),
              ),
              if (direccionError != null) const SizedBox(height: 5.0),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: telefonoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    prefixIcon: const Icon(Icons.phone),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    errorText:
                        telefonoError, // Mostrar mensaje de error debajo del campo
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() {
                        telefonoError = 'Por favor ingrese su teléfono';
                      });
                      return null; // No devolver un mensaje de error aquí
                    }
                    if (value.length < 6) {
                      telefonoError =
                          'El teléfono debe tener al menos 6 caracteres';
                    }
                    setState(() {
                      telefonoError =
                          null; // Limpiar el error si la validación es exitosa
                    });
                    return null; // Validación exitosa
                  },
                ),
              ),
              if (telefonoError != null) const SizedBox(height: 5.0),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: estadoController,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    prefixIcon: const Icon(Icons.location_city),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    errorText:
                        estadoError, // Mostrar mensaje de error debajo del campo
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() {
                        estadoError = 'Por favor ingrese su estado';
                      });
                      return null; // No devolver un mensaje de error aquí
                    }
                    if (value.length < 6) {
                      estadoError =
                          'El estado debe tener al menos 6 caracteres';
                    }
                    setState(() {
                      estadoError =
                          null; // Limpiar el error si la validación es exitosa
                    });
                    return null; // Validación exitosa
                  },
                ),
              ),
              if (estadoError != null) const SizedBox(height: 5.0),
              const SizedBox(height: 20.0),
              MaterialButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    var clientes = {
                      'nombre': nameController.text,
                      'apellido': apellidoController.text,
                      'direccion': direccionController.text,
                      'email': emailController.text,
                      'telefono': telefonoController.text,
                      'estado': estadoController.text,
                      'rol': 'cliente',
                    };
                    crearCliente(clientes);

                    // Limpiar los campos después de enviar la información
                    nameController.clear();
                    apellidoController.clear();
                    emailController.clear();
                    direccionController.clear();
                    telefonoController.clear();
                    estadoController.clear();

                    // Mostrar un mensaje de éxito después de enviar la información
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cliente creado con éxito'),
                      ),
                    );

                    // Redirigir al usuario a la pantalla de clientes
                    final route = MaterialPageRoute(
                        builder: (context) => const ClientesScreen());
                    Navigator.push(context, route);

                  }
                },
                child: const Text('Crear Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

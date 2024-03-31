import 'dart:convert';

import 'package:development_as_alison/screens/crear_clientes_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class EditarClientes {
  final String nombre;
  final String apellido;
  final String direccion;
  final int telefono;
  final String email;
  final String estado;
  final String rol;

  EditarClientes({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.estado,
    required this.rol,
    required this.direccion,
  });

  factory EditarClientes.fromJson(Map<String, dynamic> json) {
    return EditarClientes(
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      email: json['email'],
      estado: json['estado'],
      rol: json['rol'],
      direccion: json['direccion'],
    );
  }

  // Realizamos el future a la API para editar los clientes
  static Future<List<EditarClientes>> fetchEditarClientes() async {
    final response = await http.get(Uri.parse(
        'https://apiusuarios-copia.onrender.com/api/routes/clientes/d'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((cliente) => EditarClientes.fromJson(cliente))
          .toList();
    } else {
      throw Exception('Failed to load clientes from API');
    }
  }
}

class Clientes {
  final String id;
  final String nombre;
  final String apellido;
  final int telefono;
  final String email;
  final String estado;
  final String rol;
  final String direccion;

  Clientes(
    this.id, {
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.estado,
    required this.rol,
    required this.direccion,
  });

  factory Clientes.fromJson(Map<String, dynamic> json) {
    return Clientes(
      json['_id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      email: json['email'],
      estado: json['estado'],
      rol: json['rol'],
      direccion: json['direccion'],
    );
  }

  // Realizamos el future a la API para listar los clientes
  static Future<List<Clientes>> fetchClientes() async {
    final response = await http.get(Uri.parse(
        'https://apiusuarios-copia.onrender.com/api/routes/clientes'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((cliente) => Clientes.fromJson(cliente)).toList();
    } else {
      throw Exception('Failed to load clientes from API');
    }
  }
}

class _ClientesScreenState extends State<ClientesScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController rolController = TextEditingController();
  TextEditingController direccionController = TextEditingController();

  Future<void> editarCliente(
    String id,
    clienteEditado,
  ) async {
    var url = 'https://apiusuarios-copia.onrender.com/api/routes/clientes/$id';
    var response = await http.put(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(clienteEditado));
    if (response.statusCode != 200) {
      throw Exception('Failed to edit cliente');
    } else {
      setState(() {});
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente editado correctamente')));
    }
  }

  Future<void> eliminarCliente(String id) async {
    final response = await http.delete(Uri.parse(
        'https://apiusuarios-copia.onrender.com/api/routes/clientes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete cliente');
    } else {
      setState(() {

      });
      //Mostramos un dialogo en la parte inferior de la pantalla
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente eliminado correctamente')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: FutureBuilder<List<Clientes>>(
        future: Clientes.fetchClientes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Clientes>? data = snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                final clientesLista = data[index];
                return ListTile(
                  title:
                      Text('${clientesLista.nombre} ${clientesLista.apellido}'),
                  subtitle: Text(
                      ' Telefono : ${clientesLista.telefono}\n Correo : ${clientesLista.email}\n Estado : ${clientesLista.estado}\n Direccion :  ${clientesLista.direccion}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar cliente'),
                                content: Text(
                                    '¿Estás seguro de que deseas eliminar a ${clientesLista.nombre} ${clientesLista.apellido}?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      eliminarCliente(
                                          clientesLista.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Cliente eliminado correctamente')));
                                      //Recargar la vista de listado
                                      setState(() {});
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          //Mostrar formulario para editar
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final nombre = clientesLista.nombre;
                              final apellido = clientesLista.apellido;
                              final telefono = clientesLista.telefono;
                              final email = clientesLista.email;
                              final estado = clientesLista.estado;
                              final rol = clientesLista.rol;
                              final direccion = clientesLista.direccion;

                              //Asignamos los valores a los controladores
                              nombreController.text = nombre;
                              apellidoController.text = apellido;
                              telefonoController.text = telefono.toString();
                              emailController.text = email;
                              estadoController.text = estado;
                              rolController.text = rol;
                              direccionController.text = direccion;
                              return AlertDialog(
                                title: const Text('Editar cliente'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: nombreController,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        hintText: nombre,
                                        labelText: 'Nombre',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: apellidoController,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        hintText: apellido,
                                        labelText: 'Apellido',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: telefonoController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        hintText: telefono.toString(),
                                        labelText: 'Telefono',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        hintText: email,
                                        labelText: 'Email',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: estadoController,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        hintText: estado,
                                        labelText: 'Estado',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: direccionController,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        hintText: direccion,
                                        labelText: 'Direccion',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    MaterialButton(
                                        onPressed: () {
                                          var id = clientesLista.id;
                                          var clienteEditado = {
                                            'nombre': nombreController.text,
                                            'apellido': apellidoController.text,
                                            'telefono': telefonoController.text,
                                            'email': emailController.text,
                                            'estado': estadoController.text,
                                            'rol': 'cliente',
                                            'direccion':
                                                direccionController.text,
                                          };
                                          editarCliente(id, clienteEditado);
                                          setState(() {
                                           Navigator.of(context).pop();
                                          });
                                        },
                                        child: const Text('Editar cliente')),
                                    MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancelar')),
                                  ],
                                ),
                              );
                            },
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
      //Creamos un boton elevado para agregar un nuevo cliente
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final route = MaterialPageRoute(
              builder: (context) => const CrearClientesScreen());
          Navigator.push(context, route);
        },
      ),
    );
  }
}

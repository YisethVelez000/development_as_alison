import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class EditarUsuarios {
  final String name;
  final String email;
  final String rol;

  EditarUsuarios({
    required this.name,
    required this.email,
    required this.rol,
  });

  factory EditarUsuarios.fromJson(Map<String, dynamic> json) {
    return EditarUsuarios(
      name: json['name'],
      email: json['email'],
      rol: json['rol'],
    );
  }

  //Realizamos el fetch a la API
  Future<EditarUsuarios> fetchEditarUsuarios() async {
    final response = await http.get(Uri.parse(
        'https://apiusuarios-copia.onrender.com/api/user/listarUsuarios'));
    if (response.statusCode == 200) {
      return EditarUsuarios.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Usuarios {
  final String id;
  final String name;
  final String email;
  final String password;
  final String rol;

  Usuarios(
    this.id, {
    required this.name,
    required this.email,
    required this.password,
    required this.rol,
  });

  factory Usuarios.fromJson(Map<String, dynamic> json) {
    return Usuarios(
      json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      rol: json['rol'],
    );
  }

  //Realizamos el fetch a la API
  static Future<List<Usuarios>> fetchUsuarios() async {
    final response = await http.get(Uri.parse(
        'https://apiusuarios-copia.onrender.com/api/user/listarUsuarios'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Usuarios.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  //Realizamos el delete a la API
  static Future<void> eliminarUsuario(String id) async {
    final response = await http.delete(Uri.parse(
        'https://apiusuarios-copia.onrender.com/api/user/eliminarUsuario/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete usuario');
    } else {
      //Mostramos un dialogo de cliente eeiminado con exito
    }
  }
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  // Creamos los controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _rolController = TextEditingController();

  //Metodo para editar usuarios
  void editarUsuario(String id, usuarioEditado) {
    final EditarUsuarios editarUsuarios = EditarUsuarios(
      name: _nameController.text,
      email: _emailController.text,
      rol: _rolController.text,
    );
    editarUsuarios.fetchEditarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Listamos los usuarios
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: FutureBuilder<List<Usuarios>>(
        future: Usuarios.fetchUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final nameController = TextEditingController(
                                text: snapshot.data![index].name);
                            final emailController = TextEditingController(
                                text: snapshot.data![index].email);
                            final rolController = TextEditingController(
                                text: snapshot.data![index].rol);

                            return AlertDialog(
                              title: const Text('Editar Usuario'),
                              content: Column(
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                    hintText: snapshot.data![index].name,
                                    ),
                                  ),
                                  TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                    ),
                                  ),
                                  TextField(
                                    controller: rolController,
                                    decoration: const InputDecoration(
                                      hintText: 'Rol',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    editarUsuario(
                                        snapshot.data![index].id, snapshot.data);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Editar'),
                                ),
                              ],
                            );
                          },
                        );
                      }, icon: Icon(Icons.edit)),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Usuarios.eliminarUsuario(snapshot.data![index].id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text('Error');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

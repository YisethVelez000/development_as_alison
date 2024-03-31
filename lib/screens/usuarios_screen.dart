import 'dart:convert';
import 'package:development_as_alison/screens/crear_usuarios_screen.dart';
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
    final response = await http.put(Uri.parse(
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
  //Metodo para editar usuarios
  Future<void> editarUsuario(String email, Map<String, dynamic> usuario) async {
    final response = await http.put(
      Uri.parse(
          'https://apiusuarios-copia.onrender.com/api/user/editarUsuario/$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(usuario),
    );
    if (response.statusCode != 200) {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to update usuario');
    } else {
      //Mostramos un dialogo de usuario editado con exito
    }
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
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final nameController = TextEditingController(
                                    text: snapshot.data![index].name);
                                final emailController = TextEditingController(
                                    text: snapshot.data![index].email);
                                final rolController = TextEditingController(
                                    text: snapshot.data![index].rol);
                                final email = snapshot.data![index].email;

                                return AlertDialog(
                                  title: const Text('Editar Usuario'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          hintText: snapshot.data![index].name,
                                          labelText: 'Nombre',
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          labelText: 'Email',
                                          hintText: snapshot.data![index].email,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: rolController,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          hintText: snapshot.data![index].rol,
                                          labelText: 'Rol',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        var usuario = {
                                          'name': nameController.text,
                                          'email': emailController.text,
                                          'rol': rolController.text,
                                        };
                                        editarUsuario(email,
                                            usuario as Map<String, dynamic>);

                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Editar',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit)),
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
      //Creamos un boton para crear un nuevo usuario
      floatingActionButton: FloatingActionButton(onPressed: (){
        final route = MaterialPageRoute(builder: (context) => const RegistrarClientesScreen());
        Navigator.push(context, route);
      },
      child: const Icon(Icons.add),
      ),

    );
  }
}

import 'dart:convert';
import 'package:development_as_alison/screens/clientes_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditarClienteScreen extends StatefulWidget {
  final String id;
  final String nombre;
  final String apellido;
  final int telefono;
  final String email;
  final String estado;
  final String direccion;
  final String ciudad;
  

  const EditarClienteScreen(
      {super.key,
      required this.id,
      required this.nombre,
      required this.apellido,
      required this.telefono,
      required this.email,
      required this.estado,
      required this.direccion, 
      required this.ciudad});

  @override
  State<EditarClienteScreen> createState() => _EditarClienteScreenState();
}

class _EditarClienteScreenState extends State<EditarClienteScreen> {
  // Controladores para cada campo de texto
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();

  //Le asignamos a los controladores los valores que ya tiene el cliente
  @override
  void initState() {
    super.initState();
    nombreController.text = widget.nombre;
    apellidoController.text = widget.apellido;
    telefonoController.text = widget.telefono.toString();
    emailController.text = widget.email;
    estadoController.text = widget.estado;
    direccionController.text = widget.direccion;
    ciudadController.text = widget.ciudad;

  }

  //Metodo para editar los clientes
  void editarCliente(String id, Map<String, dynamic> clienteEditado) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Cliente ${widget.nombre} ${widget.apellido}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //Creamos los campos
            children: [
              const Text(
                'Editar Cliente',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              //Nombre
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Nombre',
                  hintText: widget.nombre,
                ),
              ),
              const SizedBox(height: 20),
              //Apellido
              TextFormField(
                controller: apellidoController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Apellido',
                  hintText: widget.apellido,
                ),
              ),
              const SizedBox(height: 20),
              //Telefono
              TextFormField(
                controller: telefonoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Telefono',
                ),
              ),
              const SizedBox(height: 20),
              //Email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 20),
              //Estado
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Estado',
                ),
              ),
              const SizedBox(height: 20),
              //Direccion
              TextFormField(
                controller: direccionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Direccion',
                ),
              ),
              const SizedBox(height: 20),
              //Ciudad
              TextFormField(
                controller: ciudadController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Ciudad',
                ),
              ),
              const SizedBox(height: 20),
              //Boton para editar
              MaterialButton(
                onPressed: () {
                  var clienteEditado = {
                    'nombre': nombreController.text,
                    'apellido': apellidoController.text,
                    'telefono': telefonoController.text,
                    'email': emailController.text,
                    'estado': estadoController.text,
                    'direccion': direccionController.text,
                    'ciudad': ciudadController.text
                  };
                  editarCliente(widget.id, clienteEditado);
        
                  //Mandamos a la vista del listar clientes
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ClientesScreen()),
                  );
                },
                child: const Text('Editar Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

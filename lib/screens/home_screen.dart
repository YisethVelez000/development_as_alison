import 'package:development_as_alison/screens/clientes_screen.dart';
import 'package:development_as_alison/screens/login_screen.dart';
import 'package:development_as_alison/screens/produccion_screen.dart';
import 'package:development_as_alison/screens/usuarios_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Traemos el id del usuario logueado para mostrarle un mensaje de bienvenida con su nombre

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bienvenido a la pantalla de inicio!'),
        ),
        body: Column(
            //Creamos un ListView para poder desplazar los elementos de la pantalla
             children: [
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: const Text('Clientes'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ClientesScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Producción'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProduccionScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Usuarios'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UsuariosScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Cerrar sesión'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                ],
              )
             ],
            ));
  }
}

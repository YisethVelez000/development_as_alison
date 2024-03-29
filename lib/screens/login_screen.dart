import 'package:development_as_alison/screens/home_screen.dart';
import 'package:development_as_alison/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  String? emailError; // Variable to store email error message
  String? passwordError; // Variable to store password error message

  void iniciarSesion(usuario) async {
    final url =
        Uri.parse('https://apiusuarios-copia.onrender.com/api/user/login');
    var response = await http.post(url, body: usuario);
    if (response.statusCode == 200) {
      // If the response is 200, redirect the user to the home screen
      // ignore: use_build_context_synchronously
      final route = MaterialPageRoute(builder: (context) => const HomeScreen());
      // ignore: use_build_context_synchronously
      Navigator.push(context, route);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Logo de la app
            const SizedBox(height: 50),
            Image.asset('assets/logo.png', width: 250),

            // Título
            const Text('Inicio de sesión',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20.0),
            // Campo de correo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  prefixIcon: const Icon(Icons.alternate_email),
                  border: const OutlineInputBorder(
                    //Le ponemos un color azul al borde del campo
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  errorText:
                      emailError, // Display error message below the field
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    setState(() {
                      emailError = 'Por favor ingrese su correo';
                    });
                    return null; // Don't return an error string here
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
                    emailError = null; // Clear error if validation passes
                  });
                  return null; // Validation successful
                },
              ),
            ),

            // Espacio después del mensaje de error del correo
            if (emailError != null) const SizedBox(height: 5.0),
            const SizedBox(height: 20.0),
            // Campo de contraseña
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(
                    //Le ponemos un color azul al borde del campo
                    borderSide: BorderSide(color: Colors.blue),                   
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  errorText:
                      passwordError, // Display error message below the field
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    setState(() {
                      passwordError = 'Por favor ingrese su contraseña';
                    });
                    return null;
                  }
                  if (value.length < 6) {
                    setState(() {
                      passwordError =
                          'La contraseña debe tener al menos 6 caracteres';
                    });
                    return null;
                  }
                  setState(() {
                    passwordError = null; // Clear error if validation passes
                  });
                  return null;
                },
              ),
            ),

            // Espacio después del mensaje de error de la contraseña
            if (passwordError != null) const SizedBox(height: 15.0),
            const SizedBox(height: 20.0),
            // Botón de inicio de sesión
            MaterialButton(
              height: 50,
              minWidth: 150,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {
                if (_validateForm()) {
                  // Si el formulario es válido, iniciar sesión
                  var usuario = {
                    'email': emailController.text,
                    'password': passwordController.text
                  };
                  iniciarSesion(usuario);
                }
              },
              color: const Color.fromARGB(255, 92, 182, 255),
              textColor: Colors.white,
              child: const Text('Iniciar sesión'),
            ),

            // Botón de registro
            const SizedBox(height: 30),

            //Texto de registro
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the Row contents
              children: [
                GestureDetector(
                  onTap: () {
                    final route = MaterialPageRoute(
                        builder: (context) => const RegisterScreen());
                    Navigator.push(context, route);
                  },
                  child: const Text(
                    '¿No tienes una cuenta?',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // Barra de navegación inferior
      bottomNavigationBar: const BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Alison Yiseth Puerta Velez ADSO 2670689 ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.terminal_outlined,
                color: Color.fromARGB(255, 88, 133, 255), size: 20),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    // Validar el correo y la contraseña
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      setState(() {
        emailError = 'Por favor ingrese un correo valido';
      });
      return false;
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      setState(() {
        passwordError = 'La contraseña debe tener al menos 6 caracteres';
      });
      return false;
    }
    setState(() {
      emailError = null;
      passwordError = null;
    });
    return true;

  }
}

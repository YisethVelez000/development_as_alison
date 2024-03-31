import 'package:development_as_alison/screens/usuarios_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrarClientesScreen extends StatefulWidget {
  const RegistrarClientesScreen({super.key});

  @override
  State<RegistrarClientesScreen> createState() =>
      _RegistrarClientesScreenState();
}

class _RegistrarClientesScreenState extends State<RegistrarClientesScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmedPasswordController =
      TextEditingController();
  bool _obscureText = true;
  String? emailError; // Variable to store email error message
  String? passwordError; // Variable to store password error message
  String? confirmedPasswordError;
  String? nameError; // Variable to store password error message

  void registrar(usuario) async {
    final url =
        Uri.parse('https://apiusuarios-copia.onrender.com/api/user/register');
    var response = await http.post(url, body: usuario);
    if (response.statusCode == 200) {
      // If the response is 200, redirect the user to the home screen
      // ignore: use_build_context_synchronously
      final route =
          MaterialPageRoute(builder: (context) => const UsuariosScreen());
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
            // Título
            const SizedBox(height: 50.0),
            const Text('Crear usuario',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20.0),
            // Campo de nombre
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
                  errorText: nameError, // Display error message below the field
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    setState(() {
                      nameError = 'Por favor ingrese su nombre';
                    });
                    return null; // Don't return an error string here
                  }
                  if (value.length < 6) {
                    nameError = 'El nombre debe tener al menos 6 caracteres';
                  }
                  setState(() {
                    nameError = null; // Clear error if validation passes
                  });
                  return null; // Validation successful
                },
              ),
            ),
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
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: confirmedPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
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
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  errorText:
                      confirmedPasswordError, // Display error message below the field
                ),
                validator: (value) {
                  if (value != passwordController.text) {
                    setState(() {
                      confirmedPasswordError = 'Las contraseñas no coinciden';
                    });
                    return null;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20.0),

            // Espacio después del mensaje de error de la contraseña
            if (passwordError != null) const SizedBox(height: 15.0),
            const SizedBox(height: 20.0),
            // Botón de inicio de sesión
            MaterialButton(
              onPressed: () {
                if (_validateForm()) {
                  // Si el formulario es válido, iniciar sesión
                  var usuario = {
                    'name': nameController.text,
                    'email': emailController.text,
                    'password': passwordController.text,
                    'rol': 'Cliente'
                  };
                  registrar(usuario);
                }
              },
              child: const Text('Crear usuario'),
            ),

            // Botón de registro
            const SizedBox(height: 30),
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
    if (confirmedPasswordController.text.isEmpty ||
        confirmedPasswordController.text != passwordController.text) {
      setState(() {
        confirmedPasswordError = 'Las contraseñas no coinciden';
      });
      return false;
    }
    if (nameController.text.isEmpty || nameController.text.length < 6) {
      setState(() {
        nameError = 'Por favor ingrese su nombre';
      });
      return false;
    }

    // Si el correo y la contraseña son válidos, borrar los mensajes de error
    setState(() {
      emailError = null;
      passwordError = null;
      confirmedPasswordError = null;
      nameError = null;
    });

    //

    return true;
  }
}

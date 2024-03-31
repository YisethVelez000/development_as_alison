import 'package:development_as_alison/screens/produccion_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrearOrdenScreen extends StatefulWidget {
  const CrearOrdenScreen({super.key});

  @override
  State<CrearOrdenScreen> createState() => _CrearOrdenScreenState();
}

class _CrearOrdenScreenState extends State<CrearOrdenScreen> {
  // Controladores para cada campo de texto
  final TextEditingController nroOrdenController = TextEditingController();
  final TextEditingController fechaEstimadaController = TextEditingController();
  final TextEditingController tallasController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();

  // Clave para el formulario
  final _formKey = GlobalKey<FormState>();

  // Función para crear la orden de producción
  Future<void> crearOrden(ordenProduccion) async {
    final url =
        Uri.parse('https://apiusuarios-copia.onrender.com/api/routes/orden');

    var response = await http.post(url, body: ordenProduccion);

    if (response.statusCode == 200) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Orden de Producción',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Crear orden de producción',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),

              // Nro. Orden
              TextFormField(
                controller: nroOrdenController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Número de Orden',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el número de orden.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Fecha estimada
              TextFormField(
                controller: fechaEstimadaController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Fecha Estimada (YYYY-MM-DD)',
                ),
                validator: (value) {
                  final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!dateRegex.hasMatch(value!)) {
                    return 'Ingresa una fecha válida en formato YYYY-MM-DD.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Tallas
              TextFormField(
                controller: tallasController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Tallas',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa las tallas.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Cantidad
              TextFormField(
                controller: cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Cantidad',
                ),
                validator: (value) {
                  if (int.tryParse(value!) == null || int.parse(value) <= 0) {
                    return 'Por favor, ingresa una cantidad válida mayor a 0.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Color
              TextFormField(
                controller: colorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Color',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el color.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Estado
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Estado',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el estado.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Botón para crear la orden
              MaterialButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Crear la orden de producción
                    final ordenProduccion = {
                      'nroOrden': nroOrdenController.text,
                      'fechaEstimada': fechaEstimadaController.text,
                      'tallas': tallasController.text,
                      'cantidad': cantidadController.text,
                      'color': colorController.text,
                      'estado': estadoController.text,
                    };
                    crearOrden(ordenProduccion);
                  }
                  const snackBar = SnackBar(
                    content: Text('Orden de producción creada'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProduccionScreen()),
                  );
                },
                child: const Text('Crear Orden de Producción'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:development_as_alison/screens/crear_orden_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProduccionScreen extends StatefulWidget {
  const ProduccionScreen({super.key});

  @override
  State<ProduccionScreen> createState() => _ProduccionScreenState();
}

class OrdenProduccion {
  final String id;
  final int nroOrden;
  final String fechaEstimada;
  final List<String> tallas;
  final int cantidad;
  final List<String> color;
  final String estado;

  OrdenProduccion(this.id,
      {required this.nroOrden,
      required this.fechaEstimada,
      required this.tallas,
      required this.cantidad,
      required this.color,
      required this.estado});

  factory OrdenProduccion.fromJson(Map<String, dynamic> json) {
    return OrdenProduccion(json['_id'],
        nroOrden: json['nroOrden'],
        fechaEstimada: json['fechaEstimada'],
        tallas: json['tallas'].cast<String>(),
        cantidad: json['cantidad'],
        color: json['color'].cast<String>(),
        estado: json['estado']);
  }

  //Creamos el metodo FetchOrdenes para consumir la api
  static Future<List<OrdenProduccion>> fetchOrdenes() async {
    final response = await http.get(
        Uri.parse('https://apiusuarios-copia.onrender.com/api/routes/ordenes'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((orden) => OrdenProduccion.fromJson(orden))
          .toList();
    } else {
      throw Exception('Failed to load ordenes');
    }
  }

  //Creamos la funcion para eliminar una orden
}

class _ProduccionScreenState extends State<ProduccionScreen> {
  var fechaFormateada = '';
  //Creamos los controladores para los campos de la orden
  TextEditingController nroOrdenController = TextEditingController();
  TextEditingController fechaEstimadaController = TextEditingController();
  TextEditingController tallasController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController estadoController = TextEditingController();

  Future<void> editarOrden(String id, ordenEditada) async {
    var url = 'https://apiusuarios-copia.onrender.com/api/routes/ordenes/$id';
    var response = await http.put(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(ordenEditada));
    if (response.statusCode != 200) {
      throw Exception('Failed to edit cliente');
    } else {
      setState(() {});
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orden editada correctamente')));
    }
  }

  Future<void> deleteOrden(String id) async {
    final response = await http.delete(Uri.parse(
        'https://apiusuarios-copia.onrender.com/api/routes/ordenes/$id'));
    if (response.statusCode == 200) {
      setState(() {
        
      });
      //Mostramos un mensaje de que la orden fue eliminada
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orden eliminada')));
    } else {
      throw Exception('Failed to delete orden');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordenes de Producción'),
      ),
      body: FutureBuilder<List<OrdenProduccion>>(
        future: OrdenProduccion.fetchOrdenes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OrdenProduccion>? data = snapshot.data;
            return ListView.builder(
              
              itemCount: data!.length,
              itemBuilder: (context, index) {
                //Hacemos una funcion para eliminar la hora de la fecha estimada
                for (var i = 0; i < data[index].fechaEstimada.length; i++) {
                  if (data[index].fechaEstimada[i] == 'T') {
                    fechaFormateada = data[index].fechaEstimada.substring(0, i);
                    break;
                  }
                }
                return ListTile(
                    title: Text(data[index].nroOrden.toString()),
                    subtitle: Text(
                        'Estado : ${data[index].estado}\nFecha Estimada : $fechaFormateada\nTallas: ${data[index].tallas.join(', ')}\nColor: ${data[index].color.join(', ')}\nCantidad : ${data[index].cantidad}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            //Aqui se puede agregar la funcionalidad para eliminar la orden
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Eliminar Orden'),
                                  content: const Text(
                                      '¿Está seguro de eliminar la orden?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteOrden(
                                            data[index].id);
                                        setState(() {});
                                        
                                        Navigator.of(context).pop();
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
                            //Aqui se puede agregar la funcionalidad para editar la orden
                            //Mostramos un dialogo con todos los campos para editar
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final nroOrden = data[index].nroOrden;
                                  final fechaEstimada = fechaFormateada;
                                  final tallas = data[index].tallas;
                                  final cantidad = data[index].cantidad;
                                  final color = data[index].color;
                                  final estado = data[index].estado;

                                  nroOrdenController.text = nroOrden.toString();
                                  fechaEstimadaController.text = fechaEstimada;
                                  tallasController.text = tallas.join(', ');
                                  cantidadController.text = cantidad.toString();
                                  colorController.text = color.join(', ');
                                  estadoController.text = estado;
                                  return AlertDialog(
                                    title: const Text('Editar Orden'),
                                    content: Column(
                                      children: [
                                        TextField(
                                          controller: nroOrdenController,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              labelText: 'Nro Orden',
                                              hintText: nroOrden.toString()),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          controller: fechaEstimadaController,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              labelText: 'Fecha Estimada',
                                              hintText: fechaEstimada),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          controller: tallasController,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              labelText: 'Tallas',
                                              hintText: tallas.join(', ')),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          controller: cantidadController,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              labelText: 'Cantidad',
                                              hintText: cantidad.toString()),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          controller: colorController,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              labelText: 'Color',
                                              hintText: color.join(', ')),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          controller: estadoController,
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              labelText: 'Estado',
                                              hintText: estado),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          //Creamos un objeto con los campos editados
                                          final ordenEditada = {
                                            'nroOrden': nroOrdenController.text,
                                            'fechaEstimada':
                                                fechaEstimadaController.text,
                                            'tallas': tallasController.text,
                                            'cantidad': cantidadController.text,
                                            'color': colorController.text,
                                            'estado': estadoController.text
                                          };
                                          //Llamamos a la funcion para editar la orden
                                          editarOrden(
                                              data[index].id, ordenEditada);

                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: const Text('Editar'),
                                      ),
                                    ],
                                  );
                                });
                            setState(() {});
                          },
                        ),
                      ],
                    ));
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
      //Aqui se puede agregar un boton para agregar una nueva orden
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            final route = MaterialPageRoute(builder: (context) {
              return const CrearOrdenScreen();
            });
            Navigator.push(context, route);
          },
          child: const Icon(Icons.add)),
    );
  }
}

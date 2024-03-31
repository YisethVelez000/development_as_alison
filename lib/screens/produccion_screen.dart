import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProduccionScreen extends StatefulWidget {
  const ProduccionScreen({super.key});

  @override
  State<ProduccionScreen> createState() => _ProduccionScreenState();
}
/* Creamos la clase ordenProduccion para consumir la siguiente api cuyo formato es asi: 
"_id": "6604c9dd2c3ddf591f191d7b",
        "nroOrden": 12345,
        "fechaEstimada": "2024-04-15T00:00:00.000Z",
        "tallas": [
            "S,M,L"
        ],
        "cantidad": 100,
        "color": [
            "Rojo"
        ],
        "estado": "Inicio corte",
        "__v": 0
  link del api https://apiusuarios-copia.onrender.com/api/routes/ordenes
 */
class OrdenProduccion{
  final String id;
  final int nroOrden;
  final String fechaEstimada;
  final List<String> tallas;
  final int cantidad;
  final List<String> color;
  final String estado;

  OrdenProduccion(this.id, {required this.nroOrden, required this.fechaEstimada, required this.tallas, required this.cantidad, required this.color, required this.estado});

  factory OrdenProduccion.fromJson(Map<String, dynamic> json){
    return OrdenProduccion(
      json['_id'],
      nroOrden: json['nroOrden'],
      fechaEstimada: json['fechaEstimada'],
      tallas: json['tallas'].cast<String>(),
      cantidad: json['cantidad'],
      color: json['color'].cast<String>(),
      estado: json['estado']
    );
  }

  //Creamos el metodo FetchOrdenes para consumir la api
  static Future<List<OrdenProduccion>> fetchOrdenes() async {
    final response = await http.get(Uri.parse('https://apiusuarios-copia.onrender.com/api/routes/ordenes'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((orden) => OrdenProduccion.fromJson(orden)).toList();
    } else {
      throw Exception('Failed to load ordenes');
    }
  }
}
class _ProduccionScreenState extends State<ProduccionScreen> {

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
                return ListTile(
                  title: Text(data[index].nroOrden.toString()),
                  subtitle: Text('${data[index].estado} - ${data[index].fechaEstimada}\nTallas: ${data[index].tallas.join(', ')}\nColor: ${data[index].color.join(', ')}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      )
    );
  }
}
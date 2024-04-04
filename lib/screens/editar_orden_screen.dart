import 'package:flutter/material.dart';

class EditarOrdenScreen extends StatefulWidget {
  final int nroOrden;
  final List<String> tallas;
  final List<String> color;
  final String fechaEstimada;
  final int cantidad;
  final String estado;
  final String id;

  const EditarOrdenScreen({
    super.key, required this.nroOrden, required this.tallas, required this.color, required this.fechaEstimada, required this.cantidad, required this.estado, required this.id,
    
  });
  
  @override
  State<EditarOrdenScreen> createState() => _EditarOrdenScreenState();
}

class _EditarOrdenScreenState extends State<EditarOrdenScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
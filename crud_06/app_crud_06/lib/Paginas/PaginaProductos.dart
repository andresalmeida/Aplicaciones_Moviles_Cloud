import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaginaProductos extends StatefulWidget {
  const PaginaProductos({Key? key}) : super(key: key);

  @override
  State<PaginaProductos> createState() => _PaginaProductosState();
}

class _PaginaProductosState extends State<PaginaProductos> {
  // Lógica
  List _listaDatos = [];
  bool _cargando = true;

  Future _obtenerDatos() async {
    try {
      final respuesta =
          await http.get(Uri.parse('http://172.20.10.4/crud_06/conexion.php'));

      if (respuesta.statusCode == 200) {
        final datos = json.decode(respuesta.body);

        if (datos is List) {
          setState(() {
            _listaDatos = datos;
            _cargando = false;
          });
        } else {
          print('La respuesta no es una lista: $datos');
        }
      } else {
        print('Respuesta del servidor: ${respuesta.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _obtenerDatos();
  }

  // DISEÑO
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de productos Amazónicos'),
        backgroundColor: Colors.green,
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listaDatos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_listaDatos[index]['nombre_producto']),
                    subtitle: Text(_listaDatos[index]['precio_producto']),
                  ),
                );
              },
            ),
    );
  }
}

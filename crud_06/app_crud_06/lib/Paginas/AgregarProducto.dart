import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarProducto extends StatefulWidget {
  const AgregarProducto({super.key});

  @override
  State<AgregarProducto> createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nombreProducto = TextEditingController();
  TextEditingController precioProducto = TextEditingController();

  Future<bool> _guardar() async {
    try {
      final respuesta = await http.post(
        Uri.parse('http://172.20.10.4/crud_06/crear.php'),
        body: {
          'nombre_producto': nombreProducto.text,
          'precio_producto': precioProducto.text,
        },
      );

      if (respuesta.statusCode == 200) {
        final body = jsonDecode(respuesta.body);

        if (body['mensaje'] == 'Exito') {
          return true;
        } else {
          print('Error: ${body['mensaje']}');

          if (body.containsKey('error')) {
            print('Detalles del error: ${body['error']}');
          } else {
            print('Respuesta del servidor:  ${respuesta.statusCode}');
          }
        }
      } else {
        print('Error: Código de estado ${respuesta.statusCode}');
      }
    } catch (e) {
      print('Error de excepción: $e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreProducto,
                decoration: const InputDecoration(
                  hintText: 'Nombre Producto',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre del producto no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: precioProducto,
                decoration: const InputDecoration(
                  hintText: 'Precio Producto',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El precio del producto no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    bool resultado = await _guardar();
                    if (resultado) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Datos guardados exitosamente')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Error al guardar los datos')),
                      );
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
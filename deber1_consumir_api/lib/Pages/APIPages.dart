import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/Gif.dart';

class APIPages extends StatefulWidget {
  @override
  _APIPagesState createState() => _APIPagesState();
}

class _APIPagesState extends State<APIPages> {
  // Lista de GIFs
  List<Gif> _gifs = [];

  // Función para obtener los GIFs de la API
  Future<void> _getGifs() async {
    // Configurar HttpClient para ignorar verificación SSL
    HttpClient client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    // Realizar la solicitud usando el HttpClient
    final request = await client.getUrl(Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=xGvwm5izkJ6k8sONCRZrYI7Zq10R7neB&limit=10&offset=0&rating=g&bundle=messaging_non_clips"));
    final response = await request.close();

    if (response.statusCode == 200) {
      final String responseBody = await response.transform(utf8.decoder).join();
      final jsonData = jsonDecode(responseBody);

      // Limpiar la lista antes de agregar nuevos datos
      _gifs.clear();

      // Recorrer el JSON y agregar los GIFs a la lista
      for (var item in jsonData["data"]) {
        String name = item["title"];
        String url = item["images"]["original"]["url"];
        _gifs.add(Gif(name, url));

        // Imprimir en la consola
        print('Title: $name, URL: $url');
      }
      // Actualizar el estado para reflejar los nuevos datos
      setState(() {});
    } else {
      throw Exception("ERROR DE CONEXION");
    }
  }

  @override
  void initState() {
    super.initState();
    _getGifs(); // Llamar a la función para obtener los GIFs
  }

  // Diseño
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Consumir API Rest",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Consumir API"),
          backgroundColor: Colors.teal, // Cambiar el color de la AppBar
        ),
        body: _gifs.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: _gifs.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                color: Colors.lightBlue[50], // Agregar un color de fondo al ListTile
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(
                    _gifs[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    _gifs[index].url,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  leading: Image.network(
                    _gifs[index].url,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

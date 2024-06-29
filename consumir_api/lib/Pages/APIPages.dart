import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/Gif.dart';
import 'package:http/http.dart' as http;

class APIPages extends StatefulWidget{
  @override
  _APIPagesState createState()=> _APIPagesState();
}

class _APIPagesState extends State<APIPages> {
  //LOGICA


  //CONEXION
 late Future<List<Gif>> _listadoGifs; //resolver la conexion

 Future<List<Gif>> _getGifs() async {
   final response = await http.get(Uri.parse(
       "https://api.giphy.com/v1/gifs/trending?api_key=xGvwm5izkJ6k8sONCRZrYI7Zq10R7neB&limit=10&offset=0&rating=g&bundle=messaging_non_clips"));

   //agregar una lista
   List<Gif> gifs = [];


   //codigo de estado de respuestas
   if(response.statusCode ==200){
      //print(response.body);
     String body = utf8.decode(response.bodyBytes);
     final jsonData = jsonDecode(body);
     //print(jsonData["data"] [0] ["type"]);

     //recorrer el json
     /*for(var item in jsonData["data"]){
       gifs.add(Gif( item ["title"],
         item["images"] ["url"],
       ));
       //return gifs;
     }*/

     for (var item in jsonData["data"]) {
       String title = item["title"] ;
       String url = item["images"]["original"]["url"] ;
       gifs.add(Gif(title, url));

       // Imprimir en la consola
       print('Title: $title, URL: $url');
     }

   }else{
     throw Exception("ERROR DE CONEXION");
   }
   return gifs;
 }


 @override
  void initState() {
    super.initState();
    _listadoGifs = _getGifs();
 }

  //DISENO
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Consumir API Rest",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Consumir API"),
        ),

        body: Center(
          child:Container(
            child: Text("Hola mundo......"),
          )
        ),
      ),
    );
  }
}
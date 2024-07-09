import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      primarySwatch: Colors.lightGreen,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.black54, fontSize: 16),
        titleLarge: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List userData = [];

  @override
  void initState() {
    super.initState();
    // getUsers(); // Comentamos esta línea para evitar la carga inicial de usuarios
  }

  // GET
  Future<void> getUsers() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:4000/api/user'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data['user'];
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
    }
  }

  // POST
  Future<void> createUser(String firstName, String lastName, String avatar) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:4000/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'firstName': firstName,
          'lastName': lastName,
          'avatar': avatar,
        }),
      );

      if (response.statusCode == 201) {
        getUsers();
      } else {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      print(e);
    }
  }

  // PUT
  Future<void> updateUser(String id, String firstName, String lastName, String avatar) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:4000/api/user/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'firstName': firstName,
          'lastName': lastName,
          'avatar': avatar,
        }),
      );

      if (response.statusCode == 200) {
        getUsers();
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      print(e);
    }
  }

  // DELETE
  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:4000/api/user/$id'),
      );

      if (response.statusCode == 200) {
        getUsers();
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print(e);
    }
  }

  void _showUserDialog({String? id, String? firstName, String? lastName, String? avatar}) {
    final _firstNameController = TextEditingController(text: firstName);
    final _lastNameController = TextEditingController(text: lastName);
    final _avatarController = TextEditingController(text: avatar);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(id == null ? 'Create User' : 'Edit User'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(hintText: "Ponga su nombre"),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(hintText: "Ponga su apellido"),
                ),
                TextField(
                  controller: _avatarController,
                  decoration: InputDecoration(hintText: "Inserte el link de su imagen"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(id == null ? 'Create' : 'Update'),
              onPressed: () {
                if (id == null) {
                  createUser(
                    _firstNameController.text,
                    _lastNameController.text,
                    _avatarController.text,
                  );
                } else {
                  updateUser(
                    id!,
                    _firstNameController.text,
                    _lastNameController.text,
                    _avatarController.text,
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: getUsers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text('MÉTODO GET'),
                ),
                ElevatedButton(
                  onPressed: () => _showUserDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text('MÉTODO POST'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userData.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(userData[index]['avatar']),
                    ),
                    title: Text("${userData[index]["firstName"]} ${userData[index]["lastName"]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary),
                          onPressed: () {
                            _showUserDialog(
                              id: userData[index]['_id'],
                              firstName: userData[index]['firstName'],
                              lastName: userData[index]['lastName'],
                              avatar: userData[index]['avatar'],
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirme esa eliminación'),
                                  content: Text('¿Está segurísimo de que quiere eliminar el usuario?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Borrar'),
                                      onPressed: () {
                                        deleteUser(userData[index]['_id']);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gcma_v1/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final DatabaseService _databaseService = DatabaseService();

  void _editUser(String uid, String name, String email) async {
    Map<String, dynamic> userData = {
      'name': name,
      'email': email,
    };
    await _databaseService.updateUser(uid, userData);

    setState(() {});
  }

  void _deleteUser(String uid) async {
    await _databaseService.deleteUser(uid);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _databaseService.getUsers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          }

          return ListView(
            padding: EdgeInsets.all(8.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(
                        data['name'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(data['email'] ?? ['user'] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  String newName = data['name'] ?? '';
                                  String newEmail = data['email'] ?? '';

                                  TextEditingController _nameController =
                                      TextEditingController(text: newName);
                                  TextEditingController _emailController =
                                      TextEditingController(text: newEmail);

                                  return AlertDialog(
                                    title: Text('Edit User'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: _nameController,
                                          onChanged: (value) {
                                            newName = value;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Name'),
                                        ),
                                        TextFormField(
                                          controller: _emailController,
                                          onChanged: (value) {
                                            newEmail = value;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Email'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _editUser(
                                              document.id, newName, newEmail);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete User'),
                                    content: Text(
                                        'Are you sure you want to delete this user?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _deleteUser(document.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
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
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

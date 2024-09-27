import 'package:flutter/material.dart';
import 'package:primer_parcial/domain/models/dialogs.dart';
import 'package:primer_parcial/domain/models/user.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';

class UserProfile extends StatefulWidget {
  const UserProfile(
      {super.key, required this.userId, required this.repository});

  final int userId;

  final Repository repository;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<User?> userRequest;

  @override
  void initState() {
    super.initState();
    userRequest = widget.repository.getUserById(widget.userId);
  }

  void refreshUser() {
    setState(() {
      userRequest = widget.repository.getUserById(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userRequest,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: const Color.fromARGB(255, 252, 248, 255),
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          final User user = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil de Usuario'),
            ),
            body: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.person,
                    size: 200,
                  ),
                  Text('Nombre: ${user.name}'),
                  Text('Email: ${user.email}'),
                  Text('Edad: ${user.age}'),
                  Text('Género: ${user.gender.name}'),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                userDialog(context, 'Editar Usuario', widget.repository, user,
                    refreshUser);
              },
              child: const Icon(Icons.edit),
            ),
          );
        } else {
          return Center(child: Text(snapshot.error.toString()));
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:primer_parcial/domain/models/dialogs.dart';
import 'package:primer_parcial/domain/models/user.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final appLocalizations = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: userRequest,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          final User user = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(appLocalizations.userProfile),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.person,
                          size: 200,
                        ),
                        Text('${appLocalizations.name}: ${user.name}'),
                        Text('${appLocalizations.email}: ${user.email}'),
                        Text('${appLocalizations.age}: ${user.age}'),
                        Text('${appLocalizations.gender}: ${user.gender.name}'),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton.icon(
                      onPressed: () {
                        deleteUserDialog(context, widget.repository, user);
                      },
                      icon: const Icon(Icons.delete),
                      label: Text(appLocalizations.delete),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                userDialog(context, appLocalizations.editUser,
                    widget.repository, user, refreshUser);
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

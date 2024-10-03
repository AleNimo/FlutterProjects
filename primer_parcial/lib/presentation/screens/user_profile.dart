import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final textStyle = Theme.of(context).textTheme;
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: ClipOval(
                            child: Container(
                              color: Theme.of(context).colorScheme.onPrimary,
                              child: Center(
                                  child: Text(
                                user.name[0],
                                style: textStyle.displayLarge,
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person),
                                const SizedBox(width: 10),
                                Text(user.name, style: textStyle.headlineSmall),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Icon(Icons.email),
                                const SizedBox(width: 10),
                                Text(user.email,
                                    style: textStyle.headlineSmall),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                const SizedBox(width: 10),
                                Text('${user.age} ${appLocalizations.years}',
                                    style: textStyle.headlineSmall),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Icon(switch (user.gender) {
                                  Gender.male => Icons.male,
                                  Gender.female => Icons.female,
                                  Gender.other => FontAwesomeIcons.genderless,
                                }),
                                const SizedBox(width: 10),
                                Text(
                                    '${appLocalizations.gender}: ${switch (user.gender) {
                                      Gender.male => appLocalizations.male,
                                      Gender.female => appLocalizations.female,
                                      Gender.other => appLocalizations.other,
                                    }}',
                                    style: textStyle.headlineSmall),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton.icon(
                      onPressed: () {
                        deleteUserDialog(context, widget.repository, user);
                      },
                      icon: const Icon(Icons.person_off),
                      label: Text(appLocalizations.deleteUser),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                userDialog(
                  context: context,
                  repository: widget.repository,
                  userToEdit: user,
                  refreshFunction: refreshUser,
                );
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

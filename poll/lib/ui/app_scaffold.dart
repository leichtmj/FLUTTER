import 'dart:developer';

import 'package:poll/states/auth_state.dart';
import 'package:poll/states/poll_state.dart';
import 'package:poll/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:poll/ui/poll_page.dart';
import 'package:provider/provider.dart';

import '../models/poll.dart';
// import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    this.title,
    this.body,
    super.key,
  });

  final String? title;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Event Poll'),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: context.watch<AuthState>().isLoggedIn
                  ? Text(context.watch<AuthState>().currentUser!.username)
                  : Text("Bienvenue sur l'appli"),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Événements'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/polls', (_) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Connexion'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Inscription'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/signup', (_) => false);
              },
            ),
            context.watch<AuthState>().isLoggedIn
                ? ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Déconnexion'),
                    onTap: () {
                      context.read<AuthState>().logout();
                    })
                : Text('')
          ],
        ),
      ),
      body: SizedBox.expand(
        child: body,
      ),
    );
  }
}


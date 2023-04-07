import 'package:poll/states/auth_state.dart';
import 'package:poll/states/poll_state.dart';
import 'package:poll/ui/addpoll_page.dart';
import 'package:poll/ui/detail_page.dart';
import 'package:poll/ui/login_page.dart';
import 'package:poll/ui/poll_page.dart';
import 'package:poll/ui/poll_update.dart';
import 'package:poll/ui/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'ui/app_scaffold.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthState(),
      ),
      ChangeNotifierProxyProvider<AuthState, PollState>(
        create: (context) => PollState(),
        update: (context, authState, pollsState) =>
            pollsState!..setAuthToken(authState.token),
      ),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Poll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      supportedLocales: const [Locale('fr')],
      locale: const Locale('fr'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: '/polls',
      routes: {
        '/polls': (context) => const AppScaffold(
              title: 'Événements',
              body: PollPage(),
            ),
        '/polls/create': (context) => const AppScaffold(
              title: 'Ajouter un événement',
              body: AddPollPage(),
            ),
        '/polls/detail': (context) => const AppScaffold(
              title: 'Événement',
              body: DetailPage(),
            ),
        '/polls/update': (context) => const AppScaffold(
              title: 'Modifier un événement',
              body: UpdatePage(),
            ),
        '/login': (context) => const AppScaffold(
              title: 'Connexion',
              body: LoginPage(),
            ),
        '/signup': (context) => const AppScaffold(
              title: 'Inscription',
              body: SignInPage(),
            ),
      },
    );
  }
}

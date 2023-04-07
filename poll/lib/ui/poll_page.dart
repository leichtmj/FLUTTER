import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poll/models/user.dart';
import 'package:poll/states/poll_state.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;
import '../configs.dart';

import '../models/poll.dart';
import '../states/auth_state.dart';

class PollPage extends StatefulWidget {
  const PollPage({super.key});

  @override
  State<PollPage> createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  List<Poll> polls = [];

  @override
  void initState() {
    _loadPolls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue sur PollEvents'),
      ),
      body: polls == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.event),
                        title: Text(polls[index].name +
                            ' - ' +
                            DateFormat('dd/MM/yyyy', 'fr').format(DateTime(
                                DateTime.parse(polls[index].eventDate).year,
                                DateTime.parse(polls[index].eventDate).month,
                                DateTime.parse(polls[index].eventDate).day))),
                        subtitle: Text(polls[index].description),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: const Text('Détails'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/polls/detail',
                                  arguments: polls[index]);
                            },
                          ),
                          const SizedBox(width: 8),
                          context.watch<AuthState>().currentUser?.role ==
                                  'admin'
                              ? TextButton(
                                  child: const Text('Modifier'),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/polls/update',
                                        arguments: polls[index]);
                                  },
                                )
                              : Text(''),
                          const SizedBox(width: 8),
                          context.watch<AuthState>().currentUser?.role ==
                                  'admin'
                              ? TextButton(
                                  child: const Text('Supprimer'),
                                  onPressed: () {
                                        _deletePoll(polls[index].id);
                                  },
                                )
                              : Text(''),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                );
              },
              itemCount: polls.length),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          context.watch<AuthState>().currentUser?.role == 'admin'
              ? FloatingActionButton(
                  heroTag: 'create',
                  onPressed: () {
                    Navigator.pushNamed(context, '/polls/create');
                  },
                  child: const Icon(Icons.add),
                )
              : Text(''),
          const SizedBox(width: 15),
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: () {
              _loadPolls();
            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Future<void> _loadPolls() async {
    http.Response res = await http.get(
      Uri.parse('${Configs.baseUrl}/polls'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    print(res.body);

    List<dynamic> body = cnv.jsonDecode(res.body);
    polls = body.map((dynamic item) => Poll.fromJson(item)).toList();
    setState(() {});
  }

  _deletePoll(int id) async {
    final token = context.read<AuthState>().token;

    http.Response res = await http.delete(
      Uri.parse('${Configs.baseUrl}/polls/$id'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    print(res.body);

    if (res.statusCode == 200) {
      _loadPolls();
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs.dart';
import '../models/poll.dart';
import '../models/vote.dart';
import '../states/auth_state.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String password = '';
  String? error;

  late Poll poll = Poll.empty();

  late int count = 0;

  List<Vote> _votes = [];
  List<Vote> get votes => _votes;

  final _formKey = GlobalKey<FormState>();
  String? _validateRequired(String? value) {
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null;
  }

  bool isChecked = false;

  void onChecked(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });

    if (isChecked) {
      _loadVotes();
    } else {
      // fonction à appeler lorsque la case est décochée
    }
  }

  // final poll = ModalRoute.of(context)?.settings.arguments as Poll?;

  @override
  void initState() {
    // countParticipation();
    super.initState();
  }

  Future<int> countParticipation() async {
    final poll = ModalRoute.of(context)?.settings.arguments as Poll?;
    http.Response res = await http.get(
      Uri.parse('${Configs.baseUrl}/polls/${poll?.id}/votes'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    print(res.body);

    List<Vote> body = cnv.jsonDecode(res.body);
    count = body.length;
    setState(() {});
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final poll = ModalRoute.of(context)?.settings.arguments as Poll?;
    return Scaffold(
      appBar: AppBar(
        title: Text(poll!.name),
      ),
      body: ListView(
        children: [
          Text(
              DateFormat('dd/MM/yyyy', 'fr').format(DateTime(
                  DateTime.parse(poll.eventDate).year,
                  DateTime.parse(poll.eventDate).month,
                  DateTime.parse(poll.eventDate).day)),
              style: TextStyle(fontStyle: FontStyle.italic)),
          Text(poll.description),

          // Image.asset('assets/header.png'),
          // const IconAndDetail(Icons.calendar_month, '1er avril'),
          // const IconAndDetail(Icons.location_city, 'Annecy'),

          const Divider(),
          Text(
            'Participation' + ' - ' + count.toString() + ' participants',
            style: TextStyle(fontSize: 28),
          ),
          CheckboxListTile(
            title: const Text('Cocher pour participer'),
            value: isChecked,
            onChanged: onChecked,
          ),
          ListView.builder(
  shrinkWrap: true,
  itemCount: _votes.length,
  itemBuilder: (BuildContext context, int index) {
    final vote = _votes[index];
    return ListTile(
      title: Text(vote.user.username),
    );
  },
),
        ],
      ), 
    );
  }

  Future<void> _loadVotes() async {
    final poll = ModalRoute.of(context)?.settings.arguments as Poll?;

    http.Response res = await http.get(
      Uri.parse('${Configs.baseUrl}/polls/${poll?.id}/votes'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    print(res.body);

    List<dynamic> body = cnv.jsonDecode(res.body);
    final _votes = body.map((dynamic item) => Poll.fromJson(item)).toList();

    setState(() {});
  }
}

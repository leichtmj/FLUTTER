import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as cnv;

import '../configs.dart';
import '../models/poll.dart';
import '../states/auth_state.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  
  String name = '';
  String description = '';
  DateTime eventDate = DateTime.now();
  String date='';
  bool isModif = false;
  String? error;
  final _formKey = GlobalKey<FormState>();
  String? _validateRequired(String? value) {
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null;
  }


  @override
  void initState() {
    super.initState();
  }


  void _update() async {
    final poll = ModalRoute.of(context)?.settings.arguments as Poll?;
    final token = context.read<AuthState>().token;
    String finalDate='';

    if(name == ''){
      name = poll!.name;
    }

    if(description == ''){
      description = poll!.description;
    }

    if(date != ''){
      isModif = true;
      final eventDate = DateTime.parse(date);
      finalDate= DateTime(eventDate.year, eventDate.month, eventDate.day).toIso8601String();
    }

    final loginResponse = await http.put(
      Uri.parse('${Configs.baseUrl}/polls/${poll?.id}'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader: 'Bearer $token'},
      body: json.encode({
        'name': name,
        'description': description,
        isModif? 'eventDate': '':  finalDate,
      }),
    );
    print(loginResponse.statusCode);

    if (loginResponse.statusCode == HttpStatus.ok) {
      print('ok');
      Navigator.pushNamedAndRemoveUntil(context, '/polls', (_) => false);
    }
    else if (loginResponse.statusCode == HttpStatus.unauthorized || loginResponse.statusCode == HttpStatus.badRequest) {
      print('marche pas');
      print(name);
      print(description);
      print(finalDate);
      print(token);
    }
    
  }



  @override
  Widget build(BuildContext context) {
    final poll = ModalRoute.of(context)?.settings.arguments as Poll?;
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: poll?.name),
            onChanged: (value) => poll?.name = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: poll?.description),
            onChanged: (value) => description = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText:DateFormat('dd/MM/yyyy','fr').format(DateTime(DateTime.parse(poll!.eventDate).year, DateTime.parse(poll.eventDate).month, DateTime.parse(poll.eventDate).day)), hintText: 'aaaa-mm-jj'),
            onChanged: (value) => date = value,
            validator: _validateRequired,
          ),
          if (error != null)
            Text(error!,
                style: theme.textTheme.labelMedium!
                    .copyWith(color: theme.colorScheme.error)),
          ElevatedButton(
            onPressed: _update,
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../configs.dart';
import '../states/auth_state.dart';

class AddPollPage extends StatefulWidget {
  const AddPollPage({super.key});

  @override
  State<AddPollPage> createState() => _AddPollPageState();
}

class _AddPollPageState extends State<AddPollPage> {
  String name = '';
  String description = '';
  DateTime eventDate = DateTime.now();
  String date='';
  String? error;
  final _formKey = GlobalKey<FormState>();
  String? _validateRequired(String? value) {
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null;
  }

  void _submit() async {
    
    if(date == '' || date == null || date == ""){
      eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day+1);
    }
    else{
      eventDate = DateTime.parse(date);
    }


    final token = context.read<AuthState>().token;
    final finalDate= DateTime(eventDate.year, eventDate.month, eventDate.day).toIso8601String();

    final response = await http.post(
      Uri.parse('${Configs.baseUrl}/polls'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader: 'Bearer $token'},
      body: json.encode({
        'name': name,
        'description': description,
        'eventDate':  finalDate,
      }),
    );
    print(response.statusCode);

    if (response.statusCode == HttpStatus.ok) {
      print('ok');
      Navigator.pop(context);
    }
    else if (response.statusCode == HttpStatus.unauthorized || response.statusCode == HttpStatus.badRequest) {
      print('marche pas');
      print(name);
      print(description);
      print(finalDate);
      print(token);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nom'),
            onChanged: (value) => name = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            onChanged: (value) => description = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Date', hintText: 'aaaa-mm-jj'),
            onChanged: (value) => date = value,
            validator: _validateRequired,
          ),
          if (error != null)
            Text(error!,
                style: theme.textTheme.labelMedium!
                    .copyWith(color: theme.colorScheme.error)),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}

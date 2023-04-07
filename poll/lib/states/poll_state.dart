import 'dart:convert';

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:poll/models/poll.dart';

import '../configs.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

import '../result.dart';

//n'est pas utilisé
class PollState extends ChangeNotifier {
  List<Poll> _polls = [];
  Poll? _poll;
  String? _token;
  late String error;

  List<Poll> get polls => _polls;
  String? get token => _token;

  void setAuthToken(token) async {
    _token = token;
  }

  Future<List<Poll>> getAll() async {
    final allPollsResponse = await http.get(
      Uri.parse('${Configs.baseUrl}/polls'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    if (allPollsResponse.statusCode == HttpStatus.ok) {
      List<dynamic> polls = json.decode(allPollsResponse.body);

      _polls = polls.map((poll) => Poll.fromJson(poll)).toList();
      notifyListeners();
      return _polls;
    }
    // else {
    //   error = allPollsResponse.statusCode == HttpStatus.unauthorized ||
    //           allPollsResponse.statusCode == HttpStatus.badRequest
    //       ? 'Identifiants incorrects'
    //       : 'Erreur de connexion';
    // }

    return _polls;
  }



  
}

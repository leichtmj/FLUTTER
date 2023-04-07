import 'package:intl/intl.dart';
import 'package:poll/models/user.dart';

class Vote {
  Vote(
      {required this.pollId,
      required this.status,
      required this.created,
      required this.user});



  int pollId;
  String status; 
  String created;
  User user;


  Vote.fromJson(Map<String, dynamic> json)
      : this(
          pollId: json['pollId'] as int,
          status: json['status'] as String,
          created: json['created'] as String,
          user: json['user'] as User,
        );

  @override
  String toString() {
    return '$pollId $status $created $user';
  }
}

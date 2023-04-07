import 'package:intl/intl.dart';

class Poll {
  Poll(
      {required this.id,
      required this.name,
      required this.description,
      this.imageName,
      required this.eventDate});

  Poll.empty()
      : this(
          id: 0,
          name: '',
          description: '',
          imageName: '',
          eventDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        );

  



  int id;
  String name;
  String description;
  String? imageName;
  String eventDate;

  Poll.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as int,
          name: json['name'] as String,
          description: json['description'] as String,
          imageName: json['imageName'] as String?,
          eventDate: json['eventDate'] as String,
        );

  @override
  String toString() {
    return '$id $name $description $imageName $eventDate';
  }
}

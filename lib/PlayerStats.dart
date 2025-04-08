
import 'package:uuid/uuid.dart';

class PlayerStats {
  String name;
  int time;
  final String id;

  PlayerStats(this.id, this.name, this.time);

  PlayerStats.json(Map<String, dynamic> json)
      : id = json['id'] ?? const Uuid().v4(),
        name = json['name'] ?? "PlayerF ${json['id']}",
        time = json['time'] ?? 60;

}
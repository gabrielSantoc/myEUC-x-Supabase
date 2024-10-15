import 'package:hive/hive.dart';

part 'eventModelHive.g.dart';

@HiveType(typeId: 1)
class EventModelHive {
  EventModelHive({
    required this.date,
    required this.eventName,
    required this.eventDescription,
  });

  @HiveField(0)
  late final String date;

  @HiveField(1)
  late final String eventName;

  @HiveField(2)
  late final String eventDescription;

}
class Alarm {
  final int? id;
  final String title;
  final DateTime alarmTime;
  final bool isActive;
  final String? description;
  final double? latitude;
  final double? longitude;

  Alarm({
    this.id,
    required this.title,
    required this.alarmTime,
    this.isActive = true,
    this.description,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'alarm_time': alarmTime.millisecondsSinceEpoch,
      'is_active': isActive ? 1 : 0,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Alarm.fromMap(Map<String, dynamic> map) {
    return Alarm(
      id: map['id'],
      title: map['title'],
      alarmTime: DateTime.fromMillisecondsSinceEpoch(map['alarm_time']),
      isActive: map['is_active'] == 1,
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Alarm copyWith({
    int? id,
    String? title,
    DateTime? alarmTime,
    bool? isActive,
    String? description,
    double? latitude,
    double? longitude,
  }) {
    return Alarm(
      id: id ?? this.id,
      title: title ?? this.title,
      alarmTime: alarmTime ?? this.alarmTime,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

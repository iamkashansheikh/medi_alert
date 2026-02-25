// medicine_model.dart
class Medicine {
  String id;
  String name;
  String time; // 24-hour format: "17:30"
  String repeatType; // 'once', 'daily', 'weekly', 'monthly'
  List<int> selectedDays; // [1,2,3] for Monday, Tuesday, Wednesday
  bool hasSnooze;
  int snoozeMinutes;
  DateTime createdAt;

  Medicine({
    String? id,
    required this.name,
    required this.time,
    this.repeatType = 'once',
    this.selectedDays = const [],
    this.hasSnooze = true,
    this.snoozeMinutes = 5,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  // Display time in 12-hour format
  String get displayTime {
    final parts = time.split(':');
    if (parts.length != 2) return time;
    
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    
    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour % 12;
    if (displayHour == 0) displayHour = 12;
    
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  // Repeat text for display
  String get repeatText {
    switch (repeatType) {
      case 'once':
        return 'Once';
      case 'daily':
        return 'Daily';
      case 'weekly':
        if (selectedDays.isEmpty) return 'Weekly';
        List<String> days = [];
        for (int day in selectedDays) {
          switch (day) {
            case 1: days.add('Mon'); break;
            case 2: days.add('Tue'); break;
            case 3: days.add('Wed'); break;
            case 4: days.add('Thu'); break;
            case 5: days.add('Fri'); break;
            case 6: days.add('Sat'); break;
            case 7: days.add('Sun'); break;
          }
        }
        return 'Weekly (${days.join(', ')})';
      case 'monthly':
        return 'Monthly';
      default:
        return 'Once';
    }
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'time': time,
    'repeatType': repeatType,
    'selectedDays': selectedDays,
    'hasSnooze': hasSnooze,
    'snoozeMinutes': snoozeMinutes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Medicine.fromMap(Map<String, dynamic> map) => Medicine(
    id: map['id'],
    name: map['name'],
    time: map['time'],
    repeatType: map['repeatType'] ?? 'once',
    selectedDays: List<int>.from(map['selectedDays'] ?? []),
    hasSnooze: map['hasSnooze'] ?? true,
    snoozeMinutes: map['snoozeMinutes'] ?? 5,
    createdAt: DateTime.parse(map['createdAt']),
  );
}
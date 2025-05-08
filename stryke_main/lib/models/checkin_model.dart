import 'package:cloud_firestore/cloud_firestore.dart';


//USE THIS FOR RETRIEVING DATA FOR COACH VIEW
class CheckIn {
  final bool checkedIn;
  final DateTime timestamp;

  CheckIn({required this.checkedIn, required this.timestamp});

  factory CheckIn.fromMap(Map<String, dynamic> map) {
    return CheckIn(
      checkedIn: map['checkedIn'] ?? false,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'checkedIn': checkedIn,
    'timestamp': timestamp,
  };
}

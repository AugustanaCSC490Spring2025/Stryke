import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CheckInService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<bool> isCheckedInToday(String userId) async {
    final doc = await _db.collection('users').doc(userId).collection('checkins').doc(todayKey).get();
    return doc.exists && doc.data()?['checkedIn'] == true;
  }

  Future<void> createUnverifiedCheckIn(String userId) async {
    final docRef = _db.collection('users').doc(userId).collection('checkins').doc(todayKey);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'checkedIn': false,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> markCheckedIn(String userId) async {
    await _db.collection('users').doc(userId).collection('checkins').doc(todayKey).set({
      'checkedIn': true,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

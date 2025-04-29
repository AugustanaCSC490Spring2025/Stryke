import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/stat_point.dart';
import '../utils/field_mapping.dart';

class FirestoreService {

  Future<List<StatPoint>> fetchStatData(String metricName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final userId = user.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(metricName)
        .get();

    // Get the correct field name for this metric
    final fieldName = getFieldNameForMetric(metricName);

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final timestamp = data['timestamp'];
      final value = data['value'];

      print("Fetched timestamp: $timestamp, value: $value");

      if (timestamp == null || value == null) {
        throw Exception("Missing 'timestamp' or '$fieldName' field in: $data");
      }

      return StatPoint(
        (timestamp as Timestamp).toDate(),
        double.parse(value.toString()),
      );
    }).toList();
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/stat_point.dart';

class FirestoreService {

  Future<List<StatPoint>> fetchStatData(String metricName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final userId = user.uid;
    QuerySnapshot snapshot;

    print(metricName);

    snapshot = await FirebaseFirestore.instance.collection('users').doc(userId!).collection(metricName.toLowerCase()).get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      print("Raw data: $data");

      final timestamp = data['timestamp'];
      final value = data['weight'];

      if (timestamp == null || value == null) {
        throw Exception("Missing 'timestamp' or 'weight' field in: $data");
      }

      return StatPoint(
        (timestamp as Timestamp).toDate(),
        double.parse(value.toString()),
      );
    }).toList();

  }
}

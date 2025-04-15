import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stat_point.dart';

// class FirestoreService {
//   Future<List<StatPoint>> fetchStatData() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(myUser!.uid).collection( dynamicBasedOnWhicheverIsSelected );
//     return snapshot.docs.map((doc) {
//       final data = doc.data();
//       return StatPoint(
//         DateTime.parse(data['date']),
//         (data['value'] as num).toDouble(),
//       );
//     }).toList();
//   }
// }

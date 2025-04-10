import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/utils/exerciseDropDown.dart';

class ExerciseServices{
  
  Future<List<ExerciseDropdownItem>> fetchGlobalQuickAddData() async{
    final snapshot = await FirebaseFirestore.instance.collection('exercises').get();

    return snapshot.docs.map((doc){
      return ExerciseDropdownItem(id: doc.id, name: doc['name']);
    }).toList();
  }

  Future<void> addExerciseDataForUser({required String userID, required String exerciseID, required Map<String, dynamic> metrics}) async{
    
  }

  
} 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/utils/exerciseDropDown.dart';

class ExerciseServices{
  
  Future<List<ExerciseDropdownItem>> fetchGlobalExercises() async{
    final snapshot = await FirebaseFirestore.instance.collection('exercises').get();

    return snapshot.docs.map((doc){
      return ExerciseDropdownItem(id: doc.id, name: doc['name']);
    }).toList();
  }

  Future<List<String>> fetchGloabalExerciseTrackedFields(String exerciseName) async{
    final snapshot = await FirebaseFirestore.instance.collection('exercises')
      .where('name', isEqualTo: exerciseName)
      .limit(1)
      .get();

    if(snapshot.docs.isNotEmpty){
      return List<String>.from(snapshot.docs.first.get('trackedFields'));
    }else{
      return [];
    }
  }

  Future<List>fetchGlobalExerciseNames() async{
    final snapshot = await FirebaseFirestore.instance.collection('exercises').get();

    return snapshot.docs.map((doc){
      return doc.get('name');
    }).toList();
  }

  Future<void> addUserExercise({required String userID, required String exerciseID, required Map<String, dynamic> metrics}) async{
    final globalExerciseRef = await FirebaseFirestore.instance.collection('exercises').doc(exerciseID);

    final userExercisesRef = await FirebaseFirestore.instance.collection(exerciseID);

    await userExercisesRef.add({
      'metrics' : metrics,
      'timestamp' : DateTime.now()
    });
  }

  
} 

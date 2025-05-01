import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/components/exerciseDropDown.dart';

class ExerciseServices{
  
  Future<List<ExerciseDropdownItem>> fetchGlobalExercises() async{
    final snapshot = await FirebaseFirestore.instance.collection('exercises').get();

    return snapshot.docs.map((doc){
      return ExerciseDropdownItem(id: doc.id, name: doc['name']);
    }).toList();
  }

  Future <String> fetchGloabalExerciseTrackedField(String exerciseName) async{
    final snapshot = await FirebaseFirestore.instance.collection('exercises')
      .where('name', isEqualTo: exerciseName)
      .limit(1)
      .get();

    if(snapshot.docs.isNotEmpty){
      return snapshot.docs.first.get('trackedField');
    }else{
      return '';
    }
  }

  Future<List>fetchGlobalExerciseNames() async{
    final snapshot = await FirebaseFirestore.instance.collection('exercises').get();

    return snapshot.docs.map((doc){
      return doc.get('name');
    }).toList();
  }

  Future<void> addUserExercise({required String userID, required String exerciseName, required String value, required DateTime date}) async{
    final userExerciseRef = FirebaseFirestore.instance.collection('users').doc(userID).collection(exerciseName);

    await userExerciseRef.add({
      'value' : value,
      'timestamp' : Timestamp.fromDate(date)
    });
  }

  Future <void> addUserWeight({required String userID, required String weight, required DateTime date})async{
    final userWeightRef = FirebaseFirestore.instance.collection('users').doc(userID).collection('Weight');

    await userWeightRef.add({
      'timestamp' : Timestamp.fromDate(date),
      'value' : weight
    });
  }

  Future <double> fetchGoal({required String userID, required String goalName}) async{
    final goalDoc = await FirebaseFirestore.instance.collection('users').doc(userID)
      .collection('goals').doc(goalName).get();

    final rawData = goalDoc.data()?['goalValue'];
    return double.tryParse(rawData ?? '') ?? 0;
  }

  Future <void> addGoal({required String userID, required String goalAmount, required String goalName}) async {
    final goalDoc = FirebaseFirestore.instance.collection('users').doc(userID).collection('goals').doc(goalName);

    await goalDoc.set({
      'timestamp' : DateTime.now(),
      'goalValue' : goalAmount,
      'trackedGoal' : goalName
    });
  }

  Future <QuerySnapshot> checkEntry({required String userID, required String metricName}) async {
    return await FirebaseFirestore.instance.collection('users').doc(userID)
      .collection(metricName)
      .orderBy('timestamp')
      .limit(1)
      .get();
  }
} 

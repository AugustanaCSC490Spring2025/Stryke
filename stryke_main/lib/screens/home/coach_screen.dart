import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../database_services/exercise_service.dart';
import '../../widgets/metric_box/coach_metric_box.dart';
import '../../widgets/profile_info_topbar.dart';
import '../../utils/spacing.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  User? myUser = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  List<Map<String, dynamic>> athleteCards = [];
  String selectedMetric = 'Weight';
  String searchQuery = '';
  List<String> metricBoxExercises = [];
  String? teamId = '';

  @override
  void initState() {
    super.initState();
    _loadCoachAthletes();
    _loadGlobalExercises();
  }

  Future<void> _loadGlobalExercises() async {
    final rawList = await ExerciseServices().fetchGlobalExerciseNames();
    final List<String> names = rawList.cast<String>();

    if (!names.contains('Weight')) names.add('Weight');

    final uniqueNames = names.toSet().toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    setState(() {
      metricBoxExercises = uniqueNames;
    });
  }



  Future<void> _loadCoachAthletes() async {
    if (myUser == null) return;

    setState(() => isLoading = true);

    final coachId = myUser!.uid;
    final teamsSnapshot =
        await FirebaseFirestore.instance.collection('teams').get();
    final List<String> athleteIds = [];

    for (var doc in teamsSnapshot.docs) {
      final data = doc.data();
      List<String> coachIds = [];
      final rawCoachIds = data['coaches_IDs'];
      if (rawCoachIds is String) {
        coachIds.add(rawCoachIds);
      } else if (rawCoachIds is Iterable) {
        coachIds = List<String>.from(rawCoachIds);
      }
      if (coachIds.contains(coachId)) {
        final rawAthleteIDs = data['athlete_IDs'];

        if (rawAthleteIDs is String) {
          athleteIds.add(rawAthleteIDs);
        } else if (rawAthleteIDs is Iterable) {
          athleteIds.addAll(List<String>.from(rawAthleteIDs));
        }
      }
    }

    final Set<String> uniqueAthleteIds = athleteIds.toSet();
    final List<Map<String, dynamic>> fetched = [];

    for (String uid in uniqueAthleteIds) {
      print('Loading athlete: $uid');

      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!userDoc.exists) {
        print('User $uid not found');
        continue;
      }

      final firstName = userDoc.data()?['first_Name'] ?? 'Unknown';
      final lastName = userDoc.data()?['last_Name'] ?? '';
      final lastInitial = lastName.isNotEmpty ? '${lastName[0]}.' : '';
      final name = '$firstName $lastInitial';

      final todayStart = DateTime.now();
      final today = DateTime(todayStart.year, todayStart.month, todayStart.day);

      final checkinQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('checkins')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
          .get();

      final checkedInToday = checkinQuery.docs.any((doc) => doc['checkedIn'] == true);


      final metricSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection(selectedMetric)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (metricSnapshot.docs.isEmpty) {
        print('No data for $uid on $selectedMetric');
        continue;
      }


      final metricDoc = metricSnapshot.docs.first;
      final value = metricDoc['value'];
      final date = DateFormat.yMMMMd().format((metricDoc['timestamp'] as Timestamp).toDate());

      fetched.add({
        'id': uid,
        'name': name,
        'value': value,
        'date': date,
        'checkedInToday' : checkedInToday
      });
    }

    setState(() {
      athleteCards = fetched;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final filteredAthletes = athleteCards.where((athlete) {
      final name = athlete['name'].toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .07)),
          ProfileInfoTopbar(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            myUser: myUser!,
          ),
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .02)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Athletes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )),
                  verticalSpacing(10),
                  TextField(
                    onChanged: (val) => setState(() => searchQuery = val),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF303030),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white38),
                    ),
                  ),
                  verticalSpacing(15),
                  Row(
                    children: [
                      const Text(
                        "Filtered For...",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        dropdownColor: const Color(0xFF2C2C2C),
                        value: selectedMetric,
                        style: const TextStyle(
                          color: Color(0xFFB7FF00),
                          fontSize: 18,
                        ),
                        items: metricBoxExercises
                            .map((name) => DropdownMenuItem<String>(
                          value: name,
                          child: Text(name,
                              style: const TextStyle(color: Color(0xFFB7FF00))),
                        ))
                            .toList(),
                        onChanged: (newMetric) {
                          if (newMetric != null) {
                            setState(() => selectedMetric = newMetric);
                            _loadCoachAthletes();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: verticalSpacing(10)),
          isLoading
              ? const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final athlete = filteredAthletes[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: buildCoachMetricBox(
                            context: context,
                            athleteId: athlete['id'],
                            athleteName: athlete['name'],
                            value: athlete['value'],
                            date: athlete['date'],
                            selectedMetric: selectedMetric,
                          checkedInToday: athlete['checkedInToday'],
                            teamId: teamId,
                        ),
                      );
                    },
                    childCount: filteredAthletes.length,
                  ),
                ),
        ],
      ),
    );
  }
}

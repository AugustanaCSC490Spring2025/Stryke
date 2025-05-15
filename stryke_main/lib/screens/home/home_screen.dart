import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/metric_entry.dart';
import '../../widgets/metric_box/add_metric_dialog.dart';
import '../../widgets/metric_box/metric_box_builder.dart';
import '../../utils/spacing.dart';
import 'package:test_app/database_services/exercise_service.dart';
import 'package:intl/intl.dart';
import '../../widgets/profile_info_topbar.dart';
import '../../widgets/attendance/workout_checkin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? myUser = FirebaseAuth.instance.currentUser;
  String? weight;
  bool isLoading = true;
  bool isCoach = false;

  // Student
  late List<String> preferences;
  List<MetricEntry> metricEntries = [];
  List metricBoxExercises = [];
  Set<String> addedMetrics = {};

  // Coach
  List<Map<String, dynamic>> athleteMetrics = [];
  String selectedMetric = "Weight";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadGlobalExercises();
  }

  Future<void> _initializeUser() async {
    setState(() => isLoading = true);

    final userRef =
    FirebaseFirestore.instance.collection('users').doc(myUser!.uid);
    final userDoc = await userRef.get();
    final data = userDoc.data() ?? {};
    final role = data['is_Coach'] ?? false;

    isCoach = role == 'coach';

    if (isCoach) {
      await _loadAthleteData();
    } else {
      await _loadStudentData(data);
    }

    setState(() => isLoading = false);
  }

  Future<void> _loadStudentData(Map<String, dynamic> data) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(myUser!.uid);
    final userDoc = await userRef.get();

    List<String> prefs;

    if (!userDoc.exists || data['metric_preferences'] == null) {
      prefs = ['Weight'];
      await userRef.set({
        'metric_preferences': prefs,
        'is_Coach': false,
        'name': 'Unnamed' // or however you collect it
      }, SetOptions(merge: true)); // 🔐 safer merge
    } else {
      prefs = List<String>.from(data['metric_preferences']);
    }

    setState(() => preferences = prefs);
    await _loadUserPreferences(preferences);
  }


  Future<void> _loadUserPreferences(List<String> preferences) async {
    if (preferences.isEmpty) preferences.add('Weight');

    for (var collection in preferences) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(myUser!.uid)
          .collection(collection)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final timestamp = doc.get('timestamp');
        final date = DateFormat('MM/dd/yyyy').format(timestamp.toDate());
        setState(() {
          weight = doc['value'].toString();
          metricEntries.add(MetricEntry(
            metricType: collection,
            value: weight!,
            date: date,
          ));
        });
      }
    }
  }

  Future<void> _loadAthleteData() async {
    final usersSnapshot =
    await FirebaseFirestore.instance.collection('users').get();
    List<Map<String, dynamic>> fetchedData = [];

    for (var userDoc in usersSnapshot.docs) {
      final userId = userDoc.id;
      final name = userDoc.data()['name'] ?? 'Unnamed';

      final metricSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(selectedMetric)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (metricSnapshot.docs.isNotEmpty) {
        final metricDoc = metricSnapshot.docs.first;
        final value = metricDoc.get('value').toString();
        final timestamp = metricDoc.get('timestamp') as Timestamp;
        final formattedDate = DateFormat.yMMMMd().format(timestamp.toDate());

        fetchedData.add({
          'name': name,
          'value': value,
          'date': formattedDate,
          'userId': userId,
        });
      }
    }

    fetchedData.sort(
            (a, b) => double.parse(b['value']).compareTo(double.parse(a['value'])));
    setState(() => athleteMetrics = fetchedData);
  }

  Future<void> _loadGlobalExercises() async {
    ExerciseServices().fetchGlobalExerciseNames().then((exerciseNames) {
      setState(() {
        metricBoxExercises = exerciseNames;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1C1C1C),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return isCoach
        ? _buildCoachScreen(screenHeight, screenWidth)
        : _buildStudentScreen(screenHeight, screenWidth);
  }

  Widget _buildCoachScreen(double screenHeight, double screenWidth) {
    final filteredAthletes = athleteMetrics.where((athlete) {
      final name = athlete['name'].toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ProfileInfoTopbar(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                myUser: myUser!),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Filtered for...',
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    dropdownColor: const Color(0xFF2C2C2C),
                    value: selectedMetric,
                    style: const TextStyle(color: Color(0xFFB7FF00)),
                    items:
                    ['Weight', 'Bench Press', 'Squat'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newMetric) {
                      if (newMetric != null) {
                        setState(() => selectedMetric = newMetric);
                        _loadAthleteData();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAthletes.length,
                itemBuilder: (context, index) {
                  final athlete = filteredAthletes[index];
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        title: Text(
                          athlete['name'],
                          style: const TextStyle(color: Color(0xFFB7FF00)),
                        ),
                        subtitle: Text(
                          '${athlete['value']} lbs',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(athlete['date'],
                                style: const TextStyle(color: Colors.white54)),
                            const Icon(Icons.arrow_forward_ios,
                                color: Colors.white70, size: 16),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentScreen(double screenHeight, double screenWidth) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .07)),
          ProfileInfoTopbar(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              myUser: myUser!),
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .025)),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WorkoutCheckInCard(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        userId: myUser?.uid),
                    verticalSpacing(screenHeight * .02),
                    Container(height: 1, color: Colors.white24),
                    verticalSpacing(screenHeight * .02),
                    const Text("Your Metrics...",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    verticalSpacing(screenHeight * .01),
                    ...metricEntries.map((entry) => buildMetricBox(
                        context, entry.metricType, entry.value, entry.date)),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB7FF00),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * .35,
                            vertical: screenHeight * .025,
                          ),
                        ),
                        onPressed: () {
                          showAddMetricDialog(
                            context: context,
                            metricBoxExercises: metricBoxExercises,
                            addedMetrics: addedMetrics,
                            metricEntries: metricEntries,
                            userID: myUser!.uid,
                            refreshState: () => setState(() {}),
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.black, size: 25)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpacing(screenHeight * .05),
            ]),
          ),
        ],
      ),
    );
  }
}

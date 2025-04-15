import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:test_app/utils/exerciseDropDown.dart';
import '../../helpers/metric_box_builder.dart';
import '../../utils/spacing.dart';
import 'package:test_app/database_services/exerciseService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? myUser = FirebaseAuth.instance.currentUser;
  String? name;
  String? weight;
  bool isLoading = true;
  List<ExerciseDropdownItem> _exerciseOptions = [];
  ExerciseDropdownItem? _quickAddValue;
  List metricBoxes = [];
  List metricBoxExercises = [];
  List<String> trackedFields = [];
  Map<String, String> fieldValues = {};
  Set<String> addedMetrics = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadGlobalExercises();
  }

  // Function to load user data from Firestore
  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(myUser!.uid)
        .get();
      
    QuerySnapshot weightSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(myUser!.uid)
        .collection('weights')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    
    DocumentSnapshot weightDoc = weightSnapshot.docs.first;
    setState(() {
      weight = weightDoc['weight'].toString();
      metricBoxes.add(buildMetricBox("Weight", weight!, 'date'));
    });


    if (userDoc.exists) {
      setState(() {
        //weight = weightDoc['weight'];
        name = userDoc['first_Name'];
      });
    } else {
      setState(() {
        name = "Unknown User";
      });
    }

    setState(() => isLoading = false);
  }

  Future<void> _loadGlobalExercises() async {
    final exercises = await ExerciseServices().fetchGlobalExercises();
    ExerciseServices().fetchGlobalExerciseNames().then((exerciseNames){

      setState(() {
        _exerciseOptions = exercises;
        metricBoxExercises = exerciseNames;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(
        slivers: [
          // HEIGHT BEFORE PROFILE BAR
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .03)),

          //TOP BAR WITH PROFILE ICON AND USER NAME
          SliverAppBar(
            floating: false,
            pinned: false,
            snap: false,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF1C1C1C),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22.0,
                      backgroundImage: NetworkImage(myUser?.photoURL ??
                          'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg'),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome,',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$name! You are $weight pounds',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                      iconSize: 26,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .035)),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.05, right: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quick Add",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: const Color(0xFF303030),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 5),
                          Expanded(
                            child: DropdownButton<ExerciseDropdownItem>(
                              hint: const Text(
                                "Select Exercise: ",
                                style: TextStyle(color: Colors.white24),
                              ),
                              underline: SizedBox(),
                              dropdownColor: const Color(0xFF303030),
                              value: _quickAddValue,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              iconSize: 30,
                              isExpanded: true,
                              onChanged: (ExerciseDropdownItem? newValue) {
                                setState(() {
                                  _quickAddValue = newValue;
                                });
                              },
                              items: _exerciseOptions.map((exercise) {
                                return DropdownMenuItem<ExerciseDropdownItem>(
                                  value: exercise,
                                  child: Text(exercise.name,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                              width: 2,
                              height: screenWidth * 0.1,
                              color: Color(0xFF1C1C1C)),
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "input here",
                                hintStyle: TextStyle(color: Colors.white24),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.add, color: Color(0xFFB7FF00)),
                            onPressed: () async {
                            },
                          ),
                        ],
                      ),
                    ),
                    verticalSpacing(screenHeight * .02),

                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    verticalSpacing(screenHeight * .02),

                    const Text(
                      "Your Metrics",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),

                    verticalSpacing(screenHeight * .02),

                    // Dynamically add the metric boxes here
                    ...metricBoxes,

                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB7FF00),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String? selectedMetric;
                              String inputValue = '';

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    backgroundColor: const Color(0xFF303030),
                                    title: const Text(
                                      'Add New Metric',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        DropdownButton<String>(
                                          hint: const Text(
                                            'Select Metric...',
                                            style: TextStyle(
                                                color: Colors.white24),
                                          ),
                                          underline: const SizedBox(),
                                          dropdownColor:
                                              const Color(0xFF303030),
                                          value: selectedMetric,
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                          onChanged: (String? newValue) async{
                                            setState(() {
                                              selectedMetric = newValue;
                                              trackedFields = [];
                                              fieldValues.clear();
                                            });
                                            final fields = await ExerciseServices().fetchGloabalExerciseTrackedFields(newValue!);

                                            setState((){
                                              trackedFields = fields;
                                              fieldValues = {for (var field in fields) field: ''};
                                            });
                                          },
                                          items: metricBoxExercises.map<DropdownMenuItem<String>>((name){
                                            return DropdownMenuItem(
                                              value: name,
                                              child: Text(name,
                                              style: TextStyle(color: Colors.white),
                                              ),
                                            );
                                          }).toList(),
                                        ),

                                        //Dynamic Fields Values Based on 
                                        const SizedBox(height: 10),
                                        ...trackedFields.map((fieldName){
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: TextField(
                                              style: const TextStyle(color: Colors.white),
                                              decoration: InputDecoration(
                                                hintText: 'Enter $fieldName',
                                                hintStyle: TextStyle(color: Colors.white24),
                                                enabledBorder: const UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white24)
                                                )
                                              ),
                                            onChanged: (value){
                                              setState((){
                                                fieldValues[fieldName] = value;
                                              });
                                            }
                                            ),
                                          );
                                        }).toList(),                                        
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          if (selectedMetric != null) {
                                            if (addedMetrics.contains(selectedMetric)) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("You already have a $selectedMetric metric displayed."),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return; // Prevent adding duplicate
                                            }
                                            final allFieldsFilled = fieldValues.values.every((value) => value.isNotEmpty);
                                            //Check If All Fields Are Filled In
                                            if(!allFieldsFilled){
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('You have not filled out $selectedMetric'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                            Navigator.of(context).pop();

                                            this.setState(() {
                                              addedMetrics.add(selectedMetric!);
                                              metricBoxes.add(buildMetricBox(selectedMetric!, 
                                              fieldValues.entries.map((e) => "${e.key}: ${e.value}").join("  •  "),
                                              "4/4/2025")); // Get the date of the value
                                            });
                                          }
                                        },
                                        child: const Text('Add'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ).then((_){
                            setState(() {
                              trackedFields = [];
                              fieldValues.clear();
                            });
                          });
                        },
                        child: const Text("Add Metric Box"),
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_app/components/main_navigation.dart';
import '../../utils/spacing.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? myUser = FirebaseAuth.instance.currentUser;
  String? _quickAddValue;
  String? _lineChartSelect;
  String? _lineChartPeriod;
  String? name;
  bool isLoading = true;

  

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);
    
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users') 
        .doc(myUser!.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        name = userDoc['first_Name']; 
      });
    } else {
      setState(() {
        name = "Unknown User"; 
      });
    }

    setState(() => isLoading = false);
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
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .07)),

          //TOP BAR WITH PROFILE ICON AND USER NAME
          SliverAppBar(
            floating: false,
            pinned: false,
            snap: false,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF1C1C1C),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                // Reduced padding to bring it closer
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.05),
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(myUser!.photoURL ?? // maybe the png in the app folders?
                            'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome,',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // User's Name (white)
                            Text(
                              '$name!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.02),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .035)),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keep striving for success,',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'Stay Hard!',
                    style: const TextStyle(
                      color: Color(0xFFB7FF00),
                      fontSize: 18,
                    ),
                  ),
                ],
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
                          "For Today...",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Text(
                          "Quick Add",
                          style: TextStyle(
                            color: Color(0xFFB7FF00), // bright green for contrast
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          ),
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
                          // DropdownButton for selection with arrow
                          Expanded(
                            child: DropdownButton<String>(
                              hint: const Text(
                                "Select: ",
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
                              onChanged: (String? newValue) {
                                setState(() {
                                  _quickAddValue = newValue;
                                });
                              },
                              items: <String>[
                                'Weight',
                                '3pt %',
                                '50s Free'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                              width: 1,
                              height: screenWidth * 0.1,
                              color: Color(0xFF1C1C1C)),
                          const SizedBox(width: 5),
                          // Text "input"
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "input here",
                                hintStyle: TextStyle(color: Colors.white24),
                                border: InputBorder
                                    .none, // No border around the TextField
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          // Black line divider
                          // Plus button at the end
                          IconButton(
                            icon:
                                const Icon(Icons.add, color: Color(0xFFB7FF00)),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(top: screenHeight * .05)),

                    const Text(
                      "Performance Data",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF303030),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      height: screenHeight * .30,
                      child: LineChart(
                        LineChartData(lineBarsData: [
                          LineChartBarData(
                            belowBarData: BarAreaData(
                                show: true, color: const Color(0x45B7FF00)),
                            color: const Color(0xFFB7FF00),
                            spots: const [
                              FlSpot(0, 3),
                              FlSpot(1, 5),
                              FlSpot(2, 6),
                              FlSpot(3, 7),
                              FlSpot(4, 7),
                              FlSpot(5, 8),
                              FlSpot(6, 9),
                              FlSpot(7, 10),
                              FlSpot(8, 12),
                              FlSpot(9, 15),
                            ],
                          ),
                        ]),
                      ),
                    ),
                    verticalSpacing(2),
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: const Color(0xFF303030),
                      ),
                      child: Row(
                        children: [
                          // Text "Select"
                          const Text(
                            "Value: ",
                            style: TextStyle(color: Colors.white24, fontSize: 18),
                          ),
                          const SizedBox(width: 40),
                          Container(
                              width: 2,
                              height: screenWidth * 0.1,
                              color: Color(0xFF1C1C1C)),
                          const SizedBox(width: 40),
                          // DropdownButton for selection with arrow
                          Expanded(
                            child: DropdownButton<String>(
                              hint: const Text(
                                "Select: ",
                                style: TextStyle(color: Colors.white24),
                              ),
                              underline: SizedBox(),
                              dropdownColor: const Color(0xFF303030),
                              value: _lineChartSelect,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              iconSize: 30,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _lineChartSelect = newValue;
                                });
                              },
                              items: <String>[
                                'Weight',
                                '3pt %',
                                '50s Free'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpacing(2),
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: const Color(0xFF303030),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Text "Select"
                          const Text(
                            "Period: ",
                            style: TextStyle(color: Colors.white24, fontSize: 18),
                          ),
                          const SizedBox(width: 35),
                          Container(
                              width: 2,
                              height: screenWidth * 0.1,
                              color: Color(0xFF1C1C1C)),
                          const SizedBox(width: 40),
                          // DropdownButton for selection with arrow
                          Expanded(
                            child: DropdownButton<String>(
                              hint: const Text(
                                "Select: ",
                                style: TextStyle(color: Colors.white24),
                              ),
                              underline: SizedBox(),
                              dropdownColor: const Color(0xFF303030),
                              value: _lineChartPeriod,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              iconSize: 30,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _lineChartPeriod = newValue;
                                });
                              },
                              items: <String>[
                                '3 Days',
                                'Week',
                                'Month'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(top: screenHeight * .05)),

                    // MAKE THE THINGS IN SMALL NICE BOXES
                    const Text(
                      "Quick Access",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF303030),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.flag, color: Color(0xFFB7FF00)),
                        title: Text("Goals", style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainNavigation(index: 2)),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF303030),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.show_chart, color: Color(0xFFB7FF00)),
                        title: Text("View Progress", style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainNavigation(index: 1)),
                          );
                        },
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../../utils/spacing.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? myUser = FirebaseAuth.instance.currentUser;
  String? _quickAddValue;
  String? name;
  String? weight;
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
        weight = userDoc['weight'];
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
                            '$name! You are $weight pounds', // getting data from firebase and
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
                      iconSize: 26, // Slightly smaller icon
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
                    Container(
                      height: screenHeight * .15,
                      width: screenWidth,
                      // ignore: sort_child_properties_last
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double containerHeight = constraints.maxHeight;
                          return Column(
                            children: [
                              Text('weight'),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: containerHeight * .2)),
                              SizedBox(
                                height: containerHeight * .3,
                              ),
                              Text('Weight')
                            ],
                          );
                        },
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF303030),
                        borderRadius: BorderRadius.circular(20),
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

import 'package:flutter/material.dart';
import 'package:test_app/utils/spacing.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: verticalSpacing(screenHeight * .03)),

        //TOP ROW
        SliverAppBar(
          floating: false,
          pinned: false,
          snap: false,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white)),
                  Text("Filler, add metric later"),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                    iconSize: 26,
                    onPressed: () {
                      //NOTIFYCATIONS
                    },
                  ),
                ],
              ),
            ),
          ),
        )

        //GRAPH



      ]),
    );
  }
}

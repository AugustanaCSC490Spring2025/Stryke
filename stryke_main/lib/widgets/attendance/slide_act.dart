import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SlideToConfirmCard extends StatefulWidget {
  final double screenWidth;
  final Future<bool> Function() onSlide;
  final bool isCheckedIn;

  const SlideToConfirmCard({
    super.key,
    required this.screenWidth,
    required this.onSlide,
    required this.isCheckedIn,
  });

  @override
  State<SlideToConfirmCard> createState() => _SlideToConfirmCardState();
}

class _SlideToConfirmCardState extends State<SlideToConfirmCard> {
  final GlobalKey<SlideActionState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenWidth * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF303030),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attendance Check-In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          widget.isCheckedIn
              ? Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check_circle, color: Color(0xFFB7FF00), size: 32),
                Text(
                  ' Checked in for the day',
                  style: TextStyle(
                    color: Color(0xFFB7FF00),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
              : SlideAction(
            key: _key,
            borderRadius: 30,
            elevation: 0,
            innerColor: Colors.white,
            outerColor: const Color(0xFFB7FF00),
            sliderButtonIcon: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: const Icon(Icons.arrow_forward, color: Colors.black),
            ),
            text: 'Slide to Confirm',
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            onSubmit: () async {
              try {
                bool success = await widget.onSlide();

                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                      Text('❌ Check-in failed. You must be at the gym.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  await Future.delayed(const Duration(milliseconds: 800));
                  _key.currentState?.reset();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ Check-in failed: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
                await Future.delayed(const Duration(milliseconds: 800));
                _key.currentState?.reset();
              }
            },
          )
        ],
      ),
    );
  }
}

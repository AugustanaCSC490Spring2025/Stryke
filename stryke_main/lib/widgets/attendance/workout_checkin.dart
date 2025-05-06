import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test_app/widgets/attendance/slide_act.dart';

class WorkoutCheckInCard extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final String? userId;

  const WorkoutCheckInCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userId,
  });

  @override
  State<WorkoutCheckInCard> createState() => _WorkoutCheckInCardState();
}

class _WorkoutCheckInCardState extends State<WorkoutCheckInCard> {
  bool isCheckedIn = false;
  String locationStatus = '';

  Future<bool> _checkInUser() async {
    setState(() {
      locationStatus = '';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationStatus = 'Location services are disabled.';
        });
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          locationStatus = 'Location permission denied.';
        });
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationStatus =
              'Location permissions are permanently denied. Please enable them in settings.';
        });
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("${position.latitude}, ${position.longitude}");

      //LAT AND LONG ARE SET TO OLIN RIGHT NOW
      //NEED TO CHANGE TO CARVER EVENTUALLY
      const double gymLat = 41.50314;
      const double gymLng = -90.55042;
      const double maxDistanceMeters = 250;

      final distance = Geolocator.distanceBetween(
        gymLat,
        gymLng,
        position.latitude,
        position.longitude,
      );

      print('You are ${distance} meters from the correct location');

      print('You are $distance meters from the correct location');

      if (distance <= maxDistanceMeters) {
        setState(() {
          isCheckedIn = true;
          locationStatus = 'Check-in successful!';
        });
        return true;
      } else {
        setState(() {
          isCheckedIn = false;
          locationStatus = 'You must be at the gym to check in.';
        });
        return false;
      }
    } catch (e) {
      setState(() {
        locationStatus = 'Error accessing location: $e';
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SlideToConfirmCard(
      screenWidth: screenWidth,
      onSlide: _checkInUser,
      isCheckedIn: isCheckedIn,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  bool isLoading = false;
  String locationStatus = '';

  Future<void> _checkInUser() async {
    setState(() {
      isLoading = true;
      locationStatus = '';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationStatus = 'Location services are disabled.';
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          locationStatus = 'Location permission denied.';
          isLoading = false;
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationStatus =
          'Location permissions are permanently denied. Please enable them in settings.';
          isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      //LAT AND LONG ARE SET TO OLIN RIGHT NOW
      //NEED TO CHANGE TO CARVER EVENTUALLY
      const double gymLat = 41.50314;
      const double gymLng = -90.55042;
      const double maxDistanceMeters = 100;

      final distance = Geolocator.distanceBetween(
        gymLat,
        gymLng,
        position.latitude,
        position.longitude,
      );

      if (distance <= maxDistanceMeters) {
        setState(() {
          isCheckedIn = true;
          locationStatus = 'Check-in successful!';
        });
      } else {
        setState(() {
          locationStatus = 'You must be at the gym to check in.';
        });
      }
    } catch (e) {
      setState(() {
        locationStatus = 'Error accessing location: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2A2A2A),
      margin: EdgeInsets.all(widget.screenWidth * 0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(widget.screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout Check-In',
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (!isCheckedIn)
              ElevatedButton(
                onPressed: isLoading ? null : _checkInUser,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Check In'),
              )
            else
              ElevatedButton(
                onPressed: () {
                  // Navigate to your workout logging screen
                  Navigator.pushNamed(context, '/workoutLog');
                },
                child: const Text('Log Workout'),
              ),
            if (locationStatus.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  locationStatus,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

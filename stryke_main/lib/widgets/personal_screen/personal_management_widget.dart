import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/main_navigation.dart';
import '../../screens/intro/views/team_input.dart';

class PersonalManagementWidget extends StatelessWidget {
  final List<String> teamIDs;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final Function(String teamId) deleteTeam;
  final User? myUser;

  const PersonalManagementWidget({
    super.key,
    required this.teamIDs,
    required this.nameController,
    required this.ageController,
    required this.heightController,
    required this.deleteTeam,
    required this.myUser,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.035),
      decoration: BoxDecoration(
        color: const Color(0xFF303030),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Personal Management",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.add, color: Color(0xFFB7FF00)),
            title: const Text("Add Team", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TeamInputScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment, color: Color(0xFFB7FF00)),
            title: const Text("My Teams", style: TextStyle(color: Colors.white)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF303030),
                    title: const Text('My Teams', style: TextStyle(color: Colors.white)),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: teamIDs.isEmpty
                          ? const Text('No teams.', style: TextStyle(color: Colors.white70))
                          : FutureBuilder<List<String>>(
                              future: Future.wait(teamIDs.map((id) async {
                                final doc = await FirebaseFirestore.instance.collection('teams').doc(id).get();
                                final data = doc.data();
                                return data?['name'] ?? id;
                              })),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return const CircularProgressIndicator();
                                final teamNames = snapshot.data!;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: teamNames.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(teamNames[index], style: const TextStyle(color: Colors.white)),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => deleteTeam(teamIDs[index]),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Close', style: TextStyle(color: Color(0xFFB7FF00))),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Color(0xFFB7FF00)),
            title: const Text("Edit Personal Data", style: TextStyle(color: Colors.white)),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: const Color(0xFF303030),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Edit Personal Data", style: TextStyle(color: Colors.white, fontSize: 20)),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintText: 'ex. Phil Foden',
                              labelText: "First & Last name",
                              labelStyle: TextStyle(color: Colors.white38),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFB7FF00))),
                              errorStyle: TextStyle(height: 0.8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: ageController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              hintText: 'ex. 21',
                              labelStyle: TextStyle(color: Colors.white38),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFB7FF00))),
                              errorStyle: TextStyle(height: 0.8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: heightController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "ex. 6' 2",
                              labelText: 'Height',
                              labelStyle: TextStyle(color: Colors.white38),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFB7FF00))),
                              errorStyle: TextStyle(height: 0.8),
                            ),
                            onChanged: (val) {
                              final digits = val.replaceAll(RegExp(r'[^0-9]'), '');
                              if (digits.length >= 2) {
                                final ft = digits[0];
                                final inch = digits.substring(1);
                                final formatted = "$ft' $inch";
                                heightController.value = TextEditingValue(
                                  text: formatted,
                                  selection: TextSelection.collapsed(offset: formatted.length),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final userId = FirebaseAuth.instance.currentUser?.uid;
                                  final name = nameController.text.trim();
                                  final age = ageController.text.trim();
                                  final height = heightController.text.trim();

                                  final nameValid = name.contains(' ');
                                  final ageValid = age.isNotEmpty;

                                  final heightRegex = RegExp(r"^(\d{1,2})[' ]?\s?(\d{1,2})$");
                                  final match = heightRegex.firstMatch(height);
                                  final heightValid = match != null &&
                                      int.tryParse(match.group(1)!) != null &&
                                      int.tryParse(match.group(2)!) != null &&
                                      int.parse(match.group(1)!) >= 4 &&
                                      int.parse(match.group(1)!) <= 7 &&
                                      int.parse(match.group(2)!) >= 0 &&
                                      int.parse(match.group(2)!) <= 11;

                                  if (userId != null && nameValid && ageValid && heightValid) {
                                    final parts = name.split(' ');
                                    final firstName = parts.first;
                                    final lastName = parts.sublist(1).join(' ');

                                    await myUser?.updateDisplayName("$firstName $lastName");

                                    await FirebaseFirestore.instance.collection("users").doc(userId).update({
                                      "first_Name": firstName,
                                      "last_Name": lastName,
                                      "age": age,
                                      "height": height,
                                    });

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MainNavigation(index: 1)),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Please enter valid name, age, and height.")),
                                    );
                                  }
                                },
                                child: const Text("Save", style: TextStyle(color: Color(0xFFB7FF00))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

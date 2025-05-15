import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text("User not logged in."));

    final notificationsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: StreamBuilder(
        stream: notificationsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No notifications yet."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final title = data['title'];
              final body = data['body'];
              final timestamp = (data['timestamp'] as Timestamp).toDate();
              final isRead = data['isRead'] ?? false;

              return ListTile(
                leading: Icon(
                  isRead ? Icons.notifications_none : Icons.notifications,
                  color: isRead ? Colors.grey : Colors.blue,
                ),
                title: Text(title),
                subtitle: Text(body),
                trailing: Text(DateFormat('MMM d, h:mm a').format(timestamp)),
                onTap: () {
                  docs[index].reference.update({'isRead': true});
                },
              );
            },
          );
        },
      ),
    );
  }
}

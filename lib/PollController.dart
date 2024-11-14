import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'Poll.dart';
import 'PollService.dart';

class PollController extends GetxController {
  var polls = <Poll>[].obs;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    fetchPolls();
    configureFCM();
    requestNotificationPermissions();
  }

  void configureFCM() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        fetchPolls(); // Update polls on notification
      },
    );
    messaging.requestPermission();
    messaging.getAPNSToken().then(
      (token) {
        // Handle the APNs token if necessary
      },
    );
  }

  void fetchPolls() {
    try {
      FirebaseFirestore.instance.collection('polls').snapshots().listen(
        (snapshot) {
          polls.value = snapshot.docs.map(
            (doc) {
              return Poll.fromDocument(doc);
            },
          ).toList();

          // Only call startService once, not within a loop
          if (snapshot.docs.isNotEmpty) {
            final pollData = snapshot.docs.first.data();

            final question = pollData['question'] ?? 'Unknown question';
            final options = List<String>.from(pollData['options'] ?? []);
            final votes = List<int>.from(
                (pollData['votes'] as List).map((item) => item as int));

            PollService.startService(question, options, votes);
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching polls: $e");
      }
    }
  }

  void updateVote(String pollId, int optionIndex) async {
    try {
      final pollRef =
          FirebaseFirestore.instance.collection('polls').doc(pollId);
      final pollData = await pollRef.get();

      final votes = List<int>.from(
        (pollData['votes'] as List).map((item) => item as int),
      );
      votes[optionIndex] += 1;

      await pollRef.update({'votes': votes});

      // Optionally update the service after a vote
      PollService.updateService(pollData['question'], votes);
    } catch (e) {
      if (kDebugMode) {
        print("Error updating vote: $e");
      }
    }
  }

  void createVote(String question, List<String> options) async {
    try {
      final pollRef = FirebaseFirestore.instance.collection('polls').doc();
      final pollData = {
        'question': question,
        'options': options,
        'votes': List<int>.filled(options.length, 0),
      };
      await pollRef.set(pollData);
    } catch (e) {
      if (kDebugMode) {
        print("Error creating vote: $e");
      }
    }
  }

  void requestNotificationPermissions() async {
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getAPNSToken().then((token) {
      // Send the APNs token to your backend if needed
    });
  }

  Future<void> requestLocalNetworkPermission() async {
    try {
      final socket = await Socket.connect(
        'localhost',
        80,
        timeout: const Duration(seconds: 2),
      );
      socket.destroy();
    } catch (e) {
      if (kDebugMode) {
        print("Triggered local network permission request: $e");
      }
    }
  }
}

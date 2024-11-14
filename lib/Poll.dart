import 'package:cloud_firestore/cloud_firestore.dart';

class Poll {
  String id;
  String question;
  List<String> options;
  List<int> votes;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.votes,
  });

  factory Poll.fromDocument(DocumentSnapshot doc) {
    return Poll(
      id: doc.id,
      question: doc['question'],
      options: List<String>.from(doc['options']),
      votes: List<int>.from(doc['votes']),
    );
  }
}

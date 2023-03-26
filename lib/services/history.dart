import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

Future historyAdd(
  String history,
  String? email,
) async {
  try {
    final instance = FirebaseFirestore.instance;
    final dbHistory = instance.collection('history');
    final refHistory = dbHistory.doc();
    refHistory.set({
      'id': refHistory.id,
      'email': email,
      'log': history,
    });
  } on FirebaseException catch (e) {
    log(e.toString());
  }
}

Future historyUpdate(String id, String history, String? email) async {
  try {
    final instance = FirebaseFirestore.instance;
    final dbHistory = instance.collection('history');
    final refHistory = dbHistory.doc(id);

    refHistory.update({
      'email': email,
      'log': history,
    });
  } on FirebaseException catch (e) {
    log(e.toString());
  }
}

Future historyDelete(String id, String title, String? email) async {
  final instance = FirebaseFirestore.instance;
  final dbHistory = instance.collection('history');
  final refHistory = dbHistory.doc(id);

  refHistory.delete();
}

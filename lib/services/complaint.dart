import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

Future complaintAdd(String title, Timestamp date, String desc, String imageUrl, int status, String userId) async {
  try {
    final db = FirebaseFirestore.instance.collection('complaints');
    final ref = db.doc();
    ref.set(
        {'id': ref.id, 'title': title, 'date': date, 'desc': desc, 'image': imageUrl, 'status': status, 'idUser': userId});
  } on FirebaseException catch (e) {
    log(e.toString());
  }
}

Future complaintUpdate(
    String docId, String title, Timestamp date, String desc, String imageUrl, int status, String userId) async {
  try {
    final db = FirebaseFirestore.instance.collection('complaints');
    final ref = db.doc(docId);
    ref.update(
        {'id': docId, 'title': title, 'date': date, 'desc': desc, 'image': imageUrl, 'status': status, 'idUser': userId});
  } on FirebaseException catch (e) {
    log(e.toString());
  }
}

Future complaintDelete(String docId) async {
  final db = FirebaseFirestore.instance;
  final ref = db.collection('complaints').doc(docId);
  ref.delete();
}

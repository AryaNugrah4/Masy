import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

Future complaintAdd(
    String title, Timestamp date, String desc, String imageUrl, int status, String userId, String? email) async {
  try {
    final instance = FirebaseFirestore.instance;
    final db = instance.collection('complaints');
    final dbHistory = instance.collection('history');
    final ref = db.doc();
    final refHistory = dbHistory.doc();
    ref.set(
        {'id': ref.id, 'title': title, 'date': date, 'desc': desc, 'image': imageUrl, 'status': status, 'idUser': userId});
    refHistory.set({
      'id': refHistory.id,
      'email': email,
      'log': "Pengaduan '$title' baru saja ditambahkan",
    });
  } on FirebaseException catch (e) {
    log(e.toString());
  }
}

Future complaintUpdate(String docId, String title, Timestamp date, String desc, String imageUrl, int status, String userId,
    String? email) async {
  try {
    final instance = FirebaseFirestore.instance;
    final db = instance.collection('complaints');
    final dbHistory = instance.collection('history');
    final ref = db.doc(docId);
    final refHistory = dbHistory.doc();

    ref.update(
        {'id': docId, 'title': title, 'date': date, 'desc': desc, 'image': imageUrl, 'status': status, 'idUser': userId});
    refHistory.set({
      'id': refHistory.id,
      'email': email,
      'log': "Pengaduan '$title' baru saja diubah",
    });
  } on FirebaseException catch (e) {
    log(e.toString());
  }
}

Future complaintDelete(String docId, String title, String? email) async {
  final instance = FirebaseFirestore.instance;
  final db = instance.collection('complaints');
  final dbHistory = instance.collection('history');
  final ref = db.doc(docId);
  final refHistory = dbHistory.doc();

  ref.delete();
  refHistory.set({
    'id': refHistory.id,
    'email': email,
    'log': "Pengaduan '$title' baru saja dihapus",
  });
}

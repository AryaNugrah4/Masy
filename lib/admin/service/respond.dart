import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> respondAdd(String desc, String complaintId, String userId, int status) async {
  try {
    Timestamp now = Timestamp.now();
    DateTime dateTime = now.toDate();

    final timestamp = Timestamp.fromDate(dateTime);
    final db = FirebaseFirestore.instance.collection('complaints').doc(complaintId).collection('respond');
    final db2 = FirebaseFirestore.instance.collection('complaints').doc(complaintId);
    final ref = db.doc();
    await ref.set({'id': ref.id, 'date': timestamp, 'desc': desc, 'complaintId': complaintId, 'operatorId': userId});
    await db2.update({'status': status});
  } on FirebaseException catch (e) {
    log(e.toString());
  }
}

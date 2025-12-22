import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reminder.dart';

class ReminderRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<Reminder?> getReminder(String userId) {
    return _db.collection('reminders').doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Reminder.fromMap(doc.data()!);
    });
  }

  Future<void> saveReminder(Reminder reminder, String userId) async {
    await _db.collection('reminders').doc(userId).set(
      reminder.toMap(),
      SetOptions(merge: true),
    );
  }
}

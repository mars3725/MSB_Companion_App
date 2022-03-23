import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

DocumentReference? userDoc;
DocumentReference? robotDoc;

//Schedule
// List<Event> events = [
//   Event(
//       start: const TimeOfDay(hour: 5, minute: 0),
//       end: const TimeOfDay(hour: 8, minute: 0),
//       name: 'Super Cool Event',
//       color: Colors.green),
//   Event(
//       start: const TimeOfDay(hour: 15, minute: 0),
//       end: const TimeOfDay(hour: 17, minute: 0),
//       name: 'Another Event',
//       color: Colors.orange),
// ];

//Home
// String name = 'Alfred Botly';
// double batteryPercentage = 0.67;

//Robot Settings
bool enabled = false;
bool movementLocked = false;
bool allowSleep = false;
double volume = 0.5;

//Companion App Settings
bool darkMode = true;
bool offlineMode = true;

//Document References
DocumentReference? getUserDoc() {
  if (FirebaseAuth.instance.currentUser == null) {
    return null;
  } else {
    return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid.toString());
  }
}

DocumentReference? getRobotDoc() {
  if (FirebaseAuth.instance.currentUser == null) {
    return null;
  } else {
    return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid.toString());
  }
}

//Cloud Sync
Future<bool> getData() async {
  return true;
}

Future<bool> pushData() async {
  return true;
}
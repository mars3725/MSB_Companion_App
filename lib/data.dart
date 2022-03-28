import 'package:cloud_firestore/cloud_firestore.dart';

//Document References
DocumentReference? userDoc;
DocumentReference? robotDoc;

//Robot Settings
bool enabled = false;
bool movementLocked = false;
bool allowSleep = false;
double volume = 0.5;

//Companion App Settings
bool darkMode = true;
bool offlineMode = false;
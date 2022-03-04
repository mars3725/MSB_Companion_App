import 'package:flutter/material.dart';
import 'package:msb_companion/event.dart';

//Schedule
List<Event> events = [
  Event(
      start: const TimeOfDay(hour: 5, minute: 0),
      end: const TimeOfDay(hour: 8, minute: 0),
      name: 'Super Cool Event',
      color: Colors.green)
];

//Home
String name = 'Alfred Botly';
double batteryPercentage = 0.67;

//Robot Settings
bool enabled = false;
bool movementLocked = false;
bool allowSleep = false;
double volume = 0.5;



//Cloud Sync
Future<bool> getData() async {
  return true;
}

Future<bool> pushData() async {
  return true;
}
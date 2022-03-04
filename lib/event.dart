import 'package:flutter/material.dart';

class Event {
  TimeOfDay start, end;
  String name;
  Color color;

  Event({
    required this.start,
    required this.end,
    required this.name,
    this.color = Colors.green
  });
}
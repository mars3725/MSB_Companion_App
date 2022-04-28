import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../radial_progress_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key, required this.data}) : super(key: key);
  final DocumentSnapshot data;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 50, left: 30, right: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(widget.data.get('name'),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: CustomPaint(
              foregroundPainter: RadialPainter(
                  bgColor: Theme.of(context).colorScheme.inverseSurface,
                  lineColor: Theme.of(context).colorScheme.primary,
                  percent: widget.data.get('battery').toDouble(),
                  width: 25),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${(widget.data.get('battery')*100).toInt()}%",
                      style: const TextStyle(
                        fontSize: 64.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Robot Battery",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {},
                  iconSize: 48,
                  icon: const Icon(Icons.message)),
              const Spacer(),
              IconButton(onPressed: () {},
                  iconSize: 48,
                  icon: const Icon(Icons.videocam))
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'data.dart';
import 'radial_progress_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 50, left: 30, right: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(name,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: CustomPaint(
              foregroundPainter: RadialPainter(
                  bgColor: Theme.of(context).colorScheme.inverseSurface,
                  lineColor: Theme.of(context).colorScheme.primary,
                  percent: batteryPercentage.toDouble(),
                  width: 25),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${(batteryPercentage*100).toInt()}%",
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
              IconButton(onPressed: () {
                print('initiate message');
              },
                  iconSize: 48,
                  icon: const Icon(Icons.message)),
              const Spacer(),
              IconButton(onPressed: () {
                print('initiate video call');
              },
                  iconSize: 48,
                  icon: const Icon(Icons.videocam))
            ],
          )
        ],
      ),
    );
  }
}

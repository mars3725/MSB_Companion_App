import 'package:flutter/material.dart';

import 'data.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 100, bottom: 15),
            child: Text('Schedule',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          Expanded(child: GridView.count(
            childAspectRatio: 1.5,
            padding: const EdgeInsets.symmetric(horizontal: 30),
              controller: ScrollController(
                  initialScrollOffset: 100*TimeOfDay.now().hour.toDouble(),
                  keepScrollOffset: true
              ),
              crossAxisCount: 2,
              children: List.generate(TimeOfDay.hoursPerDay*2, (index) {
                TimeOfDay time = TimeOfDay(hour: index~/2, minute: 0);

                Border _border = Border.symmetric(horizontal: BorderSide(color: Theme.of(context).colorScheme.inverseSurface));
                Widget _child = Container();
                Color? _color;

                if (index % 2 == 0) {
                  _child = Text(
                      time.format(context).splitMapJoin(':00', onMatch: (match) => ''),
                      style: const TextStyle(fontSize: 18)
                  );
                } else {
                  for (var e in events) {
                    if (e.start.hour <= time.hour && e.end.hour > time.hour) {
                      _border = Border(
                          top: time.hour == e.start.hour? const BorderSide() : BorderSide.none,
                          bottom: time.hour == e.end.hour-1? const BorderSide() : BorderSide.none
                      );

                      double middle = (e.start.hour + e.end.hour)/2;
                      if (time.hour == middle.toInt()) {
                        if (middle % 1 == 0.5) {
                          _child = Center(child: Text(
                              e.name,
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center));
                        } else {
                          _child = Text(
                              e.name,
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center);
                        }
                      }

                      _color = e.color;
                    }
                  }
                }

                return Container(
                  height: 10,
                    decoration: BoxDecoration(border: _border, color: _color),
                    child: _child
                );
              })
          )
          )
        ],
      )
    );
  }

  @override
  void dispose() {
    super.dispose();

  }
}

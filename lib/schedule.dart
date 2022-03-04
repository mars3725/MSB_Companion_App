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
    return Column(
      children: <Widget>[
        const Text('Schedule',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
        const Padding(padding: EdgeInsets.all(15)),
        Expanded(child: GridView.count(
            controller: ScrollController(
                initialScrollOffset: 100*TimeOfDay.now().hour.toDouble(),
                keepScrollOffset: true
            ),
            crossAxisCount: 2,
            children: List.generate(TimeOfDay.hoursPerDay*2, (index) {
              TimeOfDay time = TimeOfDay(hour: index~/2, minute: 0);

              Border border = const Border.symmetric(horizontal: BorderSide(color: Colors.black));
              Widget child = Container();
              Color? color;

              if (index % 2 == 0) {
                child = Text(time.format(context));
              } else {
                for (var e in events) {
                  if (e.start.hour <= time.hour && e.end.hour > time.hour) {
                    border = Border(
                        top: time.hour == e.start.hour? const BorderSide() : BorderSide.none,
                        bottom: time.hour == e.end.hour-1? const BorderSide() : BorderSide.none
                    );

                    double middle = (e.start.hour + e.end.hour)/2;
                    if (time.hour == middle.toInt()) {
                      if (middle % 1 == 0.5) {
                        child = Center(child: Text(
                            e.name, textAlign: TextAlign.center));
                      } else {
                        child = Text(
                            e.name, textAlign: TextAlign.center);
                      }
                    }

                    color = e.color;
                  }
                }
              }

              return Container(
                  decoration: BoxDecoration(border: border, color: color),
                  child: child
              );
            })
        )
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

  }
}

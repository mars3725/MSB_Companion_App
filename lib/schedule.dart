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

              if (index % 2 == 0) {
                return GridTile(child: Text(time.format(context)));

              } else {
                for (var e in events) {
                  if (e.start.hour <= time.hour && e.end.hour > time.hour) {
                    return GridTile(child: Container(
                        color: e.color,
                        child: time.hour == (e.start.hour + e.end.hour)~/2?
                              Center(child: Text(e.name, textAlign: TextAlign.center))
                            : null)
                    );
                  }
                }

                return Container();
              }
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

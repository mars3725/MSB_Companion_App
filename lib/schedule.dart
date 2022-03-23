import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:msb_companion/event.dart';
import 'package:msb_companion/event_dialog.dart';

import 'data.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);
  final double scale = 2;

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
          stream: robotDoc!.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading"));
            }

            List<Widget> times = List.generate(24, (index) => Positioned(
              top: 60*widget.scale*index,
              left: 15,
              height: 60*widget.scale,
              width: MediaQuery.of(context).size.width-30,
              child: GestureDetector(
                onTap: ()=> print('no event $index'),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: Theme.of(context).colorScheme.inverseSurface, height: 2, thickness: 2),
                    SizedBox(
                      height: 60*widget.scale-2,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                        TimeOfDay(hour: index, minute: 0).format(context).splitMapJoin(':00', onMatch: (match) => ''),
                        style: const TextStyle(fontSize: 18)
                    )),
                  ],
                ),
              ),
            ));

            List<Widget> events = [];
            snapshot.data!.get('events').asMap().forEach((index, event) {
              events.add(Positioned(
                top: event['start']*widget.scale,
                left: MediaQuery.of(context).size.width*1/3-15,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return EventDialog(event, newEvent: false);
                        }
                    ).then((result) => setState(() {

                      print(result);
                      print(event);
                      print(snapshot.data!.get('events'));

                      List events = snapshot.data!.get('events');
                      if (result == 'edit') {
                        events[index] = event;
                        robotDoc!.update({
                          'events': events
                        });
                      } else if (result == 'delete') {
                        events.removeAt(index);
                        robotDoc!.update({
                          'events': events
                        });
                      }
                    }));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*2/3,
                    height: (event['end'] - event['start'])*widget.scale,
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(child: Text(
                        event['name'],
                        style: const TextStyle(fontSize: 18)
                    )),
                  ),
                ),
              ));
            });

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 100, bottom: 15),
                  child: Text('Schedule',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                ),
                const Padding(padding: EdgeInsets.all(15)),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: ScrollController(
                        initialScrollOffset: 60*widget.scale*TimeOfDay.now().hour,
                        keepScrollOffset: true
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 120*24,
                      child: Stack(
                        children: [...times, ...events],
                      ),
                    ),
                  ),
                ),
              ],
            );
            //
            // return Column(
            //   children: <Widget>[
            //     const Padding(
            //       padding: EdgeInsets.only(top: 100, bottom: 15),
            //       child: Text('Schedule',
            //           style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            //     ),
            //     const Padding(padding: EdgeInsets.all(15)),
            //     Expanded(child: GridView.count(
            //         childAspectRatio: MediaQuery.of(context).size.width/(1.5*widget.cellHeight),
            //         padding: const EdgeInsets.symmetric(horizontal: 30),
            //         controller: ScrollController(
            //             initialScrollOffset: 100*TimeOfDay.now().hour.toDouble(),
            //             keepScrollOffset: true
            //         ),
            //         crossAxisCount: 2,
            //         children: List.generate(TimeOfDay.hoursPerDay*2, (index) {
            //           TimeOfDay time = TimeOfDay(hour: index~/2, minute: 0);
            //
            //           Border _border = Border.symmetric(horizontal: BorderSide(color: Theme.of(context).colorScheme.inverseSurface));
            //           Widget _child = Container();
            //           Color? _color;
            //
            //           if (index % 2 == 0) {
            //             _child = Text(
            //                 time.format(context).splitMapJoin(':00', onMatch: (match) => ''),
            //                 style: const TextStyle(fontSize: 18)
            //             );
            //           } else {
            //             for (var e in events) {
            //               int timeSeconds = time.hour*60 + time.minute;
            //
            //               if (timeSeconds <= e['start'] && timeSeconds+60 >= e['start']) {
            //                 _border = Border(
            //                     top: time.hour*60 == e['start']? const BorderSide() : BorderSide.none,
            //                     bottom: time.hour*60 == e['end']-1? const BorderSide() : BorderSide.none
            //                 );
            //                 double middle = (e['start'] + e['end'])/2;
            //                 if (time.hour*60 == middle.toInt()) {
            //                   if (middle % 1 == 0.5) {
            //                     _child = Center(child: Text(
            //                         e['name'],
            //                         style: const TextStyle(fontSize: 18),
            //                         textAlign: TextAlign.center));
            //                   } else {
            //                     _child = Text(
            //                         e['name'],
            //                         style: const TextStyle(fontSize: 18),
            //                         textAlign: TextAlign.center);
            //                   }
            //                 }
            //
            //                 _color = Colors.orange;
            //               }
            //             }
            //           }
            //
            //           return SizedOverflowBox(
            //             size: Size.square(250),
            //             child: GestureDetector(
            //               onTap: () {
            //
            //                 // int index = -1;
            //
            //
            //                 // Event event = Event(start: time, end: time.replacing(hour: time.hour+1), name: 'New Event');
            //                 // for (int i = 0; i < events.length; i++) {
            //                 //   if (events.elementAt(i).start.hour <= time.hour && events.elementAt(i).end.hour > time.hour) {
            //                 //     index = i;
            //                 //     event = Event(
            //                 //         name: events.elementAt(i).name,
            //                 //         color: events.elementAt(i).color,
            //                 //         start: events.elementAt(i).start,
            //                 //         end: events.elementAt(i).end);
            //                 //   }
            //                 // }
            //
            //                 // showDialog(
            //                 //     barrierDismissible: true,
            //                 //     context: context,
            //                 //     builder: (context) {
            //                 //       return EventDialog(event, newEvent: (index == -1));
            //                 //     }
            //                 // ).then((result) => setState(() {
            //                 //   if (result == 'create') {
            //                 //     events.add(event);
            //                 //   } else if (result == 'edit') {
            //                 //     events[index] = event;
            //                 //   } else if (result == 'delete') {
            //                 //     events.removeAt(index);
            //                 //   }
            //                 // }));
            //               },
            //               child: Container(
            //                 height: 20,
            //                   decoration: BoxDecoration(border: _border, color: _color),
            //                   child: _child
            //               ),
            //             ),
            //           );
            //         })
            //     )
            //     )
            //   ],
            // );
          }
        )
    );
  }
}

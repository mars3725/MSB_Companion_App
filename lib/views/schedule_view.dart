import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msb_companion/event_dialog.dart';

import '../data.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key, required this.data}) : super(key: key);
  final DocumentSnapshot data;
  final double scale = 2;

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {

  @override
  Widget build(BuildContext context) {
    List<Widget> times = List.generate(24, (index) => Positioned(
      top: 60*widget.scale*index,
      left: 15,
      height: 60*widget.scale,
      width: MediaQuery.of(context).size.width-30,
      child: GestureDetector(
        onTap: () {
          Map<String, dynamic> event = {
            'start': index*TimeOfDay.minutesPerHour,
            'end': (index+1)*TimeOfDay.minutesPerHour,
            'name': 'New Event'
          };

          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return EventDialog(event, newEvent: true);
              }
          ).then((result) => setState(() {
            List events = widget.data.get('events');
            if (result == 'done') {
              events.add(event);
              robotDoc!.update({
                'events': events
              });
            }
          }));
        },
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
    widget.data.get('events').asMap().forEach((index, event) {
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
              List events = widget.data.get('events');
              if (result == 'done') {
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

    return Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 15),
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
                    children: [...times,
                      ...events,
                      Positioned(
                        top: 60*widget.scale*TimeOfDay.now().hour+TimeOfDay.now().minute*widget.scale,
                        left: 15,
                        width: MediaQuery.of(context).size.width-30,
                        child: const Divider(color: Colors.orange, height: 4, thickness: 4),
                      )],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}

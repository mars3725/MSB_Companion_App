import 'package:flutter/material.dart';

import 'data.dart';
import 'event.dart';

class EventDialog extends StatefulWidget {
  const EventDialog(this.event, {Key? key, this.newEvent = false}) : super(key: key);
  final bool newEvent;
  final Event event;

  @override
  _EventDialogState createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  late final TextEditingController _nameController = TextEditingController(text: widget.event.name);
  late final TextEditingController _startController = TextEditingController(text: widget.event.start.format(context));
  late final TextEditingController _endController = TextEditingController(text: widget.event.end.format(context));
  String _validationText = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.newEvent? 'Add Event' : 'Edit Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              controller: _nameController,
              onChanged: (value) => widget.event.name = value,
              decoration: const InputDecoration(label: Text('Name'))),
          const Padding(padding: EdgeInsets.all(10)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: const InputDecoration(label: Text('Start Time')),
                controller: _startController,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                      initialTime: widget.event.start, context: context);
                  if (time != null) {
                    _startController.text = time.format(context);
                    widget.event.start = time;
                  }
                },
              ),
            ),
            const Spacer(),
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: const InputDecoration(label: Text('End Time')),
                controller: _endController,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                      initialTime: widget.event.end, context: context);
                  if (time != null) {
                    _endController.text = time.format(context);
                    widget.event.end = time;
                  }
                },
              ),
            ),
          ]),
          const Padding(padding: EdgeInsets.all(10)),
          Text(_validationText, style: const TextStyle(color: Colors.red)),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        widget.newEvent? Container() : TextButton(
            onPressed: () => Navigator.of(context).pop('delete'),
            child: const Text('Delete')
        ),
        TextButton(
            onPressed: () {
              double start = widget.event.start.hour + widget.event.end.minute / 60;
              double end = widget.event.end.hour + widget.event.end.minute / 60;

              bool hasValidDuration = start < end;

              if (!hasValidDuration) {
                setState(() {
                  _validationText = 'Start time must be earlier than end time';
                });
                return;
              }

              print("${widget.event.name}: ${widget.event.start.format(context)} to ${widget.event.end.format(context)}");
              pushData().then((success) => print('updated: $success'));

              widget.newEvent? Navigator.of(context).pop('create') : Navigator.of(context).pop('edit');
              setState(() {
              });
            },
            child: widget.newEvent? const Text('Create') : const Text('Finish'))
      ],
    );
  }
}

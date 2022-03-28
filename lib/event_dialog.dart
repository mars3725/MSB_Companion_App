import 'package:flutter/material.dart';

class EventDialog extends StatefulWidget {
  const EventDialog(this.event, {Key? key, this.newEvent = false}) : super(key: key);
  final bool newEvent;
  final Map<String, dynamic> event;

  @override
  _EventDialogState createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  late final TextEditingController _nameController = TextEditingController(text: widget.event['name']);
  late final TextEditingController _startController = TextEditingController(text: TimeOfDay(minute: widget.event['start']%60, hour: widget.event['start']~/60).format(context));
  late final TextEditingController _endController = TextEditingController(text: TimeOfDay(minute: widget.event['end']%60, hour: widget.event['end']~/60).format(context));
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
              textCapitalization: TextCapitalization.words,
              onChanged: (value) => widget.event['name'] = value,
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
                      initialTime: TimeOfDay(minute: widget.event['start']%60, hour: widget.event['start']~/60), context: context);
                  if (time != null) {
                    _startController.text = time.format(context);
                    widget.event['start'] = time.hour*60 + time.minute;
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
                      initialTime: TimeOfDay(minute: widget.event['end']%60, hour: widget.event['end']~/60), context: context);
                  if (time != null) {
                    _endController.text = time.format(context);
                    widget.event['end'] = time.hour*60 + time.minute;
                  }
                },
              ),
            ),
          ]),
          _validationText != ''? Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(_validationText, style: const TextStyle(color: Colors.red)))
            : Container(),
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
              if (widget.event['start'] > widget.event['end']) {
                setState(() {
                  _validationText = 'Start time must be earlier than end time';
                });
                return;
              }

              Navigator.of(context).pop('done');
              setState(() {
              });
            },
            child: widget.newEvent? const Text('Create') : const Text('Finish'))
      ],
    );
  }
}

import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  DateTimePicker({Key? key}) : super(key: key);
  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _selectDate(context);
          },
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(120, 50))),
          child: const Text("year-month-day"),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            _selectTime(context);
          },
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(120, 50))),
          child: const Text("hour-minute"),
        ),
        const SizedBox(height: 20),
        Text(
          'current time ${selectedDate.toString().split(' ')[0]} ${selectedTime.format(context)}',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 60,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(2, (index) {
            return ElevatedButton(
              onPressed: () {
                if (index == 0) {
                  Navigator.pop(context, "null");
                } else {
                  Navigator.pop(
                      context,
                      '${selectedDate.toString().split(' ')[0]} ${selectedTime.format(context)}');
                }
              },
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(100, 50))),
              child: Text(index == 0 ? "cancel" : "confirm"),
            );
          }),
        )
      ],
    );
  }
}

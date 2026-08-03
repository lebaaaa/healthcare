import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

class AddApptScreen extends StatefulWidget {
  AddApptScreen({super.key, required this.addApptCallback, });
  final Function addApptCallback;

  @override
  State<AddApptScreen> createState() => _AddApptScreenState();
}

class _AddApptScreenState extends State<AddApptScreen> {
  final TextEditingController dateController = TextEditingController();

  final TextEditingController timeController = TextEditingController();
  late DateTime _selectedDate;
  @override
  Widget build(BuildContext context) {
    // TODO Widgets for user to enter date and time
    // TODO ElevatedButton to execute addApptCallback
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Appointment Date & Time',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan, fontSize: 24),
          ),
          DatePicker(maxDate: DateTime(DateTime.now().year + 1), minDate: DateTime.now(),
             onDateSelected: (date){
              setState(() {
                _selectedDate = date;
              });
             },
          ),
          SizedBox(height: 8,),
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              //border: OutlineInputBorder(),
              labelText: 'Time',
            ),
            controller: timeController,
          ),
          ElevatedButton(
            onPressed: (){
              widget.addApptCallback(_selectedDate, timeController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
            child: const Text("ADD"),
          )
        ],
      ),
    );
  }
}

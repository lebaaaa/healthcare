import 'package:flutter/material.dart';

class AddApptScreen extends StatelessWidget {
  AddApptScreen({super.key, required this.addApptCallback});
  final Function addApptCallback;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

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
          TextField(
            autofocus: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              //border: OutlineInputBorder(),
              labelText: 'Date',
            ),
            controller: dateController,
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
              addApptCallback(dateController.text, timeController.text);
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

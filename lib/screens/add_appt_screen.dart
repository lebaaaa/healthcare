import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:intl/intl.dart';
import '../utilities/app_colors.dart';

class AddApptScreen extends StatefulWidget {
  AddApptScreen({super.key, required this.addApptCallback, });
  final Function addApptCallback;

  @override
  State<AddApptScreen> createState() => _AddApptScreenState();
}

class _AddApptScreenState extends State<AddApptScreen> {
  final List<String> _timeSlots = ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM'];
  DateTime ? _selectedDate;
  String ? _selectedTime;
  @override
  Widget build(BuildContext context) {
    // TODO Widgets for user to enter date and time
    // TODO ElevatedButton to execute addApptCallback
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Appointment Date & Time',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 24),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(5),
              tileColor: AppColors.surface,
              title: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  spacing: 20,
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.primary, size: 30,),
                    Text(_selectedDate == null ? 'Select a date':
                      DateFormat('dd MMM yyyy').format(_selectedDate!), style: TextStyle(color: AppColors.textSecondary, fontSize: 23),)
                  ]
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.border, width: 2)),
              onTap: () async {
                final picked = await showDatePickerDialog(
                  height: 500,
                  context: context,
                  minDate: DateTime.now(),
                  maxDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            ),
            SizedBox(height: 15,),
            ListTile(
              contentPadding: EdgeInsets.all(5),
              tileColor: AppColors.surface,
              title: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                    spacing: 20,
                    children: [
                      Icon(Icons.access_time, color: AppColors.primary, size: 30,),
                      Text(_selectedTime == null ? 'Select a time':
                      _selectedTime!, style: TextStyle(color: AppColors.textSecondary, fontSize: 23),)
                    ]
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.border, width: 2)),

              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        'Select a Time',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _timeSlots.map((time) {
                          return ChoiceChip(
                            label: Text(time),
                            selected: _selectedTime == time,
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.background,
                            labelStyle: TextStyle(
                              color: _selectedTime == time ? Colors.white : AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            side: BorderSide(color: AppColors.border),
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedTime = time;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 30,),
            SafeArea(
              child: ElevatedButton(
                onPressed: (_selectedTime != null) && (_selectedDate != null) ? (){
                  widget.addApptCallback(_selectedDate, _selectedTime);
                  // Navigator.pushReplacementNamed(context, '/test');
                  Navigator.pop(context);
                }:null,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: Size(30, 60)),
                child: const Text("Confirm Booking", style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
            )
          ],
        ),
      ),
    );
  }
}

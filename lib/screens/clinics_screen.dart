import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../models/clinic.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';
import '../utilities/api_calls.dart';
import 'add_appt_screen.dart';

class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({Key? key}) : super(key: key);

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  String _selectedRegion = ApiCalls().regionId.keys.first;
  late Clinic _selectedClinic;

  Future<void> _addTask(DateTime date, String time) async {
    await FirebaseCalls().addAppointment(Appointment(userid: appUser.userid, userName: appUser.name, point_id: _selectedClinic.place_id, clinicName: _selectedClinic.name, date: date, time: time));
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: SafeArea(
        child: Column(
          children: [
            //TODO Dropdown widget for user to select region
            Center(
              child: DropdownButton(
                menuMaxHeight: 300,
                value:
                _selectedRegion,
                items: ApiCalls().regionId.keys.map<DropdownMenuItem<String>>((String item) { //Q&A
                  return DropdownMenuItem<String>(value: item, child: Text(item)); //taken from flutter website
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRegion = newValue!;
                    ApiCalls().fetchClinics(_selectedRegion);
                  });
                },
              ),
            ),
            //TODO FutureBuilder to get clinics in selected region
            FutureBuilder<List<Clinic>>(
              future:  ApiCalls().fetchClinics(_selectedRegion),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Clinic clinic= snapshot.data![index];
                        return ListTile(
                          title: Text(clinic.name),
                          subtitle: Text(clinic.address),
                          onTap: () async {
                            _selectedClinic = clinic;
                            showModalBottomSheet(
                              backgroundColor: Colors.grey.shade50,
                              context: context,
                              isScrollControlled: true,
                              builder: (context){
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: AddApptScreen(addApptCallback: _addTask,),
                                  ),
                                );
                              }
                            );
                          },
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            //TODO Implement onTap for clinic > shows AddApptScreen() in bottom sheet
            //TODO Adds appointment to firebase with userid, userName, point_id, clinicName, date and time
          ],
        ),
      ),
    );
  }
}

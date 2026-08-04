import 'package:flutter/material.dart';
import 'package:healthcare/utilities/app_colors.dart';

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
      appBar: AppBar(
        backgroundColor: AppColors.Primary,
        centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.teal.shade400,
          ),
          child: DropdownButton(
            borderRadius: BorderRadius.circular(12),
            dropdownColor: Colors.teal.shade400,
            menuMaxHeight: 300,
            value:
            _selectedRegion,
            items: ApiCalls().regionId.keys.map<DropdownMenuItem<String>>((String item) { //Q&A
              return DropdownMenuItem<String>(value: item, child: Text(item, style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,),)); //taken from flutter website
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedRegion = newValue!;
                ApiCalls().fetchClinics(_selectedRegion);
              });
            },
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: SafeArea(
        child: FutureBuilder<List<Clinic>>(
          future:  ApiCalls().fetchClinics(_selectedRegion),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Clinic clinic= snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12), side: BorderSide(width: 1.3, color: AppColors.Borders),),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      tileColor: AppColors.Background,
                      title: Text(clinic.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        spacing: 15,
                        children: [
                          Divider(thickness: 2, color: Colors.black38,),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.pin_drop_outlined),
                              Expanded(child: Text(clinic.address, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.phone_sharp),
                              Expanded(child: Text(clinic.contact, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.access_time),
                              Expanded(child: Text(clinic.opening_hours, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.Background,
                              side: BorderSide(width: 1.5, color: AppColors.Primary),
                            ),
                            onPressed: () {
                              _selectedClinic = clinic;
                              showModalBottomSheet(
                                backgroundColor: Colors.grey.shade50,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery
                                              .of(context)
                                              .viewInsets
                                              .bottom),
                                      child: AddApptScreen(
                                        addApptCallback: _addTask,),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 15,
                                children: [
                                  Icon(Icons.calendar_month, size: 20,color: AppColors.Primary),
                                  Text('Book Appointment', style: TextStyle(fontSize: 18, color: AppColors.Primary),)
                                ],
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/clinic.dart';
import '../widgets/navigation_bar.dart';
import '../utilities/api_calls.dart';

class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({Key? key}) : super(key: key);

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  List<String> _regions = [
    "Ang Mo Kio",
    "Bedok",
    "Clementi",
    "Woodlands",
  ];
  String _selectedRegion = 'Clementi';
  late Clinic _selectedClinic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
      body: SafeArea(
        child: Column(
          children: [
            //TODO Dropdown widget for user to select region
            Center(
              child: DropdownButton(
                value:
                _selectedRegion
                ,
                items: [
                  DropdownMenuItem<String>(
                    value: _regions[0],
                    child: Text(_regions[0]),
                  ),
                  DropdownMenuItem<String>(
                    value: _regions[1],
                    child: Text(_regions[1]),
                  ),
                  DropdownMenuItem<String>(
                    value: _regions[2],
                    child: Text(_regions[2]),
                  ),
                  DropdownMenuItem<String>(
                    value: _regions[3],
                    child: Text(_regions[3]),
                  ),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _selectedRegion = newValue!;
                  });
                },
              ),
            ),
            //TODO FutureBuilder to get clinics in selected region
            FutureBuilder<List<Clinic>>(
              future: fetchClinics(_selectedRegion),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Clinic publicHoliday = snapshot.data![index];
                      return ListTile(
                        title: Text(publicHoliday.name),
                      );
                    },
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

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
  String _selectedRegion = ApiCalls().regionId.keys.first;
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
                menuMaxHeight: 300,
                value:
                _selectedRegion,
                items: ApiCalls().regionId.keys.map<DropdownMenuItem<String>>((String item) {
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

            //TODO Implement onTap for clinic > shows AddApptScreen() in bottom sheet
            //TODO Adds appointment to firebase with userid, userName, point_id, clinicName, date and time
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../widgets/navigation_bar.dart';
import '../utilities/firebase_calls.dart';

class UpdateAppUserScreen extends StatefulWidget {
  const UpdateAppUserScreen({Key? key}) : super(key: key);

  @override
  State<UpdateAppUserScreen> createState() => _UpdateAppUserScreenState();
}

class _UpdateAppUserScreenState extends State<UpdateAppUserScreen> {
  //TODO add contact, age, gender throughout this screen
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  List<String> genders = ['Male', 'Female', 'Rather not say'];
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: appUsersCollection
                .where('userid', isEqualTo: auth.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  QueryDocumentSnapshot doc = snapshot.data!.docs[0];
                  nameController.text = doc.get('name');
                  contactController.text = doc.get('contact');
                  ageController.text = doc.get('age');
                  
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Update App User',
                    textAlign: TextAlign.center,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: 'Name'),
                    controller: nameController,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: 'Contact'),
                    controller: contactController,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: 'Age'),
                    controller: ageController,
                  ),
                  DropdownButton(
                    value: _selectedGender,
                    items: [
                      DropdownMenuItem(value: genders[0],child: Text(genders[0]),),
                      DropdownMenuItem(value: genders[1],child: Text(genders[1]),),
                      DropdownMenuItem(value: genders[2], child: Text(genders[2]))
                    ],
                    onChanged: (newValue){
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    }
                  ),
                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      appUser = AppUser(
                        name: nameController.text,
                        age: ageController.text,
                        contact: contactController.text,
                        gender: _selectedGender,
                        email: auth.currentUser?.email ?? "",
                        userid: auth.currentUser?.uid ?? "",

                      );
                      await FirebaseCalls().updateAppUser(appUser);
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

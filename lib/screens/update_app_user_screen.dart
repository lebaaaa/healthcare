import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/utilities/app_colors.dart';

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
  List<String> genders = ['Male', 'Female', 'NA'];
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.Primary,
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 4),
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
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade200,
                      child: Icon(Icons.person, size: 60, color: Colors.teal.shade800),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Personal Information',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                      ),
                      controller: nameController,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                      ),
                      controller: contactController,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: const Icon(Icons.cake_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey, width: 2.0),
                              ),
                            ),
                            controller: ageController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField(
                              hint: Text('Gender'),
                              icon: const Icon(Icons.arrow_drop_down),
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: const Icon(Icons.wc), // People/Gender icon
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                ),
                              ),
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      label: Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00796B), // Teal background color
                        foregroundColor: Colors.white, // White text & icon
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0), // Rounded corners
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.save_outlined, size: 20),
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
                      }
                    ),
                    // ElevatedButton(
                    //   child: const Text('Save'),
                    //   onPressed: () async {
                    //     appUser = AppUser(
                    //       name: nameController.text,
                    //       age: ageController.text,
                    //       contact: contactController.text,
                    //       gender: _selectedGender,
                    //       email: auth.currentUser?.email ?? "",
                    //       userid: auth.currentUser?.uid ?? "",
                    //
                    //     );
                    //     await FirebaseCalls().updateAppUser(appUser);
                    //     Navigator.pushReplacementNamed(context, '/home');
                    //   },
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

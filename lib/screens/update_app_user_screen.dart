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
  TextEditingController genderController = TextEditingController();

  List<String> genders = ['Male', 'Female'];
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
                  genderController.text = doc.get('gender');
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
                    detailsTextField(controller: nameController, labeltext: 'Full Name', labelicon: Icons.badge_outlined,),
                    const SizedBox(height: 24),
                    detailsTextField(controller: contactController, labeltext: 'Contact Number', labelicon: Icons.phone,),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: detailsTextField(controller: ageController, labeltext: 'Age', labelicon: Icons.cake,),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField(
                              hint: Text(genderController.text),
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

class detailsTextField extends StatefulWidget {
  detailsTextField({
    super.key,
    required this.controller,
    required this.labeltext,
    required this.labelicon
  });

  final TextEditingController controller;
  final String labeltext;
  final IconData labelicon;

  @override
  State<detailsTextField> createState() => _detailsTextFieldState();
}

class _detailsTextFieldState extends State<detailsTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        labelText: widget.labeltext,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(widget.labelicon),
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
      controller: widget.controller,
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';
import '../utilities/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Primary,
        centerTitle: true,
        title: const Text(
          'Healthcare',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 24),
        ),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout, color: Colors.white,),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //TODO Widgets to show upcoming appointments
          //Text('Welcome ${appointment.userName}')
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseCalls().getAppointments(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12,),
                        Text(
                          'Hello, ${appUser.name}!',
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 6,),
                        Text(
                          "You have upcoming ${snapshot.data!.docs.length} appointments",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 12,),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot doc = snapshot.data!.docs[index];
                              return Card(
                                elevation: 10,
                                shadowColor: Colors.black26, // Softer shadow
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Rounded edges
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        // leading: CircleAvatar(
                                        //   child: Icon(Icons.local_hospital, color: Colors.grey.shade900,),
                                        //   backgroundColor: Colors.grey.shade400,
                                        // ),
                                        // title: Text(doc['clinicName']),
                                        // // subtitle: Text(DateFormat('dd MMM yyyy').format(doc['date'].toDate())),
                                        // subtitle: Text("Confirmed Appointment"),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                        leading: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.teal.shade100, // Soft primary background
                                            shape: BoxShape.circle,
                                          ),
                                          // REFINE 2: Primary-colored icon with background tint
                                          child: Icon(Icons.local_hospital, color: AppColors.Primary),
                                        ),
                                        title: Text(
                                          doc['clinicName'],
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                        subtitle: const Text("Confirmed Appointment"),
                                      ),
                                      // Container(
                                      //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                      //   decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //       color: Colors.black,
                                      //       width: 1,
                                      //     ),
                                      //     borderRadius: BorderRadius.circular(12),
                                      //     // color: Colors.orange,
                                      //     gradient: const LinearGradient(
                                      //       colors: [Colors.orange, Colors.red],
                                      //       begin: Alignment.topLeft,
                                      //       end: Alignment.bottomRight,
                                      //     ),
                                      //     boxShadow: const [
                                      //       BoxShadow(
                                      //         blurRadius: 30,
                                      //         offset: Offset(15, 15),
                                      //         color: Colors.black12,
                                      //       )
                                      //     ],
                                      //   ),
                                      //   child: Row(
                                      //     children: [
                                      //       Icon(Icons.calendar_month),
                                      //       SizedBox(width: 16,),
                                      //       Text("${DateFormat('dd MMM yyyy').format(doc['date'].toDate())}, ${doc['time']}"),
                                      //     ],
                                      //   ),
                                      // )
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        decoration: BoxDecoration(
                                          // REFINE 4: Lighter border
                                          border: Border.all(
                                            color: Colors.teal.shade900,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          // REFINE 3: Primary Gradient instead of Red/Orange
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.Primary,
                                              Colors.teal,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 8,
                                              offset: Offset(0, 3),
                                              color: Colors.black12,
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.calendar_month, color: Colors.white), // White icon
                                            const SizedBox(width: 16),
                                            Text(
                                              "${DateFormat('dd MMM yyyy').format(doc['date'].toDate())}, ${doc['time']}",
                                              style: const TextStyle(
                                                color: Colors.white, // White text
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }
}

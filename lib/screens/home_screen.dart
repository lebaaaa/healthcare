import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';
import '../utilities/firebase_calls.dart';
import '../widgets/navigation_bar.dart';
import '../utilities/app_colors.dart';
import 'add_appt_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _updateAppt(String docId, DateTime newDate, String newTime) async {
    await FirebaseCalls().updateAppointmentDateTime(docId, newDate, newTime);
  }
  Future<void> _deleteAppt(String docId) async {
    await FirebaseCalls().deleteAppointment(docId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Background,
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
              // 1. Show a loading spinner while waiting for data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2. Handle errors if any occur
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // 3. Handle the empty list state safely
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        welcomeMessage(
                          userName: appUser.name,
                          appointmentCount: 0,
                        ),
                        const SizedBox(height: 150),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy_rounded,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No upcoming appointments.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // 4. Data is safely available here
              final docs = snapshot.data!.docs;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      welcomeMessage(
                        userName: appUser.name,
                        appointmentCount: docs.length,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot doc = docs[index];

                            String dateStr = DateFormat('dd MMM yyyy').format(doc['date'].toDate());
                            String timeStr = doc['time'] ?? '';

                            return GestureDetector(
                              onTap: (){
                                showModalBottomSheet(
                                  backgroundColor: AppColors.Background,
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
                                          addApptCallback: (DateTime updatedDate, String updatedTime) {
                                            // Pass the specific doc.id and the new values to your function
                                            _updateAppt(doc.id, updatedDate, updatedTime);// Close the bottom sheet
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              onLongPress: (){
                                // showDialog and AlertDialog suggested by Gemini AI
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Delete Appointment'),
                                      content: const Text('Are you sure you want to delete this appointment? This action cannot be undone.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext); // Close the dialog without doing anything
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext); // Close the dialog
                                            _deleteAppt(doc.id); // Call your delete function
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.Primary, // Solid primary background
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.Primary,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.white24, // Translucent white circle
                                          child: const Icon(
                                            Icons.local_hospital_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                doc['clinicName'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Confirmed Appointment',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black12, // Darkened pill background
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 20),
                                          Text(
                                            '$dateStr, $timeStr',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class welcomeMessage extends StatefulWidget {
  const welcomeMessage({
    super.key,
    required this.userName,
    required this.appointmentCount,
  });

  final String userName;
  final int appointmentCount;

  @override
  State<welcomeMessage> createState() => _welcomeMessageState();
}

class _welcomeMessageState extends State<welcomeMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12,),
        Text(
          'Hello, ${widget.userName}!',
          style: TextStyle(
              color: Colors.teal,
              fontSize: 30,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 6,),
        Text(
          "You have upcoming ${widget.appointmentCount} appointment",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 12,)
      ],
    );
  }
}

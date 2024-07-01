import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_repair_service/component/service_category_card.dart';
import 'package:home_repair_service/component/snack_bar_component.dart';
import 'package:home_repair_service/provider/user_notifier.dart';
import 'package:home_repair_service/services/auth/auth_service.dart';
import 'package:home_repair_service/services/database/firestore.dart';
import 'package:home_repair_service/component/get_request_history.dart';
import 'package:home_repair_service/view/homeowner/feedback.dart';
import 'package:home_repair_service/view/homeowner/request_form.dart';
import 'package:home_repair_service/view/homeowner/setting.dart';
import 'package:home_repair_service/view/welcome_screen.dart';
import 'package:provider/provider.dart';

class HMDashboard extends StatefulWidget {
  const HMDashboard({super.key});

  @override
  State<HMDashboard> createState() => _HMDashboardState();
}

class _HMDashboardState extends State<HMDashboard> {
  final authService = AuthService();
  FirestoreService firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser!;
  String name = "";

  Future<void> signOut() async {
    await authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
    SnackbarComponent.showSnackbar(context, 'Successfully Signed Out');
  }

  void getName() {
    User? user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          name = documentSnapshot.get('name');
        });
      } else {
        return null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  child: Image(
                      image: AssetImage(
                    'lib/assets/icons/profile.png',
                  )),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Homeowner',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Consumer<UserNotifier>(
                      builder: (context, userNotifier, child) {
                        return Text(
                          userNotifier.name.isEmpty ? name : userNotifier.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        );
                      },
                    ),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.feedback),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FeedbackPage()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Setting()));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Align(
              alignment: Alignment(-0.8, 0.0),
              child: Text(
                "Service Category",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            padding: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: const [
                ServiceCategoryComponent(
                  serviceCategory: "Electrical",
                  page: RequestForm(),
                  colors: Color(0xFFBBE4FF),
                  imgPath: 'lib/assets/icons/electrical.png',
                ),
                ServiceCategoryComponent(
                  serviceCategory: "Plumbing",
                  colors: Color(0xFFA09C9C),
                  imgPath: 'lib/assets/icons/plumbing.png',
                ),
                ServiceCategoryComponent(
                  serviceCategory: "Aircond",
                  colors: Color(0xFFA09C9C),
                  imgPath: 'lib/assets/icons/air-conditioner.png',
                ),
                ServiceCategoryComponent(
                  serviceCategory: "Roof",
                  colors: Color(0xFFA09C9C),
                  imgPath: 'lib/assets/icons/roof.png',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
            width: 16,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Align(
              alignment: Alignment(-0.8, 0.0),
              child: Text(
                "Request History",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: const Alignment(0, -1.2),
              child: GetRequestHistory(
                user: user.uid,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

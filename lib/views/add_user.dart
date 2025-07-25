import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/widgets/constant.dart';
import 'package:whisper/widgets/text_field.dart';

import '../controller/friend_screen.dart';

class AddUserScreen extends StatefulWidget {
  final UserModel currentUser;
  const AddUserScreen({
    super.key,
    required this.currentUser,
  });

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final textAddNameController = TextEditingController();
  String friendSearch = "";
  TextEditingController searchtextController = TextEditingController();
  late friend_controller friendController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> defaultUserImages = [
    "assets/images/profile2.png",
    "assets/images/profile3.png",
    "assets/images/profile4.png",
    "assets/images/profile5.png",
    "assets/images/profile6.png",
    "assets/images/profile7.png",
    "assets/images/profile8.png",
    "assets/images/profile9.png",
    "assets/images/profile10.png",
  ];
  @override
  void initState() {
    super.initState();
    friendController = friend_controller();
  }

  @override
  void dispose() {
    textAddNameController.dispose();
    super.dispose();
  }
  Stream<QuerySnapshot> getUsers()
  {
    return _firestore.collection('users').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: addUserIcon),
          backgroundColor: addUserBackground,
          title: const Text(
            'Add Profile',
            style: TextStyle(color: addUserText),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: SearchAnchor.bar(
                isFullScreen: false,
                barPadding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 10)),
                barBackgroundColor:WidgetStateProperty.all(Colors.black),
                barElevation:WidgetStateProperty.all(0),
                barShape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                barLeading: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(Icons.person_search, color: Colors.white),
                ),
                barTextStyle: WidgetStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                barHintText: 'Search by name...',
                suggestionsBuilder: (BuildContext context, SearchController controller) {
                  return <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: getUsers(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Text('no data');
                        }
                        final query = controller.text.toLowerCase();
                        final filteredDocs = snapshot.data!.docs.where((doc) {
                          final name = (doc['fullName'] ?? '').toString().toLowerCase();
                          return query.isEmpty || name.startsWith(query);
                        }).toList();

                        return Column(
                          children: filteredDocs.map((doc)
                          {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(defaultUserImages[1]),
                              ),
                              title: Text(doc['fullName'] ?? 'No Name'),
                              trailing: TextButton(onPressed: (){}, child: Icon(Icons.add)),
                              onTap: ()
                              {
                                controller.closeView(doc['fullName']);
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ];
                },
              ),
            ),
            const TabBar(tabs: [
              Tab(text: "Sent Requests"),
              Tab(text: "Recieved Requests")
            ]),
            const Expanded(
              child: TabBarView(children: [
                Center(
                    child: Text(
                      'Sent Requests',
                      style: TextStyle(color: Colors.black),
                    )),
                Center(
                    child: Text(
                      'Received Requests',
                      style: TextStyle(color: Colors.black),
                    )),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

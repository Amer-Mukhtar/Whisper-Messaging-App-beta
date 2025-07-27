import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/widgets/constant.dart';
import '../controller/friend_controller.dart';
import '../models/user_friends_model.dart';

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
  friend_controller friendController=friend_controller();
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


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: addUserIcon),
          backgroundColor: addUserBackground,
          title: const Text(
            'Add Profile',
            style: TextStyle(color: addUserText),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: SearchAnchor.bar(
                  viewBackgroundColor: Color(0xFF211a23),
                  isFullScreen: false,
                  barPadding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 10)),
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
                  barHintStyle: WidgetStateProperty.all(
                    const TextStyle(color: Colors.white),
                  ),
                  barBackgroundColor: WidgetStateProperty.all(Colors.grey[900]),

                  suggestionsBuilder: (BuildContext context, SearchController controller) {
                    return <Widget>[
                      StreamBuilder<List<DocumentSnapshot>>(
                        stream: friendController.getUsers(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text('no data');
                          }
                          final query = controller.text.toLowerCase();
                          final filteredDocs = snapshot.data!.where((doc) {
                            final name = (doc['fullName'] ?? '').toString().toLowerCase();
                            return query.isEmpty || name.startsWith(query);
                          }).toList();

                          return Column(
                            children: filteredDocs.map((doc) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(defaultUserImages[1]),
                                ),
                                title: Text(doc['fullName'] ?? 'No Name'),
                                titleTextStyle: TextStyle(color: Colors.white),
                                trailing: TextButton(
                                  onPressed: () {
                                    final friendModel = FriendsModel(
                                      requestSender: widget.currentUser.fullName,
                                      requestReceiver: doc['fullName'] ?? 'No Name',
                                      requestStatus: 'pending',
                                      timestamp: DateTime.now(),
                                    );

                                    friendController.addFriendRequest(friendModel);
                                  },
                                  child: const Icon(Icons.add,color: Colors.white,),
                                ),
                                onTap: () {
                                  // Optional: handle tap
                                },
                              );
                            }).toList(),
                          );
                        },
                      )

                    ];
                  },
                ),
              ),
               const TabBar(tabs:
               [
                Tab(text: "Sent Requests"),
                Tab(text: "Recieved Requests")
               ],indicator: const BoxDecoration(),
                 labelColor: Colors.white,
                 dividerColor: Colors.transparent,
               ),
               Expanded(
                child: TabBarView(children:
                [
                  StreamBuilder<QuerySnapshot>(
                    stream: friendController.getFriendSentList(widget.currentUser),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: Text('No data'));
                      }
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final fullName = data['RequestReciever'] ?? 'No Name';
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: ListTile(
                              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) ,
                              tileColor: Color(0xFF211a23),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(defaultUserImages[1]),
                              ),
                              title: Text(fullName,style: TextStyle(color: Colors.white),),
                              trailing: TextButton(onPressed: (){
                                final model = FriendsModel(
                                  requestSender: data['RequestSender'],
                                  requestReceiver: data['RequestReciever'],
                                  requestStatus: data['RequestStatus'],
                                  timestamp: (data['timestamp'] as Timestamp).toDate(),
                                );
                                friendController.withdrawFriendRequest(model);
                              }, child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15)
                              ),child: Text('Withdraw',style: TextStyle(color: Colors.white),))),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: friendController.getFriendRecievedList(widget.currentUser),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: Text('No data'));
                      }
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final fullName = data['RequestSender'] ?? 'No Name';
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: ListTile(
                              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) ,
                              tileColor: Color(0xFF211a23),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(defaultUserImages[1]),
                              ),
                              title: Text(fullName,style: TextStyle(color: Colors.white),),
                              trailing: SizedBox(
                                width:MediaQuery.of(context).size.width * 0.45,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(onPressed: ()
                                    {
                                      final model = FriendsModel(
                                        requestSender: data['RequestSender'],
                                        requestReceiver: data['RequestReciever'],
                                        requestStatus: data['RequestStatus'],
                                        timestamp: (data['timestamp'] as Timestamp).toDate(),
                                      );
                                      friendController.withdrawFriendRequest(model);                                  }, child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(15)
                                        ),child: Text('Reject',style: TextStyle(color: Colors.white),))
                                    ),
                                    TextButton(onPressed: ()
                                    {
                                      final model = FriendsModel(
                                        requestSender: data['RequestSender'],
                                        requestReceiver: data['RequestReciever'],
                                        requestStatus: data['RequestStatus'],
                                        timestamp: (data['timestamp'] as Timestamp).toDate(),
                                      );
                                      friendController.acceptFriendRequest(model);
                                    }, child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15)
                                        ),child: Text('Accept',style: TextStyle(color: Colors.black),))
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

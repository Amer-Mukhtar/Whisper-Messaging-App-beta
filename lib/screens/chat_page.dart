import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whisper/widgets/Conversation.dart';
import 'add_user.dart';
import 'chat_detail.dart';
import 'profile_screen.dart';

class ChatUsers {
  String name;
  String messageText;
  String imageURL;
  String time;

  ChatUsers({
    required this.name,
    required this.messageText,
    required this.imageURL,
    required this.time,
  });
}

class ChatPageState {
  static List<ChatUsers> chatUsers = [
    ChatUsers(
      name: "Kris Benwat",
      messageText: "Awesome Setup",
      imageURL: "https://plus.unsplash.com/premium_photo-1673866484792-c5a36a6c025e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
      time: "Now",
    ),
    ChatUsers(
      name: "Glady's Murphy",
      messageText: "That's Great",
      imageURL: "https://randomuser.me/api/portraits/men/83.jpg",
      time: "Yesterday",
    ),
    ChatUsers(
      name: "Jorge Henry",
      messageText: "Hey where are you?",
      imageURL: "https://randomuser.me/api/portraits/men/81.jpg",
      time: "31 Mar",
    ),
    ChatUsers(
      name: "Philip Fox",
      messageText: "Busy! Call me in 20 mins",
      imageURL: "https://randomuser.me/api/portraits/men/63.jpg",
      time: "28 Mar",
    ),
    ChatUsers(
      name: "Debra Hawkins",
      messageText: "Thank you, It's awesome",
      imageURL: "https://randomuser.me/api/portraits/women/8.jpg",
      time: "23 Mar",
    ),
    ChatUsers(
      name: "Jacob Pena",
      messageText: "Will update you in the evening",
      imageURL: "https://randomuser.me/api/portraits/men/65.jpg",
      time: "17 Mar",
    ),
    ChatUsers(
      name: "Andrey Jones",
      messageText: "Can you please share the file?",
      imageURL: "https://randomuser.me/api/portraits/women/86.jpg",
      time: "24 Feb",
    ),
    ChatUsers(
      name: "John Wick",
      messageText: "How are you?",
      imageURL: "https://randomuser.me/api/portraits/men/25.jpg",
      time: "18 Feb",
    ),
  ];
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading:false,
        title: const Text('Whisper',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const profile()),
                );

              },
              child: const CircleAvatar(
                backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1673866484792-c5a36a6c025e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D'),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100, // Adjust height as needed
            child: ListView.builder(
              itemCount: ChatPageState.chatUsers.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 10, left: 10, top: 10,bottom: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailPage()));
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(ChatPageState.chatUsers[index].imageURL),
                        ),
                      ),
                      Text(ChatPageState.chatUsers[index].name)
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 65,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ChatPageState.chatUsers.length,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 16),
                      itemBuilder: (context, index) {
                        return ConversationList(
                          name: ChatPageState.chatUsers[index].name,
                          messageText: ChatPageState.chatUsers[index].messageText,
                          imageUrl: ChatPageState.chatUsers[index].imageURL,
                          time: ChatPageState.chatUsers[index].time,
                          isMessageRead: (index == 0 || index == 3),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 50,width: 80,margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
         color: Colors.white,
           borderRadius: BorderRadius.circular(20),
        ),

        child: Center(
          child: IconButton(
            onPressed: (){Navigator.push(context, MaterialPageRoute(
                builder: (context)=>AddProfileScreen()));},icon: const Icon(CupertinoIcons.person_add,
          ),
        ),
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whisper/screens/profile_screen.dart';

import 'home_chat_screen.dart';

class edit_profile extends StatefulWidget {
  const edit_profile({super.key});

  @override
  State<edit_profile> createState() => _edit_profileState();
}

class _edit_profileState extends State<edit_profile> {
  @override
  String pic_link='https://plus.unsplash.com/premium_photo-1673866484792-c5a36a6c025e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 130,
            backgroundImage: NetworkImage(pic_link),
          ),

          SizedBox(height: 40),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(width: 25),
              Icon(CupertinoIcons.profile_circled, size: 40),
              SizedBox(width: 10),
              Container(
                child: Row(
                  children: [
                    Text("", style: TextStyle(color: Colors.black45)),
                    Container(
                      width: 250,
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),




      SizedBox(
            height: 15,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:
          [
            SizedBox(width: 25,),
            Icon(CupertinoIcons.book,size: 40,),
            SizedBox(width: 10,),
            Container(
              width: 250,height:40,
              child: TextField(decoration: InputDecoration(
                labelText: 'Quote',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),

              ),),
            )
          ],
          ),


          SizedBox(height: 15), // Add some vertical spacing if needed
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              SizedBox(width: 25,),
              Icon(CupertinoIcons.mail,size: 40,),
              SizedBox(width: 10,),
              Container(
                width: 250,height:40,
                child: TextField(decoration: InputDecoration(
                  labelText: 'Email Adress',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                ),),
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              ElevatedButton(
              onPressed: () {},
                   child: Text('Upload Profile Picture',style: TextStyle(color: Colors.white,fontSize: 10),),
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.red,
                           padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                         ),
                       ),SizedBox(width: 15,),
              ElevatedButton(
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>home()));},
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ],
          ),
        ],
      ),




    );
  }
}

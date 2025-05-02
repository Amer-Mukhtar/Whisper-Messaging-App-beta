import 'package:flutter/material.dart';
import '../views/Message.dart';
import 'constant.dart';


class ConversationList extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String currentuser;

  ConversationList({
    required this.name,
    required this.imageUrl,
    required this.currentuser
  });

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return MessageScreen(
              receiver:widget.name,currentuser: widget.currentuser,imageurl:widget.imageUrl
            );
          }
          )
          );
        },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(45)),
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),

        child: Row(
          children: <Widget>[

            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: const TextStyle(fontSize: 17,color: TextColor,fontWeight: FontWeight.w800),
                          ),



                        ],
                      ),
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
}

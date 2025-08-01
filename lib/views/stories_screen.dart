import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whisper/core/theme/custom_themes/context_extensions.dart';
import 'package:whisper/models/user_model.dart';
import '../controller/stories_controller.dart';
import '../models/stories_model.dart';
import '../widgets/fullscreen_image.dart';

class StoriesScreen extends StatefulWidget {
  UserModel currentUser;
   StoriesScreen({super.key,required this.currentUser});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}
  StoriesController storiesController=StoriesController();

  class _StoriesScreenState extends State<StoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.background.accented,
        onPressed: () async {
          final imageurl = await storiesController.uploadImageToSupabase(widget.currentUser);
          if (imageurl != null) {
            StoriesModel storiesModel = StoriesModel(
              username: widget.currentUser.fullName,
              timestamp: DateTime.now(),
              imageUrl: imageurl, userProfile: widget.currentUser.imageUrl!,
            );
            await storiesController.sendStory(storiesModel);
            setState(() {

            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to upload image")),
            );
          }
        },
        child: Icon(CupertinoIcons.plus, color: Colors.redAccent),
      ),

      backgroundColor: context.background.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Stories',),

      ),
      body: FutureBuilder<List<StoriesModel>>(
        future: storiesController.getStories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stories found'));
          }

          final stories = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: stories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final story = stories[index];

              return InkWell(
                onLongPress: (){
                  StoriesModel storiesModel=StoriesModel(
                      username: story.username,
                      timestamp: story.timestamp,
                      imageUrl: story.imageUrl,
                      userProfile: story.imageUrl

                  );
                  showoptions(context,storiesModel,widget.currentUser);
                },
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => FullScreenImage(imageUrl: story.imageUrl),
                  ));
                },
                child: Stack(
                  children: [
                    // Story image
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(story.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Profile image
                    Positioned(
                      top: 8,
                      left: 8,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(
                            story.imageUrl, // Replace with `story.userProfile` if available
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      )
      ,
    );
  }
  void showoptions(BuildContext context,StoriesModel storiesModel,UserModel currentUser)
  {

    if(storiesModel.username==currentUser.fullName)
      {
        showModalBottomSheet(context: context, builder: (BuildContext context){
          return Container(padding: EdgeInsets.all(0),
            child: Wrap(
              children: [
                ListTile(
                  onTap: (){
                    StoriesController storiesController=StoriesController();
                    storiesController.deleteStory(storiesModel);
                  },
                  tileColor: Color(0xFF211a23),
                  leading: Icon(CupertinoIcons.delete,color: Colors.red,),
                  title: Text('Delete',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),);
        }
        );
      }
    else
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You Are Not the Owner Of This Story'),
           behavior: SnackBarBehavior.floating,duration: Duration(seconds: 1),
          ),
        );

      }
  }
}

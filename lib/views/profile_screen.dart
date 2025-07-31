import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:whisper/core/theme/custom_themes/context_extensions.dart';
import 'package:whisper/models/user_model.dart';
import '../controller/profile_controller.dart';
import '../controller/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel currentuser;
  final String? image;

  const ProfileScreen({super.key, required this.currentuser, this.image});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profile_controller = ProfileController();
  bool isUploading = false;

  Future<void> handleImageUpload() async {
    setState(() {
      isUploading = true;
    });

    final success = await profile_controller.uploadImageToSupabase(widget.currentuser);

    setState(() {
      isUploading = false;
    });

    if (success) {
      setState(() {}); // Refresh UI with new image
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
        ),
        actions: [
          IconButton(onPressed: (){
            Get.find<ThemeController>().toggleTheme();
          }, icon: Get.find<ThemeController>().isDarkMode.value ?  Icon(Icons.dark_mode,color: context.background.accented,)
              :  Icon(Icons.light_mode,color: context.background.accented,)
          ),

          IconButton(
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            icon: Icon(
              Icons.logout,
              color: context.background.accented,
            ),
          ),

        ],
      ),
      body: Container(
        color: context.background.primary,
        child: Column(
          children: [
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 130,
                  backgroundImage: widget.currentuser.imageUrl != null
                      ? NetworkImage(widget.currentuser.imageUrl!)
                      : const AssetImage('assets/images/profile3.png') as ImageProvider,
                ),
                if (isUploading)
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                Positioned(
                  right: 40,
                  bottom: 5,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                    child: IconButton(
                      onPressed: isUploading ? null : handleImageUpload,
                      icon: const Icon(CupertinoIcons.plus, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.only(left: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Icon(
                    CupertinoIcons.profile_circled,
                    size: 40,
                    color: context.background.accented,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        "Full Name",
                        style: context.textStyles.bodyMedium,
                      ),
                      Text(
                        widget.currentuser.fullName,
                        style: context.textStyles.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Icon(
                    Icons.email,
                    size: 40,
                    color: context.background.accented,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'Email ID',
                        style: context.textStyles.bodyMedium,
                      ),
                      Text(
                        widget.currentuser.email,
                        style: context.textStyles.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

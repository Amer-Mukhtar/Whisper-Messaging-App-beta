import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:whisper/models/user_model.dart';
import 'package:whisper/widgets/constant.dart';
import '../controller/profile_controller.dart';

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
          IconButton(
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            icon: const Icon(
              Icons.logout,
              color: profileIcon,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        color: profileBackground,
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
                  const Icon(
                    CupertinoIcons.profile_circled,
                    size: 40,
                    color: profileIcon,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Full Name",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        widget.currentuser.fullName,
                        style: const TextStyle(color: profileText),
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
                  const Icon(
                    Icons.email,
                    size: 40,
                    color: profileIcon,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email ID',
                        style: TextStyle(color: profileText),
                      ),
                      Text(
                        widget.currentuser.email,
                        style: const TextStyle(color: profileText),
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

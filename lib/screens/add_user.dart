import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/screens/chatPage_screen.dart';
import 'package:whisper/widgets/constant.dart';
import 'package:whisper/widgets/text_field.dart';
class AddUserScreen extends StatefulWidget {
  final String currentUser;
  final String currentEmail;
  const AddUserScreen({
    super.key,
    required this.currentUser,
    required this.currentEmail,
  });

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final textAddNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textAddNameController.dispose();
    super.dispose();
  }

  Future<bool> _checkIfUserExists(String name, String collection, String field) async 
  {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: name)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
  Future<bool> _checkIfUserExists2(String name2,String name, String collection, String field2,String field) async
  {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: name)
        .where(field2,isEqualTo: name2)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: addUserIcon),
          backgroundColor: addUserBackground,
          title: const Text(
            'Add Profile',
            style: TextStyle(color: addUserText),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: 300),
              color: addUserBackground,
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 130,
                        backgroundColor: Colors.black,
                        backgroundImage: AssetImage('assets/images/icon.png'),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Whisper a friend',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: addUserText),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomTextField(
                          textStyle: TextStyle(color: Colors.white),
                          label: 'User Name',
                          hintText: 'Enter User Name',
                          keyboardType: TextInputType.name,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter User Name';
                            }
                            return null;
                          },
                          controller: textAddNameController,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final userExistsInDatabase = await _checkIfUserExists(
                              textAddNameController.text,
                              'users',
                              'fullName',
                            );

                            if (!userExistsInDatabase)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('User with this name does not exist in the database.')),
                              );
                            }//String name2,String name, String collection, String field2,String field

                            else {
                              final userAlreadyAdded = await _checkIfUserExists2(
                                textAddNameController.text,
                                widget.currentUser,
                                'added_users',//collection
                                'AddedUser',
                                'CurrentUser'
                                //field
                              );
                              if (userAlreadyAdded )//
                              {

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('User with this name has already been added.')),
                                );
                              }

                              else
                              {
                                try {
                                  Map<String, String> adduser = {
                                    'CurrentUser': widget.currentUser,
                                    'AddedUser': textAddNameController.text,
                                  };
                                  await FirebaseFirestore.instance.collection('added_users').add(adduser);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        currentuser: widget.currentUser,
                                        email: widget.currentEmail,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error adding user: $e')),
                                  );
                                }
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 10),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            ),
        );
    }
}
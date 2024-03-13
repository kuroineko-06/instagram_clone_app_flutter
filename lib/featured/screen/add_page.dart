import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _file;

  void postImage(
    String uid,
    String name,
    String profileImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, name, profileImage);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("Posted", context);
        clearImage();
        clearDesc();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create a Post"),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Take a Photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Choose from gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void clearDesc() {
    setState(() {
      _descriptionController.text = "";
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text("New posts"),
            ),
            body: Container(
              color: mobileBackgroundColor,
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: IconButton(
                      onPressed: () => _selectImage(context),
                      icon: Icon(
                        Icons.upload,
                        size: 25,
                      )),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text("Post To"),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back), onPressed: clearImage),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                      onPressed: () =>
                          postImage(user.uid, user.name, user.photoURL),
                      child: Text(
                        "Post",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                color: mobileBackgroundColor,
                child: Column(
                  children: <Widget>[
                    _isLoading
                        ? LinearProgressIndicator()
                        : Padding(padding: EdgeInsets.only(top: 0)),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.photoURL),
                        ),
                        SizedBox(width: 15),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.2,
                                      color: const Color.fromARGB(
                                          255, 212, 207, 207)))),
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              hintText: "Write your caption...",
                              border: InputBorder.none,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                ),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(height: 50)
                  ],
                ),
              ),
            ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/screen/chats_page.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class GroupsWidget extends StatefulWidget {
  final String uid;
  final String profileImage;
  final String name;
  const GroupsWidget(
      {Key? key,
      required this.uid,
      required this.name,
      required this.profileImage})
      : super(key: key);

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  var userData = {};
  bool isFollowing = false;
  bool isLoading = false;

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap.data()!;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatsApp(
                  profileImage: widget.profileImage.toString(),
                  receiverUid: widget.uid.toString(),
                  receiverName: widget.name.toString(),
                ))),
        child: Container(
          width: double.infinity,
          height: 90,
          color: mobileBackgroundColor,
          child: Column(children: [
            Container(
              color: mobileBackgroundColor,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              userData['photoURL'].toString(),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                userData['name'].toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Press to chat",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

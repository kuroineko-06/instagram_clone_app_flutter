import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/screen/profile_page.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/featured/widgets/follow_button.dart';

class ProfileCard extends StatefulWidget {
  final String uid;
  const ProfileCard({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  var userData = {};
  int followers = 0;
  int following = 0;
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
      body: Container(
        width: double.infinity,
        height: 303,
        color: mobileBackgroundColor,
        child: Column(children: [
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(uid: userData['uid'].toString()))),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              height: 280,
              width: 202,
              color: Color.fromARGB(255, 9, 8, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.close,
                              size: 20,
                            )),
                      ),
                      Container(
                        child: CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(
                              userData['photoURL'].toString(),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        alignment: Alignment.center,
                        child: Text(
                          userData['name'].toString(),
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        child: Stack(
                          children: [
                            isFollowing
                                ? Container(
                                    child: FollowButton(
                                      text: 'Unfollow',
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      borderColor: Colors.grey,
                                      function: () async {
                                        await FireStoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );

                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      },
                                    ),
                                  )
                                : Container(
                                    child: FollowButton(
                                      text: 'Follow',
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      borderColor: Colors.blue,
                                      function: () async {
                                        await FireStoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );

                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

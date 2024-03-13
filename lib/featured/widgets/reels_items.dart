import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/screen/add_reels.dart';
import 'package:instagram_clone/featured/screen/reels_page.dart';
import 'package:instagram_clone/featured/widgets/avatar_reels.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class ReelsItems extends StatefulWidget {
  final String uid;
  final String name;
  final String photoURL;
  const ReelsItems(
      {super.key,
      required this.uid,
      required this.name,
      required this.photoURL});

  @override
  State<ReelsItems> createState() => _ReelsItemsState();
}

class _ReelsItemsState extends State<ReelsItems> {
  var userData = {};
  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap.data()!;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: mobileBackgroundColor,
          height: 130,
          constraints: BoxConstraints(maxWidth: double.infinity),
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                constraints: BoxConstraints(maxHeight: double.infinity),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        margin: EdgeInsets.symmetric(vertical: 3),
                        padding: EdgeInsets.only(left: 14),
                        child: Stack(
                          children: [
                            InkWell(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => ReelScreen(
                                              uid: widget.uid.toString(),
                                            ))),
                                child: Container(
                                  height: 75,
                                  width: 70,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        child: AvatarReels(
                                            uid: widget.uid.toString()),
                                        radius: 35,
                                        backgroundImage: NetworkImage(
                                            widget.photoURL.toString()),
                                      ),
                                    ],
                                  ),
                                )),
                            Positioned(
                              bottom: -11,
                              right: -0,
                              child: Container(
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => AddReels(
                                                  name: widget.name,
                                                  photoURL: widget.photoURL
                                                      .toString())));
                                    },
                                    icon: Icon(
                                      Icons.add_circle,
                                      size: 25,
                                      color: Colors.blue,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          userData['name'].toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ]),
              ),
            ],
          )),
    );
  }
}

class ReelsItems2 extends StatefulWidget {
  final String uid;
  final String photoURL;
  const ReelsItems2({
    super.key,
    required this.uid,
    required this.photoURL,
  });

  @override
  State<ReelsItems2> createState() => _ReelsItems2State();
}

class _ReelsItems2State extends State<ReelsItems2> {
  var userData = {};
  bool isLoading = false;
  bool isFollowing = false;
  int followers = 0;

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mobileBackgroundColor,
        height: 120,
        constraints: BoxConstraints(maxWidth: double.infinity),
        child: Row(
          children: [
            Container(
              width: 100,
              constraints: BoxConstraints(maxHeight: double.infinity),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      padding: EdgeInsets.only(left: 14),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ReelScreen(
                                          uid: widget.uid.toString(),
                                        ))),
                            child: Container(
                              height: 75,
                              width: 70,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    child:
                                        AvatarReels(uid: widget.uid.toString()),
                                    radius: 35,
                                    backgroundImage: NetworkImage(
                                        widget.photoURL.toString()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -3,
                            left: 12,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: isFollowing
                                    ? SizedBox.shrink()
                                    : Container(
                                        width: 45,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: mobileBackgroundColor,
                                            border: Border.all(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: IconButton(
                                          onPressed: () async {
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
                                          icon: Icon(
                                            Icons.person_add_alt_sharp,
                                            color: Colors.white,
                                            size: 19,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        userData['name'].toString(),
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

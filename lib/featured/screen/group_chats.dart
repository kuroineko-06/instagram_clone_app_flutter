import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/screen/profile_page.dart';
import 'package:instagram_clone/featured/widgets/group_widget.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class GroupsChat extends StatefulWidget {
  final String uid;
  const GroupsChat({super.key, required this.uid});

  @override
  State<GroupsChat> createState() => _GroupsChatState();
}

class _GroupsChatState extends State<GroupsChat> {
  var userData = {};
  bool isFollowing = false;
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
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
      appBar: AppBar(
        title: Text('${userData['name'].toString()} messages'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      color: mobileBackgroundColor,
                      height: 50,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: _buildMessageSearch(),
                    ),
                  ),
                ],
              ),
              isShowUsers
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      color: mobileBackgroundColor,
                      child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where(
                              'name',
                              isGreaterThanOrEqualTo: searchController.text,
                            )
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                        uid: (snapshot.data! as dynamic)
                                            .docs[index]['uid'],
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 300,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          (snapshot.data! as dynamic)
                                              .docs[index]['photoURL'],
                                        ),
                                        radius: 18,
                                      ),
                                      title: Text(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['name'],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      width: double.infinity,
                      color: mobileBackgroundColor,
                      child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center();
                          }
                          return Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              itemBuilder: (context, index) =>
                                  !(snapshot.data! as dynamic)
                                          .docs[index]['followers']
                                          .contains(FirebaseAuth
                                              .instance.currentUser!.uid)
                                      ? SizedBox.shrink()
                                      : Container(
                                          height: 90,
                                          width: 300,
                                          child: GroupsWidget(
                                            uid: (snapshot.data! as dynamic)
                                                .docs[index]['uid'],
                                            name: (snapshot.data! as dynamic)
                                                .docs[index]['name'],
                                            profileImage:
                                                (snapshot.data! as dynamic)
                                                    .docs[index]['photoURL'],
                                          ),
                                        ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageSearch() {
    return Form(
      child: TextFormField(
        controller: searchController,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            hintText: 'Search for a user...',
            prefixIcon: Padding(
              padding: EdgeInsets.only(top: 4, left: 5),
              child: Icon(Icons.search_sharp),
            )),
        onFieldSubmitted: (String _) {
          setState(() {
            isShowUsers = true;
          });
        },
      ),
    );
  }
}

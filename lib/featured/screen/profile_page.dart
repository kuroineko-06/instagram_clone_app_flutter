import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/featured/screen/detail_posts.dart';
import 'package:instagram_clone/featured/screen/save_posts.dart';
import 'package:instagram_clone/featured/widgets/reels_in_profile.dart';
import 'package:instagram_clone/featured/widgets/reels_widget.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/featured/screen/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/featured/widgets/follow_button.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  String selectedValue = "darkMode";

  Future<Null> _pullRefresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      getData();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(
            userData['name'].toString(),
            style: TextStyle(color: primaryColor),
          ),
          centerTitle: false,
          actions: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: SizedBox(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: mobileBackgroundColor,
                    ),
                    child:
                        Container(width: 200, child: _buildAppBarSettingPage()),
                  ),
                ))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Container(
            color: mobileBackgroundColor,
            child: ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                    userData['photoURL'].toString(),
                                  ),
                                  radius: 40,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          buildStatColumn(postLen, "posts"),
                                          buildStatColumn(
                                              followers, "followers"),
                                          buildStatColumn(
                                              following, "following"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          FirebaseAuth.instance.currentUser!
                                                      .uid ==
                                                  widget.uid
                                              ? FollowButton(
                                                  text: 'Sign Out',
                                                  backgroundColor:
                                                      mobileBackgroundColor,
                                                  textColor: primaryColor,
                                                  borderColor: Colors.grey,
                                                  function: () async {
                                                    await AuthMethods()
                                                        .signOut();
                                                    if (context.mounted) {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoginPage(),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                )
                                              : isFollowing
                                                  ? FollowButton(
                                                      text: 'Unfollow',
                                                      backgroundColor:
                                                          Colors.white,
                                                      textColor: Colors.black,
                                                      borderColor: Colors.grey,
                                                      function: () async {
                                                        await FireStoreMethods()
                                                            .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid'],
                                                        );

                                                        setState(() {
                                                          isFollowing = false;
                                                          followers--;
                                                        });
                                                      },
                                                    )
                                                  : FollowButton(
                                                      text: 'Follow',
                                                      backgroundColor:
                                                          Colors.blue,
                                                      textColor: Colors.white,
                                                      borderColor: Colors.blue,
                                                      function: () async {
                                                        await FireStoreMethods()
                                                            .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid'],
                                                        );

                                                        setState(() {
                                                          isFollowing = true;
                                                          followers++;
                                                        });
                                                      },
                                                    )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                top: 15,
                              ),
                              child: Text(
                                userData['name'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Container(
                            //   alignment: Alignment.centerLeft,
                            //   padding: const EdgeInsets.only(
                            //     top: 1,
                            //   ),
                            //   child: Text(
                            //     userData['dateOfBirth'].toString(),
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Icon(Icons.grid_on),
                          Icon(Icons.video_collection),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 500,
                  width: double.maxFinite,
                  child: TabBarView(
                    children: [
                      // Widget for the first tab
                      Container(child: buildPostGridWidget()),
                      // Widget for the second tab (You can replace this with your own implementation)
                      Container(child: buildReelsGridWidget()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPostGridWidget() {
    return Container(
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: widget.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailPage(
                          uid: userData['uid'],
                          name: userData['name'],
                        )));
              },
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                physics: AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap =
                      (snapshot.data! as dynamic).docs[index];

                  return SizedBox(
                    child: Image(
                      image: NetworkImage(snap['postUrl']),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildReelsGridWidget() {
    return Container(
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('reels')
            .where('uid', isEqualTo: widget.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: (snapshot.data! as dynamic).docs.length,
              physics: AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 1.5,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Container(
                          height: 700,
                          width: 500,
                          child:
                              ReelsItem(snapshot.data!.docs[index].data())))),
                  child: Container(child: ReelsInProfile(snap.data())),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBarSettingPage() {
    return Container(
      child: DropdownButton(
          underline: SizedBox(),
          icon: Icon(
            Icons.settings,
            size: 25,
          ),
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
          },
          items: dropdownItems),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        child: Container(
          width: 170,
          child: InkWell(
            onTap: () {
              // getAllPost();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SavePosts()));
            },
            child: Container(
                margin: EdgeInsets.only(top: 10), child: Text("Saved")),
          ),
        ),
        value: 'savePost',
      ),
      DropdownMenuItem(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text("Dark mode: ",
                    style:
                        TextStyle(fontSize: 16, color: getSvgColor(context))),
              ),
              Container(
                child: ToggleSwitch(
                  minWidth: 35,
                  minHeight: 25,
                  initialLabelIndex: 0,
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  icons: [
                    Icons.light_mode,
                    Icons.dark_mode,
                  ],
                  iconSize: 30.0,
                  activeBgColors: [
                    [Colors.black45, Colors.black26],
                    [Colors.yellow, Colors.orange]
                  ],
                  animate:
                      true, // with just animate set to true, default curve = Curves.easeIn
                  curve: Curves.easeInCirc,
                  onToggle: (index) {
                    print('switched to: $index');
                    if (index == 0) {
                      Get.changeTheme(ThemeData.light());
                    } else {
                      Get.changeTheme(ThemeData.dark());
                    }
                  },
                ),
              ),
            ],
          ),
          value: "darkMode"),
    ];
    return menuItems;
  }
}

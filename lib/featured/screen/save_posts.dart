import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/widgets/post_card.dart';
import 'package:instagram_clone/utils/colors.dart';

class SavePosts extends StatefulWidget {
  const SavePosts({
    super.key,
  });
  State<SavePosts> createState() => _SavePostsState();
}

class _SavePostsState extends State<SavePosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved"),
      ),
      body: Container(
        color: mobileBackgroundColor,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('savedId', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) => (snapshot.data! as dynamic)
                          .docs[index]['savedId']
                          .contains(FirebaseAuth.instance.currentUser!.uid)
                      ? PostCard(snap: snapshot.data!.docs[index].data())
                      : Container(
                          height: 0,
                        )),
            );
            // ));
          },
        ),
      ),
    );
  }
}

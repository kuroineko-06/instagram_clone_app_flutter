import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/widgets/reels_widget.dart';

class ReelScreen extends StatefulWidget {
  final String uid;
  const ReelScreen({super.key, required this.uid});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('reels')
              .where('uid', isEqualTo: widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            return PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: PageController(initialPage: 0, viewportFraction: 1),
              itemBuilder: (context, index) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return ReelsItem(snapshot.data!.docs[index].data());
              },
              itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
            );
          },
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class AvatarReels extends StatefulWidget {
  final String uid;
  const AvatarReels({super.key, required this.uid});

  @override
  State<AvatarReels> createState() => _AvatarReelsState();
}

class _AvatarReelsState extends State<AvatarReels> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('reels')
          .where('uid', isEqualTo: widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => Column(
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                      border: GradientBoxBorder(
                          width: 2,
                          gradient: LinearGradient(
                              colors: [Colors.yellowAccent, Colors.redAccent])),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

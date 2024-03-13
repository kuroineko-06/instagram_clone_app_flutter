import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/widgets/likes_animation.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  final String postId;
  const CommentCard({super.key, required this.snap, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap.data()['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: snap.data()['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            )),
                        TextSpan(
                            text: ': ${snap.data()['text']}',
                            style: TextStyle(
                              color: primaryColor,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMd().add_jm().format(
                            snap.data()['datePublished'].toDate(),
                          ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
            child: LikeAnimation(
              isAnimating: snap
                  .data()['likes']
                  .contains(FirebaseAuth.instance.currentUser!.uid),
              smallLike: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: IconButton(
                    icon: snap
                            .data()['likes']
                            .contains(FirebaseAuth.instance.currentUser!.uid)
                        ? const Icon(
                            Icons.favorite,
                            size: 23,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            size: 23,
                          ),
                    onPressed: () => FireStoreMethods().likesComment(
                        postId.toString(),
                        snap.data()['commentId'],
                        FirebaseAuth.instance.currentUser!.uid,
                        snap.data()['likes'])),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              child: Text('${snap.data()['likes'].length}'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/screen/profile_page.dart';
import 'package:instagram_clone/featured/widgets/likes_animation.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../provider/user_provider.dart';

class ReelsItem extends StatefulWidget {
  final snapshot;
  ReelsItem(this.snapshot, {super.key});

  @override
  State<ReelsItem> createState() => _ReelsItemState();
}

class _ReelsItemState extends State<ReelsItem> {
  late VideoPlayerController controller;
  bool play = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ignore: deprecated_member_use
    controller = VideoPlayerController.network(widget.snapshot['reelsvideo'])
      ..initialize().then((value) {
        setState(() {
          controller.setLooping(true);
          controller.setVolume(1);
          controller.play();
        });
      });
    FireStoreMethods().watchReels(widget.snapshot['postId'],
        widget.snapshot['uid'], widget.snapshot['watched']);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                play = !play;
              });
              if (play) {
                controller.play();
              } else {
                controller.pause();
              }
            },
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: VideoPlayer(controller),
            ),
          ),
          if (!play)
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.white30,
                radius: 35,
                child: Icon(
                  Icons.play_arrow,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          Positioned(
            top: 460,
            right: 5,
            child: Column(
              children: [
                LikeAnimation(
                  isAnimating: widget.snapshot['like'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    icon: widget.snapshot['like'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            size: 25,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            size: 25,
                          ),
                    onPressed: () => FireStoreMethods().likeReels(
                      widget.snapshot['postId'].toString(),
                      user.uid,
                      widget.snapshot['like'],
                    ),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '${widget.snapshot['like'].length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 15),
                // GestureDetector(
                //   onTap: () {
                //     showBottomSheet(
                //       backgroundColor: Colors.transparent,
                //       context: context,
                //       builder: (context) {
                //         return Padding(
                //           padding: EdgeInsets.only(
                //             bottom: MediaQuery.of(context).viewInsets.bottom,
                //           ),
                //           child: DraggableScrollableSheet(
                //             maxChildSize: 0.6,
                //             initialChildSize: 0.6,
                //             minChildSize: 0.2,
                //             builder: (context, scrollController) {
                //               return Comment(widget.snapshot['postId'], 'reels');
                //             },
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: Icon(
                //     Icons.comment,
                //     color: Colors.white,
                //     size: 28,
                //   ),
                // ),

                SizedBox(height: 15),
                // FirebaseAuth.instance.currentUser!.uid == widget.snapshot['uid']
                //     ? SizedBox.shrink()
                //     : Column(
                //         children: [
                //           Icon(
                //             Icons.send,
                //             color: Colors.white,
                //             size: 25,
                //           ),
                //           SizedBox(width: 3),
                //           Text(
                //             '0',
                //             style: TextStyle(
                //               fontSize: 12,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ],
                //       ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.1),
                ],
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                      uid: widget.snapshot['uid'].toString()))),
                          child: ClipOval(
                            child: SizedBox(
                              height: 45,
                              width: 45,
                              child: Image.network(
                                  widget.snapshot['profileImage']),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.snapshot['name'].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      FirebaseAuth.instance.currentUser!.uid ==
                              widget.snapshot['uid']
                          ? SizedBox.shrink()
                          : Container(
                              margin: EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              width: 60,
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Follow',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      widget.snapshot['caption'].toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  FirebaseAuth.instance.currentUser!.uid ==
                          widget.snapshot['uid']
                      ? Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                size: 25,
                              ),
                              SizedBox(width: 5),
                              Text(
                                  '${widget.snapshot['watched'].length} Viewer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

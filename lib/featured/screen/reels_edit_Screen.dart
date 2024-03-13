import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/resources/storage.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class ReelsEditeScreen extends StatefulWidget {
  File videoFile;
  final String name;
  final String photoURL;
  ReelsEditeScreen(this.videoFile,
      {super.key, required this.name, required this.photoURL});

  @override
  State<ReelsEditeScreen> createState() => _ReelsEditeScreenState();
}

class _ReelsEditeScreenState extends State<ReelsEditeScreen> {
  final caption = TextEditingController();
  late VideoPlayerController controller;
  bool Loading = false;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        controller.setLooping(false);
        controller.setVolume(1.0);
        controller.play();
      });
  }

  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: false,
          title: Text(
            'New Reels',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: mobileBackgroundColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Loading
                ? const Center(
                    child: Column(
                    children: [
                      const SizedBox(height: 50),
                      LinearProgressIndicator()
                    ],
                  ))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                              width: 270,
                              height: 420,
                              child: controller.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio: controller.value.aspectRatio,
                                      child: VideoPlayer(controller),
                                    )
                                  : const CircularProgressIndicator()),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 60,
                          width: 280,
                          child: TextField(
                            controller: caption,
                            maxLines: 10,
                            decoration: const InputDecoration(
                              hintText: 'Write a caption ...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 45,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Save draft',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  Loading = true;
                                });
                                String Reels_Url = await StorageMethod()
                                    .uploadVideoToStorage(
                                        'Reels', widget.videoFile);
                                await FireStoreMethods().CreatReels(
                                    Reels_Url,
                                    caption.text,
                                    widget.name,
                                    widget.photoURL.toString());
                                Navigator.of(context).pop();
                                showSnackBar("Post reels complete", context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

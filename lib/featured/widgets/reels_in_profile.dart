// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsInProfile extends StatefulWidget {
  final snapshot;
  ReelsInProfile(this.snapshot, {super.key});

  @override
  State<ReelsInProfile> createState() => _ReelsInProfileState();
}

class _ReelsInProfileState extends State<ReelsInProfile> {
  late VideoPlayerController controller;
  bool play = true;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.snapshot['reelsvideo']))
      ..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500,
      child: VideoPlayer(controller),
    );
  }
}

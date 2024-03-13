import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/screen/reels_edit_Screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:photo_manager/photo_manager.dart';

class AddReels extends StatefulWidget {
  final String name;
  final String photoURL;
  const AddReels({super.key, required this.name, required this.photoURL});

  @override
  State<AddReels> createState() => _AddReelsState();
}

class _AddReelsState extends State<AddReels> {
  final List<Widget> _mediaList = [];
  final List<File> path = [];
  File? _file;
  int currentPage = 0;
  int? lastPage;
  _fetchNewMedia() async {
    lastPage = currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(type: RequestType.video);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: currentPage, size: 60);

      for (var asset in media) {
        if (asset.type == AssetType.video) {
          final file = await asset.file;
          if (file != null) {
            path.add(File(file.path));
            _file = path[0];
          }
        }
      }
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (asset.type == AssetType.video)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            alignment: Alignment.center,
                            width: 350,
                            height: 150,
                            child: Row(
                              children: [
                                Text(
                                  asset.videoDuration.inMinutes.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  ':',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  asset.videoDuration.inSeconds.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                );
              }

              return Container();
            },
          ),
        );
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  int indexx = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'New Reels',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mobileBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _mediaList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 250,
              crossAxisSpacing: 3,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      indexx = index;
                      _file = path[index];
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReelsEditeScreen(_file!,
                            name: widget.name,
                            photoURL: widget.photoURL.toString()),
                      ));
                    });
                  },
                  child: _mediaList[index]);
            },
          ),
        ),
      ),
    );
  }
}

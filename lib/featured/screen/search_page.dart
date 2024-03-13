import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/featured/screen/profile_page.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: Form(
              child: TextFormField(
                controller: searchController,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? Container(
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
                    return SizedBox.shrink();
                  }
                  if (snapshot.hasError) {
                    return SizedBox.shrink();
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ['uid'],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage((snapshot.data!)
                                .docs[index]['photoURL']
                                .toString()),
                            radius: 16,
                          ),
                          title: Text(
                            (snapshot.data! as dynamic)
                                .docs[index]['name']
                                .toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          : Container(
              color: mobileBackgroundColor,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('datePublished')
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }

                  return MasonryGridView.count(
                    crossAxisCount: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Image.network(
                      (snapshot.data! as dynamic)
                          .docs[index]['postUrl']
                          .toString(),
                      fit: BoxFit.cover,
                    ),
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  );
                },
              ),
            ),
    );
  }
}

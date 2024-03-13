import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/screen/profile_page.dart';
import 'package:instagram_clone/featured/widgets/chats_bubble.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';

class ChatsApp extends StatefulWidget {
  final String receiverName;
  final String receiverUid;
  final String profileImage;
  const ChatsApp(
      {super.key,
      required this.receiverUid,
      required this.receiverName,
      required this.profileImage});

  @override
  State<ChatsApp> createState() => _ChatsAppState();
}

class _ChatsAppState extends State<ChatsApp> {
  final TextEditingController chatsEditingController = TextEditingController();
  final FireStoreMethods _chatMessage = FireStoreMethods();
  String selectedValue = "item1";

  void sendMessages(String uid, String profileImage) async {
    if (chatsEditingController.text.isNotEmpty) {
      await _chatMessage.sendMessage(uid, widget.receiverName,
          chatsEditingController.text, widget.receiverUid, profileImage);
      chatsEditingController.clear();
    }
  }

  @override
  void dispose() {
    chatsEditingController.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Row(
            children: [
              Container(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.profileImage),
                  radius: 19,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${widget.receiverName}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          actions: [
            _dropDownButton(),
          ],
          centerTitle: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput(),
          ],
        ));
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatMessage.getMessages(
          widget.receiverUid, FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList());
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == FirebaseAuth.instance.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            data['senderId'] == FirebaseAuth.instance.currentUser!.uid
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ChatBubble(
                message: data['message'],
                color:
                    data['senderId'] == FirebaseAuth.instance.currentUser!.uid
                        ? Colors.blue
                        : Color.fromARGB(255, 86, 85, 85)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: Color.fromARGB(255, 205, 202, 202)),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: TextFormField(
            controller: chatsEditingController,
            obscureText: false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hintText: "Enter your messages...",
              border: InputBorder.none,
            ),
          ),
        )),
        Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: IconButton(
              onPressed: () {
                sendMessages(FirebaseAuth.instance.currentUser!.uid,
                    widget.profileImage);
              },
              icon: Icon(Icons.arrow_upward)),
        ),
      ],
    );
  }

  Widget _dropDownButton() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButton(
            underline: SizedBox(),
            icon: Icon(
              Icons.info,
              size: 25,
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
            items: dropdownItems));
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        child: InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(uid: widget.receiverUid))),
            child: Text("View profile ${widget.receiverName}")),
        value: 'item1',
      ),
      DropdownMenuItem(
        child: InkWell(child: Text("item 2")),
        value: 'item2',
      ),
    ];
    return menuItems;
  }
}

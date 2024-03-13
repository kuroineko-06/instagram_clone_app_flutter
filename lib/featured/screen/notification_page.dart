import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/featured/widgets/notification_badge.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:instagram_clone/models/notification.dart';
import 'package:instagram_clone/utils/colors.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late int _totalNotifications;
  PushNotification? _notificationInfo;
  late final FirebaseMessaging _messaging;
  @override
  void initState() {
    _totalNotifications = 0;
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });
    checkForInitialMessage();
    registerNotification();
    super.initState();
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      print("Handling a background message: ${message.messageId}");
      return;
    }

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => (),
      //     ));
    }); // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Notification"),
      ),
      body: Container(
        color: mobileBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _notificationInfo != null
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.2, color: Colors.white)),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://images.unsplash.com/photo-1710088912041-34d1767d376a?q=80&w=1004&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                              radius: 36,
                            ),
                          ),
                          Container(
                            width: 20,
                          ),
                          Container(
                            height: double.infinity,
                            width: MediaQuery.of(context).size.width * 0.56,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${_notificationInfo!.dataTitle ?? _notificationInfo!.title}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '${_notificationInfo!.dataBody ?? _notificationInfo!.body}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.more_vert_outlined)),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Text(
                          "Empty notification",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                  ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String name;
  final likes;
  final savedId;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImage;

  const Post({
    required this.description,
    required this.uid,
    required this.name,
    required this.likes,
    required this.savedId,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImage,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        savedId: snapshot["savedId"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        name: snapshot["name"],
        postUrl: snapshot['postUrl'],
        profileImage: snapshot['profileImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "savedId": savedId,
        "name": name,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profileImage': profileImage
      };
}

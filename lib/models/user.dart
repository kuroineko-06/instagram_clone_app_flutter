class User {
  final String name;
  final String uid;
  final String photoURL;
  final String email;
  final String dateOfBirth;
  final List followers;
  final List following;

  const User(
      {required this.name,
      required this.uid,
      required this.photoURL,
      required this.email,
      required this.dateOfBirth,
      required this.followers,
      required this.following});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        uid: json["uid"],
        email: json["email"],
        photoURL: json["photoURL"],
        dateOfBirth: json["dateOfBirth"],
        followers: json["followers"],
        following: json["following"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "uid": uid,
        "photoURL": photoURL,
        "dateOfBirth": dateOfBirth,
        "followers": followers,
        "following": following,
      };
}


import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String description, uid, postUrl, username,postId, profImage;
  final likes;
  final DateTime datePublished;


  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.likes,
    required this.postId,
    required this.postUrl,
    required this.profImage
});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage']
    );
  }

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "likes": likes,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profImage': profImage
  };
}
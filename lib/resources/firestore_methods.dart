

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instagram/resources/storage_methode.dart';
import 'package:flutter_instagram/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FireStoreMethods{

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
      await StorageMethod().uploadImage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes)async{
    if(likes.contains(uid)){
      _firestore.collection("posts").doc(postId).update({
        "likes":FieldValue.arrayRemove([uid])
      });
    }else{
      _firestore.collection("posts").doc(postId).update({
        "likes":FieldValue.arrayUnion([uid])
      });
    }
  }

  Future<void> postComment(String postId, String text, String name,String uid, String profPic)async{
    String res = "Some error is occured";
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection("comments").doc(commentId).set({
          "profilePic":profPic,
          "name":name,
          "text":text,
          "uid":uid,
          "commentId":commentId,
          "datePublished":DateTime.now()
        }).then((value) async{
          print("sucess");
        }).onError((error, stackTrace) {

          print('error');
        })
        ;

      }else{
        print('text is empty');
      }


    }
    catch(e){
      res = e.toString();
      print(e);
    }

  }
}
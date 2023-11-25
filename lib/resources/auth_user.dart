import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_instagram/resources/storage_methode.dart';

import '../models/user.dart';

class AuthMethods{


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Member?> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('users').doc(currentUser.uid).get();

    return Member.fromSnap(documentSnapshot);
  }

  Future<String> signUp({
    required String email,
    required String username,
    required String bio,
    required String password,
     Uint8List? file
  })async{
    String res = "Some error is occurred";

    try{
      if(email.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || password.isNotEmpty || file != null){
        UserCredential? credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        // add User's data
        if(credential.user != null){
          String photoUrl = await StorageMethod().uploadImage("ProfileImages", file!, false);
          Member user = Member(
            username: username,
            uid: credential.user!.uid,
            photoUrl: photoUrl,
            email: email,
            bio: bio,
            followers: [],
            following: [],
          );
          await _firestore.collection("users").doc(credential.user!.uid).set(user.toJson());
        }
      }
      res = "success";
    }catch(error){
      res = error.toString();
    }

    return res ;
  }


  Future<String> LoginUser({required String email, required String password})async{
    String res = "Some error occured";

    try {
      if(email.isNotEmpty && password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
      }
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user.dart';
import 'package:flutter_instagram/providers/user_provider.dart';
import 'package:flutter_instagram/resources/firestore_methods.dart';
import 'package:flutter_instagram/utils/appcolors.dart';
import 'package:flutter_instagram/widgets/comment_card.dart';
import 'package:provider/provider.dart';

import '../responsive/mobile_screen_layout.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Member? member = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>MobileScreenLayout())),icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),),
        title: const Text("Comment",
          style: TextStyle(
          color: Colors.white,
            fontWeight: FontWeight.w500
        ),),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection("comments").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index)=>CommentCard(snap: snapshot.data!.docs[index],));
        },

      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(member!.photoUrl),
              ),
              const SizedBox(width: 15,),
              Expanded(child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Comment as user",
                  border: InputBorder.none,

                ),
              )),
              InkWell(
                onTap: ()async{
                  await FireStoreMethods().postComment(widget.snap['postId'],textEditingController.text , member!.username, member.uid, member.photoUrl);
                  setState(() {
                    textEditingController.text = "";
                  });
                },
                child: const Text("Post",
                  style: TextStyle(
                  color: Colors.blueAccent
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

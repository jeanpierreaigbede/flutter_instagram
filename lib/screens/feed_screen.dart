import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/appcolors.dart';
import 'package:flutter_instagram/widgets/post_card.dart';
import 'package:flutter_svg/flutter_svg.dart';


class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
        height: 30,
        color: Colors.white,),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.message, color: Colors.white,))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount:snapshot.data!.docs.length,
              itemBuilder: (context,index){
            return PostCard(snap: snapshot.data!.docs[index],);
          });
        },
      )
    );
  }



}

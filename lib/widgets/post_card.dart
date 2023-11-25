import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user.dart';
import 'package:flutter_instagram/providers/user_provider.dart';
import 'package:flutter_instagram/resources/firestore_methods.dart';
import 'package:flutter_instagram/screens/comment_screen.dart';
import 'package:flutter_instagram/utils/appcolors.dart';
import 'package:flutter_instagram/utils/utils.dart';
import 'package:flutter_instagram/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  int commentsLength = 0;
  @override
  void initState() {
    getComments();
    super.initState();
  }

  void getComments()async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection("comments").get();
        commentsLength = querySnapshot.docs.length;
  }
  bool isLikeAnimation = false;

  @override
  Widget build(BuildContext context) {
    final Member? member = Provider.of<UserProvider>(context).getUser;
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.snap['profImage']),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                  Text(widget.snap['username'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,

                  ),),
                /*Text("username",
                  style: TextStyle(
                    fontSize: 15,


                  ),),*/

            ],),
                )),
            IconButton(
                onPressed: (){
                  showDialog(context: context, builder: (context)=>Dialog(
                  insetPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    child: TextButton(
                      child:const Text("Delete"),
                      onPressed: ()async{
                        await FirebaseFirestore.instance.collection("posts").doc(widget.snap['postId']).delete().then((value) {
                          showSnackBar(context, "deleted");
                          Navigator.pop(context);
                        })
                        .onError((error, stackTrace) {
                          showSnackBar(context, error.toString());
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ));
                }, icon: const Icon(Icons.more_vert, color: Colors.white,)
            ),
          ],
        ),

        //IMAGE SESSION
        GestureDetector(
          onDoubleTap: ()async{
            setState(() {
              isLikeAnimation = true;
            });

            await FireStoreMethods().likePost(widget.snap['postId'], member!.uid, widget.snap['likes']);

          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.4,
                width: double.infinity,
                child: Image.network(widget.snap['postUrl'],fit: BoxFit.cover,),
              ),
              AnimatedOpacity(
                opacity: isLikeAnimation? 1:0,
                duration: const Duration(milliseconds: 400),
                child: LikeAnimation(
                      child: const Icon(Icons.favorite,color: Colors.white,size: 100,),
                      isAnimating: isLikeAnimation,
                    duration:const Duration(milliseconds: 400),
                    onEnd: (){
                        setState(() {
                          isLikeAnimation = false;
                        });
                    },
                ),
              )

            ],
          ),
        ),
        // LIKE SESSION AND OTHER
        Row(
          children: [
            LikeAnimation(
              isAnimating: widget.snap['likes'].contains(member!.uid),
              smallLike: true,
              child: IconButton(
                onPressed: ()async{
                  await FireStoreMethods().likePost(widget.snap['postId'], member.uid, widget.snap['likes']);
                }, icon: Icon(widget.snap['likes'].contains(member.uid)?Icons.favorite:Icons.favorite_border_outlined,color: widget.snap['likes'].contains(member.uid)?Colors.red:Colors.white),),
            ),
          IconButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentScreen(snap: widget.snap,))), icon: const Icon(Icons.comment,color: Colors.white,),),
          IconButton(onPressed: (){}, icon: const Icon(Icons.send,color: Colors.white,)),
            Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.bookmark_border,color: Colors.white,),
                  ),
            ))
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.snap['likes'].length} likes",
                style: const TextStyle(
                    fontSize: 16,fontWeight: FontWeight.w600,color: secondaryColor),
              ),
              RichText(text:
              TextSpan(
                text: widget.snap['username'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold
                ),
                children: [
                  TextSpan(
                    text:" " + widget.snap['description'],
                    style:const  TextStyle(
                      fontWeight: FontWeight.normal,
                      color: secondaryColor
                    )
                  )
                ]
              ),

              ),

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentScreen(snap: widget.snap)));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('View all ${commentsLength} comments',style: TextStyle(fontSize: 16,color: secondaryColor),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()).toString(),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: secondaryColor),),
              )
            ],
          ),
        )
      ],
    );
  }
}



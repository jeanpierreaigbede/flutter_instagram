import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        /*crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,*/
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(widget.snap['profilePic']),
          ),
          Column(children: [
            RichText(
                text: TextSpan(
                  text:widget.snap["name"],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16
                ),
                children:[
                  TextSpan(
                    text:"  ${  widget.snap['text']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                    ),
                  )
                ]
            )),
            Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()).toString())
          ],),
          IconButton(
            icon: const Icon(Icons.favorite,color: Colors.white,),
            onPressed: (){},
          )
        ],
      ),
    );
  }
}

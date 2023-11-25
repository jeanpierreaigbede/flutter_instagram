import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/user.dart';
import 'package:flutter_instagram/utils/appcolors.dart';


class ProfileScreen extends StatefulWidget {

  final uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int followers = 0;
  int following = 0;
  int postLength = 0;
  bool isLoading = false;


  @override
  void initState() {
    getData();
    super.initState();
  }
  void getData()async{
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts').get();


    setState(() {
      userData = snapshot.data() as Map<String, dynamic>;
      postLength = querySnapshot.docs.length;

      followers = userData['followers'].length;
      following = userData['following'].length;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? const Center(child:  CircularProgressIndicator()):Scaffold(
      /*appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          "Username"
        ),
      ),*/
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(userData['photoUrl']),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildColumn(postLength, "posts"),
                          buildColumn(followers, "followers"),
                          buildColumn(following, "following"),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width*0.6,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:Border.all(color: secondaryColor)
                        ),
                        child: Text(
                          "Edit Profile"
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        userData['username'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    Text(
                      userData['bio'],
                      style: const TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: secondaryColor,height: 1,),
          ],
        ),
      ),
    );
  }

  Column buildColumn(int numbers,String label){
    return Column(
      children: [
        Text(
          numbers.toString(),
          style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),
        ),
       const  SizedBox(height: 2,),
        Text(
          label,
          style:const TextStyle(
            color:secondaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w500
        ),)
      ],
    );
  }
}

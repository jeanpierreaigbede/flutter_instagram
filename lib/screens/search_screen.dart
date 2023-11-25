import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/appcolors.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchContreoller = TextEditingController();
  bool showUser = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchContreoller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextField(
          controller:searchContreoller,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'search user',
            suffixIcon: IconButton(
              icon: Icon(Icons.search,),
              onPressed: (){
                if(searchContreoller.text !="" && searchContreoller.text !=" "){
                  setState(() {
                    showUser = true;
                  });
                }
              },
            )
          ),
          onSubmitted: (value){
            if(searchContreoller.text !="" && searchContreoller.text !=" "){
              setState(() {
                showUser = true;
              });
            }
          },
        ),
      ),
      body: showUser && searchContreoller.text !="" && searchContreoller.text !=" "
          ? FutureBuilder(
        future: FirebaseFirestore.instance.collection("users").where("username",isGreaterThanOrEqualTo: searchContreoller.text.trim()).get(),
        builder: (context,  snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                return ListTile(
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(snapshot.data!.docs[index]['photoUrl']),
                  ),
                  title: snapshot.data!.docs[index]['username'],
                );

              });
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }
          return Container();
        },
      )
          :Text("post"),
    );
  }
}

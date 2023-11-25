import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_instagram/resources/firestore_methods.dart';
import 'package:flutter_instagram/utils/appcolors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/utils.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  Uint8List? _file;
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() {
                    _isLoading = true;
                  });
                  Uint8List? file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                    _isLoading = false;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  setState(() {
                    _isLoading = true;
                  });
                  Uint8List? file = await pickImage(ImageSource.gallery);

                  setState(() {
                    _isLoading = false;
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(
      String description,
      String username,
      String uid,
      profImage
      )async{
    Navigator.pop(context);
    setState(() {
      _isLoading = true;
    });
    String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage);

    if(res == "success"){
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, "Posted !");
      clearImage();
    }else{
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
      clearImage();
    }
  }

  void clearImage()async{
    setState(() {
      _file = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Center(
      child: _isLoading?const CircularProgressIndicator():IconButton(
        icon: const Icon(
          Icons.upload,
        ),
        onPressed: () => _selectImage(context),
      ),
    ): Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(onPressed: (){
          clearImage();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        actions: [
          TextButton(
              onPressed: ()=>postImage(_descriptionController.text, userProvider.getUser!.username, userProvider.getUser!.uid, userProvider.getUser!.photoUrl), child: Text(
            'Post ',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ))
        ],
        title: Text("Post to"),
      ),
      body: Column(
        children: [
          _isLoading? const LinearProgressIndicator():Container(),          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  userProvider.getUser!.photoUrl,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Write a caption...",
                      border: InputBorder.none),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45.0,
                width: 45.0,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(_file!),
                        )),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),

    );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_instagram/resources/auth_user.dart';
import 'package:flutter_instagram/screens/home_screen.dart';
import 'package:flutter_instagram/screens/login_screen.dart';
import 'package:flutter_instagram/utils/appcolors.dart';
import 'package:flutter_instagram/utils/utils.dart';
import 'package:flutter_instagram/widgets/textfield_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  bool _isloading = false;

  Uint8List? image;

  @override
  void dispose() {
_emailController.dispose();
_passwordController.dispose();
_usernameController.dispose();
_bioController.dispose();
    super.dispose();
  }

  void signUpUser()async{
    setState(() {
      _isloading = true;
    });
    String  res = await AuthMethods().signUp(
        email: _emailController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        password: _passwordController.text,
        file: image
    );

    setState(() {
      _isloading = false;
    });

    if(res != "success"){
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Text(res),
            )
        )
      );
    }else{
      print("Success");
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
    }

  }

  void selectImage()async{
    Uint8List? im = await pickImage(ImageSource.gallery);
    if(im != null){
      setState(() {
        image = im;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40,),
                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  height: 64,
                  color: primaryColor,
                ),
                const SizedBox(height: 40,),

                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                     children: [
                       image != null?CircleAvatar(
                         radius: 70,
                        backgroundImage: MemoryImage(image!),
                         backgroundColor: Colors.red,
                       ):
                       Container(
                         height: 100,
                         width: 100,
                         decoration: BoxDecoration(
                           color: Colors.red,
                           borderRadius: BorderRadius.circular(50),
                           image: const DecorationImage(
                             image:NetworkImage('https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250'),
                           )
                         ),
                         // child: Image.network("https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250"),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(left: 10),

                         child: Align(
                           alignment: Alignment.bottomRight,
                             child: IconButton(
                                   onPressed: (){
                                     selectImage();
                                   },
                                   icon: const Icon(Icons.camera_alt_sharp)),
                             ),
                       )
                     ],
                  ),
                ),
                const SizedBox(height: 40,),
                TextFieldInput(
                  textEditingController:_usernameController,
                  hintext: "Enter your username",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 20,),
                TextFieldInput(
                  textEditingController:_emailController,
                  hintext: "Enter your email",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 20,),
                TextFieldInput(
                  textEditingController:_bioController,
                  hintext: "Enter your bio",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 20,),

                TextFieldInput(
                  textEditingController:_passwordController,
                  hintext: "Enter your password",
                  textInputType: TextInputType.text,
                  isPass: true,),
                const SizedBox(height: 20,),
                InkWell(
                  onTap:signUpUser,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 45,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: _isloading?const Center(child: CircularProgressIndicator(color: Colors.white,),):const Text("Sign Up"),
                  ),
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("You already have account ?"),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                        },
                        child: const Text(
                          "Sign in",
                           style: TextStyle(color: Colors.white,),
                        )
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

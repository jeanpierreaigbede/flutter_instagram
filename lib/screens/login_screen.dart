import 'package:flutter/material.dart';
import 'package:flutter_instagram/resources/auth_user.dart';
import 'package:flutter_instagram/screens/feed_screen.dart';
import 'package:flutter_instagram/screens/sigup_screen.dart';
import 'package:flutter_instagram/utils/appcolors.dart';
import 'package:flutter_instagram/widgets/textfield_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 2,),
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                height: 64,
                color: primaryColor,
              ),
              const SizedBox(height: 40,),
              TextFieldInput(textEditingController:_emailController,hintext: "Enter your email",textInputType: TextInputType.text,),
              const SizedBox(height: 20,),
              TextFieldInput(textEditingController:_passwordController,hintext: "Enter your password",textInputType: TextInputType.text,isPass: true,),
              const SizedBox(height: 20,),
              InkWell(
                onTap: loginUser,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: _isLoading?const CircularProgressIndicator(color: Colors.white,):const Text("Login in"),
                ),
              ),
              const SizedBox(height: 10,),
              Flexible(child:  Container(),flex: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("You don't have acount ?"),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                  },
                      child:const  Text(
                        "Sign Up",
                  style: TextStyle(color: Colors.white,),))
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  void loginUser()async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().LoginUser(
        email: _emailController.text,
        password: _passwordController.text);


    setState(() {
      _isLoading = false;
    });
    if(res != "success"){

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(res),
          )));
    }else{
      print(res);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const FeedScreen()));
    }
  }
}

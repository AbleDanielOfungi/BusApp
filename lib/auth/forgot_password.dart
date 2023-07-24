import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import '../component/my_button/my_button.dart';


class ForgotPasswordPage extends StatefulWidget {

  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();


}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController=TextEditingController();
  @override
  void dispoe(){
    emailController.dispose();
    //super.dispose();
  }



  Future passwordReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),

      );

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset link sent, check your Email'),
            );

          });

    } on FirebaseAuthException catch(e){
      //print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );

          });


    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        //elevation: 10,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text('Enter your Email we will send you a password reset link',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),),
          ),
          SizedBox(height: 20,),
          TextField(
          controller: emailController,
            obscureText: false,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 42,
                  vertical: 20
              ),
              enabledBorder: OutlineInputBorder(
                gapPadding: 10,
                borderRadius: BorderRadius.circular(20),
                borderSide:BorderSide(
                    color: Colors.black
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:BorderSide(
                    color: Colors.black
                ),
              ),
              labelText: 'Email',
              hintText: 'Enter Email',
              suffixIcon: Icon(Icons.mail_lock_outlined),
            ),
          ),
          SizedBox(height: 20,),

          MaterialButton(
            onPressed: passwordReset,
            child:Text('Reset Password',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            color: Colors.deepPurple,
            splashColor:Colors.yellow,


          ),

        ],
      ),
    );
  }

}



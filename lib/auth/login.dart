import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dashboard/accountant_dashboard/accountant.dart';
import '../dashboard/accountant_dashboard/acountant_booking_records.dart';
import '../dashboard/admin_dashboard/admin_screens/admin_dashbord_screen.dart';
import '../dashboard/other_dashboard/other.dart';
import '../dashboard/passenger_dashbord/passenger_dashbord.dart';
import 'forgot_password.dart';
import 'register.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(12),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                //color: Colors.black.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.grey.shade300
                                ),
                              ),
                              child: Center(
                                child: const Icon(Icons.directions_bus_filled_outlined,
                                size: 40,),
                              ),
                            ),


                            Text('Welcome Back',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Sign In with your email or password'),
                            Text('or continue with social media'),

                            SizedBox(
                              height: 80,
                            ),



                            Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 40,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: emailController,
                              //new decoration1 from mytextfield
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

                              validator: (value) {
                                if (value!.length == 0) {
                                  return "Email cannot be empty";
                                }
                                if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return ("Please enter a valid email");
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                emailController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText: _isObscure3,
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
                                labelText: 'Password',
                                hintText: 'Enter Password',
                                suffixIcon: IconButton(
                                    icon: Icon(_isObscure3
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure3 = !_isObscure3;
                                      });
                                    }),
                              ),

                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return "Password cannot be empty";
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("please enter valid password min. 6 character");
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                passwordController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),

                            SizedBox(
                              height: 5,
                            ),

                            //forgot password
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [


                                  GestureDetector(
                                      onTap:(){
                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                          return ForgotPasswordPage();

                                        }));
                                      },
                                      child: Text('Forgot Password?',style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ))),
                                ],
                              ),
                            ),


                            SizedBox(
                              height: 15,
                            ),


                            Container(
                              height: 60,
                              width: double.infinity,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                elevation: 5.0,
                                height: 40,
                                onPressed: () {
                                  setState(() {
                                    visible = true;
                                  });
                                  signIn(
                                      emailController.text, passwordController.text);
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: visible,
                                child: Container(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 4,
                                      backgroundColor: Colors.grey,
                                    ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Don't have an account? ,"),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return Register();
                                    }));
                                  },
                                  child: const Text("Register",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),),
                                ),
                              ],
                            )


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  //teacher==donor
  //student==recipient
  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Passenger") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>  PassengerDashboardScreen(),
            ),
          );
        }
        //new
        else if(documentSnapshot.get('role')=="Admin"){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>  AdminDashboardScreen(),
            ),
          );
        }
        else if(documentSnapshot.get('role')=="Acountant"){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>  Accountant(),
            ),
          );
        }
        // //new
        else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>  Other(),
            ),
          );

        }
      }

      else {
        print('Document does not exist on the database');
      }


    });
  }

  //not signing in
  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('No user found for that email.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );


        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Wrong password provided for that user.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }
}



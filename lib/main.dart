import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safety_app/services/authservice.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthService().handleAuth(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String phoneNo;
  String smsCode;
  String verificationId;

  bool codeSent= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Enter Phone No"),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter phone no",
                ),
                onChanged: (value) {
                  this.phoneNo = value;
                },
              ),
              codeSent ? TextField(
                decoration: InputDecoration(
                  hintText: "otp",
                ),
                onChanged: (value) {
                  this.smsCode = value;
                },
              ) : Container(),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  codeSent? AuthService().signInWithOTP(smsCode, verificationId) : verifyPhone(phoneNo);
                },
                child: codeSent ? Text("Login") : Text("Verify"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };
    
    final PhoneVerificationFailed verificationFailed = (AuthException exception) {
      print(exception.message);
      
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent=true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: phoneNo,
    timeout: const Duration(seconds: 5), 
    verificationCompleted: verified, 
    verificationFailed: verificationFailed, 
    codeSent: smsSent, 
    codeAutoRetrievalTimeout: autoTimeout);
  }
}

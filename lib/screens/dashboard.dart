import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safety_app/services/authservice.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:sms/sms.dart';
import './contacts.dart';
import '../models/contactModel.dart';
import '../services/storage.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var dbHelper = Storage();
  List<ContactModel> contacts;



  static const platform = const MethodChannel('sendSms');


  Future<Position> getCurrentLocation() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.contacts,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactList()),
              );
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Send SMS"),
                onPressed: () async {
                  Position position = await getCurrentLocation();
                  contacts = await dbHelper.getContacts();
                  print(contacts[0].number);
                  SmsSender sender = new SmsSender();
                  for(int i=0;i<contacts.length;i++){
                    print(i);
                    await sender.sendSms(new SmsMessage(contacts[i].number.trim(), 'Help Me '+'http://maps.google.com/?q='+position.latitude.toString()+','+position.longitude.toString()));
                  }
                  // contacts.map((contact) {
                  //   await sender.sendSms(new SmsMessage(contact.number.trim(), 'Help ME!!'));
                  // });
                  // String address = "+918460729886";
                  // sender.sendSms(new SmsMessage("+918460729886", 'Hello flutter!'));
                  // sendSms();
                  // _sendSMS(message, recipents);
                },
              ),
              RaisedButton(
                child: Text("SignOut"),
                onPressed: () {
                  AuthService().signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

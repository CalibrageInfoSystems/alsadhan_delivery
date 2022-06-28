import 'dart:async';
// import 'dart:html';
import 'package:alsadhan_delivery_agent/DeliveryBoy/DeliveryBoyScreen.dart';
import 'package:alsadhan_delivery_agent/Notification/allNotificationScreen.dart';
// import 'package:alsadhan_delivery_agent/models/message.dart';
import 'package:alsadhan_delivery_agent/services/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'localdb/LocalDb.dart';
import 'login/login.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
// import 'localization/app_translations_delegate.dart';

void main() => runApp(MyApp());
LocalData localData = new LocalData();
int roleID = 0;
int deliveryAgentId = 0;

ApiConnector apiConnector = new ApiConnector();


class MyApp extends StatefulWidget {
  
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
   

    

    localData.getIntToSF(LocalData.USER_ROLEID).then((onValue){

      roleID = onValue;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: Colors.blue[900],
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      //home:  roleID == 4 ? Directionality(textDirection: TextDirection.rtl,child: MyHomePage(title: 'Al- sadhan'))
                   //      : DeliveryBoyScreen(),
      home: Directionality(textDirection: TextDirection.rtl,child: MyHomePage(title: 'Al- sadhan')),
      
    );
  }
   void handleRouting(dynamic notification) {
    switch (notification['title']) {
      case 'first':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => NotificationScreen()));
        break;
      case 'second':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => NotificationScreen()));
        break;
    }
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
  
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState() {
    super.initState();

    localData.getIntToSF(LocalData.LOGINID).then((id) {
      setState(() {
        deliveryAgentId = id;
        print(" --- Login ID >>> " + deliveryAgentId.toString());
        
      });
    });

    splashMove();
  }

  splashMove() {
    return Timer(Duration(seconds: 3), navigatePage);
  }

  navigatePage() {

    if (deliveryAgentId == 0){
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => LoginScreen()));

    }
    else{
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => DeliveryBoyScreen(0)));

    }
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/Alsadhan_banner1.jpg"),
          fit: BoxFit.fill
        ) ,
      ),
    )
      // FittedBox(
      //     fit: BoxFit.fill,
      //         child: Image( height:1200,
      //           image: AssetImage("images/Alsadhan_banner1.jpg"),
      //         ),
      // )
    );
  }

  
}

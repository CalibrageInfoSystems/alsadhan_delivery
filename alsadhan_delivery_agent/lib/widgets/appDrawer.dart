
import 'package:alsadhan_delivery_agent/DeliveryBoy/DeliveryBoyScreen.dart';
import 'package:alsadhan_delivery_agent/localdb/LocalDb.dart';
import 'package:alsadhan_delivery_agent/login/login.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog progressDialog;

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  LocalData localData = new LocalData();

  bool islogin = false;
  String username = '';
  String mobilenumber = '';
  bool isArabic = false;
  @override
  void initState() {
    super.initState();
    localData.isarabic().then((iseng) {
      setState(() {
        print('************ is Arabic : ' + isArabic.toString());
        isArabic = iseng;
      });
    });
    localData.getBoolValuesSF(LocalData.ISLOGIN).then((islogindata) {
      setState(() {
        if (islogindata != null) {
          islogin = islogindata;
          if (islogin) {
            localData.getStringValueSF(LocalData.USER_NAME).then((name) {
              setState(() {
                
                username = name;
              });
            });
            localData
                .getStringValueSF(LocalData.USER_MOBILENUMBER)
                .then((mobile) {
              setState(() {
                mobilenumber = mobile;
              });
            });
          }
        } else {
          islogindata = false;
        }
      });
    });

    progressDialog =
        new ProgressDialog(context, type: ProgressDialogType.Normal);

    progressDialog.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.black54,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInCubic,
      progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Colors.white,
              Colors.grey[200],
              Colors.blue[200],
              Colors.blue[400],
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: () {

                },
                child: Container(
                    // margin: EdgeInsets.all(10),
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8),
                    //     border: Border.all(width: 2, color: Colors.blue[900])),
                    // padding: EdgeInsets.all(10),
                    // child: Row(
                    //   children: <Widget>[
                    //     // Expanded(
                    //     //   child: Text(
                    //     //     isArabic == true ? 'جميع الفئات' : 'ALL CATEGORIES',
                    //     //     style: TextStyle(color: Colors.blue[900]),
                    //     //   ),
                    //     // ),
                    //     Image(
                    //       height: 30,
                    //       image: AssetImage('images/right.png'),
                    //     )
                    //   ],
                    // )
                    ),
            
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.blue[900]),
                title: Text(
                  isArabic == true ? 'الرئيسية' : 'Home',
                  style: TextStyle(color: Colors.blue[900]),
                ),
                // onTap: () {            

                // },
                onTap: () {
                      Navigator.of(context).pushReplacement(
                     new MaterialPageRoute(
                                    builder: (context) => DeliveryBoyScreen(0)));
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      Colors.blue,
                      Colors.blue[500],
                      Colors.blue[700],
                      Colors.blue[900],
                    ],
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.white),
                  title: Text(
                    islogin == false
                        ? (isArabic == true ? 'تسجيل الدخول' : 'Login')
                        : (isArabic == true ? 'تسجيل خروج' : 'LogOut'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    if (islogin) {
                      localData.addIntToSF(LocalData.LOGINID,0);
                      localData.removeStringToSF(LocalData.CART_MODEL);
                      localData.addBoolToSF(LocalData.ISLOGIN, false);                      
                      // localData.clearLocalDta();                    
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    } 
                  },
                  // onTap: () {
                  //   Navigator.of(context)
                  //       .pushReplacementNamed(Constants.HOME_SCREEN);
                  // },
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

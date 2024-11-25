import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class Maru extends StatefulWidget {
  Maru({super.key});

  @override
  State<Maru> createState() => _MaruState();
}

class _MaruState extends State<Maru> {
  CustomThemes customThemes = CustomThemes();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  CustomThemes customs = CustomThemes();
  bool initialize = false;

  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies(){
    super.didChangeDependencies();

    // initialize
    if(!initialize){
      simulateRequest();
    }
  }

  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  void simulateRequest() async {
    print("3 seconds start now!");
    String? token = await _storage.read(key: 'token');
    if(token != null){
      // get the user credentials
      ApiConnection api = new ApiConnection();
      var response = await api.check_token(token);
      print(token);

      // check if it has a valid json structure
      bool isJson = isValidJson(response);
      if(isJson){
        LocalAuthentication auth = LocalAuthentication();
        bool proceed = await customs.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to Login!");
        if(proceed){
          // get the token if the response is valid
          var decode_res = jsonDecode(response);
          if(decode_res['success']){
            print(decode_res);
            // redirect to the other page
            if(decode_res['data']['user_type'] == "1"){
              // technician dashboard
              Navigator.pushReplacementNamed(context, "/technician_dashboard");
            }else if(decode_res['data']['user_type'] == "2"){
              // admin dashboard
              Navigator.pushReplacementNamed(context, "/admin_dashboard");
            }else if(decode_res['data']['user_type'] == "3"){
              // super admin dashboard
              Navigator.pushReplacementNamed(context, "/super_admin_dashboard");
            }else if(decode_res['data']['user_type'] == "4"){
              // member dashboard
              Navigator.pushReplacementNamed(context, "/member_dashboard");
            }else{
              Navigator.pushReplacementNamed(context, "/landing_page");
              customs.maruSnackBarDanger(
                  context: context,
                  text: "${decode_res['message']}"
              );
            }
          }else{
            Navigator.pushReplacementNamed(context, "/landing_page");
            customs.maruSnackBarDanger(
                context: context,
                text: "${decode_res['message']}"
            );
          }
        }else{
          customs.maruSnackBarDanger(context: context, text: "Authenticated failed!");
        }
      }else{
        Navigator.pushReplacementNamed(context, "/landing_page");
        customs.maruSnackBarDanger(
            context: context,
            text: response.toString()
        );
      }
    }else{
      Navigator.pushReplacementNamed(context, "/landing_page");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: customThemes.primaryColor,
        body: LayoutBuilder(builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: width * 0.3,
                          height: 20,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage("assets/images/koica-nobg.png"),
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.3,
                          height: (width * 0.3) - 10,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 0.0
                          ),
                          child: Image(
                            image: AssetImage("assets/images/maru-nobg.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          height: 50,
                          width: width * 0.3,
                          child: Image(
                            image: AssetImage("assets/images/uniworld-nobg.png"),
                            width: width * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    text: TextSpan(
                        text: "Maru",
                        style: customs.darkTextStyle(
                            size: 50, fontweight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: "\nDairy Co-op",
                            style: customs.darkTextStyle(
                                size: 25, fontweight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: "\nMobile App",
                            style: customs.darkTextStyle(
                                size: 25, fontweight: FontWeight.normal),
                          )
                        ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: height * 0.35,
                ),
                const SpinKitWave(
                  color: Colors.white,
                  size: 30.0,
                ),
              ],
            ),
          );
        }));
  }
}

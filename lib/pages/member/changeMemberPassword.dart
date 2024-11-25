import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class ChangeMemberPassword extends StatefulWidget {
  const ChangeMemberPassword({super.key});

  @override
  State<ChangeMemberPassword> createState() => _ChangeMemberPasswordState();
}

class _ChangeMemberPasswordState extends State<ChangeMemberPassword> {
  // customs
  CustomThemes customs = CustomThemes();
  TextEditingController username = new TextEditingController();
  TextEditingController password_1 = new TextEditingController();
  TextEditingController password_2 = new TextEditingController();
  FlutterSecureStorage _storage = FlutterSecureStorage();

  bool hidePass1 = true;
  bool hidePass2 = true;
  final _formKey = GlobalKey<FormState>();
  bool save_loader = false;

  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: customs.primaryShade,
      appBar: AppBar(
        backgroundColor: customs.whiteColor,
        elevation: 1,
        title: Builder(builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          return Container(
            width: screenWidth,
            child: Center(
              child: Container(
                width: 250,
                child: Row(
                  children: [
                    SizedBox(
                      height: 70,
                      child:
                      Image(image: AssetImage("assets/images/maru-nobg.png")),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Maru Dairy Co-op",
                      style: customs.primaryTextStyle(
                          size: 20, fontweight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
      body: SafeArea(child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          double calculatedWidth = width / 2 - 170;
          calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
          return Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(230, 245, 248, 1),
                  Color.fromRGBO(255, 255, 255, 1),
                  Color.fromRGBO(227, 228, 229, 1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: height - 5,
                  width: width,
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("Change Password", style: customs.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Username", style: customs.darkTextStyle(size: 14, fontweight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                customs.maruTextFormField(
                                  isChanged: (value){},
                                  floatingBehaviour: FloatingLabelBehavior.always,
                                  hintText: "Enter your username!",
                                  editingController: username,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter Username!";
                                    }
                                    return null;
                                  }
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("New Password!", style: customs.darkTextStyle(size: 14, fontweight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                customs.maruPassword(
                                  isChanged: (value){},
                                  passwordStatus: (){
                                    setState(() {
                                      hidePass1 = !hidePass1;
                                    });
                                  },
                                  floatingBehaviour: FloatingLabelBehavior.always,
                                  hintText: "Enter your new password!",
                                  editingController: password_1,
                                  hidePassword: hidePass1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter Password!";
                                    }
                                    return null;
                                  }
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Re-enter Password", style: customs.darkTextStyle(size: 14, fontweight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                customs.maruPassword(
                                  isChanged: (value){},
                                  hidePassword: hidePass2,
                                  passwordStatus: (){
                                    setState(() {
                                      hidePass2 = !hidePass2;
                                    });
                                  },
                                  floatingBehaviour: FloatingLabelBehavior.always,
                                  hintText: "Re-enter your password!",
                                  editingController: password_2,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter Password!";
                                    }
                                    return null;
                                  }
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width:width*0.5, child: Divider(color: customs.secondaryShade_2,height: 30,)),
                          Container(
                              padding: EdgeInsets.all(8.0),
                              width: width,
                              child: customs.maruButton(
                                  text: "Change Password",
                                  showLoader: save_loader,
                                  disabled: save_loader,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()){
                                      if(password_1.text == password_2.text){
                                        LocalAuthentication auth = LocalAuthentication();
                                        bool proceed = await customs.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to change your password!");
                                        if(proceed){
                                          //proceed and save the password
                                          ApiConnection apiConnection = new ApiConnection();
                                          String? token = await _storage.read(key: "token");
                                          setState(() {
                                            save_loader = true;
                                          });
                                          var res = await apiConnection.updatePassword(token!, username.text, password_1.text);
                                          if(isValidJson(res)){
                                            var response = jsonDecode(res);
                                            if(response['success']){
                                              customs.maruSnackBarSuccess(context: context, text: response['message']);
                                            }else{
                                              customs.maruSnackBarDanger(context: context, text: response['message']);
                                            }
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: "An error has occured!");
                                          }
                                          setState(() {
                                            save_loader = false;
                                          });
                                        }else{
                                          customs.maruSnackBarDanger(context: context, text: "Authenticated failed!");
                                        }
                                      }else{
                                        customs.maruSnackBarDanger(context: context, text: "Passwords don`t match!");
                                      }
                                    }
                                  },
                                  fontSize: 15
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      )),
    );
  }
}

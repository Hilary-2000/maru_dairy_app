import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  // themes
  CustomThemes customs = CustomThemes();
  String? selectedGender = "";
  String? selectedRegion = "";
  bool? isChecked = true;
  bool? hidePassword = true;
  bool? hidePassword_2 = true;
  List<DropdownMenuItem<String>> genderList = [
    const DropdownMenuItem(child: Text("Select Gender"), value: ""),
    const DropdownMenuItem(child: Text("Male"), value: "male"),
    const DropdownMenuItem(child: Text("Female"), value: "female"),
  ];


  List<DropdownMenuItem<String>> regions = [
    const DropdownMenuItem(child: Text("Select your region"), value: ""),
    const DropdownMenuItem(child: Text("Njebi"), value: "Njebi"),
    const DropdownMenuItem(child: Text("Munyu/Kiriti"), value: "Munyu/Kiriti"),
  ];

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController_2 = TextEditingController();
  bool disableLogin = false;
  final _formKey = GlobalKey<FormState>();

  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _national_id = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _region = TextEditingController();
  final TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.primaryShade,
      appBar: AppBar(
        backgroundColor: customs.whiteColor,
        elevation: 1,
        title: Builder(
          builder: (context) {
            double screenWidth = MediaQuery.of(context).size.width;
            double calculatedWidth = screenWidth/2 - 160;
            calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
            return Container(
              margin: EdgeInsets.fromLTRB(calculatedWidth, 0, 0, 0),
              child: Row(
                children: [
                  SizedBox(
                    height: 60,
                    child: Image(image: AssetImage("assets/images/maru-nobg.png")),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Maru Dairy Co-op", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                ],
              ),
            );
          }
        ),
      ),
      body: SafeArea(child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 15.0),
                        child: Text(
                          "Register",
                          textAlign: TextAlign.left,
                          style: customs.darkTextStyle(size: width * 0.05,
                        ),
                      )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 15.0),
                        child: Text(
                          "Fill all the required fields to proceed!",
                          style: customs.secondaryTextStyle(size: width * 0.03),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        // FULLNAME WIDGET
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.0),
                          child: customs.maruTextFormField(
                              label: "Fullname",
                              isChanged: (text) {
                                print("Value :  $text");
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your Fullname!";
                                }
                                return null;
                              },
                              editingController: _fullname,
                              hintText: "Example: John Doe"),
                        ),
                        // FULLNAME WIDGET
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.0),
                          child: customs.maruTextFormField(
                              label: "Phone Number",
                              textType: TextInputType.number,
                              isChanged: (text) {
                                print("Value :  $text");
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your phone!";
                                }
                                return null;
                              },
                              editingController: _phonenumber,
                              hintText: "Kenyan : 0743551250"),
                        ),
                        // FULLNAME WIDGET
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.0),
                          child: customs.maruTextFormField(
                            textType: TextInputType.emailAddress,
                              label: "Email",
                              isChanged: (text) {
                                print("Value :  $text");
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your Email!";
                                }
                                return null;
                              },
                              editingController: _email,
                              hintText: "abc@example.com"),
                        ),

                        // ID NUMBER WIDGET
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.0),
                          child: customs.maruTextFormField(
                              textType: TextInputType.number,
                              label: "Id Number",
                              isChanged: (text) {
                                print("Value :  $text");
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your national id!";
                                }
                                return null;
                              },
                              editingController: _national_id,
                              hintText: "Kenyan Id"),
                        ),

                        // GENDER WIDGET
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.0),
                          child: customs.maruDropdownButtonFormField(
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Select your gender";
                              }
                              return null;
                            },
                            defaultValue: selectedGender,
                            hintText: "Gender",
                            items: genderList,
                            onChange: (value){
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                        ),

                        // REGION WIDGET
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.0),
                          child: customs.maruDropdownButtonFormField(
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Select your region";
                              }
                              return null;
                            },
                            defaultValue: selectedRegion,
                            hintText: "Regions",
                            items: regions,
                            onChange: (value){
                              setState(() {
                                selectedRegion = value;
                              });
                            },

                          ),
                        ),

                        // USERNAME WIDGET
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.0),
                          child: customs.maruTextFormField(
                              textType: TextInputType.text,
                              label: "Username",
                              isChanged: (text) {
                                print("Value :  $text");
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your username!";
                                }
                                return null;
                              },
                              editingController: _username,
                              hintText: "Type your username"),
                        ),

                        // PASSWORD
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: SizedBox(
                            width: width,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15.0),
                                    child: customs.maruTextFormField(
                                        label: "Password",
                                        editingController: _passwordController,
                                        textType: TextInputType.text,
                                        hideText: hidePassword!,
                                        isChanged: (text) {
                                          print("Value :  $text");
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter Password!";
                                          }
                                          return null;
                                        },
                                        hintText: "Type your password"),
                                  ),
                                ),
                                TextButton(
                                  iconAlignment: IconAlignment.end,
                                  onPressed: () {
                                    setState(() {
                                      hidePassword =
                                          hidePassword == true ? false : true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.all<Color>(
                                            customs.darkColor),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            const Color.fromRGBO(0, 0, 0, 0)),
                                    padding:
                                        WidgetStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.symmetric(
                                                vertical: 17, horizontal: 1)),
                                    textStyle:
                                        WidgetStateProperty.all<TextStyle>(
                                      customs.primaryTextStyle(
                                          size: 10,
                                          fontweight: FontWeight.normal),
                                    ),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon( (hidePassword! ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash), size: 15,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // RE-ENTER PASSWORD
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: SizedBox(
                            width: width,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15.0),
                                    child: customs.maruTextFormField(
                                        label: "Re-enter Password",
                                        editingController: _passwordController_2,
                                        textType: TextInputType.text,
                                        hideText: hidePassword_2!,
                                        isChanged: (text) {
                                          print("Value :  $text");
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Re-enter Password!";
                                          }
                                          return null;
                                        },
                                        hintText: "Type your password"),
                                  ),
                                ),
                                TextButton(
                                  iconAlignment: IconAlignment.end,
                                  onPressed: () {
                                    setState(() {
                                      hidePassword_2 = hidePassword_2 == true ? false : true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                    WidgetStateProperty.all<Color>(
                                        customs.darkColor),
                                    backgroundColor:
                                    WidgetStateProperty.all<Color>(
                                        const Color.fromRGBO(0, 0, 0, 0)),
                                    padding:
                                    WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(
                                            vertical: 17, horizontal: 1)),
                                    textStyle:
                                    WidgetStateProperty.all<TextStyle>(
                                      customs.primaryTextStyle(
                                          size: 10,
                                          fontweight: FontWeight.normal),
                                    ),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon( (hidePassword_2! ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash), size: 15,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: customs.maruButton(
                                iconSize: 15,
                                type: Type.primary,
                                text: "Register",
                                showLoader: disableLogin,
                                disabled : disableLogin,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if(_passwordController.text == _passwordController_2.text){
                                      setState(() {
                                        disableLogin = true;
                                      });
                                      ApiConnection apiConnect = new ApiConnection();
                                      var response = await apiConnect.saveNewMember(_fullname.text, _phonenumber.text, _email.text, _national_id.text, selectedGender!, selectedRegion!, _username.text, _passwordController.text);
                                      setState(() {
                                        disableLogin = false;
                                      });
                                      if(isValidJson(response)){
                                        var data = jsonDecode(response);
                                        if(data['success']){
                                          //redirect to the login page
                                          Navigator.pushReplacementNamed(context, "/login", arguments: {
                                            "message": data['message'],
                                            "success": true
                                          });
                                        }else{
                                          customs.maruSnackBarDanger(context: context, text: data['message']);
                                        }
                                      }else{
                                        customs.maruSnackBarDanger(context: context, text: "A fatal error has occured try again later!");
                                      }
                                    }else{
                                      customs.maruSnackBarDanger(context: context, text: "Passwords don`t match!");
                                    }

                                  }
                                },
                                size: Sizes.md,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "You have an account?",
                            style: customs.darkTextStyle(
                                size: width * 0.035,
                                fontweight: FontWeight.normal),
                          ),
                          TextSpan(
                              text: " Log In",
                              style: customs.primaryTextStyle(
                                  size: width * 0.035,
                                  fontweight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(context, "/login");
                                })
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}

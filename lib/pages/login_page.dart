import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  CustomThemes customs = CustomThemes();
  List<DropdownMenuItem<String>> list = [
    const DropdownMenuItem(child: Text("99"), value: "99"),
    const DropdownMenuItem(child: Text("98"), value: "98"),
    const DropdownMenuItem(child: Text("97"), value: "97"),
    const DropdownMenuItem(child: Text("96"), value: "96"),
  ];
  bool? isChecked = true;
  bool? hidePassword = true;

  late final TextEditingController _passwordController = TextEditingController();
  late final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }
  bool disableLogin = false;

  @override
  Widget build(BuildContext context) {// Access the arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    bool showPass = false;
    String message = "";
    if(args != null){
      print(args);
      showPass = true;
      message = args['message'];
    }

    return Scaffold(
      backgroundColor: customs.primaryShade,
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
                  SizedBox(height: height*0.1,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      width: 150,
                      height: 140,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0.0),
                      child: Image(
                        image: AssetImage("assets/images/maru-nobg.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 15.0),
                        child: Text(
                          "Login",
                          textAlign: TextAlign.left,
                          style: customs.darkTextStyle(size: width * 0.07),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 15.0),
                      child: Text(
                        "Welcome back! Please provide your details.",
                        style: customs.secondaryTextStyle(size: width * 0.03),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  if(showPass)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 15.0),
                        child: Text(
                          "${message}.",
                          style: customs.successTextStyle(size: width * 0.03),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),

                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15.0),
                          child: customs.maruTextFormField(
                              label: "Username",
                              isChanged: (text) {
                                print("Value :  $text");
                              },
                              editingController: _usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Username!";
                                }
                                return null;
                              },
                              hintText: "Type your username"),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15.0),
                          child: customs.maruPassword(
                            passwordStatus: (){
                              setState(() {
                                hidePassword = !hidePassword!;
                              });
                            },
                            hintText: "Type your password",
                            hidePassword: hidePassword,
                            editingController: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Password!";
                              }
                              return null;
                            },
                            isChanged: (text) {
                              print("Value :  $text");
                            }
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(0.0),
                                  margin: EdgeInsets.all(0.0),
                                  child: Checkbox(
                                      activeColor: customs.primaryColor,
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value;
                                        });
                                      }),
                                ),
                                Text(
                                  "Remember me",
                                  style: customs.secondaryTextStyle(
                                      size: width * 0.035),
                                ),
                                const Spacer(),
                                RichText(
                                    textAlign: TextAlign.right,
                                    text: TextSpan(
                                        text: "Forgot password?",
                                        style: customs.primaryTextStyle(
                                            underline: true,
                                            size: width * 0.035,
                                            fontweight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushReplacementNamed(context, "/forgot_password");
                                          })),
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
                                text: "Log In",
                                showLoader: disableLogin,
                                disabled : disableLogin,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {

                                    // store the username and password
                                    setState(() {
                                      disableLogin = true;
                                    });
                                    String username = _usernameController.value.text;
                                    String password = _passwordController.value.text;

                                    await _storage.write(key: "username", value: username);
                                    await _storage.write(key: "password", value: password);

                                    // get the user credentials
                                    ApiConnection api = new ApiConnection();
                                    var response = await api.processLogin(username, password);
                                    print(response);
                                    setState(() {
                                      disableLogin = false;
                                    });

                                    // check if it has a valid json structure
                                    bool isJson = isValidJson(response);
                                    if(isJson){
                                      // get the token if the response is valid
                                      var decode_res = jsonDecode(response);
                                      if(decode_res['success']){
                                        customs.maruSnackBarSuccess(
                                            context: context,
                                            text: "${decode_res['message']}"
                                        );

                                        // store the token
                                        await _storage.write(key: "token", value: decode_res['token']);
                                        print(decode_res['user_type']);

                                        // redirect to the other page
                                        if(decode_res['user_type'] == "1"){
                                          // technician dashboard
                                          Navigator.pushReplacementNamed(context, "/technician_dashboard");
                                        }else if(decode_res['user_type'] == "2"){
                                          // admin dashboard
                                          Navigator.pushReplacementNamed(context, "/admin_dashboard");
                                        }else if(decode_res['user_type'] == "3"){
                                          // super admin dashboard
                                          Navigator.pushReplacementNamed(context, "/super_admin_dashboard");
                                        }else if(decode_res['user_type'] == "4"){
                                          // member dashboard
                                          Navigator.pushReplacementNamed(context, "/member_dashboard");
                                        }
                                      }else{
                                        customs.maruSnackBarDanger(
                                            context: context,
                                            text: "${decode_res['message']}"
                                        );
                                      }
                                      print(decode_res);
                                    }else{
                                      customs.maruSnackBarDanger(
                                          context: context,
                                          text: "Fatal error occured!"
                                      );
                                    }
                                  }
                                },
                                size: Sizes.md,
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Don`t have an account?",
                            style: customs.darkTextStyle(
                                size: width * 0.035,
                                fontweight: FontWeight.normal),
                          ),
                          TextSpan(
                              text: " Sign Up",
                              style: customs.primaryTextStyle(
                                  size: width * 0.035,
                                  underline: true,
                                  fontweight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(context, "/sign_up");
                                })
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height > 710 ? height-710 : 0,
                  ),
                  Container(
                    width: width,
                    padding: EdgeInsets.only(right: 30),
                    child: Row(
                      children: [
                        Container(
                          width: width * 0.3,
                          height: 25,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage("assets/images/koica-nobg.png"),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 50,
                          child: Image(
                            image: AssetImage("assets/images/uniworld-nobg.png"),
                            width: width * 0.4,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
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

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';


class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  CustomThemes customs = CustomThemes();
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  bool loadData = false;
  bool initialize = false;

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if(!initialize){
      await customs.initialize();
      setState(() {
        initialize = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.whiteColor,
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
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: customs.whiteColor
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
                            "Forgot Password",
                            textAlign: TextAlign.left,
                            style: customs.darkTextStyle(size: width * 0.05,
                            ),
                          )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 15.0),
                          child: Text(
                            "Provide your username to reset your password!",
                            style: customs.secondaryTextStyle(size: width * 0.03),
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
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
                              label: "Provide your Username",
                              isChanged: (text) {
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your Username!";
                                }
                                return null;
                              },
                              editingController: username,
                              hintText: "Provide Username"),
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
                                type: Type.primary,
                                text: "Reset Password",
                                disabled: loadData,
                                showLoader: loadData,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // set state
                                    setState(() {
                                      loadData = true;
                                    });
                                    // go ahead and reset the password!
                                    ApiConnection apiConnection = ApiConnection();
                                    var response = await apiConnection.resetPassword(username: username.text);
                                    if(customs.isValidJson(response)){
                                      var res = jsonDecode(response);
                                      if(res['success']){
                                        customs.maruSnackBarSuccess(context: context, text: res['message']);
                                      }else{
                                        customs.maruSnackBarDanger(context: context, text: res['message']);
                                      }
                                    }else{
                                      customs.maruSnackBarDanger(context: context, text: "An error has occured!");
                                    }

                                    // set state
                                    setState(() {
                                      loadData = false;
                                    });
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
                    padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "You remember your password?",
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

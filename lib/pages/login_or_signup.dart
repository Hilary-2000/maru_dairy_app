import 'package:flutter/material.dart';
import 'package:maru/packages/maru_theme.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {

  CustomThemes customThemes = CustomThemes();
  bool init = false;

  void didChangeDependencies(){
    super.didChangeDependencies();

    if(!init){
      customThemes.initialize();
      setState(() {
        init = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: customThemes.primaryShade,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          return Container(
            decoration: BoxDecoration(
              color: customThemes.whiteColor
            ),
            height: height,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: height * 0.15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: width * 0.3,
                          height: 40,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage("assets/images/koica-nobg.png"),
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.25,
                          height: (width * 0.25) - 10,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 0.0),
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
                  const SizedBox(
                    height: 80.0,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Welcome to The ",
                            style: customThemes.darkTextStyle(size: 25.0, fontweight: FontWeight.bold)
                          ),
                          TextSpan(
                              text: "Maru",
                              style: customThemes.darkTextStyle(size: 25.0, fontweight: FontWeight.bold)
                          ),
                          TextSpan(
                            text: " Dairy Farmers App",
                              style: customThemes.darkTextStyle(size: 25.0, fontweight: FontWeight.bold)
                          )
                        ],
                      )
                  ),
                  const SizedBox(height: 20.0,),
                  Center(
                    child: Text(
                        "Register to the Maru Dairy Farmers App or provide your credentials to Login!",
                      textAlign: TextAlign.center,
                      style: customThemes.secondaryTextStyle(size: 15.0, fontweight:  FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  Row(
                    children: [
                      Expanded(child: customThemes.maruButton(
                        text: "Create an account",
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, "/sign_up");
                        },
                        fontSize: 20.0)),
                    ],
                  ),
                  const SizedBox(height: 15.0,),
                  Row(
                    children: [
                      Expanded(
                        child: customThemes.marOutlineuButton(
                          text: "Login",
                          onPressed: (){
                            Navigator.pushReplacementNamed(context, "/login");
                          },
                          fontSize: 20.0
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:maru/packages/maru_theme.dart';

class ChangeMemberPassword extends StatefulWidget {
  const ChangeMemberPassword({super.key});

  @override
  State<ChangeMemberPassword> createState() => _ChangeMemberPasswordState();
}

class _ChangeMemberPasswordState extends State<ChangeMemberPassword> {
  // customs
  CustomThemes customs = CustomThemes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.primaryShade,
      appBar: AppBar(
        backgroundColor: customs.whiteColor,
        elevation: 1,
        title: Builder(builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double calculatedWidth = screenWidth / 2 - 210;
          calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
          return Container(
            margin: EdgeInsets.fromLTRB(calculatedWidth, 0, 0, 0),
            child: Row(
              children: [
                SizedBox(
                  height: 45,
                  child: Image(image: AssetImage("assets/images/maru-nobg.png")),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Maru Dairy Co-op", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
              ],
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
                              customs.maruTextField(
                                isChanged: (value){},
                                floatingBehaviour: FloatingLabelBehavior.always,
                                hintText: "Enter your username!",
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
                              customs.maruTextField(
                                isChanged: (value){},
                                floatingBehaviour: FloatingLabelBehavior.always,
                                hintText: "Enter your new password!",
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
                              customs.maruTextField(
                                isChanged: (value){},
                                floatingBehaviour: FloatingLabelBehavior.always,
                                hintText: "Re-enter your password!",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width:width*0.5, child: Divider(color: customs.secondaryShade_2,height: 30,)),
                        Container(padding: EdgeInsets.all(8.0),width: width, child: customs.maruIconButton(icons: Icons.save, text: "Change Password", onPressed: (){},fontSize: 14)),
                      ],
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

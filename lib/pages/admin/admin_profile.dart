import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  // CUSTOM THEME
  CustomThemes customs = CustomThemes();
  var admin_data = null;
  bool _init = false;

  // change to camel case
  String toCamelCase(String text) {
    // Step 1: Split the string by spaces or underscores
    List<String> words = text.split(RegExp(r'[\s_]+'));

    // Step 2: Capitalize the first letter of each word and lowercase the rest
    List<String> capitalizedWords = words.map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    // Step 3: Join the capitalized words with spaces
    return capitalizedWords.join(' ');
  }

  void didChangeDependencies(){
    // change dependencies
    super.didChangeDependencies();

    if(!_init){
      // get member details
      getAdminDetails();

      // set state
      setState(() {
        _init = true;
      });
    }
  }


  Future<void> getAdminDetails() async {
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.viewAdminProfile();
    if(customs.isValidJson(response)){
      print(response);
      var res = jsonDecode(response);
      if(res['success']){
        // set state
        setState(() {
          admin_data = res['administrator'];
        });
      }else{
        Navigator.pop(context);
        customs.maruSnackBarDanger(context: context, text: "An error has occured!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Stack(children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  width: width,
                                  height: 200,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: width * 0.9,
                                        height: 100,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8)),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromRGBO(1, 176, 241, 1),
                                                Color.fromRGBO(255, 193, 7, 1),
                                                Color.fromRGBO(20, 72, 156, 1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )),
                                      ),
                                      Container(
                                        width: width * 0.9,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8)),
                                          color: customs.whiteColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.2), // Shadow color with opacity
                                              spreadRadius: 1, // Spread radius
                                              blurRadius: 5, // Blur radius
                                              offset: const Offset(0,1), // Offset in the x and y direction
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 45,
                                            ),
                                            Text(
                                              toCamelCase(admin_data != null ? admin_data['fullname'] ?? "N/A" : "N/A"),
                                              style: customs.darkTextStyle(
                                                  size: 20,
                                                  fontweight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top:
                                  65, // Adjust this value to move the CircleAvatar up
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: CircleAvatar(
                                        radius: width * 0.1,
                                        child: ClipOval(
                                          child: Image.asset(
                                            "assets/images/hilla.jpg",
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        )),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: width * 0.7,
                          child: Divider(
                            color: customs.secondaryShade_2,
                          ),
                        ),
                        Container(
                          width: width * 0.9,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phone Number:",
                                style: customs.darkTextStyle(
                                    size: 12, fontweight: FontWeight.bold),
                              ),
                              Text(
                                admin_data != null ? admin_data['phone_number'] ?? "N/A" : "N/A",
                                style: customs.secondaryTextStyle(size: 16),
                              ),
                              Divider(
                                color: customs.secondaryShade_2,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: width * 0.9,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email:",
                                style: customs.darkTextStyle(
                                    size: 12, fontweight: FontWeight.bold),
                              ),
                              Text(
                                admin_data != null ? admin_data['email'] ?? "N/A" : "N/A",
                                style: customs.secondaryTextStyle(size: 16),
                              ),
                              Divider(
                                color: customs.secondaryShade_2,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: width * 0.9,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Location:",
                                style: customs.darkTextStyle(
                                    size: 12, fontweight: FontWeight.bold),
                              ),
                              Text(
                                toCamelCase(admin_data != null ? admin_data['residence'] ?? "N/A" : "N/A"),
                                style: customs.secondaryTextStyle(size: 16),
                              ),
                              Divider(
                                color: customs.secondaryShade_2,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: width * 0.9,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Region:",
                                style: customs.darkTextStyle(
                                    size: 12, fontweight: FontWeight.bold),
                              ),
                              Text(
                                toCamelCase(admin_data != null ? admin_data['region'] ?? "N/A" : "N/A"),
                                style: customs.secondaryTextStyle(size: 16),
                              ),
                              Divider(
                                color: customs.secondaryShade_2,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: width * 0.9,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Username:",
                                style: customs.darkTextStyle(
                                    size: 12, fontweight: FontWeight.bold),
                              ),
                              Text(
                                admin_data != null ? admin_data['username'] ?? "N/A" : "N/A",
                                style: customs.secondaryTextStyle(size: 16),
                              ),
                              Divider(
                                color: customs.secondaryShade_2,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: width * 0.9,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "National Id:",
                                style: customs.darkTextStyle(
                                    size: 12, fontweight: FontWeight.bold),
                              ),
                              Text(
                                admin_data != null ? admin_data['national_id'] ?? "N/A" : "N/A",
                                style: customs.secondaryTextStyle(size: 16),
                              ),
                            ],
                          ),
                        ),
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

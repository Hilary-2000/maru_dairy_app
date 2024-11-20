import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TechnicianProfile extends StatefulWidget {
  const TechnicianProfile({super.key});

  @override
  State<TechnicianProfile> createState() => _TechnicianProfileState();
}

class _TechnicianProfileState extends State<TechnicianProfile> {
  CustomThemes customs = CustomThemes();
  bool loading = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String name = "N/A";
  String phone_number = "N/A";
  String email = "N/A";
  String residence = "N/A";
  String region = "N/A";
  String username = "N/A";
  String national_id = "N/A";
  String collection_days = "0";
  String litresCollected = "0";
  String profile = "";

  void initState() {
    // TODO: implement initState
    super.initState();

    // load technician details
    loadTechnicianDetails();
  }

  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

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
  // fetch technician profile
  Future<void> loadTechnicianDetails() async {
    setState((){
      loading = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    String? token = await _storage.read(key: 'token');
    var response = await apiConnection.getTechnicianDetails(token!);
    print(response);
    if(isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        //get the success message
        setState(() {
          name = res['technician_data']['fullname'].toString();
          phone_number = res['technician_data']['phone_number'].toString();
          email = res['technician_data']['email'].toString();
          residence = res['technician_data']['residence'].toString();
          username = res['technician_data']['username'].toString();
          national_id = res['technician_data']['national_id'].toString();
          collection_days = res['technician_data']['collection_days'].toString();
          litresCollected = res['technician_data']['collection_amount'].toString();
          region = res['technician_data']['region'].toString();
          profile = res['technician_data']['profile_photo'].toString();
        });
      }else{

      }
    }
    setState((){
      loading = false;
    });
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
            child: Skeletonizer(
              enabled: loading,
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
                                    height: 250,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: width * 0.9,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8)),
                                            color: customs.secondaryColor
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.9,
                                          height: 150,
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
                                                offset: const Offset(0,
                                                    1), // Offset in the x and y direction
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 45,
                                              ),
                                              Text(
                                                "$name",
                                                style: customs.darkTextStyle(
                                                    size: 20,
                                                    fontweight: FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "$collection_days",
                                                        style:
                                                        customs.darkTextStyle(
                                                            size: 15,
                                                            fontweight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Text(
                                                        "Collection Days",
                                                        style: customs
                                                            .secondaryTextStyle(
                                                            size: 10,
                                                            fontweight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "$litresCollected",
                                                        style:
                                                        customs.darkTextStyle(
                                                            size: 15,
                                                            fontweight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Text(
                                                        "Litres Collected",
                                                        style: customs
                                                            .secondaryTextStyle(
                                                            size: 10,
                                                            fontweight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
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
                                          radius: 44,
                                          child: ClipOval(
                                            child: (profile.isNotEmpty) ?
                                            Image.network(
                                              "${customs.apiURLDomain}$profile",
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    color: customs.primaryColor,
                                                    backgroundColor: customs.secondaryShade_2,
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset(
                                                  "assets/images/placeholderImg.jpg",
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                );
                                              },
                                            )
                                                :
                                            Image.asset(
                                              // profile.length > 0 ? profile : "assets/images/placeholderImg.jpg",
                                              "assets/images/placeholderImg.jpg",
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
                                  "$phone_number",
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
                                  "$email",
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
                                  "Residence:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                Text(
                                  "$residence",
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
                                  "$region",
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
                                  "$username",
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
                                  "$national_id",
                                  style: customs.secondaryTextStyle(size: 16),
                                ),
                                Divider(
                                  color: customs.secondaryShade_2,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      )),
      floatingActionButton: CircleAvatar(
        backgroundColor: customs.secondaryShade_2,
        radius: 25,
        child: IconButton(
          onPressed: (){
            Navigator.pushNamed(context, "/edit_technician_profile");
          },
          icon: Icon(FontAwesomeIcons.penFancy, size: 15, color: customs.secondaryColor,),
        ),
      ),
    );
  }
}

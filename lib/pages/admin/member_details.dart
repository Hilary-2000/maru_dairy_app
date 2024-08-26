import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MemberDetails extends StatefulWidget {
  const MemberDetails({super.key});

  @override
  State<MemberDetails> createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  CustomThemes customs = CustomThemes();
  Map<String, dynamic>? args;
  List<Color> bg_color = [];
  int index = 0;
  var memberData = null;
  String collection_days = "0";
  String collected_amount = "0";
  bool loading = false;

  Future<void> getMemberData() async {
    setState(() {
      loading = true;
    });
    // get the arguments
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if(customs.isValidJson(jsonEncode(args))){
      var arguments = jsonDecode(jsonEncode(args));
      setState(() {
        index = arguments['index'];
      });
      ApiConnection apiConnection = new ApiConnection();
      var response = await apiConnection.adminMemberDetails(arguments['member_id'].toString());
      if(customs.isValidJson(response)){
        var res = jsonDecode(response);
        if(res['success']){
          setState(() {
            memberData = res['member_details'];
            collection_days = res['collection_days'];
            collected_amount = res['total_collection'];
          });
        }else{
          setState(() {
            memberData = null;
            collection_days = "0";
            collected_amount = "0";
          });

          customs.maruSnackBarDanger(context: context, text: res['message']);
        }
      }else{
        customs.maruSnackBarDanger(context: context, text: "An error occured!");
      }
    }else{
      Navigator.pop(context);
    }

    // set state
    setState(() {
      loading = false;
    });
  }

  void didChangeDependencies(){
    super.didChangeDependencies();
    setState(() {
      bg_color = [customs.primaryColor, customs.secondaryColor, customs.warningColor, customs.darkColor, customs.successColor];
    });

    //GET MEMBER DATA
    getMemberData();
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
                Skeletonizer(
                  enabled: loading,
                  child: Container(
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
                                                  topRight: Radius.circular(8)
                                              ),
                                              color: bg_color[index % bg_color.length]
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
                                                memberData != null ? customs.toCamelCase(memberData['fullname'] ?? "N/A") : "N/A",
                                                style: customs.darkTextStyle(
                                                    size: 20,
                                                    fontweight: FontWeight.bold),
                                              ),
                                              Text(
                                                memberData != null ? memberData['membership'] ?? "N/A" : "N/A",
                                                style: customs.secondaryTextStyle(
                                                    size: 12,
                                                    fontweight: FontWeight.normal),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        collection_days,
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
                                                        collected_amount,
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
                                                  Column(
                                                    children: [
                                                      Text(
                                                        (memberData != null ? customs.toCamelCase((memberData['animals'] ?? "0").toString()) : "0"),
                                                        style:
                                                        customs.darkTextStyle(
                                                            size: 15,
                                                            fontweight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Text(
                                                        "Animal",
                                                        style: customs
                                                            .secondaryTextStyle(
                                                            size: 10,
                                                            fontweight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  )
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
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                customs.maruIconButton(
                                    icons: Icons.history,
                                    text: "Collection History",
                                    onPressed: (){
                                      Navigator.pushNamed(context, "/admin_member_history", arguments: {"member_id": (memberData != null ? memberData['user_id'] ?? "-0" : "-0"), "member_data": memberData});

                                    },
                                    fontSize: 14
                                ),
                                SizedBox(width: 20,),
                                customs.maruIconButton(
                                    icons: Icons.history,
                                    text: "Membership",
                                    onPressed: (){
                                      Navigator.pushNamed(context, "/member_membership", arguments: {"member_id": (memberData != null ? memberData['user_id'] ?? "-0" : "-0"), "member_data": memberData});
                                    },
                                    type: Type.secondary,
                                    fontSize: 14)
                              ],
                            ),
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
                                      size: 12, fontweight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  memberData != null ? customs.toCamelCase(memberData['phone_number'] ?? "N/A") : "N/A",
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
                                  memberData != null ? customs.toCamelCase(memberData['email'] ?? "N/A") : "N/A",
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
                                  memberData != null ? customs.toCamelCase(memberData['residence'] ?? "N/A") : "N/A",
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
                                  memberData != null ? customs.toCamelCase(memberData['region'] ?? "N/A") : "N/A",
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
                                  memberData != null ? customs.toCamelCase(memberData['username'] ?? "N/A") : "N/A",
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
                                  memberData != null ? customs.toCamelCase(memberData['national_id'] ?? "N/A") : "N/A",
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
                                  "Membership Number:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                Text(
                                  memberData != null ? customs.toCamelCase(memberData['membership'] ?? "N/A") : "N/A",
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
                  ),
                )
              ],
            ),
          );
        },
      )),
      floatingActionButton: CircleAvatar(
        backgroundColor: customs.primaryShade_2,
        child: IconButton(
          icon: Icon(Icons.edit, color: customs.primaryColor,),
          onPressed: () {
            Navigator.pushNamed(context, "/admin_edit_member_details", arguments: {"index": index, "member_id": (memberData != null ? (memberData['user_id'] ?? "0") : "0")});
          },
        ),
      ),
    );
  }
}

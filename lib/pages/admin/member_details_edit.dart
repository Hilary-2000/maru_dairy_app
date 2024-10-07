import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class MemberDetailsEdit extends StatefulWidget {
  const MemberDetailsEdit({super.key});

  @override
  State<MemberDetailsEdit> createState() => _MemberDetailsEditState();
}

class _MemberDetailsEditState extends State<MemberDetailsEdit> {
  CustomThemes customs = CustomThemes();
  List<Color> bg_color = [];
  bool loading = false;
  bool save_loader = false;
  Map<String, dynamic>? args;
  var memberData = null;
  int index = 0;
  String collection_days = "0";
  String collected_amount = "0";
  final _formKey = GlobalKey<FormState>();
  bool loading_regions = false;
  var region_data = [];

  // editing controller
  TextEditingController phone_controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController membershipController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController animalController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  var regionDV = "";
  bool _init = false;
  // List<DropdownMenuItem<String>> regions = [
  //   const DropdownMenuItem(child: Text("Select your region"), value: ""),
  //   const DropdownMenuItem(child: Text("Njebi"), value: "Njebi"),
  //   const DropdownMenuItem(child: Text("Njembi"), value: "Njembi"),
  //   const DropdownMenuItem(child: Text("Munyu/Kiriti"), value: "Munyu/Kiriti"),
  // ];
  List<DropdownMenuItem<String>> regions = [];

  var genderDV = "";
  List<DropdownMenuItem<String>> genderList = [
    const DropdownMenuItem(child: Text("Select Gender"), value: ""),
    const DropdownMenuItem(child: Text("Male"), value: "male"),
    const DropdownMenuItem(child: Text("Female"), value: "female"),
  ];

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    setState(() {
      bg_color = [
        customs.primaryColor,
        customs.secondaryColor,
        customs.warningColor,
        customs.darkColor,
        customs.successColor
      ];
    });

    if(!_init){
      setState(() {
        _init = true;
      });

      await getRegions();

      //GET MEMBER DATA
      getMemberData();
    }
  }

  Future<void> getRegions() async {
    setState(() {
      loading_regions = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getActiveRegions();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        // regions
        setState(() {
          region_data = res['regions'];
          regions = (res['regions'] as List).map((region){
            return DropdownMenuItem(child: Text("${region['region_name']}"), value: "${region['region_id']}");
          }).toList();
        });
      }else{
        region_data = [];
        customs.maruSnackBarDanger(context: context, text: res['message']);
      }
    }

    // set state
    setState(() {
      loading_regions = false;
    });
  }

  Future<void> getMemberData() async {
    setState(() {
      loading = true;
    });
    // get the arguments
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (customs.isValidJson(jsonEncode(args))) {
      var arguments = jsonDecode(jsonEncode(args));
      setState(() {
        index = arguments['index'];
      });
      ApiConnection apiConnection = new ApiConnection();
      var response = await apiConnection.adminMemberDetails(arguments['member_id'].toString());
      if (customs.isValidJson(response)) {
        var res = jsonDecode(response);
        if (res['success']) {
          setState(() {
            memberData = res['member_details'];
            collection_days = res['collection_days'];
            collected_amount = res['total_collection'];

            fullnameController.text = (res['member_details']['fullname'] ?? "").toString();
            emailController.text = (res['member_details']['email'] ?? "").toString();
            phone_controller.text = (res['member_details']['phone_number'] ?? "").toString();
            locationController.text = (res['member_details']['residence'] ?? "").toString();
            idController.text = (res['member_details']['national_id'] ?? "").toString();
            animalController.text = (res['member_details']['animals'] ?? "").toString();
            membershipController.text = (res['member_details']['membership'] ?? "").toString();

            // check if the region value is present or not
            String region_detail = res['member_details']['region'] ?? "";
            bool present = false;
            for(int index = 0; index < region_data.length; index++){
              if("${region_data[index]['region_id']}" == "$region_detail"){
                present = true;
                break;
              }
            }
            if(!present){
              regionDV = "";
            }else{
              regionDV = region_detail;
            }
            print(region_data);

            // gender dv
            genderDV = res['member_details']['gender'] ?? "";
            // regionDV = res['member_details']['region'] ?? "";
          });
        } else {
          setState(() {
            memberData = null;
            collection_days = "0";
            collected_amount = "0";

            fullnameController.text = "";
            emailController.text = "";
            phone_controller.text = "";
            locationController.text = "";
            idController.text = "";
            animalController.text = "";
            membershipController.text = "";

            // gender dv
            genderDV = res['gender'];
            regionDV = res['region'];
          });

          customs.maruSnackBarDanger(context: context, text: res['message']);
        }
      } else {
        customs.maruSnackBarDanger(context: context, text: "An error occured!");
      }
    } else {
      Navigator.pop(context);
    }

    // set state
    setState(() {
      loading = false;
    });
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
          double calculatedWidth = width / 2 - 170;
          calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
          return loading_regions || loading ?
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitCircle(
                  size: 50,
                  color: customs.primaryColor,
                ),
                Text("Loading member details...", style: customs.primaryTextStyle(size: 14))
              ],
            ),
          )    
              : 
          Container(
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
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  width: width,
                                  height: 250,
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
                                              customs.toCamelCase(memberData != null ? memberData['fullname'] ?? "N/A" : "N/A"),
                                              style: customs.darkTextStyle(
                                                  size: 20,
                                                  fontweight: FontWeight.bold),
                                            ),
                                            Text(
                                              "REG2022-002",
                                              style: customs.secondaryTextStyle(
                                                  size: 12,
                                                  fontweight:
                                                      FontWeight.normal),
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
                                                      "$collected_amount",
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
                                                      customs.toCamelCase(
                                                          memberData != null
                                                              ? (memberData[
                                                                      'animals'] ??
                                                                  "0").toString()
                                                              : "0"),
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
                                      radius: 44,
                                      child: ClipOval(
                                        child: (memberData != null) ?
                                        Image.network(
                                          "${customs.apiURLDomain}${memberData['profile_photo']}",
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
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
                                      )
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: (width * 0.5) + 15,
                                  top: 125,
                                  child: CircleAvatar(
                                    radius: 15,
                                    child: IconButton(
                                      icon: const Icon(
                                        FontAwesomeIcons.penFancy,
                                        size: 10,
                                      ),
                                      onPressed: () {
                                      },
                                      color: customs.secondaryColor,
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: width * 0.7,
                          child: Divider(
                            color: customs.secondaryShade_2,
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(children: [
                            Container(
                              width: width * 0.9,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Fullname:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                      isChanged: (value) {},
                                      floatingBehaviour:
                                      FloatingLabelBehavior.always,
                                      hintText: "e.g, John Doe",
                                      editingController: fullnameController,
                                      validator:(value) {
                                        if(value == null || value.isEmpty){
                                          return "Enter member name";
                                        }
                                        return null;
                                      }
                                  ),
                                  Divider(
                                    color: customs.secondaryShade_2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.9,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Membership Number:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                      isChanged: (value) {},
                                      textType: TextInputType.text,
                                      floatingBehaviour:
                                      FloatingLabelBehavior.always,
                                      hintText: "e,g: REG2020-001",
                                      editingController: membershipController,
                                      validator: (value) {
                                        if(value == null || value.isEmpty){
                                          return "Enter member animal number";
                                        }
                                        return null;
                                      }),
                                  Divider(
                                    color: customs.secondaryShade_2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.9,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone Number:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                      textType: TextInputType.number,
                                      isChanged: (value) {},
                                      floatingBehaviour:
                                      FloatingLabelBehavior.always,
                                      hintText: "e.g, 0712345678",
                                      editingController: phone_controller,
                                      validator: (value) {
                                        if(value == null || value.isEmpty){
                                          return "Enter member phone number";
                                        }
                                        return null;
                                      }
                                  ),
                                  Divider(
                                    color: customs.secondaryShade_2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.9,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gender:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruDropdownButtonFormField(
                                    defaultValue: genderDV,
                                    onChange: (value) {
                                      setState(() {
                                        genderDV = value!;
                                      });
                                    },
                                    items: genderList,
                                    validator: (value) {
                                    if(value == null || value.isEmpty){
                                        return "Select member gender";
                                      }
                                      return null;
                                    }
                                  ),
                                  Divider(
                                    color: customs.secondaryShade_2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.9,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                      isChanged: (value) {},
                                      textType: TextInputType.emailAddress,
                                      floatingBehaviour:
                                          FloatingLabelBehavior.always,
                                      hintText: "e.g me@mail.com",
                                      editingController: emailController,
                                      validator: (value) {
                                        if(value == null || value.isEmpty){
                                          return "Select member email";
                                        }
                                        return null;
                                      }
                                  ),
                                  Divider(
                                    color: customs.secondaryShade_2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.9,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Location:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                    isChanged: (value) {},
                                    textType: TextInputType.text,
                                    floatingBehaviour:
                                        FloatingLabelBehavior.always,
                                    hintText: "Thika, Kiambu County",
                                    editingController: locationController,
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return "Enter member location";
                                      }
                                      return null;
                                    }
                                  ),
                                  Divider(
                                    color: customs.secondaryShade_2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.9,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Region:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruDropdownButtonFormField(
                                      defaultValue: regionDV,
                                      onChange: (value) {
                                        setState(() {
                                          regionDV = value!;
                                        });
                                      },
                                      items: regions,
                                      validator: (value) {
                                        if(value == null || value.isEmpty){
                                          return "Select member region";
                                        }
                                        return null;
                                      }),
                                  Divider(
                                    color: customs.secondaryShade_2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.9,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "National Id:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                      isChanged: (value) {},
                                      textType: TextInputType.text,
                                      floatingBehaviour:
                                          FloatingLabelBehavior.always,
                                      hintText: "e,g: 11223322",
                                      editingController: idController,
                                      validator: (value) {
                                        if(value == null || value.isEmpty){
                                          return "Enter member National Id number";
                                        }
                                        return null;
                                      }),
                                  Divider(
                                    color: customs.secondaryShade_2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.9,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Animal Count:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                      isChanged: (value) {},
                                      textType: TextInputType.number,
                                      floatingBehaviour:
                                          FloatingLabelBehavior.always,
                                      hintText: "e,g: 30",
                                      editingController: animalController,
                                      validator: (value) {
                                        if(value == null || value.isEmpty){
                                          return "Enter member animal number";
                                        }
                                        return null;
                                      }),
                                  Divider(
                                    color: customs.secondaryShade_2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                                width: width * 0.9,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                child: customs.maruButton(
                                    text: "Save",
                                    showLoader: save_loader,
                                    disabled: save_loader,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()){
                                        setState(() {
                                          save_loader = true;
                                        });
                                        ApiConnection apiCon = ApiConnection();
                                        var datapass = {
                                          "user_id": memberData['user_id'],
                                          "fullname": fullnameController.text,
                                          "phone_number": phone_controller.text,
                                          "email": emailController.text,
                                          "residence": locationController.text,
                                          "region": regionDV,
                                          "national_id": idController.text,
                                          "animals": animalController.text,
                                          "membership": membershipController.text,
                                          "gender": genderDV
                                        };
                                        print(datapass);
                                        var response = await apiCon.adminUpdateMember(datapass);
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

                                        setState(() {
                                          save_loader = false;
                                        });
                                      }
                                    }))
                          ]),
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditTechnicianProfile extends StatefulWidget {
  const EditTechnicianProfile({super.key});

  @override
  State<EditTechnicianProfile> createState() => _EditTechnicianProfileState();
}

class _EditTechnicianProfileState extends State<EditTechnicianProfile> {
  CustomThemes customs = CustomThemes();
  bool loading = false;
  FlutterSecureStorage _storage = FlutterSecureStorage();

  String name = "N/A";
  String phone_number = "N/A";
  String email = "N/A";
  String residence = "N/A";
  String region = "";
  String username = "N/A";
  String national_id = "N/A";
  String collection_days = "0";
  String litresCollected = "0";
  String profile = "";
  bool saveLoader = false;
  String gender = "male";

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController areaResidence = TextEditingController();
  TextEditingController nationalId = TextEditingController();

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

  String nameAbbr(String name){
    String abbr = "";
    List<String> words = name.split(' ');
    int length = words.length >=2 ? 2 : words.length;
    for(int index = 0; index < length; index++){
      abbr += words[index].substring(0,1);
    }
    return abbr;
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


          phoneNumber.text = phone_number;
          emailAddress.text = email;
          areaResidence.text = residence;
          nationalId.text = national_id;
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
    List<DropdownMenuItem<String>> regions = [
      const DropdownMenuItem(child: Text("Select your region"), value: ""),
      const DropdownMenuItem(child: Text("Njembi"), value: "Njembi"),
      const DropdownMenuItem(child: Text("Njebi"), value: "Njebi"),
      const DropdownMenuItem(child: Text("Munyu/Kiriti"), value: "Munyu/Kiriti"),
    ];

    List<DropdownMenuItem<String>> genderList = [
      const DropdownMenuItem(child: Text("Select Gender"), value: ""),
      const DropdownMenuItem(child: Text("Male"), value: "male"),
      const DropdownMenuItem(child: Text("Female"), value: "female"),
    ];

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
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                              color: customs.primaryColor),
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
                                          radius: width * 0.1,
                                          child: ClipOval(
                                            child: Image.asset(
                                              // profile.length > 0 ? profile : "assets/images/placeholderImg.jpg",
                                              "assets/images/placeholderImg.jpg",
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Positioned(
                                    left: (width * 0.5) + 15,
                                    top: 125,
                                    child: Skeleton.ignore(
                                      child: CircleAvatar(
                                        radius: 15,
                                        child: IconButton(
                                          icon: const Icon(
                                            FontAwesomeIcons.penFancy,
                                            size: 10,
                                          ),
                                          onPressed: () {},
                                          color: customs.secondaryColor,
                                        ),
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
                          Container(
                            width: width * 0.9,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number:",
                                  style: customs.darkTextStyle(
                                    size: 12,
                                    fontweight: FontWeight.bold,
                                  ),
                                ),
                                customs.maruTextField(
                                  isChanged: (value) {},
                                  floatingBehaviour: FloatingLabelBehavior.always,
                                  hintText: "Phone Number",
                                  editingController: phoneNumber
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
                                    defaultValue: gender,
                                    onChange: (value) {
                                      setState(() {
                                        gender = value!;
                                      });
                                    },
                                    items: genderList
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
                                customs.maruTextField(
                                    isChanged: (value) {},
                                    textType: TextInputType.emailAddress,
                                    floatingBehaviour:
                                        FloatingLabelBehavior.always,
                                    hintText: "Email Address",
                                  editingController: emailAddress
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
                                  "Residence:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                customs.maruTextField(
                                    isChanged: (value) {},
                                    textType: TextInputType.text,
                                    floatingBehaviour:
                                        FloatingLabelBehavior.always,
                                    hintText: "Thika, Kiambu County",
                                  editingController: areaResidence
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
                                  defaultValue: region,
                                  onChange: (value) {
                                    setState(() {
                                      region = value!;
                                    });
                                  },
                                  items: regions,
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
                                  "National Id:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                customs.maruTextField(
                                    isChanged: (value) {},
                                    textType: TextInputType.text,
                                    floatingBehaviour:
                                        FloatingLabelBehavior.always,
                                    hintText: "E,g: 11223322",
                                  editingController: nationalId
                                ),
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
                              disabled: saveLoader,
                              showLoader: saveLoader,
                              text: "Update",
                              onPressed: () async {
                                setState(() {
                                  saveLoader = true;
                                });
                                ApiConnection apiConnection = new ApiConnection();
                                String? token = await _storage.read(key: 'token');
                                var response = await apiConnection.updateTechnician(token!, name, gender, phone_number, email, residence, region, username, national_id);
                                setState(() {
                                  saveLoader = false;
                                });
                                if(isValidJson(response)){
                                  var res = jsonDecode(response);
                                  if(res["success"]){
                                    customs.maruSnackBarSuccess(context: context, text: res['message']);
                                  }else{
                                    customs.maruSnackBarDanger(context: context, text: res["message"]);
                                  }
                                }else{
                                  customs.maruSnackBarDanger(context: context, text: "Fatal error has occured!");
                                }
                              }
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

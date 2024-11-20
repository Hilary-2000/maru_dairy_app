import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditTechnician extends StatefulWidget {
  const EditTechnician({super.key});

  @override
  State<EditTechnician> createState() => _EditTechnicianState();
}

class _EditTechnicianState extends State<EditTechnician> {
  CustomThemes customs = CustomThemes();
  List<Color> bg_color = [];
  bool loading = false;
  bool save_loader = false;
  Map<String, dynamic>? args;
  var technicianData = null;
  int index = 0;
  final _formKey = GlobalKey<FormState>();
  bool loading_regions = false;

  // editing controller
  TextEditingController phone_controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  var regionDV = "";
  bool _init = false;

  List<DropdownMenuItem<String>> regions = [];

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
        if(res['regions'].length > 0){
          setState(() {
            regions = (res['regions'] as List).map((region){
              return DropdownMenuItem(child: Text("${region['region_name']}"), value: "${region['region_id']}");
            }).toList();
          });
        }else{
          setState(() {
            regions = [const DropdownMenuItem(child: Text("Select your region"), value: "")];
          });
        }
      }else{
        customs.maruSnackBarDanger(context: context, text: res['message']);
      }
    }

    // set state
    setState(() {
      loading_regions = false;
    });
  }
  var genderDV = "";
  List<DropdownMenuItem<String>> genderList = [
    const DropdownMenuItem(child: Text("Select Gender"), value: ""),
    const DropdownMenuItem(child: Text("Male"), value: "male"),
    const DropdownMenuItem(child: Text("Female"), value: "female"),
  ];

  var status = "1";
  List<DropdownMenuItem<String>> statusList = [
    const DropdownMenuItem(child: Text("Select Status"), value: ""),
      const DropdownMenuItem(child: Text("Active"), value: "1"),
    const DropdownMenuItem(child: Text("In-Active"), value: "0"),
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

      //GET MEMBER DATA
      await getRegions();
      getMemberData();
    }
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

      var response = await apiConnection.technicianDetails(arguments['technician_id'].toString());
      if (customs.isValidJson(response)) {
        var res = jsonDecode(response);
        if (res['success']) {
          setState(() {
            technicianData = res['technician_data'];

            fullnameController.text = (res['technician_data']['fullname'] ?? "").toString();
            emailController.text = (res['technician_data']['email'] ?? "").toString();
            phone_controller.text = (res['technician_data']['phone_number'] ?? "").toString();
            locationController.text = (res['technician_data']['residence'] ?? "").toString();
            idController.text = (res['technician_data']['national_id'] ?? "").toString();

            // gender dv
            genderDV = res['technician_data']['gender'] ?? "";
            regionDV = res['technician_data']['region'] ?? "";
            status = "${res['technician_data']['status'] ?? ""}";
          });
        } else {
          setState(() {
            technicianData = null;

            fullnameController.text = "";
            emailController.text = "";
            phone_controller.text = "";
            locationController.text = "";
            idController.text = "";

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
                                                customs.toCamelCase(technicianData != null ? technicianData['fullname'] ?? "N/A" : "N/A"),
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
                                          child: (technicianData != null) ?
                                          Image.network(
                                            "${customs.apiURLDomain}$technicianData['profile_photo']",
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
                                        icon: Icon(
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
                                        onChange: (value) {},
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
                                child: loading_regions ?
                                Column(
                                  children: [
                                    SpinKitCircle(
                                      color: customs.primaryColor,
                                      size: 25,
                                    ),
                                    Text(
                                      "Please wait loading regions...",
                                      style: customs.primaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                    )
                                  ],
                                )
                                    :
                                Column(
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
                                            return "Select region";
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
                                      "Status:",
                                      style: customs.darkTextStyle(
                                          size: 12, fontweight: FontWeight.bold),
                                    ),
                                    customs.maruDropdownButtonFormField(
                                        defaultValue: status,
                                        onChange: (value) {
                                          setState(() {
                                            status = value!;
                                          });
                                        },
                                        items: statusList,
                                        validator: (value) {
                                          if(value == null || value.isEmpty){
                                            return "Select member status";
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
                                            "user_id": technicianData['user_id'],
                                            "fullname": fullnameController.text,
                                            "phone_number": phone_controller.text,
                                            "email": emailController.text,
                                            "residence": locationController.text,
                                            "region": regionDV,
                                            "national_id": idController.text,
                                            "gender": genderDV,
                                            "status": status
                                          };

                                          // update technician details
                                          var response = await apiCon.updateTechnicianDetails(datapass);
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
                                      }
                                      )
                              )
                            ]),
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

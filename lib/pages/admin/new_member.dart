import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class NewMember extends StatefulWidget {
  const NewMember({super.key});

  @override
  State<NewMember> createState() => _NewMemberState();
}

class _NewMemberState extends State<NewMember> {
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

  // region DV
  var regionDV = "";
  List<DropdownMenuItem<String>> regions = [
    const DropdownMenuItem(child: Text("Select your region"), value: ""),
    const DropdownMenuItem(child: Text("Njebi"), value: "Njebi"),
    const DropdownMenuItem(child: Text("Njembi"), value: "Njembi"),
    const DropdownMenuItem(child: Text("Munyu/Kiriti"), value: "Munyu/Kiriti"),
  ];

  var genderDV = "";
  List<DropdownMenuItem<String>> genderList = [
    const DropdownMenuItem(child: Text("Select Gender"), value: ""),
    const DropdownMenuItem(child: Text("Male"), value: "male"),
    const DropdownMenuItem(child: Text("Female"), value: "female"),
  ];

  // editing controller
  TextEditingController phone_controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController membershipController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController animalController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    setState(() {
      save_loader = false;
    });
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
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        Center(
                          child: Text("Register New Member", style: customs.darkTextStyle(size: 18, fontweight: FontWeight.bold),),
                        ),
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
                                      return "Enter member number";
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
                                      "fullname": fullnameController.text,
                                      "phone_number": phone_controller.text,
                                      "email": emailController.text,
                                      "residence": locationController.text,
                                      "region": regionDV,
                                      "national_id": idController.text,
                                      "animals": animalController.text,
                                      "membership": membershipController.text,
                                      "gender": genderDV,
                                    };
                                    var response = await apiCon.adminAddMember(datapass);
                                    if(customs.isValidJson(response)){
                                      var res = jsonDecode(response);
                                      print(res);
                                      if(res['success']){
                                        customs.maruSnackBarSuccess(context: context, text: res['message']);
                                        setState(() {
                                          fullnameController.text = "";
                                          phone_controller.text = "";
                                          emailController.text = "";
                                          locationController.text = "";
                                          regionDV = "";
                                          idController.text = "";
                                          animalController.text = "";
                                          membershipController.text = "";
                                          genderDV = "";
                                        });
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

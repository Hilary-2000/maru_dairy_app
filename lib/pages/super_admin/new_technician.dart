import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewTechnician extends StatefulWidget {
  const NewTechnician({super.key});

  @override
  State<NewTechnician> createState() => _NewTechnicianState();
}

class _NewTechnicianState extends State<NewTechnician> {
  CustomThemes customs = CustomThemes();
  List<Color> bg_color = [];
  bool loading = false;
  bool save_loader = false;
  Map<String, dynamic>? args;
  var technicianData = null;
  bool hidePassword = true;
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  int index = 0;
  final _formKey = GlobalKey<FormState>();

  // editing controller
  TextEditingController phone_controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  var regionDV = "";
  bool _init = false;
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

  var status = "1";
  List<DropdownMenuItem<String>> statusList = [
    const DropdownMenuItem(child: Text("Select Status"), value: ""),
    const DropdownMenuItem(child: Text("Active"), value: "1"),
    const DropdownMenuItem(child: Text("In-Active"), value: "0"),
  ];

  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_init){
      setState(() {
        _init = true;
        bg_color = [
          customs.primaryColor,
          customs.secondaryColor,
          customs.warningColor,
          customs.darkColor,
          customs.successColor
        ];
      });
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
          save_loader = false;
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
                          Container(
                            width: width,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("New Technician", style: customs.secondaryTextStyle(size: 18, fontweight: FontWeight.bold),),
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
                                        hintText: "e.g me@mail.com (Optional)",
                                        editingController: emailController,
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
                                        hintText: "Thika, Kiambu County (Optional)",
                                        editingController: locationController
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
                                      "Username:",
                                      style: customs.darkTextStyle(
                                          size: 12, fontweight: FontWeight.bold),
                                    ),
                                    customs.maruTextFormField(
                                        isChanged: (value) {},
                                        textType: TextInputType.text,
                                        floatingBehaviour:
                                        FloatingLabelBehavior.always,
                                        hintText: "e,g: username",
                                        editingController: usernameController,
                                        validator: (value) {
                                          if(value == null || value.isEmpty){
                                            return "Define the technician username!";
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
                                      "Password:",
                                      style: customs.darkTextStyle(
                                          size: 12, fontweight: FontWeight.bold),
                                    ),
                                    customs.maruPassword(
                                        passwordStatus: (){
                                          setState(() {
                                            hidePassword = !hidePassword!;
                                          });
                                        },
                                        hintText: "e.g ******",
                                        hidePassword: hidePassword,
                                        editingController: _passwordController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter Password!";
                                          }
                                          return null;
                                        },
                                        isChanged: (text) {
                                          print("Value :  $text");
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
                                      "Status:",
                                      style: customs.darkTextStyle(
                                          size: 12, fontweight: FontWeight.bold
                                      ),
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
                                      text: "Register",
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
                                            "gender": genderDV,
                                            "status": status,
                                            "username":usernameController.text,
                                            "password":_passwordController.text
                                          };

                                          // update technician details
                                          var response = await apiCon.registerTechnician(datapass);
                                          if(customs.isValidJson(response)){
                                            var res = jsonDecode(response);
                                            if(res['success']){
                                              customs.maruSnackBarSuccess(context: context, text: res['message']);
                                              setState(() {
                                                fullnameController.text = "";
                                                phone_controller.text = "";
                                                emailController.text = "";
                                                locationController.text = "";
                                                regionDV = "";
                                                idController.text = "";
                                                genderDV = "";
                                                status = "";
                                                usernameController.text = "";
                                                _passwordController.text = "";
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

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/maru_theme.dart';

class EditTechnicianProfile extends StatefulWidget {
  const EditTechnicianProfile({super.key});

  @override
  State<EditTechnicianProfile> createState() => _EditTechnicianProfileState();
}

class _EditTechnicianProfileState extends State<EditTechnicianProfile> {
  @override
  Widget build(BuildContext context) {
    CustomThemes customs = CustomThemes();
    const FlutterSecureStorage _storage = FlutterSecureStorage();

    List<DropdownMenuItem<String>> regions = [
      const DropdownMenuItem(child: Text("Select your region"), value: ""),
      const DropdownMenuItem(child: Text("Njebi"), value: "Njebi"),
      const DropdownMenuItem(
          child: Text("Munyu/Kiriti"), value: "Munyu/Kiriti"),
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
                                              "Hillary Ngige",
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
                                                      "213",
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
                                                      "2,576",
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
                                            "assets/images/hilla.jpg",
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
                                    size: 12, fontweight: FontWeight.bold),
                              ),
                              customs.maruTextField(
                                  isChanged: (value) {},
                                  floatingBehaviour:
                                      FloatingLabelBehavior.always,
                                  hintText: "Phone Number"),
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
                                  defaultValue: "",
                                  onChange: (value) {},
                                  items: genderList),
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
                                  hintText: "Email Address"),
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
                                  hintText: "Thika, Kiambu County"),
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
                                  defaultValue: "",
                                  onChange: (value) {},
                                  items: regions),
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
                                  hintText: "E,g: 11223322"),
                              Divider(
                                color: customs.secondaryShade_2,
                              )
                            ],
                          ),
                        ),
                        Container(
                            width: width * 0.9,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                            child: customs.maruIconButton(
                                icons: Icons.save,
                                text: "Save",
                                onPressed: () {
                                  print("Save user profile!");
                                })),
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

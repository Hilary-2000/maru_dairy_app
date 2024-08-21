import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maru/packages/maru_theme.dart';

class SelectMemberMessage extends StatefulWidget {
  const SelectMemberMessage({super.key});

  @override
  State<SelectMemberMessage> createState() => _SelectMemberMessageState();
}

class _SelectMemberMessageState extends State<SelectMemberMessage> {
  CustomThemes customs = CustomThemes();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.whiteColor,
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
            color: customs.secondaryShade_2.withOpacity(0.2),
            child: Column(
              children: [
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text("Select a Member to send a message.", style: customs.secondaryTextStyle(size: 15, fontweight: FontWeight.bold),),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.7,
                        child: customs.maruSearchTextField(
                            isChanged: (value) {},
                            hintText: "Start typing to search!"),
                      ),
                      IconButton(onPressed: (){
                        customs.maruSnackBar(context: context, text: "That`s the filter, it will be ready when the app is in production");
                      }, icon: Icon(Icons.filter_list)),
                      IconButton(onPressed: (){Navigator.pushNamed(context, "/admin_qr_code_finder");}, icon: Icon(Icons.qr_code, size: 30,))
                    ],
                  ),
                ),
                Container(
                  width: width * 0.5,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Divider(
                    color: customs.secondaryShade_2,
                  ),
                ),
                Container(
                  width: width * 0.95,
                  padding: const EdgeInsets.all(8),
                  height: height - 115,
                  decoration: BoxDecoration(
                      color: customs.whiteColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, "/admin_inquiry_inbox");
                          },
                          child: Container(
                            margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: customs.secondaryShade_2.withOpacity(0.2),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundColor: customs.primaryShade,
                                  child: Text(
                                    "PM",
                                    style: customs.primaryTextStyle(
                                        size: 18, fontweight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  "Patrick Mugoh",
                                  style: customs.darkTextStyle(size: 14),
                                ),
                                subtitle: Text(
                                  "REG2024-003",
                                  style: customs.secondaryTextStyle(size: 12),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Njebi",
                                        style: customs.darkTextStyle(size: 12)),
                                    Text(
                                      "0713620727",
                                      style: customs.secondaryTextStyle(
                                          size: 12,
                                          fontweight: FontWeight.normal),
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          color: customs.secondaryShade,
                                          borderRadius:BorderRadius.circular(5)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.5,
                          child: Divider(
                            color: customs.secondaryShade_2.withOpacity(0.2),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, "/admin_inquiry_inbox");
                          },
                          child: Container(
                            margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: customs.secondaryShade_2.withOpacity(0.2),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundColor: customs.successShade_2,
                                  child: Text(
                                    "JM",
                                    style: customs.successTextStyle(
                                        size: 18, fontweight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  "Jackline Murume",
                                  style: customs.darkTextStyle(size: 14),
                                ),
                                subtitle: Text(
                                  "REG2024-004",
                                  style: customs.secondaryTextStyle(size: 12),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Munyu/Kiriti",
                                        style: customs.darkTextStyle(size: 12)),
                                    Text(
                                      "0713622727",
                                      style: customs.secondaryTextStyle(
                                          size: 12,
                                          fontweight: FontWeight.normal),
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          color: customs.successColor,
                                          borderRadius:BorderRadius.circular(5)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.5,
                          child: Divider(
                            color: customs.secondaryShade_2.withOpacity(0.2),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, "/admin_inquiry_inbox");
                          },
                          child: Container(
                            margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: customs.secondaryShade_2.withOpacity(0.2),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundColor: customs.warningShade_2,
                                  child: Text(
                                    "GM",
                                    style: customs.warningTextStyle(
                                        size: 18, fontweight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  "Gloria Muwanguzi",
                                  style: customs.darkTextStyle(size: 14),
                                ),
                                subtitle: Text(
                                  "REG2024-006",
                                  style: customs.secondaryTextStyle(size: 12),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Njebi",
                                        style: customs.darkTextStyle(size: 12)),
                                    Text(
                                      "0713620727",
                                      style: customs.secondaryTextStyle(
                                          size: 12,
                                          fontweight: FontWeight.normal),
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          color: customs.secondaryShade,
                                          borderRadius:BorderRadius.circular(5)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.5,
                          child: Divider(
                            color: customs.secondaryShade_2.withOpacity(0.2),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, "/admin_inquiry_inbox");
                          },
                          child: Container(
                            margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: customs.secondaryShade_2.withOpacity(0.2),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundColor: customs.secondaryShade_2,
                                  child: Text(
                                    "PQ",
                                    style: customs.secondaryTextStyle(
                                        size: 18, fontweight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  "Patrick Quacco",
                                  style: customs.darkTextStyle(size: 14),
                                ),
                                subtitle: Text(
                                  "REG2024-003",
                                  style: customs.secondaryTextStyle(size: 12),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Kiriti",
                                        style: customs.darkTextStyle(size: 12)),
                                    Text(
                                      "0713620727",
                                      style: customs.secondaryTextStyle(
                                          size: 12,
                                          fontweight: FontWeight.normal),
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          color: customs.successColor,
                                          borderRadius:BorderRadius.circular(5)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.5,
                          child: Divider(
                            color: customs.secondaryShade_2.withOpacity(0.2),
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

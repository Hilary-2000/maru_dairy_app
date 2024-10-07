import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maru/packages/maru_theme.dart';

class AdminInquiries extends StatefulWidget {
  const AdminInquiries({super.key});

  @override
  State<AdminInquiries> createState() => _AdminInquiriesState();
}

class _AdminInquiriesState extends State<AdminInquiries> {
  CustomThemes customs = CustomThemes();
  bool hide = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        double calculatedWidth = width / 2 - 170;
        calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
        return Container(
          height: height,
          width: width,
          color: customs.secondaryShade_2.withOpacity(0.2),
          child: !hide ?
          Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.7,
                      child: Text("Inquiries", style: customs.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
                    ),
                    CircleAvatar(backgroundColor: customs.secondaryShade_2, child: IconButton(onPressed: (){}, icon: Icon(Icons.search), color: customs.secondaryColor,)),
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
                height: height - 90,
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
                                "Hello Admin I was asking how long does it take for my mem...",
                                style: customs.secondaryTextStyle(size: 12),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("5 mins",
                                      style: customs.secondaryTextStyle(size: 10)),
                                  SizedBox(height: 5,),
                                  Icon(Icons.check, size: 15, color: customs.secondaryColor,),
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
                                "How long will it take to create the account for my collegue who...",
                                style: customs.secondaryTextStyle(size: 12),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("25 mins",
                                      style: customs.secondaryTextStyle(size: 10)),
                                  SizedBox(height: 5,),
                                  Icon(Icons.checklist_outlined, size: 15, color: customs.secondaryColor,)
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
                                "Thanks for the response!",
                                style: customs.secondaryTextStyle(size: 12),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("10:10 AM",
                                      style: customs.secondaryTextStyle(size: 10)),
                                  SizedBox(height: 5,),
                                  // Icon(Icons.checklist_outlined, size: 15, color: customs.secondaryColor,)
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
                                  Text("Sep 23",
                                      style: customs.secondaryTextStyle(size: 10)),
                                  SizedBox(height: 5,),
                                  Icon(Icons.checklist_outlined, size: 15, color: customs.successColor,)
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
          )
              :
          Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.7,
                      child: Text("Inquiries", style: customs.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
                    ),
                    CircleAvatar(backgroundColor: customs.secondaryShade_2, child: IconButton(onPressed: (){}, icon: Icon(Icons.search), color: customs.secondaryColor,)),
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
                child: Text("No inquiries present at the moment", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.normal),),
              )
            ],
          ),
        );
      },
    ));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class MemberSettings extends StatefulWidget {
  final void Function() getNotifications;
  const MemberSettings({super.key, this.getNotifications = _defualtFunction});
  static void _defualtFunction(){}

  @override
  State<MemberSettings> createState() => _MemberSettingsState();
}

class _MemberSettingsState extends State<MemberSettings> {
  CustomThemes customs = CustomThemes();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isLightMode = true;

  String total_collection = "0";
  String growth = "0%";
  String trajectory = "constant";
  String duration = "N/A";
  String greetings = "Hello,";
  bool loading = false;
  var member_data = null;
  bool _init = false;

  // did change dependencies
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_init){
      widget.getNotifications();
      setState(() {
        _init = true;
      });
      // member dashboard
      memberDashboard("7 days");
    }
  }
  // get the member dashboard
  Future<void> memberDashboard(String period) async {
    setState(() {
      loading = true;
    });
    //get the member dashboard
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getMemberDetails();
    if (customs.isValidJson(response)) {
      var res = jsonDecode(response);
      if (res['success']) {
        member_data = res['member_details'];
      } else {
        member_data = null;
      }
    } else {
      member_data = null;
    }
    setState(() {
      loading = false;
    });
  }
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
          decoration: BoxDecoration(
            color: customs.secondaryShade_2.withOpacity(0.2),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Text("Account", style: customs.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Profile", style: customs.darkTextStyle(size: 12, fontweight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: customs.whiteColor
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.primaryShade_2,
                                child: Icon(
                                  FontAwesomeIcons.user,
                                  size: 20,
                                  color: customs.primaryColor,
                                ),
                              ),
                              title: Text("View Profile", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("View your information", style: customs.secondaryTextStyle(size: 12),),
                              splashColor: customs.dangerColor,
                              onTap: (){
                                Navigator.pushNamed(context, "/member_view_profile");
                              },
                              tileColor: customs.secondaryShade_2,
                            ),
                            Container(width: width * 0.8,child: Divider(color: customs.secondaryShade_2,)),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.primaryShade_2,
                                child: Icon(
                                  FontAwesomeIcons.userPen,
                                  size: 20,
                                  color: customs.primaryColor,
                                ),
                              ),
                              title: Text("Edit Profile", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("Update your information", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                Navigator.pushNamed(context, "/member_edit_profile");
                              },
                              tileColor: customs.secondaryShade_2,
                            ),
                            Container(width: width * 0.8, child: Divider(color: customs.secondaryShade_2,)),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.primaryShade_2,
                                child: Icon(
                                  FontAwesomeIcons.key,
                                  size: 20,
                                  color: customs.primaryColor,
                                ),
                              ),
                              title: Text("Change Password", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("Change your login password", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                Navigator.pushNamed(context, "/change_member_password");
                              },
                              tileColor: customs.secondaryShade_2,
                            ),
                            Container(width: width * 0.8, child: Divider(color: customs.secondaryShade_2,)),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.primaryShade_2,
                                child: Icon(
                                  FontAwesomeIcons.idCard,
                                  size: 20,
                                  color: customs.primaryColor,
                                ),
                              ),
                              title: Text("View Membership", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("View your membership status", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                Navigator.pushNamed(context, "/member_membership",
                                arguments: {"member_id" : member_data['user_id']});
                              },
                              tileColor: customs.secondaryShade_2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Report", style: customs.darkTextStyle(size: 12, fontweight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: customs.whiteColor
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.primaryShade_2,
                                child: Icon(
                                  FontAwesomeIcons.filePdf,
                                  size: 20,
                                  color: customs.primaryColor,
                                ),
                              ),
                              title: Text("Generate Reports", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("Download your milk collection statement", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                Navigator.pushNamed(context, "/member_reports");
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Settings", style: customs.darkTextStyle(size: 12, fontweight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: customs.whiteColor
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.primaryShade_2,
                                child: Icon(
                                  FontAwesomeIcons.sun,
                                  size: 20,
                                  color: customs.primaryColor,
                                ),
                              ),
                              title: Text("Light Mode", style: customs.darkTextStyle(size: 14),),
                              onTap: (){
                              },
                              trailing: Switch(
                                value: _isLightMode,
                                activeTrackColor: customs.primaryColor,
                                inactiveThumbColor: customs.primaryColor,
                                trackOutlineColor: WidgetStateProperty.all<Color>(customs.primaryColor),
                                onChanged: (bool value) {
                                  setState(() {
                                    _isLightMode = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                        child: customs.marOutlineuButton(
                            text: "Log-out",
                            type: Type.danger,
                            onPressed: () async {
                              ApiConnection apiConn = new ApiConnection();
                              await apiConn.logout();
                              _storage.delete(key: "username");
                              _storage.delete(key: "password");
                              _storage.delete(key: "token");
                              Navigator.pushReplacementNamed(
                                  context, "/landing_page");
                            },
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}

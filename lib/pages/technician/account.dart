import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/maru_theme.dart';

class TechnicianAccount extends StatefulWidget {
  const TechnicianAccount({super.key});

  @override
  State<TechnicianAccount> createState() => _TechnicianAccountState();
}

class _TechnicianAccountState extends State<TechnicianAccount> {
  CustomThemes customs = CustomThemes();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isLightMode = true;
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
                                Navigator.pushNamed(context, "/technician_profile");
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
                                Navigator.pushNamed(context, "/edit_technician_profile");
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
                                print("Tapped");
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
                                print("Tapped");
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
                            onPressed: () {
                              _storage.delete(key: "username");
                              _storage.delete(key: "password");
                              Navigator.pushReplacementNamed(
                                  context, "/landing_page");
                            },
                            fontWeight: FontWeight.bold,
                            fontSize: 15
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
    ));
  }
}

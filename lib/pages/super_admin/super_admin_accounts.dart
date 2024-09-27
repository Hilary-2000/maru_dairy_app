import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class SuperAdminAccounts extends StatefulWidget {
  final void Function(int) updateIndex;
  const SuperAdminAccounts({super.key, required this.updateIndex});

  @override
  State<SuperAdminAccounts> createState() => _SuperAdminAccountsState();
}

class _SuperAdminAccountsState extends State<SuperAdminAccounts> {
  CustomThemes customs = CustomThemes();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isLightMode = true;
  bool _isInitialized = false;
  String price = "Kes 0";
  int index = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_isInitialized){
      initializeAccount();
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> initializeAccount() async {
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getMilkPrice();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      print(res);
      if(res['success']){
        setState(() {
          price = "Kes ${res['price']}";
        });
      }else{
        setState(() {
          price = "Kes 0";
        });
      }
    }else{
      setState(() {
        price = "Kes 0";
      });
    }
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
                                Navigator.pushNamed(context, "/admin_profile");
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
                                Navigator.pushNamed(context, "/admin_edit_profile");
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
                              subtitle: Text("Get comprehensive reports on the system.", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                Navigator.pushNamed(context, "/generate_admin_report");
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
                            Text("Users", style: customs.darkTextStyle(size: 12, fontweight: FontWeight.bold),),
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
                                backgroundColor: customs.infoShade_2,
                                child: Icon(
                                  FontAwesomeIcons.userDoctor,
                                  size: 20,
                                  color: customs.infoColor,
                                ),
                              ),
                              title: Text("Members", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("Manage members and their membership status.", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                index = 1;
                                widget.updateIndex(index);
                              },
                            ),
                            Container(width: width * 0.8, child: Divider(color: customs.secondaryShade_2,)),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.secondaryShade_2,
                                child: Icon(
                                  FontAwesomeIcons.userDoctor,
                                  size: 20,
                                  color: customs.secondaryColor,
                                ),
                              ),
                              title: Text("Technicians", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("Manage technicians and their permissions.", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                Navigator.pushNamed(context, "/manage_technicians");
                              },
                            ),
                            Container(width: width * 0.8, child: Divider(color: customs.secondaryShade_2,)),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.warningShade_2,
                                child: Icon(
                                  FontAwesomeIcons.userDoctor,
                                  size: 20,
                                  color: customs.warningColor,
                                ),
                              ),
                              title: Text("Admin", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("Manage Administrators and their permissions.", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                Navigator.pushNamed(context, "/administrators");
                              },
                            ),
                            Container(width: width * 0.8, child: Divider(color: customs.secondaryShade_2,)),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.dangerShade_2,
                                child: Icon(
                                  FontAwesomeIcons.userDoctor,
                                  size: 20,
                                  color: customs.dangerColor,
                                ),
                              ),
                              title: Text("Super Admins", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("Manage your fellow Super Administrators and their permissions.", style: customs.secondaryTextStyle(size: 12),),
                              onTap: () async {
                                await Navigator.pushNamed(context, "/super_admin_list");
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
                            Text("General", style: customs.darkTextStyle(size: 12, fontweight: FontWeight.bold),),
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
                                  FontAwesomeIcons.droplet,
                                  size: 20,
                                  color: customs.primaryColor,
                                ),
                              ),
                              title: Text("Milk Price Per Liter", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("Change price per Litre. @$price", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                Navigator.pushNamed(context, "/milk_prices");
                              },
                            ),
                            Container(width: width * 0.8, child: Divider(color: customs.secondaryShade_2,)),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.primaryShade_2,
                                child: Icon(
                                  FontAwesomeIcons.circleMinus,
                                  size: 20,
                                  color: customs.primaryColor,
                                ),
                              ),
                              title: Text("Set Up Deduction", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("Add, update and delete the various deductions present!", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                Navigator.pushNamed(context, "/deduction_management");
                              },
                            ),
                            Container(width: width * 0.8, child: Divider(color: customs.secondaryShade_2,)),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: customs.primaryShade_2,
                                child: Icon(
                                  FontAwesomeIcons.globe,
                                  size: 20,
                                  color: customs.primaryColor,
                                ),
                              ),
                              title: Text("Set Up Regions", style: customs.darkTextStyle(size: 14),),
                              subtitle: Text("Manage all regions you have!", style: customs.secondaryTextStyle(size: 12),),
                              onTap: (){
                                Navigator.pushNamed(context, "/region_management");
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

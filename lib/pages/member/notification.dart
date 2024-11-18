import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class notificationWindow extends StatefulWidget {
  final void Function() getNotifications;
  final int notification_count;
  const notificationWindow({super.key, this.getNotifications = _defualtFunction, this.notification_count = 0});
  static void _defualtFunction(){}

  @override
  State<notificationWindow> createState() => _notificationWindowState();
}

class _notificationWindowState extends State<notificationWindow> {
  CustomThemes customs = CustomThemes();
  var member_data = null;
  String member_id = "";
  bool init = false;

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if(!init){
      setState(() {
        init = true;
      });
      widget.getNotifications();

      // get the member data
      await getMemberDetails();
    }
  }

  Future<void> getMemberDetails() async {
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getMemberDetails();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        // set state
        setState(() {
          member_data = res['member_details'];
          member_id = "${member_data['user_id']}";
        });
      }else{
        setState(() {
          member_data = res['member_details'];
          member_id = "";
        });
      }
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
            color: customs.whiteColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notifications",
                        style: customs.darkTextStyle(
                            size: 20, fontweight: FontWeight.bold),
                      ),
                      Text(
                        "Mark all as reads",
                        style: customs.primaryTextStyle(
                            size: 12, fontweight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  height: height-40,
                  child: DefaultTabController(
                    length: 2, // Number of tabs
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TabBar(
                          labelColor: customs.primaryColor,
                          unselectedLabelColor: customs.secondaryColor,
                          indicatorColor: customs.primaryColor,
                          labelStyle: customs.secondaryTextStyle(
                              size: 12,
                              fontweight: FontWeight.normal,
                              underline: false
                          ),
                          tabs: [
                            Tab(child: Column(children: [Icon(Icons.message, size: 20), SizedBox(height: 5,), Text("Inquiry")],),),
                            Tab(child: Column(children: [Icon(Icons.notifications_outlined, size: 20), Text("Nofications")])),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if(member_id.length > 0){
                                            await Navigator.pushNamed(context, "/member_chat", arguments: {"index": "0", "member_id":  member_id});
                                            widget.getNotifications();
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: "An error occured! \nRestart the application and try again!");
                                          }
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
                                                backgroundColor: customs.primaryShade_2,
                                                child: false ? Text(
                                                  "A",
                                                  style: customs.primaryTextStyle(size: 14),
                                                ) : 
                                                Icon(Icons.person, size: 25, color: customs.primaryColor,),
                                              ),
                                              title: Text(
                                                "Chat Your Favourite Administrator",
                                                style: customs.darkTextStyle(size: 14),
                                              ),
                                              subtitle: Text(
                                                "Ask your favourite administrator issues you are encountering",
                                                style: customs.secondaryTextStyle(size: 12),
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("-", style: customs.darkTextStyle(size: 12)),
                                                  Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                        color: widget.notification_count > 0 ? customs.successColor : customs.secondaryShade,
                                                        borderRadius:BorderRadius.circular(8)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  child: Center(child: Text("No notification available at the moment!", style: customs.primaryTextStyle(size: 14, fontweight: FontWeight.normal),)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      },
    ));
  }
}

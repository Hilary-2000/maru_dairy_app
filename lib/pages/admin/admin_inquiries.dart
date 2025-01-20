import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class AdminInquiries extends StatefulWidget {
  final void Function() getNotifications;
  AdminInquiries({super.key, this.getNotifications = _defaultFunction});
  static void _defaultFunction() {}

  @override
  State<AdminInquiries> createState() => _AdminInquiriesState();
}

class _AdminInquiriesState extends State<AdminInquiries>{
  CustomThemes customs = CustomThemes();
  bool load_inquiries = false;
  bool init = false;
  var chats = [];
  int increase = 0;
  List<String> selected_chat_ids = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if (!init) {
      await customs.initialize();
      // get notifications
      widget.getNotifications();

      setState(() {
        init = true;
      });
      getChats();  // Fetch chats on initialization
    }
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?', style: customs.darkTextStyle(size: 25)),
          content: Text(
            'Are you sure you want to delete chat(s)?',
            style: customs.darkTextStyle(size: 14, fontweight: FontWeight.normal),
          ),
          actions: <Widget>[
            Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("No", style: customs.successTextStyle(size: 15, fontweight: FontWeight.bold)),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Yes, Delete", style: customs.dangerTextStyle(size: 15, fontweight: FontWeight.bold)),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> getChats() async {
    setState(() {
      load_inquiries = true; // Start loading indicator
    });

    ApiConnection apiConnection = ApiConnection();
    var response = await apiConnection.getChats();

    if (customs.isValidJson(response)) {
      var res = jsonDecode(response);
      setState(() {
        chats = res['success'] ? res['chats'] : [];
      });
    } else {
      setState(() {
        chats = [];
      });
    }

    setState(() {
      load_inquiries = false; // Stop loading indicator
    });
  }


  @override
  Widget build(BuildContext context) {
    return customs.refreshIndicator(
      onRefresh: () async{
        await getChats();
        widget.getNotifications();
        HapticFeedback.lightImpact();
      },
      child: SafeArea(child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          double calculatedWidth = width / 2 - 170;
          calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
          return Container(
              height: height,
              width: width,
              color: customs.secondaryShade_2.withOpacity(0.2),
              child: load_inquiries ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCircle(
                    color: customs.primaryColor,
                    size: 50.0,
                  ),
                  Text("Loading inquiries...", style: customs.primaryTextStyle(size: 10,))
                ],
              )
                  :
              Column(
                children: [
                  selected_chat_ids.length == 0 ? Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.7,
                          child: Text("Inquiries", style: customs.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
                        ),
                        CircleAvatar(backgroundColor: customs.secondaryShade_2.withOpacity(0.2), child: IconButton(onPressed: (){}, icon: Icon(Icons.search), color: customs.secondaryColor,)),
                      ],
                    ),
                  )
                      :
                  ListTile(
                    dense: true,
                    leading: Container(
                      width: 90,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                setState(() {
                                  selected_chat_ids = [];
                                  for(int indexes = 0; indexes < chats.length; indexes++){
                                    chats[indexes]['selected'] = false;
                                  }
                                  setState(() {
                                    chats = chats;
                                  });
                                });
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: customs.darkColor,
                              )
                          ),
                          Text("${selected_chat_ids.length}", style: customs.secondaryTextStyle(size: 20, fontweight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    trailing: Container(
                      width: width/2.5,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                //send data to the database and delete
                                bool delete = await _showBackDialog() ?? false;
                                if(delete){
                                  ApiConnection apiConn = new ApiConnection();
                                  var response = await apiConn.deleteChat(chat_ids: selected_chat_ids);
                                  if(customs.isValidJson(response)){
                                    var res = jsonDecode(response);
                                    if(res['success']){
                                      customs.maruSnackBarSuccess(context: context, text: res['message']);
                                      getChats();

                                      // set the thread id empty
                                      setState(() {
                                        selected_chat_ids = [];
                                      });
                                    }else{
                                      customs.maruSnackBarDanger(context: context, text: res['message']);
                                    }
                                  }else{
                                    customs.maruSnackBarDanger(context: context, text: "An error has occured!");
                                  }
                                }
                              },
                              icon: Icon(FontAwesomeIcons.trashCanArrowUp, size: 20, color: customs.secondaryShade,)
                          ),
                        ],
                      ),
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
                    child: chats.length > 0 ?
                    ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index){
                          var chat = chats[index];
                          bool new_message = chat['seen_status'] == "notseen" && chat['message_status'] == "sent";
                          return InkWell(
                            onTap: () async {
                              if(selected_chat_ids.length == 0){
                                await Navigator.pushNamed(context, "/admin_inquiry_inbox", arguments: {"index" : index, "member_id": chat['chat_owner']});
                                getChats();
                                widget.getNotifications();
                              }else{
                                for(int indexes = 0; indexes < chats.length; indexes++){
                                  if(chat['chat_id'] == chats[indexes]['chat_id']){
                                    chats[indexes]['selected'] = !chats[indexes]['selected'];
                                    chats[indexes]['selected'] ? selected_chat_ids.add("${chat['chat_id']}") : selected_chat_ids.remove("${chat['chat_id']}");
                                  }
                                }

                                setState(() {
                                  chats = chats;
                                });
                              }
                            },
                            onLongPress: (){
                              if(selected_chat_ids.length == 0){
                                for(int indexes = 0; indexes < chats.length; indexes++){
                                  if(chat['chat_id'] == chats[indexes]['chat_id']){
                                    chats[indexes]['selected'] = true;
                                    selected_chat_ids.add("${chat['chat_id']}");
                                  }
                                }

                                setState(() {
                                  chats = chats;
                                });
                              }
                            },
                            child: Column(
                              children: [
                                IntrinsicHeight(
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: new_message ? customs.secondaryShade_2.withOpacity(0.5) : customs.secondaryShade_2.withOpacity(0.2),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: ListTile(
                                            dense: true,
                                            leading: CircleAvatar(
                                              backgroundColor: customs.primaryShade,
                                              child: Text(
                                                "${customs.nameAbbr(chat['fullname'] ?? "N.A")}",
                                                style: customs.primaryTextStyle(
                                                  size: 18,
                                                  fontweight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              "${chat['fullname'] != null ? customs.toCamelCase(chat['fullname'] ?? "N/A") : "N/A"}",
                                              style: customs.darkTextStyle(size: 14, fontweight: new_message ? FontWeight.bold : FontWeight.normal),
                                            ),
                                            subtitle: Text(
                                              customs.message_split("${chat['last_message']}"),
                                              style: customs.secondaryTextStyle(size: 12, fontweight: new_message ? FontWeight.bold : FontWeight.normal),
                                            ),
                                            trailing: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("${chat['chat_sent']}",
                                                    style: customs.secondaryTextStyle(size: 10, fontweight: new_message ? FontWeight.bold : FontWeight.normal)),
                                                SizedBox(height: 5,),
                                                chat['message_status'] == "received" ? Icon(Icons.check, size: 15, color: customs.secondaryColor,) : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // The second container that uses LayoutBuilder
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                        width: width,
                                        color: chat['selected'] ? customs.primaryShade_2 : Colors.transparent, // Match the height of the parent
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width * 0.5,
                                  child: Divider(
                                    color: customs.secondaryShade_2.withOpacity(0.2),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                    )
                        :
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          width: width - 50,
                          height: width - 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("No inquiries found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),textAlign: TextAlign.center,),
                              SizedBox(height: 30,),
                              SizedBox(
                                width: width,
                                child: Image(
                                  image: AssetImage("assets/images/search.jpg"),
                                  height: width/3,
                                  width: width/3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          );
        },
      )),
    );
  }
}

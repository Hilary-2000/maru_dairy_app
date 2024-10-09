import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class InquiryInbox extends StatefulWidget {
  const InquiryInbox({super.key});

  @override
  State<InquiryInbox> createState() => _InquiryInboxState();
}

class _InquiryInboxState extends State<InquiryInbox> {
  CustomThemes customs = CustomThemes();
  final _formKey = GlobalKey<FormState>();
  var message_ids = [];

  TextEditingController textEditingController = new TextEditingController();

  List<DropdownMenuItem<String>> regions = [
    const DropdownMenuItem(child: Text("Select your region"), value: ""),
    const DropdownMenuItem(child: Text("Njebi"), value: "Njebi"),
    const DropdownMenuItem(child: Text("Munyu/Kiriti"), value: "Munyu/Kiriti"),
  ];
  Map<String, dynamic>? args;

  List<DropdownMenuItem<String>> genderList = [
    const DropdownMenuItem(child: Text("Select Gender"), value: ""),
    const DropdownMenuItem(child: Text("Male"), value: "male"),
    const DropdownMenuItem(child: Text("Female"), value: "female"),
  ];


  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Are you sure?', style: customs.darkTextStyle(size: 25),),
          content: Text(
            'Are you sure you want to delete chat(s)?', style: customs.darkTextStyle(size: 14, fontweight: FontWeight.normal),
          ),
          actions: <Widget>[
            Row(
              children: [
                Spacer(),
                GestureDetector(onTap:(){Navigator.pop(context, false);}, child: Text("No", style: customs.successTextStyle(size: 15, fontweight: FontWeight.bold),)),
                SizedBox(width: 20,),
                GestureDetector(onTap:(){Navigator.pop(context, true);}, child: Text("Yes, Delete", style: customs.dangerTextStyle(size: 15, fontweight: FontWeight.bold),)),
              ],
            )
          ],
        );
      },
    );
  }

  Future<bool?> _confirmChatClearing() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Are you sure?', style: customs.darkTextStyle(size: 25),),
          content: Text(
            'Are you sure you want to clear all chat(s)? \nThis action is irreversible', style: customs.darkTextStyle(size: 14, fontweight: FontWeight.normal),
          ),
          actions: <Widget>[
            Row(
              children: [
                Spacer(),
                GestureDetector(onTap:(){Navigator.pop(context, false);}, child: Text("No", style: customs.successTextStyle(size: 15, fontweight: FontWeight.bold),)),
                SizedBox(width: 20,),
                GestureDetector(onTap:(){Navigator.pop(context, true);}, child: Text("Yes, Delete", style: customs.dangerTextStyle(size: 15, fontweight: FontWeight.bold),)),
              ],
            )
          ],
        );
      },
    );
  }
  bool init = false;
  var chats = null;
  var keys = [];
  var member_data = null;
  bool send_message = false;
  bool load_members = false;

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    customs.maruSnackBarSuccess(context: context, text: "Copied to clipboard");
  }

  Future<void> getMessages() async {
    setState(() {
      load_members = true;
    });
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String member_id = "";
    if (customs.isValidJson(jsonEncode(args))){
      var arguments = jsonDecode(jsonEncode(args));
      setState(() {
        member_id = "${arguments['member_id']}";
      });

      // apiConnection
      ApiConnection apiConnection = new ApiConnection();
      var response = await apiConnection.getMemberMessages(member_id: member_id);
      if(customs.isValidJson(response)){
        var res = jsonDecode(response);
        if(res['success']){
          setState(() {
            chats = res['data'];
            keys = chats.length > 0 ? chats.keys.toList() : [];
            member_data = res['member_data'];
          });
        }else{
          setState(() {
            chats = null;
            member_data = null;
            keys = [];
          });
        }
      }else{
        setState(() {
          chats = null;
          member_data = null;
          keys = [];
        });
      }
    }
    setState(() {
      load_members = false;
    });
  }

  void didChangeDependencies(){
    super.didChangeDependencies();

    if(!init){
      // set state
      setState(() {
        init = true;
      });

      // get messages
      getMessages();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: customs.whiteColor,
      body: SafeArea(child: LayoutBuilder(
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
            child:  load_members ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitCircle(
                  color: customs.primaryColor,
                  size: 50.0,
                ),
                Text("Loading Messages...", style: customs.primaryTextStyle(size: 10,))
              ],
            )
            :
            Column(
              children: [
                PopScope(
                  canPop: message_ids.length == 0,
                  onPopInvokedWithResult: (bool didPop, Object? result) async {
                    if(!didPop){
                      // reset the selected messages
                      setState(() {
                        message_ids = [];
                        chats.forEach((dateKey, chatInfo){
                          List in_chats = chatInfo['chats'];
                          for(int index = 0; index < in_chats.length; index++){
                            chats[dateKey]['chats'][index]['selected'] = false;
                          }
                        });
                        setState(() {
                          chats = chats;
                        });
                      });
                    }
                  },
                  child: GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(5),
                        color: customs.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: customs.secondaryShade_2,
                            spreadRadius: 0.5,
                            blurRadius: 1,
                            offset: Offset.fromDirection(-1,-3)
                          )
                        ]
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: message_ids.length == 0 ?
                        ListTile(
                          dense: true,
                          leading: Container(
                            width: 90,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios,
                                  size: 20,)
                                ),
                                CircleAvatar(
                                  backgroundColor: customs.primaryShade,
                                  child: Text(
                                    member_data != null ? customs.nameAbbr("${(member_data['fullname'] ?? "NA")}") : "NA",
                                    style: customs.primaryTextStyle(
                                        size: 18, fontweight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            customs.toCamelCase(member_data != null ? member_data['fullname'] ?? "" : ""),
                            style: customs.darkTextStyle(size: 14),
                          ),
                          subtitle: Text(
                            member_data != null ? member_data['membership'] ?? "" : "",
                            style: customs.secondaryTextStyle(size: 12),
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: Icon(FontAwesomeIcons.ellipsisVertical, size: 18),
                            onSelected: (String result) async {
                              // Handle the selection here
                              if(result == "member_info"){
                                String member_id = "";
                                chats.forEach((dateKey, chatInfo){
                                  List chats = chatInfo['chats'];
                                  for(var chat in chats){
                                    member_id = "${chat['chat_thread_id']}";
                                  }
                                });

                                await Navigator.pushNamed(context, "/admin_member_details", arguments: {"index" : 0, "member_id": member_id});
                              }else if(result == "clear_chat"){
                                bool clear_chat = await _confirmChatClearing() ?? false;
                                if(clear_chat){
                                  if(chats.length > 0){
                                    List <String> all_chats = [];
                                    chats.forEach((dateKey, chatInfo){
                                      List chats = chatInfo['chats'];
                                      for(var chat in chats){
                                        all_chats.add("${chat['chat_thread_id']}");
                                      }
                                    });

                                    ApiConnection apiCon = new ApiConnection();
                                    var response = await apiCon.deleteChatThreads(chat_thread_ids: all_chats);
                                    if(customs.isValidJson(response)){
                                      var res = jsonDecode(response);
                                      if(res['success']){
                                        customs.maruSnackBarSuccess(context: context, text: res['message']);
                                        getMessages();
                                      }else{
                                        customs.maruSnackBarDanger(context: context, text: res['message']);
                                      }
                                    }
                                  }
                                }
                              }
                            },
                            color: customs.whiteColor,
                            itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'member_info',
                                height: 15,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  margin: EdgeInsets.zero,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.info,
                                        size: 13,
                                        color: customs.secondaryColor,
                                      ),
                                      Text(
                                        ' Member Info',
                                        style: customs.secondaryTextStyle(
                                            size: 12,
                                            fontweight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuDivider(height: 1),
                              PopupMenuItem<String>(
                                value: 'clear_chat',
                                height: 15,
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  margin: EdgeInsets.zero,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.trash,
                                        size: 13,
                                        color: customs.dangerColor,
                                      ),
                                      Text(
                                        ' Clear Chat',
                                        style: customs.dangerTextStyle(
                                            size: 12,
                                            fontweight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                        message_ids = [];
                                        chats.forEach((dateKey, chatInfo){
                                          List in_chats = chatInfo['chats'];
                                          for(int index = 0; index < in_chats.length; index++){
                                            chats[dateKey]['chats'][index]['selected'] = false;
                                          }
                                        });
                                        setState(() {
                                          chats = chats;
                                        });
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      size: 20,
                                    )
                                ),
                                Text("${message_ids.length}", style: customs.secondaryTextStyle(size: 20, fontweight: FontWeight.bold),)
                              ],
                            ),
                          ),
                          trailing: Container(
                            width: width/2.5,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    List<String> selected_thread_ids = [];
                                    chats.forEach((dateKey, chatInfo){
                                      List chats = chatInfo['chats'];
                                      for(var chat in chats){
                                        if(chat['selected']){
                                          selected_thread_ids.add("${chat['chat_thread_id']}");
                                        }
                                      }
                                    });

                                    //send data to the database and delete
                                    bool delete = await _showBackDialog() ?? false;
                                    if(delete){
                                      ApiConnection apiConn = new ApiConnection();
                                      var response = await apiConn.deleteChatThreads(chat_thread_ids: selected_thread_ids);
                                      if(customs.isValidJson(response)){
                                        var res = jsonDecode(response);
                                        if(res['success']){
                                          customs.maruSnackBarSuccess(context: context, text: res['message']);
                                          getMessages();

                                          // set the thread id empty
                                          setState(() {
                                            selected_thread_ids = [];
                                            message_ids = [];
                                          });
                                        }else{
                                          customs.maruSnackBarDanger(context: context, text: res['message']);
                                        }
                                      }else{
                                        customs.maruSnackBarDanger(context: context, text: "An error has occured!");
                                      }
                                    }
                                  },
                                  icon: Icon(FontAwesomeIcons.trashCanArrowUp, size: 20,)
                                ),
                                message_ids.length == 1 ? IconButton(
                                  onPressed: (){
                                    String message = "";
                                    chats.forEach((dateKey, chatInfo){
                                      List chats = chatInfo['chats'];
                                      for(var chat in chats){
                                        if(chat['selected']){
                                          message = "${chat['message']}";
                                        }
                                      }
                                    });

                                    // copy the message to the clipboard
                                    copyToClipboard(context, message);
                                  },
                                  icon: Icon(FontAwesomeIcons.copy, size: 20,)
                                ) : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: height - 160,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: chats != null && chats.length > 0 ?
                  ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index){
                        var inner_chats = chats[keys[index]]['chats'] ?? [];
                        String date = chats[keys[index]]['date'] ?? "";
                        return Column(
                          children: [
                            Stack(
                              children: [
                                Center(
                                  child: Container(
                                    child: Divider(color: customs.secondaryShade_2,),
                                    width: width * 0.85,
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    child: Text("$date", style: customs.secondaryTextStyle(size: 10),),
                                    color: customs.whiteColor,
                                  ),
                                )
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: inner_chats.length,
                              itemBuilder: (context, indexes){
                                String message_status = inner_chats[indexes]['message_status'];
                                var chat = inner_chats[indexes];
                                if(message_status == "sent"){
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    child: InkWell(
                                      onLongPress: (){
                                        if(message_ids.length == 0){
                                          message_ids.add(chat['chat_thread_id']);
                                          setState(() {
                                            chats[keys[index]]['chats'][indexes]['selected'] = true;
                                          });
                                        }
                                      },
                                      onTap: (){
                                        if(message_ids.length > 0){
                                          setState(() {
                                            chats[keys[index]]['chats'][indexes]['selected'] = !chats[keys[index]]['chats'][indexes]['selected'];
                                          });
                                          if(chats[keys[index]]['chats'][indexes]['selected']){
                                            message_ids.add(chat['chat_thread_id']);
                                          }else{
                                            message_ids.remove(chat['chat_thread_id']);
                                          }
                                        }
                                      },
                                      child: IntrinsicHeight(
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: width * 0.75,
                                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: customs.secondaryShade_2,
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            width: width*0.7,
                                                            child: Text(
                                                              "${chat['message']}",
                                                              style: customs.secondaryTextStyle(size: 14),
                                                            )
                                                        ),
                                                        SizedBox(height: 10,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Text("${chat['date_sent']} ", style: customs.secondaryTextStyle(size: 10),),
                                                            // Icon(Icons.checklist_outlined, size: 15, color: customs.secondaryColor)
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer()
                                                ],
                                              ),
                                            ),
                                            // The second container that uses LayoutBuilder
                                            Container(
                                              width: width,
                                              color: chats[keys[index]]['chats'][indexes]['selected'] ? customs.primaryShade_2 : Colors.transparent,
                                              // Match the height of the parent
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }else{
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    child: InkWell(
                                      onLongPress: (){
                                        if(message_ids.length == 0){
                                          message_ids.add(chat['chat_thread_id']);
                                          setState(() {
                                            chats[keys[index]]['chats'][indexes]['selected'] = true;
                                          });
                                        }
                                      },
                                      onTap: (){
                                        if(message_ids.length > 0){
                                          setState(() {
                                            chats[keys[index]]['chats'][indexes]['selected'] = !chats[keys[index]]['chats'][indexes]['selected'];
                                          });
                                          if(chats[keys[index]]['chats'][indexes]['selected']){
                                            message_ids.add(chat['chat_thread_id']);
                                          }else{
                                            message_ids.remove(chat['chat_thread_id']);
                                          }
                                        }
                                      },
                                      child: IntrinsicHeight(
                                        child: Stack(
                                          children: [
                                            // The first container that displays the chat message
                                            Container(
                                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Spacer(),
                                                  Container(
                                                    width: width * 0.75,
                                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: customs.primaryColor,
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: width * 0.7,
                                                          child: Text(
                                                            "${chat['message']}",
                                                            style: customs.whiteTextStyle(size: 14),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              "${customs.toCamelCase(chat['fullname'])} - ",
                                                              style: customs.secondaryTextStyle(size: 10),
                                                              textAlign: TextAlign.right,
                                                            ),
                                                            Text("${chat['date_sent']}  ", style: customs.secondaryTextStyle(size: 10)),
                                                            Icon(
                                                              FontAwesomeIcons.checkDouble,
                                                              size: 15,
                                                              color: chat['seen_status'] == "notseen" ? customs.whiteColor : customs.warningColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // The second container that uses LayoutBuilder
                                            Container(
                                              width: width,
                                              color: chats[keys[index]]['chats'][indexes]['selected'] ? customs.primaryShade_2 : Colors.transparent, // Match the height of the parent
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            )
                          ],
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
                            Text("No chats found with ${customs.toCamelCase(member_data != null ? member_data['fullname'] ?? "" : "")}!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),textAlign: TextAlign.center,),
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
                ),
                Container(
                  width: width,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10,),
                        Container(
                          width: width * 0.85,
                          child: customs.maruSearchTextField(
                            isChanged: (value){},
                            hintText: "Write your message here!",
                            textType: TextInputType.text,
                            textAlign: TextAlign.left,
                            editingController: textEditingController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Write your message here!";
                              }
                              return null;
                            }
                          )
                        ),
                        Spacer(),
                        Center(
                          child: !send_message ?
                            IconButton(
                              onPressed: () async{
                                if (_formKey.currentState!.validate()){
                                  setState(() {
                                    send_message = true;
                                  });
                                  ApiConnection apiConn = ApiConnection();
                                  var responses = await apiConn.sendMessage(member_id: "${member_data['user_id']}", message: textEditingController.text);
                                  if(customs.isValidJson(responses)){
                                    var res = jsonDecode(responses);
                                    if(res['success']){
                                      customs.maruSnackBarSuccess(context: context, text: res['message']);
                                      // get messages
                                      getMessages();
                                      textEditingController.text = "";
                                    }else{
                                      customs.maruSnackBarDanger(context: context, text: res['message']);
                                    }
                                  }else{
                                    customs.maruSnackBarDanger(context: context, text: "An error has occured!");
                                  }
                                  setState(() {
                                    send_message = false;
                                  });
                                }
                              },
                              icon: Icon(Icons.send_rounded)
                            )
                              :
                            SpinKitCircle(
                              color: customs.secondaryColor,
                              size: width * 0.08,
                            ),
                        ),
                        SizedBox(
                          width: 3,
                        )
                      ],
                    ),
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

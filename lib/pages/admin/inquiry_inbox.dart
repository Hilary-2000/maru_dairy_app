import 'dart:convert';

import 'package:flutter/material.dart';
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

  bool init = false;
  var chats = null;
  var keys = [];
  var member_data = null;
  bool send_message = false;

  Future<void> getMessages() async {
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
            child:Column(
              children: [
                GestureDetector(
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
                      child: ListTile(
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
                        trailing: Icon(
                          FontAwesomeIcons.ellipsisVertical,
                          size: 15,
                          color: customs.secondaryColor,
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
                                    child: Text("$date", style: customs.secondaryTextStyle(size: 12),),
                                    color: customs.whiteColor,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 220,
                              child: ListView.builder(
                                itemCount: inner_chats.length,
                                itemBuilder: (context, indexes){
                                  String message_status = inner_chats[indexes]['message_status'];
                                  var chat = inner_chats[indexes];
                                  if(message_status == "sent"){
                                    return Container(
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
                                      );
                                  }else{
                                    return Container(
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
                                                  width: width*0.7,
                                                  child: Text(
                                                    "${chat['message']}", style: customs.whiteTextStyle(size: 14,),
                                                    textAlign: TextAlign.right,
                                                  )
                                                ),
                                                SizedBox(height: 10,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text("${chat['date_sent']} ", style: customs.secondaryTextStyle(size: 10),),
                                                    Icon(FontAwesomeIcons.checkDouble, size: 15, color: chat['seen_status'] == "notseen" ? customs.whiteColor : customs.warningColor)
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }
                              ),
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

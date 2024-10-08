import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class AdminInquiries extends StatefulWidget {
  const AdminInquiries({super.key});

  @override
  State<AdminInquiries> createState() => _AdminInquiriesState();
}

class _AdminInquiriesState extends State<AdminInquiries> {
  CustomThemes customs = CustomThemes();
  bool load_inquiries = false;
  bool init = false;
  var chats = [];

  void didChangeDependencies(){
    super.didChangeDependencies();

    if(!init){
      setState(() {
        init = true;
        getChats();
      });
    }
  }

  Future<void> getChats() async {
    setState(() {
      load_inquiries = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getChats();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          chats = res['chats'];
        });
      }else{
        setState(() {
          chats = [];
        });
      }
    }else{
      setState(() {
        chats = [];
      });
    }
    setState(() {
      load_inquiries = false;
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
                child: chats.length > 0 ?
                ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index){
                    var chat = chats[index];
                    return Column(
                      children: [GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/admin_inquiry_inbox", arguments: {"index" : index, "member_id": chat['chat_owner']});
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
                                    "${customs.nameAbbr(chat['fullname'])}",
                                    style: customs.primaryTextStyle(
                                        size: 18, fontweight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  "${customs.toCamelCase(chat['fullname'])}",
                                  style: customs.darkTextStyle(size: 14),
                                ),
                                subtitle: Text(
                                  customs.message_split("${chat['last_message']}"),
                                  style: customs.secondaryTextStyle(size: 12),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${chat['chat_sent']}",
                                        style: customs.secondaryTextStyle(size: 10)),
                                    SizedBox(height: 5,),
                                    chat['message_status'] == "received" ? Icon(Icons.check, size: 15, color: customs.secondaryColor,) : SizedBox(),
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
    ));
  }
}

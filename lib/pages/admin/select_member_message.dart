import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class SelectMemberMessage extends StatefulWidget {
  const SelectMemberMessage({super.key});

  @override
  State<SelectMemberMessage> createState() => _SelectMemberMessageState();
}

class _SelectMemberMessageState extends State<SelectMemberMessage> {
  CustomThemes customs = CustomThemes();
  bool init = false;
  var members = [];
  bool member_loading = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<Color> colors_shade = [];
  List<TextStyle> textStyles = [];

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if(!init){
      await customs.initialize();
      if(mounted){
        setState(() {
          init = !init;
        });

        // set colors and shades
        colors_shade = [customs.primaryShade, customs.secondaryShade.withOpacity(0.2), customs.warningShade, customs.secondaryShade.withOpacity(0.2), customs.secondaryShade.withOpacity(0.2)];
        textStyles = [
          customs.primaryTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
          customs.secondaryTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
          customs.warningTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
          customs.darkTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
          customs.successTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
        ];
      }

      //get the members
      getMembers();
    }
  }

  Future<void> getMembers() async {
    if(mounted){
      setState(() {
        member_loading = true;
      });
    }
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getMembers(token!);
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(mounted){
        setState(() {
          members = res['data'];
          member_loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.whiteColor,
      appBar: AppBar(
        backgroundColor: customs.whiteColor,
        iconTheme: IconThemeData(color: customs.darkColor),
        elevation: 1,
        title: Builder(builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          return Container(
            width: screenWidth,
            child: Center(
              child: Container(
                width: 250,
                child: Row(
                  children: [
                    SizedBox(
                      height: 70,
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
              ),
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
            child: member_loading ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitCircle(
                  color: customs.primaryColor,
                  size: 50.0,
                ),
                Text("Loading Members...", style: customs.primaryTextStyle(size: 10,))
              ],
            ) : Column(
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
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: members.length > 0 ?
                  ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index){
                      var item = members[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await Navigator.pushReplacementNamed(context, "/admin_inquiry_inbox", arguments: {"index" : index, "member_id": item['user_id']});
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
                                    backgroundColor: colors_shade[index % colors_shade.length],
                                    child: Text(
                                      customs.nameAbbr(item['fullname']),
                                      style: textStyles[index % textStyles.length],
                                    ),
                                  ),
                                  title: Text(
                                    customs.toCamelCase(item['fullname']),
                                    style: customs.darkTextStyle(size: 14),
                                  ),
                                  subtitle: Text(
                                    item['membership'] ?? "N/A",
                                    style: customs.secondaryTextStyle(size: 12),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(item['region_name'] ?? "-",
                                          style: customs.darkTextStyle(size: 12)),
                                      Text(
                                        item['phone_number'],
                                        style: customs.secondaryTextStyle(
                                            size: 12,
                                            fontweight: FontWeight.normal),
                                      ),
                                      Container(
                                        width: 5,
                                        height: 5,
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
                        decoration: BoxDecoration(
                            color: customs.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: customs.secondaryShade_2, blurRadius: 1, blurStyle: BlurStyle.normal),
                              BoxShadow(color: customs.secondaryShade_2, blurRadius: 1, blurStyle: BlurStyle.normal),
                              BoxShadow(color: customs.secondaryShade_2, blurRadius: 1, blurStyle: BlurStyle.normal),
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No members found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                            Spacer(),
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
            ),
          );
        },
      )),
    );
  }
}

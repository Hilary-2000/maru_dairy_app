import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MemberHistory extends StatefulWidget {
  const MemberHistory({super.key});

  @override
  State<MemberHistory> createState() => _MemberHistoryState();
}

class _MemberHistoryState extends State<MemberHistory> {
  CustomThemes customs = CustomThemes();
  Map<String, dynamic>? args;
  void findKeyWord(keyword){
    var newHistory = [];
    for(var item in collected_history){
      int present = 0;
      if(item['collection_amount'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['date'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['time'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }

      // present
      if(present > 0){
        newHistory.add(item);
      }
    }

    // display
    displayHistory(newHistory);
  }
  void didChangeDependencies(){
    super.didChangeDependencies();
    // set the initials
    double width = MediaQuery.of(context).size.width;

    if(!_init){
      setState(() {
        collections = [
          GestureDetector(
            onTap : (){
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
                  leading: Container(
                    child: const Icon(
                      Icons.water_drop_outlined,
                      size: 25,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: customs.primaryShade_2),
                  ),
                  title: Text(
                    "Collected",
                    style: customs.primaryTextStyle(size: 12),
                  ),
                  subtitle: Text(
                    "25 Litres",
                    style: customs.darkTextStyle(size: 15),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("12:03AM",
                          style: customs.secondaryTextStyle(size: 10)),
                      Text(
                        "15th July 2024",
                        style: customs.secondaryTextStyle(
                            size: 10, fontweight: FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
          GestureDetector(
            onTap : (){
              Navigator.pushNamed(context, "/member_milk_details");
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
                  leading: Container(
                    child: const Icon(
                      Icons.water_drop_outlined,
                      size: 25,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: customs.primaryShade_2),
                  ),
                  title: Text(
                    "Collected",
                    style: customs.primaryTextStyle(size: 12),
                  ),
                  subtitle: Text(
                    "25 Litres",
                    style: customs.darkTextStyle(size: 15),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("12:03AM",
                          style: customs.secondaryTextStyle(size: 10)),
                      Text(
                        "15th July 2024",
                        style: customs.secondaryTextStyle(
                            size: 10, fontweight: FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
        ];
      });
      // collection history
      getCollectionHistory();
      setState(() {
        _init = true;
      });
    }
  }

  bool loading = false;
  bool _init = false;
  String accumulated_litres = "N/A";
  List<Widget> collections = [];
  var collected_history = [];
  String total_price = "Kes 0";
  String member_name = "N/A";
  String member_code = "N/A";
  TextEditingController searchField = new TextEditingController();

  Future<void> getCollectionHistory() async {
    setState(() {
      loading = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String member_id = "";
    if(customs.isValidJson(jsonEncode(args))){
      var respond = jsonDecode(jsonEncode(args));
      member_id = respond['member_id'].toString();
      setState(() {
        member_name = respond['member_data']['fullname'] ?? "N/A";
        member_code = respond['member_data']['membership'] ?? "";
      });
      var response = await apiConnection.adminMemberHistory(member_id);
      print(response);
      if(customs.isValidJson(response)){
        var res = jsonDecode(response);
        if(res['success']){
          // display the history
          displayHistory(res['collection_history']);
          setState(() {
            collected_history = res['collection_history'];
            accumulated_litres = res['count'];
            total_price = "Kes ${res['total_price']}";
          });
        }else{
          displayHistory([]);
        }
      }else{
        customs.maruSnackBarDanger(context: context, text: "An error has occured!");
        setState(() {
          total_price = "Kes 0";
        });
      }
      setState(() {
        loading = false;
      });
    }else{
      setState(() {
        total_price = "Kes 0";
      });
      customs.maruSnackBarDanger(context: context, text: "An error has occured!");
    }
  }

  void displayHistory(var list){
    double width = MediaQuery.of(context).size.width;
    List<Widget> history = (list as List<dynamic>).asMap().entries.map((entry) {
      var item = entry.value;
      var index = entry.key;
      return Column(
        children: [
          GestureDetector(
            onTap : () async {
              await Navigator.pushNamed(context, "/edit_member_milk_data", arguments: {"collection_id": item['collection_id'], "index": index});
              // await Navigator.pushNamed(context, "/member_milk_details", arguments: {"collection_id": item['collection_id']});
              getCollectionHistory();
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
                  leading: Container(
                    child: const Icon(
                      Icons.water_drop_outlined,
                      size: 25,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: customs.primaryShade_2),
                  ),
                  title: Text(
                    "Collected",
                    style: customs.primaryTextStyle(size: 12),
                  ),
                  subtitle: Text(
                    "${item['collection_amount']} Litres",
                    style: customs.darkTextStyle(size: 15),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${item['time']}",
                          style: customs.secondaryTextStyle(size: 10)),
                      Text(
                        "${item['date']}",
                        style: customs.secondaryTextStyle(
                            size: 10, fontweight: FontWeight.normal),
                      ),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: item['collection_status'] == 0 ? customs.secondaryColor : (item['collection_status'] == 1 ? customs.successColor : customs.dangerColor),
                            borderRadius: BorderRadius.circular(5)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
        ],
      );
    }).toList();


    if(history.length == 0){
      history.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
                    Text("No collections found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                    Spacer(),
                    SizedBox(
                      width: width,
                      child: Image(
                        image: AssetImage("assets/images/search.jpg"),
                        height: width/3,
                        width: width/3,
                      ),
                    ),
                    Spacer(),
                    searchField.text.length > 0 ? Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Text(
                          "Members with this \"${searchField.text}\" keyword not found!",
                          style: customs.primaryTextStyle(size: 14, fontweight: FontWeight.normal),
                        )
                    ) : SizedBox(height: 0, width: 0,)
                  ],
                ),
              ),
            ],
          )
      );
    }

    setState(() {
      collections = history;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.whiteColor,
      appBar: AppBar(
        backgroundColor: customs.whiteColor,
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
      body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          double calculatedWidth = width / 2 - 170;
          calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: customs.secondaryShade_2.withOpacity(0.2)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Text("History : \"$member_name\"", style: customs.darkTextStyle(size: 18, fontweight: FontWeight.bold),),
                ),
                Card(
                  shadowColor: customs.primaryShade.withOpacity(0.5),
                  elevation: 2,
                  color: customs.whiteColor,
                  margin:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    color: customs.whiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "This Month:",
                          style: customs.secondaryTextStyle(
                              size: 12, fontweight: FontWeight.bold),
                        ),
                        Skeletonizer(
                          enabled: loading,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 100,
                                width: width * 0.40,
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: customs.secondaryShade_2),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey[200],
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Icon(
                                          FontAwesomeIcons.handHoldingDollar,
                                          color: customs.successColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Est. Pay",
                                            style: customs.secondaryTextStyle(
                                                size: width * 0.035,
                                                fontweight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "$total_price",
                                            style: customs.darkTextStyle(
                                                size: width * 0.028
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 100,
                                width: width * 0.40,
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: customs.secondaryShade_2),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey[200],
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.water_drop_outlined,
                                          color: customs.infoColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Acc. Litres",
                                            style: customs.secondaryTextStyle(
                                                size: width * 0.035,
                                                fontweight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "$accumulated_litres Litres",
                                            style: customs.darkTextStyle(
                                                size: width * 0.028),
                                          ),
                                        ],
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: (width * 0.2), vertical: 10),
                  child: Divider(
                    color: customs.secondaryShade_2,
                    height: 0.1,
                    thickness: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(children: [
                    Text(
                      "Lifetime",
                      textAlign: TextAlign.left,
                      style:
                      customs.secondaryTextStyle(size: 12, underline: true),
                    ),
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      width: width * 0.6,
                      child: customs.maruSearchTextField(
                        isChanged: (value) {
                          findKeyWord(value);
                        },
                        hintText: "Search",
                        editingController: searchField
                        // label: "Search"
                      ),
                    ),
                  ],
                ),
                Skeletonizer(
                  enabled: loading,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    height: height - 287,
                    decoration: BoxDecoration(
                      color: customs.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    // color: Colors.red,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: collections,
                    ),
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

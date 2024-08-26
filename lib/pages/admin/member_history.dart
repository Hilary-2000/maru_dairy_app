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
  }

  bool loading = false;
  String accumulated_litres = "N/A";
  List<Widget> collections = [];
  var collected_history = [];
  String member_name = "N/A";
  String member_code = "N/A";

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
          });
        }else{
          displayHistory([]);
        }
      }else{
        customs.maruSnackBarDanger(context: context, text: "An error has occured!");
      }
      setState(() {
        loading = false;
      });
    }else{
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

    setState(() {
      collections = history;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customs.whiteColor,
        elevation: 1,
        title: Builder(builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double calculatedWidth = screenWidth / 2 - 210;
          calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
          return Container(
            margin: EdgeInsets.fromLTRB(calculatedWidth, 0, 0, 0),
            child: Row(
              children: [
                SizedBox(
                  height: 45,
                  child: Image(image: AssetImage("assets/images/maru-nobg.png")),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Maru Dairy Co-op", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
              ],
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
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                                            "Kes 0",
                                            style: customs.darkTextStyle(
                                                size: width * 0.028),
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
                        // label: "Search"
                      ),
                    ),
                  ],
                ),
                Skeletonizer(
                  enabled: loading,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    height: height - 285,
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
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TechnicianHistory extends StatefulWidget {
  final void Function() getNotifications;
  TechnicianHistory({super.key, this.getNotifications = _defaultFunction});
  static void _defaultFunction() {}

  @override
  State<TechnicianHistory> createState() => _TechnicianHistoryState();
}

class _TechnicianHistoryState extends State<TechnicianHistory> {
  CustomThemes customs = CustomThemes();
  String drop_down = "7 days";
  bool loading = false;
  List<Color> colors_shade = [];
  List<TextStyle> textStyles = [];
  int confirmedCollection = 0;
  int notConfirmedCollection = 0;
  bool _init = false;
  List<DropdownMenuItem<String>> dayFilter = [
    const DropdownMenuItem(child: Text("7 Days"), value: "7 days"),
    const DropdownMenuItem(child: Text("14 Days"), value: "14 days"),
    const DropdownMenuItem(child: Text("1 Month"), value: "30 days"),
  ];
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Widget> collectionHistory = [];
  var collections = [];

  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  // change to camel case
  String toCamelCase(String text) {
    // Step 1: Split the string by spaces or underscores
    List<String> words = text.split(RegExp(r'[\s_]+'));

    // Step 2: Capitalize the first letter of each word and lowercase the rest
    List<String> capitalizedWords = words.map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    // Step 3: Join the capitalized words with spaces
    return capitalizedWords.join(' ');
  }

  Future<void> loadTechnicianHistory(BuildContext context) async {
    setState(() {
      loading = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    String? token = await _storage.read(key: 'token');
    var response = await apiConnection.collectHistory(token!, drop_down);
    if(isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success'] == true){
        confirmedCollection = res['confirmed'];
        notConfirmedCollection = res['not_confirmed'];
        displayCollectionHistory(res['collection_history']);

        //set state
        setState(() {
          collections = res['collection_history'];
        });
      }else{
        setState(() {
          collections = [];
          collectionHistory = [];
        });
      }
    }else{
      setState(() {
        collections = [];
        collectionHistory = [];
      });
    }
    setState(() {
      loading = false;
    });
  }

  void didChangeDependencies(){
    super.didChangeDependencies();

    if(!_init){
      // run notification
      widget.getNotifications();

      // set the technicians history
      double width = MediaQuery.of(context).size.width;
      setState((){
        collectionHistory = [
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
                  leading: CircleAvatar(
                    backgroundColor: customs.primaryShade,
                    child: Skeleton.ignore(child: Text("PM", style: customs.primaryTextStyle(size: 18, fontweight: FontWeight.bold),)),
                  ),
                  title: Text(
                    "Patrick Mugoh",
                    style: customs.darkTextStyle(size: 14),
                  ),
                  subtitle: Text(
                    "20.4 Litres",
                    style: customs.secondaryTextStyle(size: 12),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("10:03AM",
                          style: customs.darkTextStyle(size: 10)),
                      Text(
                        "15th July 2024",
                        style: customs.secondaryTextStyle(
                            size: 10, fontweight: FontWeight.normal),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: customs.successColor,
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
                  leading: CircleAvatar(
                    backgroundColor: customs.successShade_2,
                    child: Skeleton.ignore(child: Text("OM", style: customs.successTextStyle(size: 18, fontweight: FontWeight.bold),)),
                  ),
                  title: Text(
                    "Owen Malingu",
                    style: customs.darkTextStyle(size: 14),
                  ),
                  subtitle: Text(
                    "20.4 Litres",
                    style: customs.secondaryTextStyle(size: 12),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("09:56AM",
                          style: customs.darkTextStyle(size: 10)),
                      Text(
                        "15th July 2024",
                        style: customs.secondaryTextStyle(
                            size: 10, fontweight: FontWeight.normal),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: customs.successColor,
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
                  leading: CircleAvatar(
                    backgroundColor: customs.secondaryShade_2,
                    child: Skeleton.ignore(child: Text("EB", style: customs.secondaryTextStyle(size: 18, fontweight: FontWeight.bold),)),
                  ),
                  title: Text(
                    "Esmond Bwire",
                    style: customs.darkTextStyle(size: 14),
                  ),
                  subtitle: Text(
                    "16.4 Litres",
                    style: customs.secondaryTextStyle(size: 12),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("09:53AM",
                          style: customs.darkTextStyle(size: 10)),
                      Text(
                        "15th July 2024",
                        style: customs.secondaryTextStyle(
                            size: 10, fontweight: FontWeight.normal),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: customs.dangerColor,
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
        ];
        colors_shade = [customs.primaryShade, customs.secondaryShade, customs.warningShade, customs.darkShade, customs.successShade];
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
          customs.secondaryTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
        ];
      });

      // load technician history
      loadTechnicianHistory(context);

      setState(() {
        _init = true;
      });
    }
  }

  void findKeyWord(keyword){
    var newHistory = [];
    for(var item in collections){
      int present = 0;
      if(item['fullname'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['phone_number'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['email'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['region'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['membership'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['collection_amount'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['technician_id'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }

      // present
      if(present > 0){
        newHistory.add(item);
      }
    }

    // display
    displayCollectionHistory(newHistory);
  }

  void displayCollectionHistory(var list){
    double width = MediaQuery.of(context).size.width;
    List<Widget> history = (list as List<dynamic>).asMap().entries.map((entry) {
      var item = entry.value;
      var index = entry.key;
      return Column(
        children: [
          GestureDetector(
            onTap : () async {
              await Navigator.pushNamed(context, "/edit_member_milk_data", arguments: {"collection_id": item['collection_id'], "index": index});
              // after the window comes back reload the page
              loadTechnicianHistory(context);
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
                    child: Skeleton.ignore(child: Text(customs.nameAbbr(item['fullname'] ?? "-"), style: textStyles[index % textStyles.length],)),
                  ),
                  title: Text(
                    toCamelCase(item['fullname'] ?? "DELETED MEMBER"),
                    style: item['fullname'] != null ? customs.darkTextStyle(size: 14) : customs.dangerTextStyle(size: 14),
                  ),
                  subtitle: Text(
                    "${item['collection_amount'] ?? "0"} Litres",
                    style: customs.secondaryTextStyle(size: 12),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['time'],
                          style: customs.darkTextStyle(size: 10)),
                      Text(
                        item['date'],
                        style: customs.secondaryTextStyle(
                            size: 10, fontweight: FontWeight.normal),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: item['collection_status'] == 1 ? customs.successColor : customs.dangerColor,
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
                  Text("No Collections found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
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
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: CircleAvatar(
                      backgroundColor: customs.primaryShade_2,
                      child: IconButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, "/technician_collect_milk");
                          loadTechnicianHistory(context);
                        },
                        icon: Icon(Icons.add, color: customs.primaryColor,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      );
    }

    //set state
    setState(() {
      collectionHistory = history;
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
          decoration: BoxDecoration(
              color: customs.secondaryShade_2.withOpacity(0.2)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Collection History", style: customs.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
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
                        "Today:",
                        style: customs.secondaryTextStyle(
                            size: 12, fontweight: FontWeight.bold),
                      ),
                      Skeletonizer(
                        enabled: loading,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, "/decline_or_confirmed_collection", arguments: {"collection_status" : "1"});
                              },
                              child: Container(
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
                                            "Confirmed",
                                            style: customs.secondaryTextStyle(
                                                size: 12,
                                                fontweight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "$confirmedCollection Collection(s)",
                                            style: customs.darkTextStyle(
                                                size: 12),
                                          ),
                                          SizedBox(height: 8,),
                                          Row(
                                            children: [
                                              Text("View", style: customs.primaryTextStyle(size: 12, underline: false),),
                                              Icon(Icons.keyboard_double_arrow_right, color: customs.primaryColor, size: 16,)
                                            ],
                                          )
                                        ],
                                      )
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, "/decline_or_confirmed_collection", arguments: {"collection_status" : "0"});
                              },
                              child: Container(
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
                                          color: customs.dangerColor,
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
                                            "Rejected/Pending",
                                            style: customs.secondaryTextStyle(
                                                size: 12,
                                                fontweight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "$notConfirmedCollection collection(s)",
                                            style: customs.darkTextStyle(
                                                size: 12),
                                          ),
                                          SizedBox(height: 8,),
                                          Row(
                                            children: [
                                              Text("View", style: customs.primaryTextStyle(size: 12, underline: false),),
                                              Icon(Icons.keyboard_double_arrow_right, color: customs.primaryColor, size: 16,)
                                            ],
                                          )
                                        ],
                                      )
                                    ]),
                              ),
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Row(children: [
                  Spacer(),
                  Container(
                    width: width * 0.30,
                    child: customs.maruDropDownButton(
                      defaultValue: drop_down,
                      hintText: "Select days",
                      items: dayFilter,
                      onChange: (value) {
                        setState(() {
                          drop_down = value!;
                        });
                        loadTechnicianHistory(context);
                      },
                    ),
                  ),
                ]),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        width: width * 0.8,
                        child: customs.maruSearchTextField(
                            isChanged: (value){
                              findKeyWord(value);
                            },
                            label: "Type to Search",
                            hintText: "Enter keyword")
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: CircleAvatar(
                        backgroundColor: customs.successShade_2,
                        child: IconButton(
                          onPressed: () async {
                            await Navigator.pushNamed(context, "/technician_collect_milk");
                            loadTechnicianHistory(context);
                          },
                          icon: Icon(Icons.add, color: customs.successColor,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: height - 322,
                decoration: BoxDecoration(
                  color: customs.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                // color: Colors.red,
                child: Skeletonizer(
                  enabled: loading,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: collectionHistory,
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

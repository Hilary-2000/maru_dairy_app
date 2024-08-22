import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CollectMilk extends StatefulWidget {
  const CollectMilk({super.key});

  @override
  State<CollectMilk> createState() => _CollectMilkState();
}

class _CollectMilkState extends State<CollectMilk> {
  CustomThemes customs = CustomThemes();
  bool loadMembers = false;
  TextEditingController searchMember = TextEditingController();
  List<Color> colors_shade = [];
  List<TextStyle> textStyles = [];
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies(){
    setState(() {
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
    super.didChangeDependencies();
    double width = MediaQuery.of(context).size.width;
    // initialize the members
    setState(() {
      memberList = [
        Column(
          children: [
            GestureDetector(
              onTap: () {
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
                      backgroundColor: customs.warningShade,
                      child: Text(
                        "PM",
                        style: customs.primaryTextStyle(
                            size: 18, fontweight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      "N/A",
                      style: customs.darkTextStyle(size: 14),
                    ),
                    subtitle: Text(
                      "N/A",
                      style: customs.secondaryTextStyle(size: 12),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("N/A",
                            style: customs.darkTextStyle(size: 12)),
                        Text(
                          "N/A",
                          style: customs.secondaryTextStyle(
                              size: 12,
                              fontweight: FontWeight.normal),
                        ),
                        Container(
                          width: 10,
                          height: 10,
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
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
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
                        "PM",
                        style: customs.primaryTextStyle(
                            size: 18, fontweight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      "N/A",
                      style: customs.darkTextStyle(size: 14),
                    ),
                    subtitle: Text(
                      "N/A",
                      style: customs.secondaryTextStyle(size: 12),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("N/A",
                            style: customs.darkTextStyle(size: 12)),
                        Text(
                          "N/A",
                          style: customs.secondaryTextStyle(
                              size: 12,
                              fontweight: FontWeight.normal),
                        ),
                        Container(
                          width: 10,
                          height: 10,
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
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
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
                      backgroundColor: customs.dangerShade,
                      child: Text(
                        "PM",
                        style: customs.primaryTextStyle(
                            size: 18, fontweight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      "N/A",
                      style: customs.darkTextStyle(size: 14),
                    ),
                    subtitle: Text(
                      "N/A",
                      style: customs.secondaryTextStyle(size: 12),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("N/A",
                            style: customs.darkTextStyle(size: 12)),
                        Text(
                          "N/A",
                          style: customs.secondaryTextStyle(
                              size: 12,
                              fontweight: FontWeight.normal),
                        ),
                        Container(
                          width: 10,
                          height: 10,
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
        ),
      ];
    });

    // GET MEMBERS
    getMembers(context);
  }

  String nameAbbr(String name){
    String abbr = "";
    List<String> words = name.split(' ');
    int length = words.length >=2 ? 2 : words.length;
    for(int index = 0; index < length; index++){
      abbr += words[index].substring(0,1);
    }
    return abbr;
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

  // get the maru member
  List<Widget> memberList = [];
  var members_list = [];
  ApiConnection apiConnection = new ApiConnection();
  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  void getMembers(BuildContext context) async{
    setState(() {
      searchMember.text = "";
      loadMembers = true;
    });
    String? token = await _storage.read(key: 'token');
    String response = await apiConnection.getMembers(token!);
    // print(response);
    if(isValidJson(response)){
      var data = jsonDecode(response);
      double width = MediaQuery.of(context).size.width;
      // GET THE MEMBER DATA
      displayCollectionHistory(data['data']);
      setState(() {
        members_list = data['data'];
        loadMembers = false;
      });
    }else{
      // GET THE MEMBER DATA
      setState(() {
        memberList = [];
        members_list = [];
        loadMembers = false;
      });
    }
  }
  void findKeyWord(keyword){
    var newHistory = [];
    for(var item in members_list){
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
    List <Widget> members = (list as List<dynamic>).asMap().entries.map((entry) {
      var item = entry.value;
      int index = entry.key;
      return Column(
        children: [
          GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(
                  context, "/technician_capture_milk_data",
                  arguments: {"member_id": item['user_id'], "index" : index}
              );
              // get members
              getMembers(context);
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
                      nameAbbr(item['fullname']),
                      style: textStyles[index % colors_shade.length],
                    ),
                  ),
                  title: Text(
                    toCamelCase(item['fullname']),
                    style: customs.darkTextStyle(size: 14),
                  ),
                  subtitle: item['membership'] != null ? Text(item['membership'] ?? "",style: customs.secondaryTextStyle(size: 10),) : SizedBox(),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['region'] ?? "N/A",
                          style: customs.darkTextStyle(size: 12)),
                      Text(
                        item['phone_number'] ?? "N/A",
                        style: customs.secondaryTextStyle(
                            size: 10,
                            fontweight: FontWeight.normal),
                      ),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: item['collected_today'] ? customs.successColor : null,
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
    }).toList();
    // GET THE MEMBER DATA
    setState(() {
      memberList = members;
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
            child: Column(
              children: [
                Container(
                  width : width*0.9,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text("Select member", style: customs.darkTextStyle(size: 16, fontweight: FontWeight.bold))
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
                          editingController: searchMember,
                            isChanged: (value) {
                              findKeyWord(value);
                            },
                            hintText: "Start typing to search!"
                        ),
                      ),
                      IconButton(onPressed: (){Navigator.pushNamed(context, "/find_member_scanner");}, icon: Icon(Icons.qr_code, size: 30,))
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
                  height: height - 130,
                  decoration: BoxDecoration(
                      color: customs.whiteColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: SingleChildScrollView(
                    child: Skeletonizer(
                      enabled: loadMembers,
                      child: Column(
                        children: memberList,
                      ),
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

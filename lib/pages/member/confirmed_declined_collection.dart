import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ConfirmedDeclinedCollection extends StatefulWidget {
  const ConfirmedDeclinedCollection({super.key});

  @override
  State<ConfirmedDeclinedCollection> createState() => _ConfirmedDeclinedCollectionState();
}

class _ConfirmedDeclinedCollectionState extends State<ConfirmedDeclinedCollection> {
  CustomThemes customs = CustomThemes();
  List<Widget> collectionHistory = [];
  List<Color> colors_shade = [];
  List<TextStyle> textStyles = [];
  bool loading = false;
  String collectionStatus = "1";
  Map<String, dynamic>? args;
  var membersHistory = [];
  TextEditingController searchMember = new TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
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

  Future<void> loadCollectionHistory(BuildContext context) async {
    print("In");
    setState(() {
      loading = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    String? token = await _storage.read(key: 'token');
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if(isValidJson(jsonEncode(args))){
      var passedData = jsonDecode(jsonEncode(args));
      var response = await apiConnection.getCollection(token!, passedData['collection_status'], "7 days");
      collectionStatus = passedData['collection_status'];


      print(response.substring(response.length-1, response.length));
      // make the response json
      if(response.substring(response.length-1, response.length) == "]"){
        // sometimes it cuts the last character making it not a json format, add it when that happens
        response += "}";
      }
      if(isValidJson(response)){
        var res = jsonDecode(response);
        if(res['success']){
          setState(() {
            membersHistory = res['collection_history'];
          });
          displayCollectionHistory(membersHistory);
        }else{
          setState(() {
            collectionHistory = [];
          });
        }
      }else{
        setState(() {
          collectionHistory = [];
        });
      }
    }else{
      setState(() {
        collectionHistory = [];
      });
    }
    setState(() {
      loading = false;
    });
  }

  void displayCollectionHistory(var list){
    double width = MediaQuery.of(context).size.width;
    List <Widget> members = (list as List<dynamic>).asMap().entries.map((entry) {
      var item = entry.value;
      var index = entry.key;
      return Column(
        children: [
          GestureDetector(
            onTap : () async {
              await Navigator.pushNamed(context, "/edit_member_milk_data", arguments: {"collection_id": item['collection_id'], "index": index});
              loadCollectionHistory(context);
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
                    child: Skeleton.ignore(child: Text(nameAbbr(item['fullname']), style: textStyles[index % textStyles.length],)),
                  ),
                  title: Text(
                    toCamelCase(item['fullname']),
                    style: customs.darkTextStyle(size: 14),
                  ),
                  subtitle: Text(
                    "${item['collection_amount']} Litres",
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


    if(members.length == 0){
      members.add(
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
                    Text("No collection found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
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
                    searchMember.text.length > 0 ? Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Text(
                          "Members with this \"${searchMember.text}\" keyword not found!",
                          style: customs.primaryTextStyle(size: 14, fontweight: FontWeight.normal),
                        )
                    ) : SizedBox(height: 0, width: 0,),
                  ],
                ),
              ),
            ],
          )
      );
    }
    setState(() {
      collectionHistory = members;
    });
  }

  void findKeyWord(keyword){
    var newHistory = [];
    for(var item in membersHistory){
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

  void didChangeDependencies(){
    super.didChangeDependencies();
    // set the technicians history
    double width = MediaQuery.of(context).size.width;
    setState(() {
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

    // load collection history
    loadCollectionHistory(context);
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
                color: customs.secondaryShade_2.withOpacity(0.2)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(collectionStatus == "1" ? "Confirmed Collections" : (collectionStatus == "0" ? "Rejected/Pending Collection" : "Not-Confirmed Collection"), style: collectionStatus == "1" ? customs.successTextStyle(size: 20, fontweight: FontWeight.bold) : customs.secondaryTextStyle(size: 20, fontweight: FontWeight.bold),),
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
                      "Last 7 days",
                      textAlign: TextAlign.left,
                      style:
                      customs.secondaryTextStyle(size: 12, underline: true),
                    ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.9,
                          child: customs.maruSearchTextField(
                              isChanged: (value){
                                findKeyWord(value);
                              },
                              editingController: searchMember,
                              label: "Type to Search",
                              hintText: "Enter keyword")
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: height - 140,
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
      )),
    );
  }
}

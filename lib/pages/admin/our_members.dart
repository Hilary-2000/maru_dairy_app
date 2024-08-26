import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OurMembers extends StatefulWidget {
  const OurMembers({super.key});

  @override
  State<OurMembers> createState() => _OurMembersState();
}

class _OurMembersState extends State<OurMembers> {
  CustomThemes customs = CustomThemes();
  List<Widget> members = [];
  bool loading = false;
  var member_list = [];
  List<Color> colors_shade = [];
  List<TextStyle> textStyles = [];

  Future<void> getMembers() async {
    setState(() {
      loading = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.adminMembers();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          member_list = res['members'];
        });

        //display
        displayMembers(member_list);
      }else{
        customs.maruSnackBarDanger(context: context, text: "Fatal error occurred!");
      }
    }else{
      customs.maruSnackBarDanger(context: context, text: "An error occurred!");
    }
    setState(() {
      loading = false;
    });
  }

  void displayMembers(var list){
    double width = MediaQuery.of(context).size.width;
    List<Widget> collects = (list as List<dynamic>).asMap().entries.map((entry) {
      var item = entry.value;
      var index = entry.key;
      return Column(
        children: [
          GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(context, "/admin_member_details", arguments: {"index" : index, "member_id": item['user_id']});
            getMembers();
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
                    Text(item['region'] ?? "",
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
    }).toList();

    setState(() {
      members = collects;
    });
  }

  void didChangeDependencies(){
    super.didChangeDependencies();

    // double width
    double width = MediaQuery.of(context).size.width;
    setState(() {
      members = [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
                context, "/admin_member_details");
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
                  "Patrick Mugoh",
                  style: customs.darkTextStyle(size: 14),
                ),
                subtitle: Text(
                  "REG2024-003",
                  style: customs.secondaryTextStyle(size: 12),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Njebi",
                        style: customs.darkTextStyle(size: 12)),
                    Text(
                      "0713620727",
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
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
                context, "/admin_member_details");
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
                  child: Text(
                    "JM",
                    style: customs.successTextStyle(
                        size: 18, fontweight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  "Jackline Murume",
                  style: customs.darkTextStyle(size: 14),
                ),
                subtitle: Text(
                  "REG2024-004",
                  style: customs.secondaryTextStyle(size: 12),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Munyu/Kiriti",
                        style: customs.darkTextStyle(size: 12)),
                    Text(
                      "0713622727",
                      style: customs.secondaryTextStyle(
                          size: 12,
                          fontweight: FontWeight.normal),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: customs.successColor,
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
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
                context, "/admin_member_details");
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
                  backgroundColor: customs.warningShade_2,
                  child: Text(
                    "GM",
                    style: customs.warningTextStyle(
                        size: 18, fontweight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  "Gloria Muwanguzi",
                  style: customs.darkTextStyle(size: 14),
                ),
                subtitle: Text(
                  "REG2024-006",
                  style: customs.secondaryTextStyle(size: 12),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Njebi",
                        style: customs.darkTextStyle(size: 12)),
                    Text(
                      "0713620727",
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
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
                context, "/admin_member_details");
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
                  child: Text(
                    "PQ",
                    style: customs.secondaryTextStyle(
                        size: 18, fontweight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  "Patrick Quacco",
                  style: customs.darkTextStyle(size: 14),
                ),
                subtitle: Text(
                  "REG2024-003",
                  style: customs.secondaryTextStyle(size: 12),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Kiriti",
                        style: customs.darkTextStyle(size: 12)),
                    Text(
                      "0713620727",
                      style: customs.secondaryTextStyle(
                          size: 12,
                          fontweight: FontWeight.normal),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: customs.successColor,
                          borderRadius:BorderRadius.circular(5)
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
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

    //get the members
    getMembers();
  }

  void findKeyWord(keyword){
    var newHistory = [];
    for(var item in member_list){
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

      // present
      if(present > 0){
        newHistory.add(item);
      }
    }

    // display
    displayMembers(newHistory);
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
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.7,
                      child: customs.maruSearchTextField(
                          isChanged: (value) {
                            findKeyWord(value);
                          },
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
              Skeletonizer(
                enabled: loading,
                child: Container(
                  width: width * 0.95,
                  padding: const EdgeInsets.all(8),
                  height: height - 90,
                  decoration: BoxDecoration(
                      color: customs.whiteColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: members,
                    ),
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

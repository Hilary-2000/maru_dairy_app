import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';

class MilkPrices extends StatefulWidget {
  const MilkPrices({super.key});

  @override
  State<MilkPrices> createState() => _MilkPricesState();
}

class _MilkPricesState extends State<MilkPrices> {
  CustomThemes customs = CustomThemes();
  TextEditingController searchField = new TextEditingController();
  Border borders = Border();
  Border borders_2 = Border();
  Border borders_3 = Border();
  Border borders_4 = Border();
  String current_price = "Kes 0";
  bool loading = false;
  var table_data = [];
  List<Widget> table_rows = [];


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    double width = MediaQuery.of(context).size.width;

    // setState
    setState(() {
      borders = Border(
                    left: BorderSide(color: customs.secondaryShade_2, width: 1),
                    top: BorderSide(color: customs.secondaryShade_2, width: 1),
                    bottom: BorderSide(color: customs.secondaryShade_2, width: 1),
                    // right: BorderSide(color: customs.secondaryShade_2, width: 1)
                );
      borders_2 = Border(
        // left: BorderSide(color: customs.secondaryShade_2, width: 1),
        top: BorderSide(color: customs.secondaryShade_2, width: 1),
        bottom: BorderSide(color: customs.secondaryShade_2, width: 1),
        // right: BorderSide(color: customs.secondaryShade_2, width: 1)
      );
      borders_3 = Border(
        // left: BorderSide(color: customs.secondaryShade_2, width: 1),
        top: BorderSide(color: customs.secondaryShade_2, width: 1),
        bottom: BorderSide(color: customs.secondaryShade_2, width: 1),
        right: BorderSide(color: customs.secondaryShade_2, width: 1)
      );
      borders_4 = Border(
        left: BorderSide(color: customs.secondaryShade_2, width: 1),
        top: BorderSide(color: customs.secondaryShade_2, width: 1),
        bottom: BorderSide(color: customs.secondaryShade_2, width: 1),
        right: BorderSide(color: customs.secondaryShade_2, width: 1)
      );

      // table row
      table_rows = [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders
                ),
                child: Center(child: Text("45.52", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 3.5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_2
                ),
                child: Center(child: Text("12th Aug 24", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 3.5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_2
                ),
                child: Center(child: Text("25th Aug 24", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_3
                ),
                child: Center(child: CircleAvatar(backgroundColor: Colors.transparent, child: Icon(Icons.edit, size: 15, color: customs.secondaryColor,))),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders
                ),
                child: Center(child: Text("45.52", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 3.5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_2
                ),
                child: Center(child: Text("12th Aug 24", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 3.5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_2
                ),
                child: Center(child: Text("25th Aug 24", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_3
                ),
                child: Center(child: CircleAvatar(backgroundColor: Colors.transparent, child: Icon(Icons.edit, size: 15, color: customs.secondaryColor,))),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders
                ),
                child: Center(child: Text("45.52", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 3.5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_2
                ),
                child: Center(child: Text("12th Aug 24", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 3.5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_2
                ),
                child: Center(child: Text("25th Aug 24", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_3
                ),
                child: Center(child: CircleAvatar(backgroundColor: Colors.transparent, child: Icon(Icons.edit, size: 15, color: customs.secondaryColor,))),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders
                ),
                child: Center(child: Text("45.52", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 3.5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_2
                ),
                child: Center(child: Text("12th Aug 24", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 3.5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_2
                ),
                child: Center(child: Text("25th Aug 24", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_3
                ),
                child: Center(child: CircleAvatar(backgroundColor: Colors.transparent, child: Icon(Icons.edit, size: 15, color: customs.secondaryColor,))),
              )
            ],
          ),
        )
      ];
    });

    //get the milk prices
    getMilkPrices();
  }

  Future<void> getMilkPrices() async {
    setState(() {
      loading = true;
    });
    ApiConnection apiConnection = ApiConnection();
    var response = await apiConnection.getMilkPrices();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      print(res);
      if(res['success']){
        setState(() {
          setState(() {
            table_data = res['milk_prices'];
            current_price = "Kes ${res['current_price']}";
          });
          displayTable(table_data);
        });
      }else{
        setState(() {
          setState(() {
            table_data = [];
            current_price = "Kes 0";
          });
          displayTable(table_data);
        });
        customs.maruSnackBarDanger(context: context, text: "An error has occured!");
      }
    }
    setState(() {
      loading = false;
    });
  }

  void displayTable(var list){
    double width = MediaQuery.of(context).size.width;
    List<Widget> history = (list as List<dynamic>).asMap().entries.map((entry) {
      var item = entry.value;
      return
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders
                ),
                child: Center(child: Text("${item['amount']}", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 3.5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_2
                ),
                child: Center(child: Text("${item['effect_date']}", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 3.5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_2
                ),
                child: Center(child: Text("${item['end_date']}", style: customs.secondaryTextStyle(size: 14,),)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: width / 5,
                height: 50,
                decoration: BoxDecoration(
                    border: borders_3
                ),
                child: Center(child: CircleAvatar(backgroundColor: Colors.transparent, child: Icon(Icons.edit, size: 15, color: customs.secondaryColor,))),
              )
            ],
          ),
        );
    }).toList();

    if(history.length == 0){
      history.add(
          Container(
            child: Column(
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
                      Text("No milk prices found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
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
                              await Navigator.pushNamed(context, "/change_milk_price");
                              getMilkPrices();
                            },
                            icon: Icon(Icons.add_circle_rounded, color: customs.primaryColor,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
      );
    }
    setState(() {
      table_rows = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.primaryShade,
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
          return Skeletonizer(
            enabled: loading,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(color: customs.whiteColor),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Milk Prices",
                          style: customs.darkTextStyle(
                              size: 20, fontweight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    width: width,
                    child: RichText(
                      text: TextSpan(text: "Current Price : ", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold), children: [TextSpan(text: "$current_price", style: customs.primaryTextStyle(size: 14, underline: true))]),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: width / 3,
                        height: 50,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: width / 1.5,
                        height: 50,
                        child: Center(
                          child: customs.maruSearchTextField(
                            isChanged: (value){},
                            editingController: searchField,
                            hintText: "Type to search!",
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          width: width / 5,
                          height: 50,
                          decoration: BoxDecoration(
                              border: borders
                          ),
                          child: Center(child: Text("Price (Kes)", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold),)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          width: width / 3.5,
                          height: 50,
                          decoration: BoxDecoration(
                              border: borders_2
                          ),
                          child: Center(child: Text("Effective Date", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold),)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          width: width / 3.5,
                          height: 50,
                          decoration: BoxDecoration(
                              border: borders_2
                          ),
                          child: Center(child: Text("End Date", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold),)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          width: width / 5,
                          height: 50,
                          decoration: BoxDecoration(
                              border: borders_3
                          ),
                          child: Center(child: Text("Action", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold),)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: height - 190,
                    width: width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: table_rows,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      )),
      floatingActionButton: CircleAvatar(
        radius: 25,
        backgroundColor: customs.secondaryShade_2,
        child: IconButton(
          icon: Icon(
            Icons.add_circle_rounded,
            size: 35,
            color: customs.secondaryColor,
          ),
          onPressed: () async {
            await Navigator.pushNamed(context, "/change_milk_price");
            getMilkPrices();
          },
        ),
      ),
    );
  }
}

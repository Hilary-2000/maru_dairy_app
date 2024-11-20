import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  var display_data = [];
  bool _initialized = false;
  List<String> items = List<String>.generate(100, (index) => "Item $index");

  void findKeyWord(keyword){
    var newHistory = [];
    for(var item in table_data){
      int present = 0;
      if(item['amount'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['effect_date'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['end_date'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['status'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }

      // present
      if(present > 0){
        newHistory.add(item);
      }
    }

    // set state
    setState(() {
      display_data = newHistory;
    });

    // display
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


    if(!_initialized){
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
        display_data = [];

      });

      //get the milk prices
      getMilkPrices();

      setState(() {
        _initialized = !_initialized;
      });
    }
  }

  Future<void> getMilkPrices() async {
    setState(() {
      loading = true;
    });
    ApiConnection apiConnection = ApiConnection();
    var response = await apiConnection.getMilkPrices();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          setState(() {
            table_data = res['milk_prices'];
            display_data = res['milk_prices'];
            current_price = "Kes ${res['current_price']}";
          });
        });
      }else{
        setState(() {
          setState(() {
            table_data = [];
            display_data = [];
            current_price = "Kes 0";
          });
        });
        customs.maruSnackBarDanger(context: context, text: "An error has occured!");
      }
    }
    setState(() {
      loading = false;
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
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(color: customs.whiteColor),
            child: Column(
              children: [
                Skeletonizer(
                  enabled: loading,
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
                    ],
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
                        child: display_data.length > 0 ? customs.maruSearchTextField(
                          isChanged: (value){
                            findKeyWord(value);
                          },
                          editingController: searchField,
                          hintText: "Type to search!",
                        ) : SizedBox(),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: width/1.5,
                  child: Divider(),
                ),
                SizedBox(height: 10,),
                Container(
                  height: height - 190,
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: !loading ? (display_data.length > 0 ? ListView.builder(
                    itemCount: display_data.length,
                    itemBuilder: (context, index) {
                      var item = display_data[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: customs.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: customs.secondaryShade_2, blurRadius: 2, spreadRadius: 1),
                            BoxShadow(color: customs.secondaryShade_2, blurRadius: 2, spreadRadius: 1),
                            BoxShadow(color: customs.secondaryShade_2, blurRadius: 2, spreadRadius: 1),
                            BoxShadow(color: customs.secondaryShade_2, blurRadius: 2, spreadRadius: 1),
                            BoxShadow(color: customs.secondaryShade_2, blurRadius: 2, spreadRadius: 1),
                          ]
                        ),
                        child: ListTile(
                          leading: Icon(Icons.label, size: 20, color: item['status'] == 1 ? customs.successColor : customs.secondaryColor,),
                          title: Row(
                            children: [
                              Text("Kes ${item['amount']}", style: customs.secondaryTextStyle(size: 17, fontweight: FontWeight.bold),),
                              SizedBox(
                                width: 10,
                              ),
                              item['current'] ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                decoration: BoxDecoration(
                                  color: customs.successColor,
                                  borderRadius: BorderRadius.circular(2)
                                ),
                                child: Text("Current", style: customs.whiteTextStyle(size: 10, fontweight: FontWeight.bold),),
                              ) : SizedBox(height: 0, width: 0,)
                            ],
                          ),
                          subtitle: Text(item['status'] == 1 ? '${item['effect_date']} to ${item['end_date']}' : "Not-published", style: customs.secondaryTextStyle(size: 14),),
                          isThreeLine: false,
                          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15,),
                          onTap: () async {
                            // Handle the tap event
                            await Navigator.pushNamed(context, "/update_milk_prices", arguments: {"price_id": item['price_id']});
                            getMilkPrices();
                          },
                        ),
                      );
                    },
                  ) :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Container(
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
                                        radius: 30,
                                        child: IconButton(
                                          onPressed: () async {
                                            await Navigator.pushNamed(context, "/change_milk_price");
                                            getMilkPrices();
                                          },
                                          icon: Icon(Icons.add_circle_rounded, size: 40, color: customs.primaryColor,),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitCircle(
                        color: customs.primaryColor,
                        size: 50.0,
                      ),
                      Text("Loading Milk Prices...", style: customs.primaryTextStyle(size: 10,))
                    ],
                  ),
                ),
              ],
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
            size: 30,
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

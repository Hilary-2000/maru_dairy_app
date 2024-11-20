import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CaptureMilkData extends StatefulWidget {
  const CaptureMilkData({super.key});

  @override
  State<CaptureMilkData> createState() => _CaptureMilkDataState();
}

class _CaptureMilkDataState extends State<CaptureMilkData> {
  CustomThemes customs = CustomThemes();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  // DateTime? _selectedDate;
  // DateTime? _selectedTime;
  ApiConnection apiConnection = new ApiConnection();
  List<Color> colors_shade = [];
  List<Color> bg_color = [];
  List<TextStyle> textStyles = [];
  bool _init = false;

  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  TextEditingController amountCollected = TextEditingController();
  bool saveLoader = false;

  Map<String, dynamic>? args;
  bool loading = false;

  // member data
  String member_id = "";
  String memberName = "N/A";
  String prevCollection = "N/A";
  String prevDate = "N/A";
  String memberShipNumber = "N/A";
  String prevTime = "N/A";

  // get the member details
  Future<void> memberData() async {
    // Access the passed arguments here
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if(isValidJson(jsonEncode(args))){
      String? token = await _storage.read(key: 'token');
      var passedData = jsonDecode(jsonEncode(args));
      print(passedData['member_id']);

      //get the member data
      var response = await apiConnection.getMemberData(token!, passedData['member_id'].toString());
      // print(response);
      if(isValidJson(response.toString())){
        // get the farmer`s data
        setState(() {
          loading = false;
        });

        // get the string
        var res = jsonDecode(response.toString());
        if(res['success']){
          setState(() {
            memberName = res['member']['fullname'].toString();
            member_id = res['member']['user_id'].toString();
            memberShipNumber = res['member']['membership'].toString();
            prevCollection = res['previous'] != null ? res['previous']['collection_amount'].toString()+" Litres" : "N/A";
            prevDate = res['previous'] != null ? res['previous']['collection_date'].toString() : "N/A";
            prevTime = res['previous'] != null ? res['previous']['collection_time'].toString() : "N/A";
          });
        }else{
          //return to the previous page
          Navigator.pop(context);
        }
      }else{
        //return to the previous page
        Navigator.pop(context);
      }
    }else{
      //return to the previous page
      // Navigator.pop(context);
    }
  }

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    if(!_init){
      setState(() {
        loading = true;
        bg_color = [customs.primaryColor, customs.secondaryColor, customs.warningColor, customs.darkColor, customs.successColor];
        colors_shade = [customs.primaryShade, customs.secondaryShade, customs.warningShade, customs.darkShade, customs.successShade];
        textStyles = [
          customs.primaryTextStyle(
              size: 30,
              fontweight: FontWeight.bold
          ),
          customs.secondaryTextStyle(
              size: 30,
              fontweight: FontWeight.bold
          ),
          customs.warningTextStyle(
              size: 30,
              fontweight: FontWeight.bold
          ),
          customs.darkTextStyle(
              size: 30,
              fontweight: FontWeight.bold
          ),
          customs.secondaryTextStyle(
              size: 30,
              fontweight: FontWeight.bold
          ),
        ];
      });
      await memberData();
      setState(() {
        _init = true;
      });
    }
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
            color: customs.secondaryShade_2.withOpacity(0.2),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: Text(
                      "Collect Milk Data",
                      style: customs.darkTextStyle(
                          size: 15, fontweight: FontWeight.bold),
                    ),
                  ),
                  Skeletonizer(
                    enabled: loading,
                    child: Stack(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width: width,
                        height: 280,
                        child: Column(
                          children: [
                            Container(
                              width: width * 0.9,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8)),
                                  color: bg_color[jsonDecode(jsonEncode(args))['index'] % bg_color.length]),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              width: width * 0.9,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                                color: customs.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.2), // Shadow color with opacity
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 5, // Blur radius
                                    offset: const Offset(
                                        0, 1), // Offset in the x and y direction
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  Text(
                                    memberName,
                                    style: customs.darkTextStyle(
                                        size: 20, fontweight: FontWeight.bold),
                                  ),
                                  Text(
                                    memberShipNumber,
                                    style: customs.secondaryTextStyle(
                                        size: 12, fontweight: FontWeight.normal),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // its the widest container
                                      Container(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Last Collection Date : ",
                                            style: customs.secondaryTextStyle(
                                                size: 12,
                                                fontweight: FontWeight.bold),
                                          ),
                                          Text(
                                            prevDate,
                                            style: customs.secondaryTextStyle(
                                                size: 12,
                                                fontweight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Collection Amount",
                                            style: customs.secondaryTextStyle(
                                                size: 12,
                                                fontweight: FontWeight.bold),
                                          ),
                                          Text(
                                            "$prevCollection",
                                            style: customs.secondaryTextStyle(
                                                size: 12,
                                                fontweight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 65, // Adjust this value to move the CircleAvatar up
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CircleAvatar(
                              radius: width * 0.1,
                              backgroundColor: colors_shade[jsonDecode(jsonEncode(args))['index'] % colors_shade.length],
                              child: Skeleton.ignore(child: Text( memberName != "N/A" ? customs.nameAbbr(memberName) : "N/A", style: textStyles[jsonDecode(jsonEncode(args))['index'] % textStyles.length],))
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      padding: EdgeInsets.all(8),
                      width: width*0.9,
                      decoration: BoxDecoration(
                        color: customs.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: customs.secondaryShade,
                            blurRadius: 5,
                            spreadRadius: 1
                          )
                        ]
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text("Capture Milk Data", style: customs.secondaryTextStyle(size: 15, fontweight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            Container(
                              child: customs.maruTextFormField(
                                editingController: amountCollected,
                                isChanged: (value){},
                                hintText: "Milk amount in Litres",
                                label: "Milk amount in Litres",
                                textType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter Milk quantity!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              width: width*0.9,
                              child: customs.maruButton(
                                fontSize: 15,
                                showLoader: saveLoader,
                                disabled: saveLoader,
                                type: Type.success,
                                text: "Save",
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      saveLoader = true;
                                    });

                                    // this mean everything is fine!
                                    ApiConnection apiConnection = new ApiConnection();
                                    String? token = await _storage.read(key: 'token');
                                    var response = await apiConnection.collectMilkData(token!, member_id, amountCollected.text);
                                    if(isValidJson(response)){
                                      var res = jsonDecode(response);
                                      if(res['success']){
                                        customs.maruSnackBarSuccess(context: context, text: res['message']);
                                      }
                                    }else{
                                      customs.maruSnackBarDanger(context: context, text: "An error has occured!");
                                    }

                                    // save
                                    setState(() {
                                      saveLoader = false;
                                    });

                                    await memberData();
                                  }
                                }
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}

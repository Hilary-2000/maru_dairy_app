import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UpdateMilkPrices extends StatefulWidget {
  const UpdateMilkPrices({super.key});

  @override
  State<UpdateMilkPrices> createState() => _UpdateMilkPricesState();
}

class _UpdateMilkPricesState extends State<UpdateMilkPrices> {
  // customs
  CustomThemes customs = CustomThemes();
  double _currentDoubleValue = 45.0;
  double current_price = 45.0;
  String date = "Mon, 25th Aug 2024";
  DateTime date_time = DateTime.now();
  bool save_n_publish = false;
  Map<String, dynamic>? args;
  String collection_id = "-0";
  var price_data = null;
  bool loading = false;
  bool _initialized = false;
  DateTime minimum_date = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_initialized){
      //date format
      date = DateFormat('EEE, d MMM yyyy').format(date_time);
      getCurrentMilkDetails();
      setState(() {
        _initialized = true;
      });
    }
  }

  Future<void> getCurrentMilkDetails() async {
    setState(() {
      loading = true;
    });
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String price_id = args!['price_id'].toString();
    setState(() {
      collection_id = price_id;
    });
    ApiConnection apiConnection = ApiConnection();
    var response = await apiConnection.getEditMilkDetails(price_id);
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          price_data = res['milk_price_details'];
          _currentDoubleValue = double.parse(res['milk_price_details']['amount']);
          current_price = double.parse(res['current_price'].toString());
          date_time = DateTime.parse(res['milk_price_details']['effect_date']);
          date = DateFormat('EEE, d MMM yyyy').format(date_time);
          minimum_date = DateTime.parse(res['minimum_date']);
        });
      }else{
        setState(() {
          _currentDoubleValue = 0;
        });
      }
    }else{
      setState(() {
        _currentDoubleValue = 0;
      });
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
                      child: Image(
                          image: AssetImage("assets/images/maru-nobg.png")),
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
                Container(
                  height: height - 5,
                  width: width,
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "Edit Milk Price",
                                style: customs.darkTextStyle(
                                    size: 20, fontweight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Skeletonizer(
                          enabled: loading,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            width: width,
                            child: RichText(
                                text: TextSpan(
                                    text: "Current Milk Prices:",
                                    style: customs.secondaryTextStyle(
                                        size: 14, fontweight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text:
                                          " Kes $current_price per Litre",
                                          style: customs.secondaryTextStyle(size: 14)
                                      )
                                    ]
                                )
                            ),
                          ),
                        ),
                        Skeletonizer(
                          enabled: loading,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            width: width,
                            child: RichText(
                              text: TextSpan(
                                  text: "Milk Price per Litre:",
                                  style: customs.secondaryTextStyle(
                                    size: 14, fontweight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text: " Kes $_currentDoubleValue per Litre",
                                          style: customs.primaryTextStyle(size: 14)
                                      )
                                    ]
                                )
                            ),
                          ),
                        ),
                        Skeletonizer(
                          enabled: loading,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            width: width,
                            child: RichText(
                                text: TextSpan(
                                    text: "Effect Date:",
                                    style: customs.secondaryTextStyle(
                                        size: 14, fontweight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text:
                                          " $date",
                                          style: customs.primaryTextStyle(size: 14))
                                    ]
                                )
                            ),
                          ),
                        ),
                        Container(
                          width: width/2,
                          child: Divider(
                            color: customs.secondaryShade_2,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                    text: "Scroll to set price",
                                    style: customs.secondaryTextStyle(
                                        size: 14,
                                        fontweight: FontWeight.bold
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: width * 0.5,
                            child: Divider(
                              color: customs.secondaryShade_2,
                              height: 30,
                            )
                        ),
                        DecimalNumberPicker(
                          value: _currentDoubleValue,
                          minValue: 0,
                          maxValue: 1000,
                          decimalPlaces: 2,
                          textStyle: customs.secondaryTextStyle(
                            size: 20,
                          ),
                          selectedTextStyle: customs.secondaryTextStyle(
                            size: 30,
                          ),
                          haptics: true,
                          onChanged: (value){
                            setState(() => _currentDoubleValue = value);
                          },
                        ),
                        SizedBox(
                            width: width * 0.5,
                            child: Divider(
                              color: customs.secondaryShade_2,
                              height: 30,
                            )
                        ),
                        Container(
                            padding: EdgeInsets.all(8.0),
                            width: width/2,
                            child: customs.marOutlineuButton(
                                text: "Click to Set Date",
                                onPressed: () {
                                  BottomPicker.date(
                                    pickerTitle: Text(
                                      'Set the effect date',
                                      style: customs.secondaryTextStyle(
                                        fontweight: FontWeight.bold,
                                        size: 15,
                                      ),
                                    ),
                                    dateOrder: DatePickerDateOrder.dmy,
                                    initialDateTime: date_time,
                                    maxDateTime: DateTime.now().add(Duration(days: 100)),
                                    minDateTime: minimum_date,
                                    pickerTextStyle: customs.secondaryTextStyle(size: 13, fontweight: FontWeight.bold),
                                    onSubmit: (index) {
                                      setState(() {
                                        date_time = index;
                                        date = DateFormat('EEE, d MMM yyyy').format(date_time);
                                      });
                                    },
                                    bottomPickerTheme: BottomPickerTheme.blue,
                                  ).show(context);
                                },
                                fontSize: 14
                            )
                        ),
                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: width/2.2,
                                child:
                                price_data != null ? price_data['status'] == 0 ? customs.marOutlineuButton(
                                    text: "Update",
                                    disabled: save_n_publish,
                                    showLoader: save_n_publish,
                                    onPressed: () async {
                                      setState(() {
                                        save_n_publish = true;
                                      });
                                      ApiConnection apiConnection = ApiConnection();
                                      var datapass = {
                                        "amount": _currentDoubleValue,
                                        "effect_date": DateFormat('yyyyMMdd').format(date_time),
                                        "status" : "0",
                                        "price_id":collection_id
                                      };
                                      var res = await apiConnection.updateMilkPrice(datapass);
                                      if(customs.isValidJson(res)){
                                        var response = jsonDecode(res);
                                        if(response['success']){
                                          customs.maruSnackBarSuccess(context: context, text: response['message']);
                                          Navigator.pop(context);
                                        }else{
                                          customs.maruSnackBarDanger(context: context, text: response['message']);
                                        }
                                      }
                                      setState(() {
                                        save_n_publish = false;
                                      });
                                    },
                                    type: Type.success
                                ) : customs.marOutlineuButton(
                                    text: "Update & Un-Publish",
                                    fontSize: 13,
                                    disabled: save_n_publish,
                                    showLoader: save_n_publish,
                                    onPressed: () async {
                                      LocalAuthentication auth = LocalAuthentication();
                                      bool proceed = await customs.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to find technician!");
                                      if(proceed){
                                        setState(() {
                                          save_n_publish = true;
                                        });
                                        ApiConnection apiConnection = ApiConnection();
                                        var datapass = {
                                          "amount": _currentDoubleValue,
                                          "effect_date":DateFormat('yyyyMMdd').format(date_time),
                                          "status" : "0",
                                          "price_id":collection_id
                                        };
                                        var res = await apiConnection.updateMilkPrice(datapass);
                                        if(customs.isValidJson(res)){
                                          var response = jsonDecode(res);
                                          if(response['success']){
                                            customs.maruSnackBarSuccess(context: context, text: response['message']);
                                            Navigator.pop(context);
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: response['message']);
                                          }
                                        }
                                        setState(() {
                                          save_n_publish = false;
                                        });
                                      }else{
                                        customs.maruSnackBarDanger(context: context, text: "Authenticated failed!");
                                      }
                                    },
                                    type: Type.danger
                                ) : SizedBox(height: 0, width: 0,),
                              ),
                              Spacer(),
                              Container(
                                width: width/2.1,
                                child: customs.maruButton(
                                    text: "Update & Publish",
                                    disabled: save_n_publish,
                                    showLoader: save_n_publish,
                                    onPressed: () async {
                                      LocalAuthentication auth = LocalAuthentication();
                                      bool proceed = await customs.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to find technician!");
                                      if(proceed){
                                        setState(() {
                                          save_n_publish = true;
                                        });
                                        ApiConnection apiConnection = ApiConnection();
                                        var datapass = {
                                          "amount": _currentDoubleValue,
                                          "effect_date":DateFormat('yyyyMMdd').format(date_time),
                                          "status" : "1",
                                          "price_id":collection_id
                                        };
                                        var res = await apiConnection.updateMilkPrice(datapass);
                                        if(customs.isValidJson(res)){
                                          var response = jsonDecode(res);
                                          if(response['success']){
                                            customs.maruSnackBarSuccess(context: context, text: response['message']);
                                            Navigator.pop(context);
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: response['message']);
                                          }
                                        }
                                        setState(() {
                                          save_n_publish = false;
                                        });
                                      }else{
                                        customs.maruSnackBarDanger(context: context, text: "Authenticated failed!");
                                      }
                                    },
                                    type: Type.success
                                ),
                              )
                            ],
                          ),
                        )
                      ],
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class MemberMilkDetails extends StatefulWidget {
  const MemberMilkDetails({super.key});

  @override
  State<MemberMilkDetails> createState() => _MemberMilkDetailsState();
}

class _MemberMilkDetailsState extends State<MemberMilkDetails> {
  Map<String, dynamic>? args;
  CustomThemes customs = CustomThemes();
  var collection_details = null;
  int collection_status = 0;
  bool loading = false;
  bool all_status = false;
  String milk_price = "0";
  String ppl = "0";
  bool _init = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_init){
      //get the milk details
      getMilkDetails();

      setState(() {
        _init = true;
      });
    }
  }

  Future<void> changeStatus(String status) async {
    setState(() {
      all_status = true;
    });
    ApiConnection apiConnection = ApiConnection();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String collection_id = args!['collection_id'].toString();
    var response = await apiConnection.changeMilkStatus(status, collection_id);
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        customs.maruSnackBarSuccess(context: context, text: "Status changed successfully!");
        getMilkDetails();
      }else{
        customs.maruSnackBarDanger(context: context, text: res['message']);
      }
    }else{
      customs.maruSnackBarDanger(context: context, text: "An error has occured!");
    }
    setState(() {
      all_status = false;
    });
  }

  // get the milk details
  Future<void> getMilkDetails() async {
    setState(() {
      loading = true;
    });

    // API CONNECTION
    ApiConnection apiConnection = ApiConnection();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String collection_id = args!['collection_id'].toString();
    var response = await apiConnection.getMilkDetails(collection_id);
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          collection_details = res['milk_details'];
          collection_status = res['milk_details']['collection_status'];
          milk_price = res['milk_details']['price'];
          ppl = res['milk_details']['ppl'];
        });
      }else{
        setState(() {
          collection_details = null;
          collection_status = 0;
        });
      }
    }else{
      setState(() {
        collection_details = null;
        collection_status = 0;
      });
    }
    setState(() {
      loading = false;
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
              color: customs.whiteColor,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: customs.whiteColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Collection Details", style: customs.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.1,),
                  Skeletonizer(
                    enabled: loading,
                    child: Stack(
                      children: [
                        Center(child: Container( width:width*0.7, child: const Divider(), padding: const EdgeInsets.symmetric(vertical: 10),)),
                        Positioned(
                          top: 5,
                          left: 0,
                          child: SizedBox(
                            width: width,
                            child: Center(
                              child: Container(
                                width: 160,
                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                decoration: BoxDecoration(
                                  color: customs.whiteColor,
                                  borderRadius: BorderRadius.circular(3)
                                ),
                                child: Center(child: Text(collection_details != null ? (collection_details['date'] ?? "N/A") : "N/A", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold),)),
                              ),
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  Skeletonizer(
                    enabled: loading,
                    child: Center(
                      child: Text(collection_details != null ? (collection_details['time'] ?? "N/A") : "N/A", style: customs.secondaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Skeletonizer(
                    enabled: loading,
                    child: Container(
                      height: 230,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                        color: customs.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: customs.secondaryShade_2,
                            spreadRadius: 2,
                            blurRadius: 10
                          )
                        ],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(text: TextSpan(text: "Price: ", style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold), children: [TextSpan(text: "Kes $milk_price\n", style: customs.secondaryTextStyle(size: 12)), TextSpan(text: "PPL  : ", style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold)), TextSpan(text: "Kes $ppl", style: customs.secondaryTextStyle(size: 12))])),
                                IconButton(
                                  onPressed: (){},
                                  icon: Icon(
                                    Icons.broken_image_outlined,
                                    color: customs.secondaryColor,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(customs.secondaryShade_2),
                                    elevation: WidgetStateProperty.all<double>(10),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    )
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text("Collected", style: customs.secondaryTextStyle(size: 12, underline : true, fontweight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              Text((collection_details != null ? (collection_details['collection_amount']+" Litres" ?? "N/A") : "N/A"), style: customs.secondaryTextStyle(size: 25, fontweight: FontWeight.bold)),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: collection_status == 0 ? customs.secondaryColor : collection_status == 1 ? customs.successColor : customs.dangerColor,
                                ),
                                child: Text(collection_status == 0 ? "Not-Confirmed" : collection_status == 1 ? "Confirmed" : "Rejected", style: customs.whiteTextStyle(size: 12, fontweight: FontWeight.bold))
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(width: width *0.4, child: collection_status == 0 ? customs.maruButton(text: "Confirm", disabled:all_status, showLoader: all_status, onPressed: (){changeStatus("1");},fontSize: 15,type: Type.success, size: Sizes.sm, fontWeight: FontWeight.bold) : SizedBox(height: 0, width: 0,)),
                                  Container(width: width *0.4, child: collection_status == 0 ? customs.marOutlineuButton(text: "Reject",disabled: all_status, showLoader: all_status, onPressed: (){changeStatus("2");},fontSize: 15,type: Type.danger, size: Sizes.sm, fontWeight: FontWeight.bold) : SizedBox(height: 0, width: 0,))
                                ],
                              ),
                              collection_status != 0 ? customs.marOutlineuButton(text: "Revoke", onPressed: (){changeStatus("0");},fontSize: 15,type: Type.secondary, showLoader: all_status, size: Sizes.sm, fontWeight: FontWeight.bold) : SizedBox(height: 0, width: 0,)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text("Back to List", style: customs.secondaryTextStyle(size: 12, underline: true, fontweight: FontWeight.bold),),
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

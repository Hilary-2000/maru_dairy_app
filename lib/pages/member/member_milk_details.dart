import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maru/packages/maru_theme.dart';

class MemberMilkDetails extends StatefulWidget {
  const MemberMilkDetails({super.key});

  @override
  State<MemberMilkDetails> createState() => _MemberMilkDetailsState();
}

class _MemberMilkDetailsState extends State<MemberMilkDetails> {
  @override
  Widget build(BuildContext context) {
    CustomThemes customs = CustomThemes();
    const FlutterSecureStorage _storage = FlutterSecureStorage();

    List<DropdownMenuItem<String>> regions = [
      const DropdownMenuItem(child: Text("Select your region"), value: ""),
      const DropdownMenuItem(child: Text("Njebi"), value: "Njebi"),
      const DropdownMenuItem(child: Text("Munyu/Kiriti"), value: "Munyu/Kiriti"),
    ];

    List<DropdownMenuItem<String>> genderList = [
      const DropdownMenuItem(child: Text("Select Gender"), value: ""),
      const DropdownMenuItem(child: Text("Male"), value: "male"),
      const DropdownMenuItem(child: Text("Female"), value: "female"),
    ];

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
                  Stack(
                    children: [
                      Center(child: Container( width:width*0.7, child: const Divider(), padding: const EdgeInsets.symmetric(vertical: 10),)),
                      Positioned(
                        top: 5,
                        left: width * 0.365,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            color: customs.whiteColor,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text("Mon, Jun 2024", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold),),
                        )
                      )
                    ],
                  ),
                  Center(
                    child: Text("11:54AM", style: customs.secondaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 30,),
                  Container(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(""),
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
                        Column(
                          children: [
                            Text("Collected", style: customs.secondaryTextStyle(size: 12, underline : true, fontweight: FontWeight.bold),),
                            const SizedBox(height: 10,),
                            Text("19.43 Litres", style: customs.secondaryTextStyle(size: 25, fontweight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: customs.successColor,
                              ),
                              child: Text("Confirmed", style: customs.whiteTextStyle(size: 12, fontweight: FontWeight.bold))
                            ),
                            // Container(
                            //     padding: EdgeInsets.all(2),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5),
                            //       color: customs.dangerColor,
                            //     ),
                            //     child: Text("Rejected", style: customs.whiteTextStyle(size: 12, fontweight: FontWeight.bold))
                            // ),
                            // Container(
                            //   margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5),
                            //     ),
                            //     child: const Image(
                            //       image: AssetImage("assets/images/card.jpg"),
                            //       height: 150,
                            //       alignment: Alignment.center,
                            //       semanticLabel: "Member`s Card",
                            //     ),
                            // ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                customs.maruButton(text: "Confirm", onPressed: (){},fontSize: 15,type: Type.success, size: Sizes.sm),
                                customs.marOutlineuButton(text: "Reject", onPressed: (){},fontSize: 15,type: Type.danger, size: Sizes.sm)
                              ],
                            )
                          ],
                        )
                      ],
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

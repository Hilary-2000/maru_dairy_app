import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maru/packages/maru_theme.dart';

class MemberQrcode extends StatefulWidget {
  const MemberQrcode({super.key});

  @override
  State<MemberQrcode> createState() => _MemberQrcodeState();
}

class _MemberQrcodeState extends State<MemberQrcode> {
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
          double calculatedWidth = screenWidth / 2 - 170;
          calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
          return Container(
            margin: EdgeInsets.fromLTRB(calculatedWidth, 0, 0, 0),
            child: const Row(
              children: [
                SizedBox(
                  height: 20,
                  child: Image(image: AssetImage("assets/images/koica.jpg")),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 45,
                  child: Image(image: AssetImage("assets/images/maru.jpg")),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 40,
                  child: Image(image: AssetImage("assets/images/uniworld.jpg")),
                )
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
                          Text("My QrCode", style: customs.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.1,),
                  Stack(
                    children: [
                      Center(child: Container( width:width*0.7, child: const Divider(), padding: const EdgeInsets.symmetric(vertical: 10),)),
                      Positioned(
                          top: 5,
                          left: width * 0.34,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                            decoration: BoxDecoration(
                                color: customs.whiteColor,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Text("Scan My QR Code", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold),),
                          )
                      )
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    height: 300,
                    width: width * 0.7,
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
                    child: Image(
                      image: AssetImage("assets/images/maru.png"),
                      width: 150,
                      height: 150,
                    )
                  ),
                  const SizedBox(height: 20,),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text("Back to Membership", style: customs.secondaryTextStyle(size: 12, underline: true, fontweight: FontWeight.bold),),
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

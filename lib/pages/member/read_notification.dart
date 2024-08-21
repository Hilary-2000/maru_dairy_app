import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maru/packages/maru_theme.dart';

class ReadMemberNotification extends StatefulWidget {
  const ReadMemberNotification({super.key});

  @override
  State<ReadMemberNotification> createState() => _ReadMemberNotificationState();
}

class _ReadMemberNotificationState extends State<ReadMemberNotification> {
  @override
  Widget build(BuildContext context) {
    CustomThemes customs = CustomThemes();
    const FlutterSecureStorage _storage = FlutterSecureStorage();

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
                        Text("New Update Alert!", style: customs.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: customs.primaryShade_2,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("Your can now be able to upload you milk details by taking a photo of your card. With the power of AI, the data written in the card will be read and fed to the apps database.", style: customs.secondaryTextStyle(size: 14),),
                  ),
                  const SizedBox(height: 20,),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text("Back to Notifications", style: customs.secondaryTextStyle(size: 12, underline: true, fontweight: FontWeight.bold),),
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

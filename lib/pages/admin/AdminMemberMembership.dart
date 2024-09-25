import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/maru_theme.dart';

class Adminmembermembership extends StatefulWidget {
  const Adminmembermembership({super.key});

  @override
  State<Adminmembermembership> createState() => _AdminmembermembershipState();
}

class _AdminmembermembershipState extends State<Adminmembermembership> {
  CustomThemes customs = CustomThemes();
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
              color: customs.secondaryShade_2.withOpacity(0.2),
            ),
            child: Container(
              height: height - 5,
              width: width,
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Membership", style: customs.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                          IconButton(onPressed: (){Navigator.pushNamed(context, "/member_qr_code");}, icon: Icon(Icons.qr_code_2_outlined, size: 25,))
                        ],
                      ),
                    ),
                    Center(
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
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(1, 176, 241, 1),
                                        Color.fromRGBO(255, 193, 7, 1),
                                        Color.fromRGBO(20, 72, 156, 1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
                                      offset: const Offset(0,
                                          1), // Offset in the x and y direction
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    Text(
                                      "Hillary Ngige",
                                      style: customs.darkTextStyle(
                                          size: 20,
                                          fontweight: FontWeight.bold),
                                    ),
                                    Text(
                                      "REG2022-002",
                                      style: customs.secondaryTextStyle(
                                          size: 12,
                                          fontweight: FontWeight.normal),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        // its the widest container
                                        Container(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Maru Member since : ",
                                              style: customs.secondaryTextStyle(
                                                  size: 12,
                                                  fontweight: FontWeight.bold),
                                            ),
                                            Text(
                                              "June-2024",
                                              style: customs.secondaryTextStyle(
                                                  size: 12,
                                                  fontweight:
                                                  FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Subscription Balance",
                                              style: customs.secondaryTextStyle(
                                                  size: 12,
                                                  fontweight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Kes 10,232",
                                              style: customs.secondaryTextStyle(
                                                  size: 12,
                                                  fontweight:
                                                  FontWeight.normal),
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
                          top:
                          65, // Adjust this value to move the CircleAvatar up
                          left: 0,
                          right: 0,
                          child: Center(
                            child: CircleAvatar(
                                radius: 44,
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/images/hilla.jpg",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Payment History", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold),),
                          Text("View All", style: customs.primaryTextStyle(size: 10, fontweight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: customs.whiteColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      width: width * 0.95,
                      height: height * 0.49 > 300 ? height * 0.49 : 300,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 1,203",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("June 12th 2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("Jun-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 1,020",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("May 5th 2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("May-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 656",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("April 10th 2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("April-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 891",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("March 10th 2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("Mar-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 203",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Feb 15th 2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("Feb-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 785",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("June 10th 2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("Jan-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 745",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Dec 10th 2023", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("Dec-2023", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 765",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Nov 10th 2023", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("Nov-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 1,203",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("June 12th 2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("Jun-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 1,203",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("June 12th 2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("Jun-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 1,203",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("June 12th 2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("Jun-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: customs.secondaryShade_2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: customs.primaryShade_2,
                                  child: Icon(
                                    FontAwesomeIcons.handHoldingDollar,
                                    size: 20,
                                    color: customs.primaryColor,
                                  ),
                                ),
                                dense: true,
                                style: ListTileStyle.drawer,
                                title: RichText(
                                    text: TextSpan(
                                        text: "Paid : ",
                                        style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text: "Kes 1,203",
                                              style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                          )
                                        ]
                                    )
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("June 12th 2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                    Text("Jun-2024", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                  ],
                                ),
                                onTap: (){
                                  print("Tapped");
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
  }
}

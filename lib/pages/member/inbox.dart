import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/maru_theme.dart';

class MemberInbox extends StatefulWidget {
  const MemberInbox({super.key});

  @override
  State<MemberInbox> createState() => _MemberInboxState();
}

class _MemberInboxState extends State<MemberInbox> {
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
              color: customs.secondaryShade_2.withOpacity(0.2),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: customs.whiteColor,
                    boxShadow: [
                      BoxShadow(color: customs.secondaryShade_2,blurRadius: 5),
                    ]
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Chat with a Maru Admin", style: customs.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                      Text("Online...", style: customs.successTextStyle(size: 10, fontweight: FontWeight.bold),),
                    ],
                  ),
                ),
                Container(
                  height: height - 100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Spacer(),
                              Container(
                                width: width * 0.75,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: customs.primaryColor,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  children: [
                                    Text("Hello Mr Daniel, I am having issues with my account history!", style: customs.whiteTextStyle(size: 14,),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("11:23AM ", style: customs.whiteTextStyle(size: 10),),
                                        Icon(Icons.checklist_outlined, size: 15, color: customs.whiteColor)
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.75,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: customs.secondaryShade_2,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  children: [
                                    Text("Hello Hillary Ngige, Sorry to hear about that, our technical team is looking into that!", style: customs.secondaryTextStyle(size: 14),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("11:24AM ", style: customs.secondaryTextStyle(size: 10),),
                                        // Icon(Icons.checklist_outlined, size: 15, color: customs.secondaryColor)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.75,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: customs.secondaryShade_2,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  children: [
                                    Text("Hello Hillary, You can take a look at it now account has been rectified!", style: customs.secondaryTextStyle(size: 14),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("11:25AM ", style: customs.secondaryTextStyle(size: 10),),
                                        // Icon(Icons.checklist_outlined, size: 15, color: customs.secondaryColor)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Spacer(),
                              Container(
                                width: width * 0.75,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: customs.primaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  children: [
                                    Text("Everything looks good but now the problem is that I can`t download any documents!", style: customs.whiteTextStyle(size: 14,),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("11:28AM ", style: customs.whiteTextStyle(size: 10),),
                                        Icon(Icons.checklist_outlined, size: 15, color: customs.whiteColor)
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.75,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: customs.secondaryShade_2,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  children: [
                                    Text("Hello Mr Hillary, Returned it to the technical team, give us until the day ends!", style: customs.secondaryTextStyle(size: 14),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("11:29AM ", style: customs.secondaryTextStyle(size: 10),),
                                        // Icon(Icons.checklist_outlined, size: 15, color: customs.secondaryColor)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Spacer(),
                              Container(
                                width: width * 0.65,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: customs.primaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  children: [
                                    Text("Good, looking forward to your response!", style: customs.whiteTextStyle(size: 14,),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("11:23AM ", style: customs.whiteTextStyle(size: 10),),
                                        Icon(Icons.checklist_outlined, size: 15, color: customs.whiteColor)
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.75,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: customs.secondaryShade_2,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  children: [
                                    Text("Hello Mr Hillary, Your issue has been rectified successfully!", style: customs.secondaryTextStyle(size: 14),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("11:23AM ", style: customs.secondaryTextStyle(size: 10),),
                                        // Icon(Icons.checklist_outlined, size: 15, color: customs.secondaryColor)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Spacer(),
                              Container(
                                width: width * 0.68,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: customs.primaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  children: [
                                    Text("Thank Daniel, I can see everything is good!", style: customs.whiteTextStyle(size: 14,),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("11:23AM ", style: customs.whiteTextStyle(size: 10),),
                                        Icon(Icons.checklist_outlined, size: 15, color: customs.whiteColor)
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: width,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    children: [
                      Spacer(),
                      Container(
                        width: width * 0.85,
                        child: customs.maruSearchTextField(isChanged: (value){}, hintText: "Write your message here!", textType: TextInputType.text, textAlign: TextAlign.left)
                      ),
                      IconButton(onPressed: (){}, icon: Icon(Icons.send_rounded))
                    ],
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

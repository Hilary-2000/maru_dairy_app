import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/maru_theme.dart';

class memberHistory extends StatefulWidget {
  const memberHistory({super.key});

  @override
  State<memberHistory> createState() => _memberHistoryState();
}

class _memberHistoryState extends State<memberHistory> {
  CustomThemes customs = CustomThemes();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        double calculatedWidth = width / 2 - 170;
        calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: customs.secondaryShade_2.withOpacity(0.2)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("History", style: customs.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
              ),
              Card(
                shadowColor: customs.primaryShade.withOpacity(0.5),
                elevation: 2,
                color: customs.whiteColor,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  color: customs.whiteColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "This Month:",
                        style: customs.secondaryTextStyle(
                            size: 12, fontweight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 100,
                            width: width * 0.40,
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: customs.secondaryShade_2),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[200],
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      FontAwesomeIcons.handHoldingDollar,
                                      color: customs.successColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Est. Pay",
                                        style: customs.secondaryTextStyle(
                                            size: width * 0.035,
                                            fontweight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Kes 101,021",
                                        style: customs.darkTextStyle(
                                            size: width * 0.028),
                                      ),
                                    ],
                                  )
                                ]),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 100,
                            width: width * 0.40,
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: customs.secondaryShade_2),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[200],
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.water_drop_outlined,
                                      color: customs.infoColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Acc. Litres",
                                        style: customs.secondaryTextStyle(
                                            size: width * 0.035,
                                            fontweight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "45.22 Ltrs",
                                        style: customs.darkTextStyle(
                                            size: width * 0.028),
                                      ),
                                    ],
                                  )
                                ]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: (width * 0.2), vertical: 10),
                child: Divider(
                  color: customs.secondaryShade_2,
                  height: 0.1,
                  thickness: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(children: [
                  Text(
                    "Last 30 days",
                    textAlign: TextAlign.left,
                    style:
                        customs.secondaryTextStyle(size: 12, underline: true),
                  ),
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: width * 0.6,
                    child: customs.maruSearchTextField(
                      isChanged: (value) {},
                      hintText: "Search",
                      // label: "Search"
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: height - 285,
                decoration: BoxDecoration(
                  color: customs.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                // color: Colors.red,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    GestureDetector(
                      onTap : (){
                        Navigator.pushNamed(context, "/member_milk_details");
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: customs.secondaryShade_2.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              child: const Icon(
                                Icons.water_drop_outlined,
                                size: 25,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: customs.primaryShade_2),
                            ),
                            title: Text(
                              "Collected",
                              style: customs.primaryTextStyle(size: 12),
                            ),
                            subtitle: Text(
                              "25 Litres",
                              style: customs.darkTextStyle(size: 15),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("12:03AM",
                                    style: customs.secondaryTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
                    GestureDetector(
                      onTap : (){
                        Navigator.pushNamed(context, "/member_milk_details");
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: customs.secondaryShade_2.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              child: const Icon(
                                Icons.water_drop_outlined,
                                size: 25,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: customs.primaryShade_2),
                            ),
                            title: Text(
                              "Collected",
                              style: customs.primaryTextStyle(size: 12),
                            ),
                            subtitle: Text(
                              "25 Litres",
                              style: customs.darkTextStyle(size: 15),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("12:03AM",
                                    style: customs.secondaryTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
                    GestureDetector(
                      onTap : (){
                        Navigator.pushNamed(context, "/member_milk_details");
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: customs.secondaryShade_2.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              child: const Icon(
                                Icons.water_drop_outlined,
                                size: 25,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: customs.primaryShade_2),
                            ),
                            title: Text(
                              "Collected",
                              style: customs.primaryTextStyle(size: 12),
                            ),
                            subtitle: Text(
                              "25 Litres",
                              style: customs.darkTextStyle(size: 15),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("12:03AM",
                                    style: customs.secondaryTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
                    GestureDetector(
                      onTap : (){
                        Navigator.pushNamed(context, "/member_milk_details");
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: customs.secondaryShade_2.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              child: const Icon(
                                Icons.water_drop_outlined,
                                size: 25,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: customs.primaryShade_2),
                            ),
                            title: Text(
                              "Collected",
                              style: customs.primaryTextStyle(size: 12),
                            ),
                            subtitle: Text(
                              "25 Litres",
                              style: customs.darkTextStyle(size: 15),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("12:03AM",
                                    style: customs.secondaryTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
                    GestureDetector(
                      onTap : (){
                        Navigator.pushNamed(context, "/member_milk_details");
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: customs.secondaryShade_2.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              child: const Icon(
                                Icons.water_drop_outlined,
                                size: 25,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: customs.primaryShade_2),
                            ),
                            title: Text(
                              "Collected",
                              style: customs.primaryTextStyle(size: 12),
                            ),
                            subtitle: Text(
                              "25 Litres",
                              style: customs.darkTextStyle(size: 15),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("12:03AM",
                                    style: customs.secondaryTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
                    GestureDetector(
                      onTap : (){
                        Navigator.pushNamed(context, "/member_milk_details");
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: customs.secondaryShade_2.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              child: const Icon(
                                Icons.water_drop_outlined,
                                size: 25,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: customs.primaryShade_2),
                            ),
                            title: Text(
                              "Collected",
                              style: customs.primaryTextStyle(size: 12),
                            ),
                            subtitle: Text(
                              "25 Litres",
                              style: customs.darkTextStyle(size: 15),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("12:03AM",
                                    style: customs.secondaryTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
                    GestureDetector(
                      onTap : (){
                        Navigator.pushNamed(context, "/member_milk_details");
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: customs.secondaryShade_2.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              child: const Icon(
                                Icons.water_drop_outlined,
                                size: 25,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: customs.primaryShade_2),
                            ),
                            title: Text(
                              "Collected",
                              style: customs.primaryTextStyle(size: 12),
                            ),
                            subtitle: Text(
                              "25 Litres",
                              style: customs.darkTextStyle(size: 15),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("12:03AM",
                                    style: customs.secondaryTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
                    GestureDetector(
                      onTap : (){
                        Navigator.pushNamed(context, "/member_milk_details");
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: customs.secondaryShade_2.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              child: const Icon(
                                Icons.water_drop_outlined,
                                size: 25,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: customs.primaryShade_2),
                            ),
                            title: Text(
                              "Collected",
                              style: customs.primaryTextStyle(size: 12),
                            ),
                            subtitle: Text(
                              "25 Litres",
                              style: customs.darkTextStyle(size: 15),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("12:03AM",
                                    style: customs.secondaryTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
                    GestureDetector(
                      onTap : (){
                        Navigator.pushNamed(context, "/member_milk_details");
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: customs.secondaryShade_2.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              child: const Icon(
                                Icons.water_drop_outlined,
                                size: 25,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: customs.primaryShade_2),
                            ),
                            title: Text(
                              "Collected",
                              style: customs.primaryTextStyle(size: 12),
                            ),
                            subtitle: Text(
                              "25 Litres",
                              style: customs.darkTextStyle(size: 15),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("12:03AM",
                                    style: customs.secondaryTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
                    GestureDetector(
                      onTap : (){
                        Navigator.pushNamed(context, "/member_milk_details");
                      },
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: customs.secondaryShade_2.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              child: const Icon(
                                Icons.water_drop_outlined,
                                size: 25,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: customs.primaryShade_2),
                            ),
                            title: Text(
                              "Collected",
                              style: customs.primaryTextStyle(size: 12),
                            ),
                            subtitle: Text(
                              "25 Litres",
                              style: customs.darkTextStyle(size: 15),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("12:03AM",
                                    style: customs.secondaryTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
                  ],
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}

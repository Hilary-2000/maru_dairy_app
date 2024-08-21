import 'package:flutter/material.dart';
import 'package:maru/packages/maru_theme.dart';

class AdminCollectionHistory extends StatefulWidget {
  const AdminCollectionHistory({super.key});

  @override
  State<AdminCollectionHistory> createState() => _AdminCollectionHistoryState();
}

class _AdminCollectionHistoryState extends State<AdminCollectionHistory> {
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
                child: Text("Collection History", style: customs.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
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
                        "Today:",
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
                                      Icons.water_drop_outlined,
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
                                        "Confirmed",
                                        style: customs.secondaryTextStyle(
                                            size: width * 0.035,
                                            fontweight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "25 Collection(s)",
                                        style: customs.darkTextStyle(
                                            size: width * 0.028),
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Text("View", style: customs.primaryTextStyle(size: 10, underline: false),),
                                          Icon(Icons.keyboard_double_arrow_right, color: customs.primaryColor, size: 16,)
                                        ],
                                      )
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
                                      color: customs.dangerColor,
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
                                        "Declined",
                                        style: customs.secondaryTextStyle(
                                            size: width * 0.035,
                                            fontweight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "3 collection(s)",
                                        style: customs.darkTextStyle(
                                            size: width * 0.028),
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Text("View", style: customs.primaryTextStyle(size: 10, underline: false),),
                                          Icon(Icons.keyboard_double_arrow_right, color: customs.primaryColor, size: 16,)
                                        ],
                                      )
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
                    "Last 7 days",
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
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      backgroundColor: customs.secondaryShade_2,
                      child: IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.search, color: customs.secondaryColor,),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: CircleAvatar(
                      backgroundColor: customs.successShade_2,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pushNamed(context, "/technician_collect_milk");
                        },
                        icon: Icon(Icons.add, color: customs.successColor,),
                      ),
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
                        Navigator.pushNamed(context, "/edit_member_milk_data");
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
                            leading: CircleAvatar(
                              backgroundColor: customs.primaryShade,
                              child: Text("PM", style: customs.primaryTextStyle(size: 18, fontweight: FontWeight.bold),),
                            ),
                            title: Text(
                              "Patrick Mugoh",
                              style: customs.darkTextStyle(size: 14),
                            ),
                            subtitle: Text(
                              "20.4 Litres",
                              style: customs.secondaryTextStyle(size: 12),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("10:03AM",
                                    style: customs.darkTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: customs.successColor,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
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
                        Navigator.pushNamed(context, "/edit_member_milk_data");
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
                            leading: CircleAvatar(
                              backgroundColor: customs.successShade_2,
                              child: Text("OM", style: customs.successTextStyle(size: 18, fontweight: FontWeight.bold),),
                            ),
                            title: Text(
                              "Owen Malingu",
                              style: customs.darkTextStyle(size: 14),
                            ),
                            subtitle: Text(
                              "20.4 Litres",
                              style: customs.secondaryTextStyle(size: 12),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("09:56AM",
                                    style: customs.darkTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: customs.successColor,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
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
                        Navigator.pushNamed(context, "/edit_member_milk_data");
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
                            leading: CircleAvatar(
                              backgroundColor: customs.secondaryShade_2,
                              child: Text("EB", style: customs.secondaryTextStyle(size: 18, fontweight: FontWeight.bold),),
                            ),
                            title: Text(
                              "Esmond Bwire",
                              style: customs.darkTextStyle(size: 14),
                            ),
                            subtitle: Text(
                              "16.4 Litres",
                              style: customs.secondaryTextStyle(size: 12),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("09:53AM",
                                    style: customs.darkTextStyle(size: 10)),
                                Text(
                                  "15th July 2024",
                                  style: customs.secondaryTextStyle(
                                      size: 10, fontweight: FontWeight.normal),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: customs.dangerColor,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
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

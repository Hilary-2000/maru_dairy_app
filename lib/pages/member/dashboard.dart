import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:maru/pages/member/history.dart';
import 'package:maru/pages/member/notification.dart';
import 'package:maru/pages/member/settings.dart';
import 'package:maru/pages/member/view_profile.dart';

class memberDashboard extends StatefulWidget {
  const memberDashboard({super.key});

  @override
  State<memberDashboard> createState() => _memberDashboardState();
}

class _memberDashboardState extends State<memberDashboard> {
  CustomThemes customs = CustomThemes();

  void changeWindow(index) {
    setState(() {});
  }

  var index = 0;
  List<Widget> member_windows = [
    // THE MEMBER DASHBOARD AFTER LOGIN
    const memberDash(),
    // THE MEMBER MILK COLLECTION HISTORY
    const memberHistory(),
    // THE MEMBER HISTORY
    const notificationWindow(),
    // THE MEMBER PROFILE
    const MemberSettings()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.whiteColor,
      appBar: AppBar(
        backgroundColor: customs.whiteColor,
        elevation: 1,
        title: Builder(builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double calculatedWidth = screenWidth / 2 - 160;
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
      body: member_windows[index],
      bottomNavigationBar: Builder(builder: (context) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                },
                child: SizedBox(
                  height: 41,
                  width: width * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: index == 0
                            ? customs.primaryColor
                            : customs.secondaryColor,
                      ),
                      Text(
                        "Home",
                        style: index == 0
                            ? customs.primaryTextStyle(
                                size: 12, fontweight: FontWeight.bold)
                            : customs.secondaryTextStyle(
                                size: 12, fontweight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
                child: SizedBox(
                  height: 41,
                  width: width * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        color: index == 1
                            ? customs.primaryColor
                            : customs.secondaryColor,
                      ),
                      Text(
                        "History",
                        style: index == 1
                            ? customs.primaryTextStyle(
                                size: 12, fontweight: FontWeight.bold)
                            : customs.secondaryTextStyle(
                                size: 12, fontweight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                child: SizedBox(
                  height: 41,
                  width: width * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(clipBehavior: Clip.none, children: [
                        SizedBox(
                          child: Icon(
                            Icons.notifications_outlined,
                            color: index == 2
                                ? customs.primaryColor
                                : customs.secondaryColor,
                          ),
                        ),
                        Positioned(
                            left: 10,
                            top: -6,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "10",
                                style: customs.whiteTextStyle(
                                    size: 10, fontweight: FontWeight.bold),
                              ),
                            ))
                      ]),
                      Text(
                        "Notification",
                        style: index == 2
                            ? customs.primaryTextStyle(
                                size: 12, fontweight: FontWeight.bold)
                            : customs.secondaryTextStyle(
                                size: 12, fontweight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 3;
                  });
                },
                child: SizedBox(
                  height: 41,
                  width: width * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_3_outlined,
                        color: index == 3
                            ? customs.primaryColor
                            : customs.secondaryColor,
                      ),
                      Text(
                        "Account",
                        style: index == 3
                            ? customs.primaryTextStyle(
                                size: 12, fontweight: FontWeight.bold)
                            : customs.secondaryTextStyle(
                                size: 12, fontweight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: index == 3
          ? (CircleAvatar(
              radius: 25,
              backgroundColor: customs.primaryShade_2,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.penRuler,
                  size: 18,
                  color: customs.primaryColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/member_edit_profile");
                },
              ),
            ))
          : (index == 2
              ? (CircleAvatar(
                  radius: 25,
                  backgroundColor: customs.primaryShade_2,
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.signalMessenger,
                      size: 30,
                      color: customs.primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/member_inbox");
                    },
                  ),
                ))
              : null),
    );
  }
}

class memberDash extends StatefulWidget {
  const memberDash({super.key});

  @override
  State<memberDash> createState() => _memberDashState();
}

class _memberDashState extends State<memberDash> {
  CustomThemes customs = CustomThemes();
  String drop_down = "7";
  List<DropdownMenuItem<String>> dayFilter = [
    const DropdownMenuItem(child: Text("7 Days"), value: "7"),
    const DropdownMenuItem(child: Text("14 Days"), value: "14"),
    const DropdownMenuItem(child: Text("30 Days"), value: "30"),
  ];
  List<String> daysOfWeek = [
    '',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thur',
    'Fri',
    'Sat'
  ];

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
            color: customs.secondaryShade_2.withOpacity(0.2),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Card(
                  color: customs.whiteColor,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Goodmorning,",
                              style: customs.primaryTextStyle(
                                  size: width * 0.04,
                                  fontweight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: height * 0.005,
                            ),
                            Text(
                              "Hillary Ngige",
                              style: customs.successTextStyle(
                                  size: width * 0.05,
                                  fontweight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: CircleAvatar(
                                radius: width * 0.08,
                                backgroundColor: customs.primaryShade,
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/images/hilla.jpg",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, "/member_view_profile");
                              },
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: customs.primaryShade,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Text(
                                "REG2022-002",
                                style: customs.darkTextStyle(
                                    size: 10, fontweight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Card(
                  color: customs.whiteColor,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quick Actions",
                          style: customs.primaryTextStyle(
                              size: 12,
                              underline: true,
                              fontweight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customs.maruButton(
                                showArrow: true,
                                iconSize: 15,
                                fontSize: 13,
                                size: Sizes.sm,
                                text: "View Membership",
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "/member_membership");
                                }),
                            customs.maruButton(
                                showArrow: true,
                                iconSize: 15,
                                fontSize: 13,
                                size: Sizes.sm,
                                text: "Inquire",
                                onPressed: () {
                                  Navigator.pushNamed(context, "/member_inbox");
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Collection Stats",
                        style: customs.darkTextStyle(size: 15, underline: true),
                      ),
                      const Spacer(),
                      Container(
                        width: width * 0.25,
                        child: customs.maruDropDownButton(
                          defaultValue: drop_down,
                          hintText: "Select days",
                          items: dayFilter,
                          onChange: (value) {
                            setState(() {
                              drop_down = value!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  color: customs.whiteColor,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: CircleAvatar(
                          backgroundColor:
                              customs.successColor.withOpacity(0.2),
                          radius: width * 0.06,
                          child: Icon(
                            Icons.water_drop_outlined,
                            size: width * 0.1,
                            color: customs.successColor,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "25.2 Ltrs",
                                style: customs.darkTextStyle(
                                    size: width * 0.05,
                                    fontweight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Kes 1,672.1 @ Kes 66.2 per Ltr",
                                style:
                                    customs.darkTextStyle(size: width * 0.03),
                              )
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.arrow_drop_up,
                                  color: customs.successColor,
                                ),
                                Text(
                                  "5.66%",
                                  style: customs.successTextStyle(
                                      size: width * 0.03,
                                      fontweight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: customs.whiteColor,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "MILK COLLECTION STATS",
                        style: customs.darkTextStyle(
                            size: 15,
                            underline: true,
                            fontweight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      AspectRatio(
                        aspectRatio: 2.0,
                        child: BarChart(
                          BarChartData(
                              barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) => Colors.transparent,
                                tooltipPadding: EdgeInsets.zero,
                                tooltipMargin: 2,
                                getTooltipItem: (
                                  BarChartGroupData group,
                                  int groupIndex,
                                  BarChartRodData rod,
                                  int rodIndex,
                                ) {
                                  return BarTooltipItem(
                                    "${rod.toY.round()} Ltrs",
                                    customs.darkTextStyle(
                                        size: 8, fontweight: FontWeight.bold),
                                  );
                                },
                              )),
                              borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    left: BorderSide(
                                        color: customs.primaryColor, width: 1),
                                  )),
                              barGroups: [
                                BarChartGroupData(x: 1, barRods: [
                                  BarChartRodData(
                                    toY: 15,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 2, barRods: [
                                  BarChartRodData(
                                    toY: 35,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  BarChartRodData(
                                    toY: 22,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 4, barRods: [
                                  BarChartRodData(
                                    toY: 12,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 5, barRods: [
                                  BarChartRodData(
                                    toY: 45,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 6, barRods: [
                                  BarChartRodData(
                                    toY: 27,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 7, barRods: [
                                  BarChartRodData(
                                    toY: 24,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ])
                              ],
                              gridData: FlGridData(
                                show: true,
                                checkToShowHorizontalLine: (value) =>
                                    value % 10 == 0,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: customs.secondaryShade_2,
                                  strokeWidth: 1,
                                ),
                                drawVerticalLine: false,
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                    axisNameWidget: Center(
                                        child: Text("Quantity in Ltrs",
                                            style: customs.primaryTextStyle(
                                                size: 12))),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 20,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          meta.formattedValue,
                                          textAlign: TextAlign.center,
                                          style: customs.darkTextStyle(
                                              size: 10,
                                              fontweight: FontWeight.bold),
                                        );
                                      },
                                    )),
                                bottomTitles: AxisTitles(
                                    axisNameWidget: Center(
                                        child: Text("Days of the week",
                                            style: customs.primaryTextStyle(
                                                size: 12))),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 12,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          daysOfWeek[
                                              int.parse(meta.formattedValue)],
                                          textAlign: TextAlign.center,
                                          style: customs.darkTextStyle(
                                              size: 10,
                                              fontweight: FontWeight.bold),
                                        );
                                      },
                                    )),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                  showTitles: false,
                                )),
                              )), // Optional
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}

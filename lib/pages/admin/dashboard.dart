import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:maru/pages/admin/admin_account.dart';
import 'package:maru/pages/admin/admin_history.dart';
import 'package:maru/pages/admin/admin_inquiries.dart';
import 'package:maru/pages/admin/our_members.dart';
import 'package:maru/pages/technician/technician_history.dart';

class adminDashboard extends StatefulWidget {
  const adminDashboard({super.key});

  @override
  State<adminDashboard> createState() => _adminDashboardState();
}

class _adminDashboardState extends State<adminDashboard> {

  int index = 0;
  CustomThemes customs = CustomThemes();
  void _updateIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> admin_dashboard = [
      // admin dashboard
      AdminDashboard(updateIndex: _updateIndex),
      // Maru members
      OurMembers(),
      // Collection History
      TechnicianHistory(),
      // admin inquiries
      AdminInquiries(),
      // Admin Account
      AdminAccount()
    ];
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
          );
        }),
      ),
      body: admin_dashboard[index],
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
                  width: width * 0.15,
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
                  width: width * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_alt_outlined,
                        color: index == 1
                            ? customs.primaryColor
                            : customs.secondaryColor,
                      ),
                      Text(
                        "Members",
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
                  width: width * 0.14,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        color: index == 2
                            ? customs.primaryColor
                            : customs.secondaryColor,
                      ),
                      Text(
                        "History",
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
                      Stack(clipBehavior: Clip.none, children: [
                        SizedBox(
                          child: Icon(
                            Icons.chat_bubble_outline,
                            color: index == 3
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
                        "Inquiries",
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 4;
                    print(index);
                  });
                },
                child: SizedBox(
                  height: 41,
                  width: width * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_3_outlined,
                        color: index == 4
                            ? customs.primaryColor
                            : customs.secondaryColor,
                      ),
                      Text(
                        "Account",
                        style: index == 4
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
      floatingActionButton: index == 0
          ? (CircleAvatar(
              radius: 25,
              backgroundColor: customs.secondaryShade_2,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.personCirclePlus,
                  size: 20,
                  color: customs.secondaryColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/member_edit_profile");
                },
              ),
            ))
          : (index == 3
              ? (CircleAvatar(
                  radius: 25,
                  backgroundColor: customs.successShade_2,
                  child: IconButton(
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      size: 25,
                      color: customs.successColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/select_member_to_send_message");
                    },
                  ),
                ))
              : null),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  final void Function(int) updateIndex;
  const AdminDashboard({super.key, required this.updateIndex});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  CustomThemes customs = CustomThemes();
  int index = 0;
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(230, 245, 248, 1),
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(227, 228, 229, 1)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
                            CircleAvatar(
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
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              color: customs.infoColor,
                              child: Text(
                                "Administrator",
                                style: customs.whiteTextStyle(size: 10),
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
                              size: 10,
                              underline: true,
                              fontweight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            customs.maruButton(
                                showArrow: true,
                                iconSize: 15,
                                fontSize: 13,
                                size: Sizes.sm,
                                text: "Our Members",
                                onPressed: () {
                                  setState(() {
                                    index = 1;
                                    widget.updateIndex(index);
                                  });
                                }),
                            customs.maruButton(
                                showArrow: true,
                                iconSize: 15,
                                fontSize: 13,
                                size: Sizes.sm,
                                text: "Collection History",
                                onPressed: () {
                                  index = 2;
                                  widget.updateIndex(index);
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
                // SHOW THE COLLECTION IN LITERS
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
                                "1,522 Ltrs",
                                style: customs.darkTextStyle(
                                    size: width * 0.05,
                                    fontweight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Mon 17th - Sun 24th",
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
                                    toY: 150,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 2, barRods: [
                                  BarChartRodData(
                                    toY: 350,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  BarChartRodData(
                                    toY: 202,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 4, barRods: [
                                  BarChartRodData(
                                    toY: 124,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 5, barRods: [
                                  BarChartRodData(
                                    toY: 454,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 6, barRods: [
                                  BarChartRodData(
                                    toY: 279,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 7, barRods: [
                                  BarChartRodData(
                                    toY: 248,
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
                ),
                SizedBox(
                    width: width * 0.7,
                    child: Divider(
                      height: 10,
                    )),
                // SHOW THE FARMER WHO GAVE MILK STATISTICS
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Farmer Stats",
                        style: customs.darkTextStyle(size: 15, underline: true),
                      ),
                      const Spacer()
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
                            Icons.people_alt_outlined,
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
                                "25 Farmers Present",
                                style: customs.darkTextStyle(
                                    size: width * 0.05,
                                    fontweight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Mon 17th - Sun 24th",
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
                                  "15.66%",
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
                        "No. OF FARMERS PRESENT",
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
                                    "${rod.toY.round()}",
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
                                    toY: 20,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  BarChartRodData(
                                    toY: 25,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 4, barRods: [
                                  BarChartRodData(
                                    toY: 25,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 5, barRods: [
                                  BarChartRodData(
                                    toY: 26,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 6, barRods: [
                                  BarChartRodData(
                                    toY: 24,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 7, barRods: [
                                  BarChartRodData(
                                    toY: 31,
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
                                        child: Text("Number of Farmers",
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
                ),
                SizedBox(
                    width: width * 0.7,
                    child: Divider(
                      height: 10,
                    )),
                // SHOW THE FARMER WHO GAVE MILK STATISTICS
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "New Member Stats",
                        style: customs.darkTextStyle(size: 15, underline: true),
                      ),
                      const Spacer()
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
                            Icons.people_alt_outlined,
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
                                "31 New Members",
                                style: customs.darkTextStyle(
                                    size: width * 0.05,
                                    fontweight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Mon 17th - Sun 24th",
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
                                  "13.66%",
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
                        "No. OF NEW MEMBERS",
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
                                    "${rod.toY.round()}",
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
                                    toY: 5,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 2, barRods: [
                                  BarChartRodData(
                                    toY: 7,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  BarChartRodData(
                                    toY: 3,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 4, barRods: [
                                  BarChartRodData(
                                    toY: 8,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 5, barRods: [
                                  BarChartRodData(
                                    toY: 1,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 6, barRods: [
                                  BarChartRodData(
                                    toY: 3,
                                    color: customs.primaryColor,
                                  )
                                ], showingTooltipIndicators: [
                                  0
                                ]),
                                BarChartGroupData(x: 7, barRods: [
                                  BarChartRodData(
                                    toY: 12,
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
                                        child: Text("Number of Farmers",
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

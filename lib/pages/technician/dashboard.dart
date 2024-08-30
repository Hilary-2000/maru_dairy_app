import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:maru/pages/technician/account.dart';
import 'package:maru/pages/technician/technician_history.dart';
import 'package:skeletonizer/skeletonizer.dart';

class technicianDashboard extends StatefulWidget {
  const technicianDashboard({super.key});

  @override
  State<technicianDashboard> createState() => _technicianDashboardState();
}

class _technicianDashboardState extends State<technicianDashboard> {
  CustomThemes customs = CustomThemes();
  int index = 0;
  List<Widget> technician_windows = [
    // TECHNICIAN DASHBOARD
    TechnicianDashboard(),

    // TECHNICIAN HISTORY
    TechnicianHistory(),

    // ACCOUNT
    TechnicianAccount(),
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
      body: technician_windows[index],
      bottomNavigationBar: Builder(builder: (context) {
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
                      Icon(
                        Icons.person_3_outlined,
                        color: index == 2
                            ? customs.primaryColor
                            : customs.secondaryColor,
                      ),
                      Text(
                        "Account",
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
            ],
          ),
        );
      }),
    );
  }
}

class TechnicianDashboard extends StatefulWidget {
  const TechnicianDashboard({super.key});

  @override
  State<TechnicianDashboard> createState() => _TechnicianDashboardState();
}

class _TechnicianDashboardState extends State<TechnicianDashboard> {
  String drop_down = "7 days";
  String total_litres = "0";
  String period_title = "No data found!";
  String total_farmers = "0";
  String farmer_status = "stagnant";
  String collection_status = "stagnant";
  String farmer_percentage = "0%";
  String collection_percentage = "0%";

  List<DropdownMenuItem<String>> dayFilter = [
    const DropdownMenuItem(child: Text("7 Days"), value: "7 days"),
    const DropdownMenuItem(child: Text("14 Days"), value: "14 days"),
    const DropdownMenuItem(child: Text("1 Month"), value: "30 days"),
  ];
  CustomThemes customs = CustomThemes();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
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

  double _parseAmount(dynamic amount) {
    try {
      if (amount is int) {
        return amount.toDouble();
      } else if (amount is double) {
        return amount;
      } else if (amount is String) {
        return double.parse(amount);
      } else {
        throw FormatException("Amount is not a valid number.");
      }
    } catch (e) {
      return 0.0; // Default value in case of an error
    }
  }

  // barchart group data
  List<BarChartGroupData> _barChartGroupData = [];
  List<BarChartGroupData> _farmerChartGroupData = [];

  // technician data
  String full_name = "Invalid User";
  String greetings = "Hello";
  String profile_photo = "https://lsims.ladybirdsmis.com/sims/images/sch_profiles/testimonytbl1/kibwezi.jpg";

  void initState() {
    // TODO: implement initState
    super.initState();
    loadTechnicianData();
  }

  bool _loading = false;
  bool _loadingDash = false;
  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  void loadTechnicianData() async {
    setState(() {
      _loading = true;
      _loadingDash = true;
    });
    // get the user credentials
    ApiConnection api = new ApiConnection();
    String? token = await _storage.read(key: 'token');
    var technician_data = await api.getTechnicianData(token!);
    setState(() {
      _loading = false;
    });

    // check if it has a valid json structure
    bool isJson = isValidJson(technician_data);
    if (isJson) {
      var data = jsonDecode(technician_data);
      if (data['success']) {
        setState(() {
          full_name = data['data'][0]['fullname'];
          greetings = data['greetings'];
          profile_photo =
              (data['data'][0]['profile_photo'] as String).trim().length > 0
                  ? data['data'][0]['profile_photo']
                  : profile_photo;
        });

        //get the graphical data
        getDashboardData(drop_down);
      } else {
        customs.maruSnackBarDanger(context: context, text: data['message']);
      }
    } else {
      customs.maruSnackBarDanger(
          context: context, text: "Fatal error occured!");
    }
  }

  void getDashboardData(String period) async {
    setState(() {
      _loadingDash = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    String? token = await _storage.read(key: 'token');
    var dash_data = await apiConnection.getTechnicianDashboard(token!, period);

    //set the map data
    if (isValidJson(dash_data)) {
      var dashData = jsonDecode(dash_data);
      _barChartGroupData = [
        BarChartGroupData(x: 1, barRods: [
          BarChartRodData(
            toY: 0,
            color: customs.primaryColor,
          )
        ], showingTooltipIndicators: [
          0
        ]),
      ];

      if (dashData['success']) {
        // show dashboard data
        //create the barchart data
        setState(() {
          //statts and percentages
          farmer_status = dashData['farmer_status'];
          collection_status = dashData['collection_status'];
          farmer_percentage = dashData['farmer_percentage'].toString();
          collection_percentage = dashData['collection_percentage'].toString();
          //period title
          period_title = dashData['period_range'];

          // total litres
          total_litres = dashData['total_litres'].toString();

          // farmer barchart data
          _barChartGroupData = (dashData['data'] as List<dynamic>).asMap().entries.map((entry) {
            var item = entry.value;
            return BarChartGroupData(x: entry.key, barRods: [
              BarChartRodData(
                toY: _parseAmount(item['amount']),
                color: customs.primaryColor,
              )
            ], showingTooltipIndicators: [
              0
            ]);
          }).toList();

          // farmer data
          _farmerChartGroupData = (dashData['member'] as List<dynamic>).asMap().entries.map((entry) {
            var item = entry.value;
            return BarChartGroupData(x: entry.key, barRods: [
              BarChartRodData(
                toY: _parseAmount(item['farmers']),
                color: customs.primaryColor,
              )
            ], showingTooltipIndicators: [
              0
            ]);
          }).toList();

          // farmer x axis data
          daysOfWeek = (dashData['data'] as List<dynamic>).map<String>((item) {
            return item['label'].toString();
          }).toList();
          daysOfWeek.insert((daysOfWeek.length), "");

        });
      } else {
        customs.maruSnackBarDanger(
            context: context, text: "A fatal error has occured!");
      }
    } else {
      customs.maruSnackBarDanger(
          context: context, text: "An fatal error has occured!");
    }

    // hide the skeletonizer
    setState(() {
      _loadingDash = false;
    });
  }

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
                Skeletonizer(
                  enabled: _loading,
                  child: Card(
                    color: customs.whiteColor,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "$greetings,",
                                style: customs.primaryTextStyle(
                                    size: width * 0.05,
                                    fontweight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: height * 0.005,
                              ),
                              SizedBox(
                                width: width * 0.5,
                                child: Text(
                                  "$full_name",
                                  style: customs.successTextStyle(
                                      size: width * 0.06,
                                      fontweight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: width * 0.08,
                                backgroundColor: customs.primaryShade,
                                child: ClipOval(
                                  child: Image.network(
                                    "$profile_photo",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Skeleton.ignore(
                                child: Container(
                                  color: customs.secondaryColor,
                                  child: Text(
                                    "Collection Technician",
                                    style: customs.whiteTextStyle(size: 10),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Card(
                  color: customs.whiteColor,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                fontSize: 16,
                                size: Sizes.sm,
                                text: "Collect Milk",
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "/technician_collect_milk");
                                }),
                            customs.maruButton(
                                showArrow: true,
                                iconSize: 15,
                                fontSize: 16,
                                size: Sizes.sm,
                                text: "Find Technician",
                                onPressed: () {
                                  customs.maruSnackBar(
                                      context: context, text: "Coming soon!");
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
                        style: customs.darkTextStyle(size: 18, underline: true),
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
                            getDashboardData(drop_down);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                // SHOW THE COLLECTION IN LITERS
                Skeletonizer(
                  enabled: _loadingDash,
                  child: Card(
                    color: customs.whiteColor,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        Skeleton.keep(
                          child: Padding(
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
                        ),
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$total_litres Ltrs",
                                  style: customs.darkTextStyle(
                                      size: width * 0.05,
                                      fontweight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "$period_title",
                                  style:
                                      customs.darkTextStyle(size: width * 0.03),
                                )
                              ],
                            )
                          ],
                        ),
                        Expanded(
                          child: Skeleton.ignore(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      collection_status == "stagnant" ? Icons.linear_scale : collection_status == "increase" ? Icons.arrow_drop_up : Icons.arrow_drop_up,
                                      color: collection_status == "stagnant" ? customs.darkColor : collection_status == "increase" ? customs.successColor : customs.dangerColor,
                                    ),
                                    Text(
                                      "$collection_percentage%",
                                      style:collection_status == "stagnant" ? customs.darkTextStyle(size: width * 0.03, fontweight: FontWeight.bold) : collection_status == "increase" ? customs.successTextStyle(size: width * 0.03, fontweight: FontWeight.bold) : customs.dangerTextStyle(size: width * 0.03, fontweight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Skeletonizer(
                  enabled: _loadingDash,
                  child: Skeleton.leaf(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: customs.whiteColor,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "MILK COLLECTION STATS",
                            style: customs.darkTextStyle(
                                size: 18,
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
                                    getTooltipColor: (group) =>
                                        Colors.transparent,
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
                                            size: 12,
                                            fontweight: FontWeight.bold),
                                      );
                                    },
                                  )),
                                  borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        left: BorderSide(
                                            color: customs.primaryColor,
                                            width: 1),
                                      )),
                                  barGroups: _barChartGroupData,
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
                                                  size: 12,
                                                  fontweight: FontWeight.bold),
                                            );
                                          },
                                        )),
                                    bottomTitles: AxisTitles(
                                        axisNameWidget: Padding(
                                          padding: const EdgeInsets.only(top:16.0),
                                          child: Center(
                                              child: Text("Days of the week",
                                                  style: customs.primaryTextStyle(
                                                      size: 12))),
                                        ),
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 10,
                                          getTitlesWidget: (value, meta) {
                                            return Transform.rotate(
                                              angle: -30 * (3.1415927 / 180),
                                              child: Text(
                                                "${daysOfWeek[int.parse(meta.formattedValue)]}",
                                                textAlign: TextAlign.center,
                                                style: customs.darkTextStyle(
                                                    size: 12,
                                                    fontweight: FontWeight.bold),
                                              ),
                                            );
                                          },
                                        )
                                    ),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
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
                        style: customs.darkTextStyle(size: 18, underline: true),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
                Skeletonizer(
                  enabled: _loadingDash,
                  child: Card(
                    color: customs.whiteColor,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        Skeleton.keep(
                          child: Padding(
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
                        ),
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$total_farmers Farmers",
                                  style: customs.darkTextStyle(
                                      size: width * 0.05,
                                      fontweight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "$period_title",
                                  style:
                                      customs.darkTextStyle(size: width * 0.03),
                                )
                              ],
                            )
                          ],
                        ),
                        Expanded(
                          child: Skeleton.ignore(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      farmer_status == "stagnant" ? Icons.linear_scale : farmer_status == "increase" ? Icons.arrow_drop_up : Icons.arrow_drop_up,
                                      color: farmer_status == "stagnant" ? customs.darkColor : farmer_status == "increase" ? customs.successColor : customs.dangerColor,
                                    ),
                                    Text(
                                      "$farmer_percentage%",
                                      style: farmer_status == "stagnant" ? customs.darkTextStyle(size: width * 0.03, fontweight: FontWeight.bold) : farmer_status == "increase" ? customs.successTextStyle(size: width * 0.03, fontweight: FontWeight.bold) : customs.dangerTextStyle(size: width * 0.03, fontweight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Skeletonizer(
                  enabled: _loadingDash,
                  child: Skeleton.leaf(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: customs.whiteColor,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "No. OF FARMERS",
                            style: customs.darkTextStyle(
                                size: 18,
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
                                    getTooltipColor: (group) =>
                                        Colors.transparent,
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
                                            size: 12,
                                            fontweight: FontWeight.bold),
                                      );
                                    },
                                  )),
                                  borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        left: BorderSide(
                                            color: customs.primaryColor,
                                            width: 1),
                                      )),
                                  barGroups: _farmerChartGroupData,
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
                                                  size: 12,
                                                  fontweight: FontWeight.bold),
                                            );
                                          },
                                        )),
                                    bottomTitles: AxisTitles(
                                        axisNameWidget: Padding(
                                          padding: const EdgeInsets.only(top:16.0),
                                          child: Center(
                                              child: Text("Days of the week",
                                                  style: customs.primaryTextStyle(
                                                      size: 12))),
                                        ),
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 10,
                                          getTitlesWidget: (value, meta) {
                                            return Transform.rotate(
                                              angle: -30 * (3.1415927 / 180),
                                              child: Text(
                                                "${daysOfWeek[int.parse(meta.formattedValue)]}",
                                                textAlign: TextAlign.center,
                                                style: customs.darkTextStyle(
                                                    size: 12,
                                                    fontweight: FontWeight.bold),
                                              ),
                                            );
                                          },
                                        )
                                    ),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
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

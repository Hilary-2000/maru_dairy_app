import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:maru/packages/push_notification_api.dart';
import 'package:maru/pages/member/history.dart';
import 'package:maru/pages/member/notification.dart';
import 'package:maru/pages/member/settings.dart';
import 'package:skeletonizer/skeletonizer.dart';

class memberDashboard extends StatefulWidget {
  const memberDashboard({super.key});

  @override
  State<memberDashboard> createState() => _memberDashboardState();
}

class _memberDashboardState extends State<memberDashboard> {
  CustomThemes customs = CustomThemes();
  Map<String, dynamic>? args;

  void changeWindow(index) {
    setState(() {});
  }

  void _updateIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  Future<void> getNotifications() async {
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getMemberNotification(entity: "member");
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          notification_count = res['notification_count'];
        });
      }
    }
  }

  var index = 0;
  bool init = false;
  int notification_count = 0;

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: customs.whiteColor,
          title:  Text('Are you sure?', style: customs.darkTextStyle(size: 25),),
          content: Text(
            'Are you sure you want to leave?', style: customs.darkTextStyle(size: 14, fontweight: FontWeight.normal),
          ),
          actions: <Widget>[
            Row(
              children: [
                Spacer(),
                GestureDetector(onTap:(){Navigator.pop(context, false);}, child: Text("Nevermind", style: customs.successTextStyle(size: 15, fontweight: FontWeight.bold),)),
                SizedBox(width: 20,),
                GestureDetector(onTap:(){Navigator.pop(context, true);}, child: Text("Leave", style: customs.dangerTextStyle(size: 15, fontweight: FontWeight.bold),)),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if(!init){
      await customs.initialize();
      setState(() {
        init = true;
      });

      // get the passed index for notification purposes
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (customs.isValidJson(jsonEncode(args))){
        var arguments = jsonDecode(jsonEncode(args));
        int passed_index = arguments == null ? 0 : arguments['index'] ?? 0;
        setState(() {
          index = passed_index;
        });
      }

      // initialize
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      await PushNotificationApi().initNotifications();
    }
  }

  // set color mode
  Future<void> setColorMode(String color_mode) async {
    setState(() {
      customs.color_mode = color_mode;
    });
    print(color_mode);
    await customs.initialize();
    setState(() {
      customs.color_mode = color_mode;
    });
    print("Dashboard color mode : ${customs.color_mode}");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> member_windows = [
      // THE MEMBER DASHBOARD AFTER LOGIN
      memberDash(updateIndex: _updateIndex, getNotifications: getNotifications,),
      // THE MEMBER MILK COLLECTION HISTORY
      memberHistory(getNotifications: getNotifications),
      // THE MEMBER HISTORY
      notificationWindow(getNotifications: getNotifications, notification_count: notification_count,),
      // THE MEMBER PROFILE
      MemberSettings(getNotifications: getNotifications, setColorMode: setColorMode)
    ];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        didPop = index == 0;
        if(!didPop){
          setState(() {
            index = 0;
          });
          return;
        }else{
          final bool shouldPop = await _showBackDialog() ?? false;
          if (context.mounted && shouldPop) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: customs.whiteColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: customs.darkColor
          ),
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
        body: member_windows[index],
        bottomNavigationBar: Builder(builder: (context) {
          double width = MediaQuery.of(context).size.width;
          return Container(
            decoration: BoxDecoration(
              color: customs.whiteColor,
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              border: Border.all(
                color: customs.whiteColor,
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
                              child: notification_count > 0 ? Container(
                                width: 20,
                                height: 20,
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    "$notification_count",
                                    style: customs.whiteTextStyle(
                                        size: 10, fontweight: FontWeight.bold),
                                  ),
                                ),
                              ): SizedBox(height: 0)
                          )
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
                ? (false ? CircleAvatar(
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
                  ) : SizedBox())
                : null),
      ),
    );
  }
}

class memberDash extends StatefulWidget {
  final void Function(int) updateIndex;
  final void Function() getNotifications;
  const memberDash({super.key, this.getNotifications = _defualtFunction, required this.updateIndex});
  static void _defualtFunction(){}

  @override
  State<memberDash> createState() => _memberDashState();
}

class _memberDashState extends State<memberDash> {
  CustomThemes customs = CustomThemes();
  String drop_down = "7";
  List<BarChartGroupData> barGroupData = [];
  List<DropdownMenuItem<String>> dayFilter = [
    const DropdownMenuItem(child: Text("7 Days"), value: "7"),
    const DropdownMenuItem(child: Text("14 Days"), value: "14"),
    const DropdownMenuItem(child: Text("1 month"), value: "30"),
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

  bool loading = false;
  bool _init = false;

  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_init){
      // initialize
      customs.initialize();
      setState(() {
        _init = true;
      });
      widget.getNotifications();
      setState(() {
        barGroupData = [
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(
              toY: 0,
              color: customs.primaryColor,
            )
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(
              toY: 0,
              color: customs.primaryColor,
            )
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(
              toY: 0,
              color: customs.primaryColor,
            )
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 4, barRods: [
            BarChartRodData(
              toY: 0,
              color: customs.primaryColor,
            )
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 5, barRods: [
            BarChartRodData(
              toY: 0,
              color: customs.primaryColor,
            )
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 6, barRods: [
            BarChartRodData(
              toY: 0,
              color: customs.primaryColor,
            )
          ], showingTooltipIndicators: [
            0
          ]),
          BarChartGroupData(x: 7, barRods: [
            BarChartRodData(
              toY: 0,
              color: customs.primaryColor,
            )
          ], showingTooltipIndicators: [
            0
          ])];
      });
      // member dashboard
      memberDashboard(drop_down);
    }
  }

  String total_collection = "0";
  String growth = "0%";
  String trajectory = "constant";
  String duration = "N/A";
  String greetings = "Hello,";
  var member_data = null;

  // change to camel case
  String toCamelCase(String text) {
    // Step 1: Split the string by spaces or underscores
    List<String> words = text.split(RegExp(r'[\s_]+'));

    // Step 2: Capitalize the first letter of each word and lowercase the rest
    List<String> capitalizedWords = words.map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    // Step 3: Join the capitalized words with spaces
    return capitalizedWords.join(' ');
  }

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



  // get the member dashboard
  Future<void> memberDashboard(String period) async {
    setState(() {
      loading = true;
    });
    //get the member dashboard
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getMemberDash(period+" days");
    if (customs.isValidJson(response)) {
      var res = jsonDecode(response);
      if (res['success']) {
        member_data = res['member_details'];
        // set the barchart data
        List<String> days = [];
        setState(() {
          barGroupData = (res['collection_data'] as List<dynamic>).asMap().entries.map((entry) {
            var item = entry.value;
            days.add(item['label']);
            return BarChartGroupData(x: entry.key, barRods: [
              BarChartRodData(
                toY: _parseAmount(item['amount']),
                color: customs.primaryColor,
              )
            ], showingTooltipIndicators: [
              0
            ]);
          }).toList();
          daysOfWeek = days;
          growth = res['percentage'].toString();
          total_collection = res['total_collection'].toString();
          duration = res['duration'].toString();
          greetings = res['greetings'];
          trajectory = res['collection_status'].toString();
        });
      } else {
        member_data = null;
      }
    } else {
      member_data = null;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return customs.refreshIndicator(
      onRefresh: () async{
        await memberDashboard(drop_down);
        HapticFeedback.lightImpact();
      },
      child: SafeArea(child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          double calculatedWidth = width / 2 - 170;
          calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: customs.secondaryShade.withOpacity(0.2),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Skeletonizer(
                    enabled: loading,
                    effect: customs.maruShimmerEffect(),
                    child: Card(
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
                                  "$greetings",
                                  style: customs.primaryTextStyle(
                                      size: 16,
                                      fontweight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Text(
                                  toCamelCase(member_data != null ? member_data['fullname'] ?? "N/A" : "N/A"),
                                  style: customs.successTextStyle(
                                      size: 20,
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
                                    radius: 34,
                                    backgroundColor: customs.primaryShade,
                                    child: ClipOval(
                                      child: (member_data != null) ?
                                      Image.network(
                                        "${customs.apiURLDomain}${member_data['profile_photo']}",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: customs.primaryColor,
                                              backgroundColor: customs.secondaryShade_2,
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            "assets/images/placeholderImg.jpg",
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          );
                                        },
                                      )
                                          :
                                      Image.asset(
                                        // profile.length > 0 ? profile : "assets/images/placeholderImg.jpg",
                                        "assets/images/placeholderImg.jpg",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/new_member"
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Skeleton.ignore(
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: customs.infoColor,
                                        borderRadius: BorderRadius.circular(5.0)),
                                    child: Text(
                                      member_data != null ? "${member_data['membership'] ?? "N/A"}" : "N/A",
                                      style: customs.darkTextStyle(
                                          size: 10, fontweight: FontWeight.bold),
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
                                  fontSize: 16,
                                  size: Sizes.sm,
                                  text: "View Membership",
                                  onPressed: () async {
                                    LocalAuthentication auth = LocalAuthentication();
                                    bool proceed = await customs.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to view your membership!");
                                    if(proceed){
                                      Navigator.pushNamed(
                                        context, "/member_membership",
                                        arguments: {
                                          "member_id" : member_data['user_id']
                                        }
                                      );
                                    }else{
                                      customs.maruSnackBarDanger(context: context, text: "Authenticated failed!");
                                    }
                                  }),
                              customs.maruButton(
                                  showArrow: true,
                                  iconSize: 15,
                                  fontSize: 16,
                                  size: Sizes.sm,
                                  text: "Inquire",
                                  onPressed: () {
                                    // Navigator.pushNamed(context, "/member_inbox");
                                    int index = 2;
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
                          style: customs.darkTextStyle(size: 18, underline: true, fontweight: FontWeight.bold),
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
                                // member dashboard
                                memberDashboard(drop_down);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Skeletonizer(
                    enabled: loading,
                    effect: customs.maruShimmerEffect(),
                    child: Card(
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
                              radius: 30,
                              child: Icon(
                                Icons.water_drop_outlined,
                                size: 24,
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
                                    "$total_collection Ltrs",
                                    style: customs.darkTextStyle(
                                        size: 16,
                                        fontweight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "$duration",
                                    style:
                                        customs.darkTextStyle(size: 12),
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
                                      trajectory == "constant" ? Icons.linear_scale : (trajectory == "increase" ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                      color: trajectory == "constant" ? customs.darkColor : (trajectory == "increase" ? customs.successColor : customs.dangerColor),
                                    ),
                                    Text(
                                      "$growth%",
                                      style: trajectory != "constant" ? (trajectory == "increase" ? customs.successTextStyle(size: 12,fontweight: FontWeight.bold) : customs.dangerTextStyle(size: 12,fontweight: FontWeight.bold)) : customs.darkTextStyle(size: 12,fontweight: FontWeight.bold),
                                    ),
                                  ],
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
                              size: 12,
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
                                          size: 12, fontweight: FontWeight.bold),
                                    );
                                  },
                                )),
                                borderData: FlBorderData(
                                    show: true,
                                    border: Border(
                                      left: BorderSide(
                                          color: customs.primaryColor, width: 1),
                                    )),
                                barGroups: barGroupData,
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
                                          child: Text("",
                                              style: customs.primaryTextStyle(
                                                  size: 12, fontweight: FontWeight.bold))),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 15,
                                        getTitlesWidget: (value, meta) {
                                          return Transform.rotate(
                                            angle: -30 * (3.1415927 / 180),
                                            child: Text(
                                              "${daysOfWeek[int.parse(meta.formattedValue)]}",
                                              textAlign: TextAlign.center,
                                              style: customs.darkTextStyle(
                                                  size: 10,
                                                  fontweight: FontWeight.bold),
                                            ),
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
      )),
    );
  }
}

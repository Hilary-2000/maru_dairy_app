import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:maru/packages/push_notification_api.dart';
import 'package:maru/pages/admin/admin_account.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
  int notification_count = 0;
  bool init = false;
  Map<String, dynamic>? args;
  CustomThemes customs = CustomThemes();
  void _updateIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void initState(){
    super.initState();
    //get notification count
    getNotifications();
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


  Future<void> getNotifications() async {
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getNotification();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          notification_count = res['notification_count'];
        });
      }
    }
  }

  bool load_inquiries = false;

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
    List<Widget> admin_dashboard = [
      // admin dashboard
      AdminDashboard(updateIndex: _updateIndex, getNotifications: getNotifications,),
      // Maru members
      OurMembers(getNotifications: getNotifications,),
      // Collection History
      TechnicianHistory(getNotifications: getNotifications,),
      // admin inquiries
      AdminInquiries(getNotifications: getNotifications,),
      // Admin Account
      AdminAccount(updateIndex: _updateIndex, getNotifications: getNotifications,setColorMode: setColorMode,)
    ];
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
                        Image(
                            image: AssetImage("assets/images/maru-nobg.png")
                        ),
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
        body: admin_dashboard[index],
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
                                  size: 12, fontweight: FontWeight.bold
                          ),
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
                              child: notification_count > 0 ? Container(
                                width: 20,
                                height: 20,
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    notification_count > 9 ? "9+" : "$notification_count",
                                    style: customs.whiteTextStyle(
                                        size: 10, fontweight: FontWeight.bold),
                                  ),
                                ),
                              ): SizedBox(height: 0)
                          )
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
                backgroundColor: customs.secondaryShade.withOpacity(0.2),
                child: IconButton(
                  icon: Icon(
                    Icons.person_add_alt_outlined,
                    size: 25,
                    color: customs.secondaryColor,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/new_member");
                  },
                ),
              ))
            : (index == 3
                ? CircleAvatar(
                    radius: 25,
                    backgroundColor: customs.successShade_2,
                    child: IconButton(
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        size: 25,
                        color: customs.successColor,
                      ),
                      onPressed: () async {
                        await Navigator.pushNamed(context, "/select_member_to_send_message");
                      },
                    ),
                  )
                : (index == 1
                    ? (CircleAvatar(
                        radius: 25,
                        backgroundColor: customs.secondaryShade.withOpacity(0.2),
                        child: IconButton(
                          icon: Icon(
                            Icons.person_add_alt_outlined,
                            size: 25,
                            color: customs.successColor,
                          ),
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context, "/new_member"
                            );
                          },
                        ),
                      ))
                    : null
        )
        ),
      ),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  final void Function(int) updateIndex;
  final void Function() getNotifications;
  const AdminDashboard({super.key, required this.updateIndex, this.getNotifications = _defaultFunction});
  static void _defaultFunction(){}

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  CustomThemes customs = CustomThemes();
  bool loading = false;
  bool _init = false;
  int index = 0;
  String drop_down = "7";
  String greetings = "Hello";
  var member_data = null;
  var collection_stats = null;
  var member_present_stats = null;
  var member_registered_stats = null;
  String collection_count = "0";
  String member_present_count = "0";
  String members_registered_count = "0";
  String report_period = "N/A - N/A";

  String member_status = "constant";
  String member_percentage = "0%";
  String collection_status = "constant";
  String collection_percentage = "0%";

  List<DropdownMenuItem<String>> dayFilter = [
    const DropdownMenuItem(child: Text("7 Days"), value: "7"),
    const DropdownMenuItem(child: Text("14 Days"), value: "14"),
    const DropdownMenuItem(child: Text("I month"), value: "30"),
  ];
  List<BarChartGroupData> membersPresentPlot = [];
  List<BarChartGroupData> newMembersPlot = [];
  List<BarChartGroupData> collectionPlot = [];
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

  void displayGraphCollection() {
    List<String> days = [];
    List<BarChartGroupData> collects =
        (collection_stats as List<dynamic>).asMap().entries.map((entry) {
      var item = entry.value;
      days.add(item['label']);
      return BarChartGroupData(x: entry.key, barRods: [
        BarChartRodData(
          toY: _parseAmount(item['collection']),
          color: customs.primaryColor,
        )
      ], showingTooltipIndicators: [
        0
      ]);
    }).toList();
    setState(() {
      daysOfWeek = days;
      collectionPlot = collects;
    });
  }

  void displayGraphNewMembers() {
    List<String> days = [];
    List<BarChartGroupData> collects =
        (member_registered_stats as List<dynamic>).asMap().entries.map((entry) {
      var item = entry.value;
      days.add(item['label']);
      return BarChartGroupData(x: entry.key, barRods: [
        BarChartRodData(
          toY: _parseAmount(item['collection']),
          color: customs.primaryColor,
        )
      ], showingTooltipIndicators: [
        0
      ]);
    }).toList();
    setState(() {
      daysOfWeek = days;
      newMembersPlot = collects;
    });
  }

  void displayGraphPresentMembers() {
    List<String> days = [];
    List<BarChartGroupData> collects =
        (member_present_stats as List<dynamic>).asMap().entries.map((entry) {
      var item = entry.value;
      days.add(item['label']);
      return BarChartGroupData(x: entry.key, barRods: [
        BarChartRodData(
          toY: _parseAmount(item['collection']),
          color: customs.primaryColor,
        )
      ], showingTooltipIndicators: [
        0
      ]);
    }).toList();
    setState(() {
      daysOfWeek = days;
      membersPresentPlot = collects;
    });
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    // get the admin dashboard
    if(!_init){
      await customs.initialize();
      setState(() {
        collectionPlot = [
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
        ];
        membersPresentPlot = [
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
        ];
        newMembersPlot = [
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
        ];
      });
      await getAdminDash();
      _init = true;
    }
  }

  Future<void> getAdminDash() async {
    setState(() {
      loading = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.adminDashboard(drop_down);
    if (customs.isValidJson(response)) {
      var res = jsonDecode(response);
      if (res['success']) {
        setState(() {
          // members data
          member_data = res['member_data'];
          collection_stats = res['collection_graph_data'];
          member_registered_stats = res['member_registered_graph'];
          member_present_stats = res['member_present_graph'];
          collection_count = res['total_collection'].toString();
          member_present_count = res['members_present'].toString();
          members_registered_count = res['members_registered'].toString();
          greetings = res['time_of_day'];
          report_period = res['report_period'];

          member_status = res['member_status'];
          member_percentage = "${res['member_percentage']}%";
          collection_status = res['collection_status'];
          collection_percentage = "${res['collection_percentage']}%";

          //display the data on graphs
          displayGraphCollection();
          displayGraphNewMembers();
          displayGraphPresentMembers();
        });
      } else {
        setState(() {
          // members data
          member_data = null;
          collection_stats = [];
          member_registered_stats = [];
          member_present_stats = [];
          collection_count = "0";
          member_present_count = "0";
          members_registered_count = "0";
          greetings = "Hello";
          report_period = "N/A - N/A";

          //display the data on graphs
          displayGraphCollection();
          displayGraphNewMembers();
          displayGraphPresentMembers();
        });
        customs.maruSnackBarSuccess(
            context: context, text: "An error has occured!");
      }
    } else {
      setState(() {
        // members data
        member_data = null;
        collection_stats = [];
        member_registered_stats = [];
        member_present_stats = [];
        collection_count = "0";
        member_present_count = "0";
        members_registered_count = "0";
        greetings = "Hello";
        report_period = "N/A - N/A";

        //display the data on graphs
        displayGraphCollection();
        displayGraphNewMembers();
        displayGraphPresentMembers();
      });
      customs.maruSnackBarDanger(
          context: context, text: "Fatal error occured!");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return customs.refreshIndicator(
      onRefresh: ()async{
        await getAdminDash();
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
              color: customs.secondaryShade.withOpacity(0.2)
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: width*0.73,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "$greetings,",
                                  style: customs.primaryTextStyle(
                                      size: 16,
                                      fontweight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Text(
                                  member_data != null
                                      ? customs.toCamelCase(member_data['fullname'])
                                      : "N/A",
                                  style: customs.successTextStyle(
                                      size: 20,
                                      fontweight: FontWeight.bold
                                  ),
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
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Skeleton.ignore(
                                  child: Container(
                                    color: customs.warningColor,
                                    child: Text(
                                      "Administrator",
                                      style: customs.whiteTextStyle(size: 10, fontweight: FontWeight.bold),
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
                                  fontSize: 16,
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
                          style: customs.darkTextStyle(size: 12, underline: true),
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

                              // get the admin dashboard
                              getAdminDash();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  // SHOW THE COLLECTION IN LITERS
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
                              backgroundColor: customs.successColor.withOpacity(0.2),
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
                                    "$collection_count Ltrs",
                                    style: customs.darkTextStyle(
                                        size: 16,
                                        fontweight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "$report_period",
                                    style: customs.darkTextStyle(size: 12),
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
                                      collection_status == "constant"
                                          ? Icons.linear_scale
                                          : collection_status == "increase"
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                      color: collection_status == "constant"
                                          ? customs.darkColor
                                          : collection_status == "increase"
                                              ? customs.successColor
                                              : customs.dangerColor,
                                    ),
                                    Text(
                                      collection_percentage,
                                      style: collection_status == "constant"
                                          ? customs.darkTextStyle(
                                              size: 12,
                                              fontweight: FontWeight.bold)
                                          : (collection_status == "increase"
                                              ? customs.successTextStyle(
                                                  size: 12,
                                                  fontweight: FontWeight.bold)
                                              : customs.dangerTextStyle(
                                                  size: 12,
                                                  fontweight: FontWeight.bold)),
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
                  Skeletonizer(
                    enabled: loading,
                    effect: customs.maruShimmerEffect(),
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
                                              size: 8,
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
                                    barGroups: collectionPlot,
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
                                                      size: 12))),
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 20,
                                            getTitlesWidget: (value, meta) {
                                              return Transform.rotate(
                                                angle: -30 * (3.1415927 / 180),
                                                child: Text(
                                                  daysOfWeek[int.parse(
                                                      meta.formattedValue)],
                                                  textAlign: TextAlign.center,
                                                  style: customs.darkTextStyle(
                                                      size: 10,
                                                      fontweight: FontWeight.bold),
                                                ),
                                              );
                                            },
                                          )),
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
                    )
                  ),
                  // SHOW THE FARMER WHO GAVE MILK STATISTICS
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Farmer Stats",
                          style: customs.darkTextStyle(size: 12, underline: true),
                        ),
                        const Spacer()
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
                                Icons.people_alt_outlined,
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
                                    "$member_present_count Farmers Registered",
                                    style: customs.darkTextStyle(
                                        size: 16,
                                        fontweight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "$report_period",
                                    style:
                                        customs.darkTextStyle(size: 12),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.005,
                  ),
                  Skeletonizer(
                    enabled: loading,
                    effect: customs.maruShimmerEffect(),
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
                            "No. OF FARMERS REGISTERED",
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
                                            size: 8, fontweight: FontWeight.bold),
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
                                  barGroups: membersPresentPlot,
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
                                            child: Text("",
                                                style: customs.primaryTextStyle(
                                                    size: 12))),
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 20,
                                          getTitlesWidget: (value, meta) {
                                            return Transform.rotate(
                                              angle: -30 * (3.1415927 / 180),
                                              child: Text(
                                                daysOfWeek[
                                                    int.parse(meta.formattedValue)],
                                                textAlign: TextAlign.center,
                                                style: customs.darkTextStyle(
                                                    size: 10,
                                                    fontweight: FontWeight.bold),
                                              ),
                                            );
                                          },
                                        )),
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
                          style: customs.darkTextStyle(size: 12, underline: true),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                  Skeletonizer(
                    enabled: loading,
                    effect: customs.maruShimmerEffect(),
                    child: Card(
                      color: customs.whiteColor,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                                Icons.people_alt_outlined,
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
                                    "$members_registered_count New Members",
                                    style: customs.darkTextStyle(
                                        size: 16,
                                        fontweight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "$report_period",
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
                                      member_status == "constant"
                                          ? Icons.linear_scale
                                          : member_status == "increase"
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                      color: member_status == "constant"
                                          ? customs.darkColor
                                          : member_status == "increase"
                                              ? customs.successColor
                                              : customs.dangerColor,
                                    ),
                                    Text(
                                      member_percentage,
                                      style: member_status == "constant"
                                          ? customs.darkTextStyle(
                                              size: 12,
                                              fontweight: FontWeight.bold)
                                          : (member_status == "increase"
                                              ? customs.successTextStyle(
                                                  size: 12,
                                                  fontweight: FontWeight.bold)
                                              : customs.dangerTextStyle(
                                                  size: 12,
                                                  fontweight: FontWeight.bold)),
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
                  Skeletonizer(
                    enabled: loading,
                    effect: customs.maruShimmerEffect(),
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
                              "No. OF NEW MEMBERS",
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
                                              size: 8,
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
                                    barGroups: newMembersPlot,
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
                                              child: Text("",
                                                  style: customs.primaryTextStyle(
                                                      size: 12))),
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 20,
                                            getTitlesWidget: (value, meta) {
                                              return Transform.rotate(
                                                angle: -30 * (3.1415927 / 180),
                                                child: Text(
                                                  daysOfWeek[int.parse(
                                                      meta.formattedValue)],
                                                  textAlign: TextAlign.center,
                                                  style: customs.darkTextStyle(
                                                      size: 10,
                                                      fontweight: FontWeight.bold),
                                                ),
                                              );
                                            },
                                          )),
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
      )),
    );
  }
}

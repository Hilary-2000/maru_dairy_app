import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TechnicianDetails extends StatefulWidget {
  const TechnicianDetails({super.key});

  @override
  State<TechnicianDetails> createState() => _TechnicianDetailsState();
}

class _TechnicianDetailsState extends State<TechnicianDetails> {
  CustomThemes customs = CustomThemes();
  Map<String, dynamic>? args;
  List<Color> bg_color = [];
  int index = 0;
  var technicianData = null;
  String collection = "0 Litres Collected";
  bool loading = false;
  bool _init = false;
  List<dynamic>regionDV = [];

  Future<void> getTechnicianData() async {
    setState(() {
      loading = true;
      regionDV = [];
    });
    // get the arguments
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if(customs.isValidJson(jsonEncode(args))){
      var arguments = jsonDecode(jsonEncode(args));
      setState(() {
        index = arguments['index'];
      });
      ApiConnection apiConnection = new ApiConnection();
      var response = await apiConnection.technicianDetails(arguments['technician_id'].toString());
      if(customs.isValidJson(response)){
        var res = jsonDecode(response);
        if(res['success']){
          setState(() {
            technicianData = res['technician_data'];
            collection = "${res['total_collection']} Litres Collected";
            regionDV = customs.isValidJson("${res['technician_data']['region']}") ? jsonDecode("${res['technician_data']['region']}") : [];
          });
        }else{
          setState(() {
            technicianData = null;
            collection = "0 Litres Collected";
          });
          customs.maruSnackBarDanger(context: context, text: res['message']);
        }
      }else{
        setState(() {
          technicianData = null;
          collection = "0 Litres Collected";
        });
        customs.maruSnackBarDanger(context: context, text: "An error occured!");
      }
    }else{
      setState(() {
        technicianData = null;
        collection = "0 Litres Collected";
      });
      Navigator.pop(context);
    }

    // set state
    setState(() {
      loading = false;
    });
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if(!_init){
      setState(() {
        _init = true;
        bg_color = [customs.primaryColor, customs.secondaryColor, customs.warningColor, customs.darkColor, customs.successColor];
      });

      await customs.initialize();

      //GET MEMBER DATA
      getTechnicianData();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: customs.darkColor),
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
              color: customs.whiteColor,
            ),
            child: Column(
              children: [
                Skeletonizer(
                  enabled: loading,
                  effect: customs.maruShimmerEffect(),
                  child: Container(
                    height: height - 5,
                    width: width,
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("View Technician Details", style: customs.secondaryTextStyle(size: 15, fontweight: FontWeight.bold),),
                                  Hero(
                                    tag: _heroAddTodo,
                                    child: PopupMenuButton<String>(
                                      icon: Icon(FontAwesomeIcons.ellipsisVertical, size: 20, color: customs.darkColor,),
                                      onSelected: (String result) async {
                                        // Handle the selection here
                                        if(result == "delete"){
                                          var result = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                            return  _AddTodoPopupCard(technician_data: technicianData,);
                                          }));
                                          if(result != null){
                                            if(result['success']){
                                              customs.maruSnackBarSuccess(context: context, text: result['message']);
                                              Navigator.pop(context);
                                            }else{
                                              customs.maruSnackBarDanger(context: context, text: result['message']);
                                            }
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: "Cancelled!");
                                          }
                                        }
                                      },
                                      color: customs.whiteColor,
                                      itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'delete',
                                          height: 15,
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                            margin: EdgeInsets.zero,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.trash,
                                                  size: 15,
                                                  color: customs.dangerColor,
                                                ),
                                                Text(
                                                  ' Delete',
                                                  style: customs.dangerTextStyle(
                                                      size: 14,
                                                      fontweight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                              )
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Stack(children: [
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    width: width,
                                    height: 250,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: width * 0.9,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8)
                                              ),
                                              color: bg_color[index % bg_color.length]
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.9,
                                          height: 150,
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
                                                height: 45,
                                              ),
                                              Text(
                                                technicianData != null ? customs.toCamelCase(technicianData['fullname'] ?? "N/A") : "N/A",
                                                style: customs.darkTextStyle(
                                                    size: 20,
                                                    fontweight: FontWeight.bold),
                                              ),
                                              Text(
                                                collection,
                                                style: customs.secondaryTextStyle(
                                                    size: 12,
                                                    fontweight: FontWeight.normal),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                decoration: BoxDecoration(
                                                  color: (technicianData  != null ? customs.toCamelCase((technicianData['status'] ?? "0").toString()) : "0") == "1" ? customs.successColor : customs.dangerColor,
                                                  borderRadius: BorderRadius.circular(2)
                                                ),
                                                child: Text( (technicianData  != null ? customs.toCamelCase((technicianData['status'] ?? "0").toString()) : "0") == "1" ?  "Active" : "In-active", style:customs.whiteTextStyle(size: 10, fontweight: FontWeight.bold)),
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
                                        )
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: width * 0.7,
                            child: Divider(
                              color: customs.secondaryShade_2,
                            ),
                          ),
                          Container(
                            width: width * 0.9,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  technicianData != null ? technicianData['phone_number'] ?? "N/A" : "N/A",
                                  style: customs.secondaryTextStyle(size: 16),
                                ),
                                Divider(
                                  color: customs.secondaryShade_2,
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.9,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                Text(
                                  technicianData != null ? technicianData['email'] ?? "N/A" : "N/A",
                                  style: customs.secondaryTextStyle(size: 16),
                                ),
                                Divider(
                                  color: customs.secondaryShade_2,
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.9,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Location:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                Text(
                                  technicianData != null ? customs.toCamelCase(technicianData['residence'] ?? "N/A") : "N/A",
                                  style: customs.secondaryTextStyle(size: 16),
                                ),
                                Divider(
                                  color: customs.secondaryShade_2,
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.9,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Region Managed:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                Text(
                                    "${(regionDV.toString().length>2 ? regionDV.length : 0)} region(s)",
                                  style: customs.secondaryTextStyle(size: 16),
                                ),
                                Divider(
                                  color: customs.secondaryShade_2,
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.9,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Username:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                Text(
                                  technicianData != null ? customs.toCamelCase(technicianData['username'] ?? "N/A") : "N/A",
                                  style: customs.secondaryTextStyle(size: 16),
                                ),
                                Divider(
                                  color: customs.secondaryShade_2,
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.9,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "National Id:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                Text(
                                  technicianData != null ? customs.toCamelCase(technicianData['national_id'] ?? "N/A") : "N/A",
                                  style: customs.secondaryTextStyle(size: 16),
                                ),
                                Divider(
                                  color: customs.secondaryShade_2,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      )),
      floatingActionButton: CircleAvatar(
        backgroundColor: customs.secondaryShade.withOpacity(0.2),
        child: IconButton(
          icon: Icon(Icons.edit, color: customs.primaryColor,),
          onPressed: () async {
            await Navigator.pushNamed(context, "/edit_technician", arguments: {"index": index, "technician_id": (technicianData != null ? (technicianData['user_id'] ?? "0") : "0")});
            getTechnicianData();
          },
        ),
      ),
    );
  }
}


String _heroAddTodo = "ask_delete";

class _AddTodoPopupCard extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  var technician_data = null;
  _AddTodoPopupCard({Key? key, required this.technician_data}) : super(key: key);

  @override
  State<_AddTodoPopupCard> createState() => _AddTodoPopupCardState();
}

class _AddTodoPopupCardState extends State<_AddTodoPopupCard> {
  CustomThemes customThemes = new CustomThemes();

  bool saveLoader = false;
  bool init = false;

  void initState(){
    super.initState();
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await customThemes.initialize();
    if(!init){
      setState(() {
        init = !init;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          // createRectTween: (begin, end) {
          //   return CustomRectTween(begin: begin, end: end);
          // },
          child: Material(
            color: customThemes.whiteColor,
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Are you sure you want to delete \"${customThemes.toCamelCase(widget.technician_data['fullname'])}\" ?", style: customThemes.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Container(width: width, child: Text("All their data will be deleted permanently!", style: customThemes.secondaryTextStyle(size: 12, ),)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width/3,
                              child: customThemes.marOutlineuButton(
                                  text: "Delete",
                                  showLoader: saveLoader,
                                  disabled: saveLoader,
                                  onPressed: () async {
                                    setState((){
                                      saveLoader = true;
                                    });
                                    ApiConnection apiConn = ApiConnection();
                                    var response = await apiConn.deleteTechnician(widget.technician_data['user_id'].toString());
                                    if(customThemes.isValidJson(response)){
                                      var res = jsonDecode(response);
                                      if(res['success']){
                                        Navigator.pop(context, res);
                                      }else{
                                        Navigator.pop(context, res);
                                      }
                                    }
                                  },
                                  type: Type.danger
                              ),
                            ),
                            Container(
                              width: width/3,
                              child: customThemes.maruButton(
                                  text: "Cancel",
                                  showLoader: saveLoader,
                                  disabled: saveLoader,
                                  onPressed: (){
                                    Navigator.pop(context, {"success" : false, "message" : "Cancelled!"});
                                  },
                                  type: Type.secondary
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class HeroDialogRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  HeroDialogRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}
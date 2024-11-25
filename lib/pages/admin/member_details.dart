import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MemberDetails extends StatefulWidget {
  const MemberDetails({super.key});

  @override
  State<MemberDetails> createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  CustomThemes customs = CustomThemes();
  Map<String, dynamic>? args;
  List<Color> bg_color = [];
  int index = 0;
  var memberData = null;
  String collection_days = "0";
  String collected_amount = "0";
  bool loading = false;
  bool _init = false;

  Future<void> getMemberData() async {
    setState(() {
      loading = true;
    });
    // get the arguments
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if(customs.isValidJson(jsonEncode(args))){
      var arguments = jsonDecode(jsonEncode(args));
      setState(() {
        index = arguments['index'];
      });
      ApiConnection apiConnection = new ApiConnection();
      var response = await apiConnection.adminMemberDetails(arguments['member_id'].toString());
      if(customs.isValidJson(response)){
        var res = jsonDecode(response);
        if(res['success']){
          setState(() {
            memberData = res['member_details'];
            collection_days = res['collection_days'];
            collected_amount = res['total_collection'];
          });
        }else{
          setState(() {
            memberData = null;
            collection_days = "0";
            collected_amount = "0";
          });

          customs.maruSnackBarDanger(context: context, text: res['message']);
        }
      }else{
        customs.maruSnackBarDanger(context: context, text: "An error occured!");
      }
    }else{
      Navigator.pop(context);
    }

    // set state
    setState(() {
      loading = false;
    });
  }

  void didChangeDependencies(){
    super.didChangeDependencies();

    if(!_init){
      setState(() {
        _init = true;
        bg_color = [customs.primaryColor, customs.secondaryColor, customs.warningColor, customs.darkColor, customs.successColor];
      });

      //GET MEMBER DATA
      getMemberData();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.primaryShade,
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
            child: Column(
              children: [
                Skeletonizer(
                  enabled: loading,
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
                                  Text("View Member Details", style: customs.secondaryTextStyle(size: 15, fontweight: FontWeight.bold),),
                                  Hero(
                                    tag: _heroAddTodo,
                                    child: PopupMenuButton<String>(
                                      icon: Icon(FontAwesomeIcons.ellipsisVertical, size: 20,),
                                      onSelected: (String result) async {
                                        // Handle the selection here
                                        if(result == "delete"){
                                          var result = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                            return  _AddTodoPopupCard(member_data: memberData,);
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
                                                memberData != null ? customs.toCamelCase(memberData['fullname'] ?? "N/A") : "N/A",
                                                style: customs.darkTextStyle(
                                                    size: 20,
                                                    fontweight: FontWeight.bold),
                                              ),
                                              Text(
                                                memberData != null ? memberData['membership'] ?? "N/A" : "N/A",
                                                style: customs.secondaryTextStyle(
                                                    size: 12,
                                                    fontweight: FontWeight.normal),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        collection_days,
                                                        style:
                                                        customs.darkTextStyle(
                                                            size: 15,
                                                            fontweight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Text(
                                                        "Collection Days",
                                                        style: customs
                                                          .secondaryTextStyle(
                                                          size: 10,
                                                          fontweight:
                                                          FontWeight.normal
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        collected_amount,
                                                        style:
                                                        customs.darkTextStyle(
                                                            size: 15,
                                                            fontweight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Text(
                                                        "Litres Collected",
                                                        style: customs
                                                            .secondaryTextStyle(
                                                            size: 10,
                                                            fontweight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        (memberData != null ? customs.toCamelCase((memberData['animals'] ?? "0").toString()) : "0"),
                                                        style:
                                                        customs.darkTextStyle(
                                                            size: 15,
                                                            fontweight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Text(
                                                        "Animal",
                                                        style: customs
                                                            .secondaryTextStyle(
                                                            size: 10,
                                                            fontweight:
                                                            FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  )
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
                                          child: (memberData != null) ?
                                          Image.network(
                                            "${customs.apiURLDomain}${memberData['profile_photo']}",
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
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
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                customs.maruIconButton(
                                    icons: Icons.history,
                                    text: "Collection History",
                                    onPressed: (){
                                      Navigator.pushNamed(context, "/admin_member_history", arguments: {"member_id": (memberData != null ? memberData['user_id'] ?? "-0" : "-0"), "member_data": memberData});

                                    },
                                    fontSize: 14
                                ),
                                SizedBox(width: 20,),
                                customs.maruIconButton(
                                    icons: Icons.history,
                                    text: "Membership",
                                    onPressed: () async {
                                      LocalAuthentication auth = LocalAuthentication();
                                      bool proceed = await customs.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to view  \"${customs.toCamelCase(memberData['fullname'])}\" membership!");
                                      if(proceed){
                                        Navigator.pushNamed(context, "/admin_member_membership", arguments: {"member_id": (memberData != null ? memberData['user_id'] ?? "-0" : "-0"), "member_data": memberData});
                                      }else{
                                        customs.maruSnackBarDanger(context: context, text: "Authenticated failed!");
                                      }
                                    },
                                    type: Type.secondary,
                                    fontSize: 14)
                              ],
                            ),
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
                                  memberData != null ? customs.toCamelCase(memberData['phone_number'] ?? "N/A") : "N/A",
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
                                  memberData != null ? customs.toCamelCase(memberData['email'] ?? "N/A") : "N/A",
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
                                  memberData != null ? customs.toCamelCase(memberData['residence'] ?? "N/A") : "N/A",
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
                                  "Region:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                Text(
                                  memberData != null ? customs.toCamelCase(memberData['region_name'] ?? "N/A") : "N/A",
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
                                  memberData != null ? customs.toCamelCase(memberData['username'] ?? "N/A") : "N/A",
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
                                  memberData != null ? customs.toCamelCase(memberData['national_id'] ?? "N/A") : "N/A",
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
                                  "Membership Number:",
                                  style: customs.darkTextStyle(
                                      size: 12, fontweight: FontWeight.bold),
                                ),
                                Text(
                                  memberData != null ? customs.toCamelCase(memberData['membership'] ?? "N/A") : "N/A",
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
        backgroundColor: customs.primaryShade_2,
        child: IconButton(
          icon: Icon(Icons.edit, color: customs.primaryColor,),
          onPressed: () async {
            await Navigator.pushNamed(context, "/admin_edit_member_details", arguments: {"index": index, "member_id": (memberData != null ? (memberData['user_id'] ?? "0") : "0")});
            //get member details
            getMemberData();
          },
        ),
      ),
    );
  }
}

String _heroAddTodo = "ask_delete";

class _AddTodoPopupCard extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  var member_data = null;
  _AddTodoPopupCard({Key? key, required this.member_data}) : super(key: key);

  @override
  State<_AddTodoPopupCard> createState() => _AddTodoPopupCardState();
}
class _AddTodoPopupCardState extends State<_AddTodoPopupCard> {
  CustomThemes customThemes = new CustomThemes();

  bool saveLoader = false;

  void initState(){
    super.initState();
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
                      Text("Are you sure you want to delete \"${customThemes.toCamelCase(widget.member_data['fullname'])}\" membership number: \"${widget.member_data['membership']}\"?", style: customThemes.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
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
                                    LocalAuthentication auth = LocalAuthentication();
                                    bool proceed = await customThemes.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to delete \"${customThemes.toCamelCase(widget.member_data['fullname'])}\"!");
                                    if(proceed){
                                      setState((){
                                        saveLoader = true;
                                      });
                                      ApiConnection apiConn = ApiConnection();
                                      var response = await apiConn.deleteMember(widget.member_data['user_id'].toString());
                                      if(customThemes.isValidJson(response)){
                                        var res = jsonDecode(response);
                                        if(res['success']){
                                          Navigator.pop(context, res);
                                        }else{
                                          Navigator.pop(context, res);
                                        }
                                      }
                                    }else{
                                      customThemes.maruSnackBarDanger(context: context, text: "Authenticated failed!");
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
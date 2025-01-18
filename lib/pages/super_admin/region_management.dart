import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class RegionManagement extends StatefulWidget {
  const RegionManagement({super.key});

  @override
  State<RegionManagement> createState() => _RegionManagementState();
}

class _RegionManagementState extends State<RegionManagement> {
  CustomThemes customs = new CustomThemes();
  bool init = false;
  var regions = [];
  var _isLightMode = {};
  String hero_tags = "";
  bool load_regions = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if(!init){
      setState(() {
        init = !init;
      });

      // get regions
      getRegions();
    }
  }

  // get deductions
  Future<void> getRegions() async {
    setState(() {
      load_regions = true;
    });
    ApiConnection apiConnection = ApiConnection();
    var response = await apiConnection.getRegions();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          regions = res['regions'];
          for(int index = 0; index < regions.length; index++){
            _isLightMode[regions[index]['region_id']] = regions[index]['status'] == 1;
          }
        });
      }else{
        setState(() {
          regions = [];
        });
      }
    }else{
      setState(() {
        regions = [];
      });
    }
    setState(() {
      load_regions = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return customs.refreshIndicator(
      onRefresh: ()async{
        await getRegions();
        HapticFeedback.lightImpact();
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
            return load_regions ?
            Container(
              child: Center(
                child: Container(
                  height: 100,
                  child: Column(
                    children: [
                      SpinKitCircle(
                        color: customs.primaryColor,
                        size: 50.0,
                      ),
                      Text("Loading regions...", style: customs.primaryTextStyle(size: 12, fontweight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
            )
                :
            Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text("Region Management", style: customs.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                  ),
                  Container(width: width * 0.8, child: Divider(color: customs.secondaryShade_2,)),
                  Container(
                    width: width,
                    height: height - 57,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: regions.length > 0 ? ListView.builder(
                        itemCount: regions.length,
                        itemBuilder: (context, index){
                          var items = regions[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: customs.secondaryShade_2.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Hero(
                              tag: "modify_region_${items['region_id']}",
                              child: Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  leading: Transform.scale(
                                      scale: 0.7,
                                      child: Switch(
                                        value: _isLightMode[items['region_id']],
                                        activeTrackColor: customs.primaryColor,
                                        inactiveThumbColor: customs.primaryColor,
                                        trackOutlineColor: WidgetStateProperty.all<Color>(customs.primaryColor),
                                        onChanged: (bool value) async {
                                          LocalAuthentication auth = LocalAuthentication();
                                          bool proceed = await customs.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please Authenticate!");
                                          if(proceed){
                                            setState(() {
                                              _isLightMode[items['region_id']] = value;
                                            });
                                            //change the deduction status
                                            ApiConnection apiConn = ApiConnection();
                                            String status = _isLightMode[items['region_id']] ? "1" : "0";
                                            var response = await apiConn.changeRegionStatus(region_id: "${items['region_id']}", region_status: status);
                                            if(customs.isValidJson(response)){
                                              var res = jsonDecode(response);
                                              if(res['success']){
                                                customs.maruSnackBarSuccess(context: context, text: res['message']);
                                                // REFRESH DEDUCTIONS
                                                getRegions();
                                              }else{
                                                customs.maruSnackBarDanger(context: context, text: res['message']);
                                              }
                                            }
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: "Authenticated failed!");
                                          }
                                        },
                                      )
                                  ),
                                  dense: true,
                                  style: ListTileStyle.drawer,
                                  title: Text( "${items['region_name']}", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)),
                                  trailing: PopupMenuButton<String>(
                                    icon: Icon(FontAwesomeIcons.ellipsisVertical, size: 15),
                                    onSelected: (String result) async {
                                      // Handle the selection here
                                      if(result == "edit"){
                                        var result = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                          return  EditRegions(region_data: items);
                                        }));
                                        if(result != null){
                                          if(result['success']){
                                            customs.maruSnackBarSuccess(context: context, text: result['message']);
                                            // REFRESH DEDUCTIONS
                                            getRegions();
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: result['message']);
                                          }
                                        }else{
                                          // customs.maruSnackBarDanger(context: context, text: "Cancelled!");
                                        }
                                      }else if(result == "delete"){
                                        var result = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                          return  DeleteRegions(region_data: items);
                                        }));
                                        if(result != null){
                                          if(result['success']){
                                            customs.maruSnackBarSuccess(context: context, text: result['message']);

                                            // REFRESH DEDUCTIONS
                                            getRegions();
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: result['message']);
                                          }
                                        }else{
                                          // customs.maruSnackBarDanger(context: context, text: "Cancelled!");
                                        }
                                      }
                                    },
                                    color: customs.whiteColor,
                                    itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'edit',
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
                                                FontAwesomeIcons.pencil,
                                                size: 13,
                                                color: customs.secondaryColor,
                                              ),
                                              Text(
                                                ' Edit',
                                                style: customs.secondaryTextStyle(
                                                    size: 12,
                                                    fontweight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      PopupMenuDivider(height: 1),
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
                                                size: 13,
                                                color: customs.dangerColor,
                                              ),
                                              Text(
                                                ' Delete',
                                                style: customs.dangerTextStyle(
                                                    size: 12,
                                                    fontweight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: (){
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                    ) : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          width: width - 50,
                          height: 200,
                          decoration: BoxDecoration(
                              color: customs.whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: customs.secondaryShade_2, blurRadius: 1, blurStyle: BlurStyle.normal),
                                BoxShadow(color: customs.secondaryShade_2, blurRadius: 1, blurStyle: BlurStyle.normal),
                                BoxShadow(color: customs.secondaryShade_2, blurRadius: 1, blurStyle: BlurStyle.normal),
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("No regions found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                              Spacer(),
                              SizedBox(
                                width: width,
                                child: Image(
                                  image: AssetImage("assets/images/search.jpg"),
                                  height: width/4,
                                  width: width/4,
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        )),
        floatingActionButton: CircleAvatar(
          backgroundColor: customs.primaryShade_2,
          child: Material(
            color: Colors.transparent,
            child: Hero(
              tag: "add_region",
              child: IconButton(
                icon: Icon(Icons.add_circle_rounded, color: customs.primaryColor,),
                onPressed: () async {
                  var result = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                    return  AddRegions();
                  }));
                  if(result != null){
                    if(result['success']){
                      customs.maruSnackBarSuccess(context: context, text: result['message']);
                      // REFRESH DEDUCTIONS
                      getRegions();
                    }else{
                      customs.maruSnackBarDanger(context: context, text: result['message']);
                    }
                  }else{
                    // customs.maruSnackBarDanger(context: context, text: "Cancelled!");
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditRegions extends StatefulWidget {
  var region_data = null;
  EditRegions({super.key, required this.region_data});

  @override
  State<EditRegions> createState() => _EditRegionsState();
}

class _EditRegionsState extends State<EditRegions> {
  CustomThemes customThemes = new CustomThemes();
  bool init = false;
  TextEditingController regionNameController = TextEditingController();

  void didChangeDependencies(){
    super.didChangeDependencies();
    if(!init){
      setState(() {
        init = !init;
        regionNameController.text = widget.region_data['region_name'];
      });
    }
  }

  bool saveLoader = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "modify_region_${widget.region_data['region_id']}",
          child: Material(
            color: customThemes.whiteColor,
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Update Region", style: customThemes.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            width: width,
                            child: customThemes.maruTextFormField(
                              isChanged: (value){
                                print(value);
                                setState(() {
                                  regionNameController.text = value;
                                });
                              },
                              hintText: "Region Name",
                              editingController: regionNameController,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return "Provide Region Name";
                                }
                                return null;
                              }
                            )
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width/3,
                                child: customThemes.maruButton(
                                    text: "Update",
                                    showLoader: saveLoader,
                                    disabled: saveLoader,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()){
                                        LocalAuthentication auth = LocalAuthentication();
                                        bool proceed = await customThemes.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to update region!");
                                        if(proceed){
                                          setState((){
                                            saveLoader = true;
                                          });
                                          ApiConnection apiConn = ApiConnection();
                                          var response = await apiConn.updateRegion(region_id: widget.region_data['region_id'].toString(), region_name: regionNameController.text);
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
                                      }
                                    },
                                    type: Type.success
                                ),
                              ),
                              Container(
                                width: width/3,
                                child: customThemes.marOutlineuButton(
                                    text: "Cancel",
                                    showLoader: saveLoader,
                                    disabled: saveLoader,
                                    onPressed: (){
                                      // Navigator.pop(context, {"success" : false, "message" : "Cancelled!"});
                                      Navigator.pop(context);
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
      ),
    );
  }
}


// delete regions
class DeleteRegions extends StatefulWidget {
  var region_data = null;
  DeleteRegions({super.key, required this.region_data});

  @override
  State<DeleteRegions> createState() => _DeleteRegionsState();
}

class _DeleteRegionsState extends State<DeleteRegions> {
  CustomThemes customThemes = new CustomThemes();

  bool saveLoader = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "modify_region_${widget.region_data['region_id']}",
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
                      Text("Are you sure you want to delete \"${customThemes.toCamelCase(widget.region_data['region_name'])}\" ?", style: customThemes.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Container(width: width, child: Text("Deduction will be deleted permanently!", style: customThemes.secondaryTextStyle(size: 12, ),)),
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
                                    bool proceed = await customThemes.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to delete region!");
                                    if(proceed){
                                      setState((){
                                        saveLoader = true;
                                      });
                                      ApiConnection apiConn = ApiConnection();
                                      var response = await apiConn.deleteRegion(region_id: widget.region_data['region_id'].toString());
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
                                    Navigator.pop(context);
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

// add regions
class AddRegions extends StatefulWidget {
  const AddRegions({super.key});

  @override
  State<AddRegions> createState() => _AddRegionsState();
}

class _AddRegionsState extends State<AddRegions> {
  CustomThemes customThemes = new CustomThemes();
  TextEditingController region_name_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool saveLoader = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "add_region",
          child: Material(
            color: customThemes.whiteColor,
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Add Region", style: customThemes.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            width: width,
                            child: customThemes.maruTextFormField(
                              isChanged: (value){},
                              hintText: "Region Name",
                              floatingBehaviour: FloatingLabelBehavior.always,
                              label: "Region Name",
                              editingController: region_name_controller,
                              validator:  (value) {
                                if(value == null || value.isEmpty){
                                  return "Provide Region Name";
                                }
                                return null;
                              }
                            )
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width/3,
                                child: customThemes.maruButton(
                                    text: "Add",
                                    showLoader: saveLoader,
                                    disabled: saveLoader,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()){
                                        LocalAuthentication auth = LocalAuthentication();
                                        bool proceed = await customThemes.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to add a region!");
                                        if(proceed){
                                          setState((){
                                            saveLoader = true;
                                          });
                                          ApiConnection apiConn = ApiConnection();
                                          var response = await apiConn.addRegions(region_name: region_name_controller.text);
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
                                      }
                                    },
                                    type: Type.success
                                ),
                              ),
                              Container(
                                width: width/3,
                                child: customThemes.marOutlineuButton(
                                    text: "Cancel",
                                    showLoader: saveLoader,
                                    disabled: saveLoader,
                                    onPressed: (){
                                      // Navigator.pop(context, {"success" : false, "message" : "Cancelled!"});
                                      Navigator.pop(context);
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

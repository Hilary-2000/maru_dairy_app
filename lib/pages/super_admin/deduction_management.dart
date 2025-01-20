import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';

class DeductionManagement extends StatefulWidget {
  const DeductionManagement({super.key});

  @override
  State<DeductionManagement> createState() => _DeductionManagementState();
}

class _DeductionManagementState extends State<DeductionManagement> {
  CustomThemes customs = new CustomThemes();
  bool init = false;
  var deductions = [];
  var _isLightMode = {};
  String hero_tags = "";
  bool load_deductions = false;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if(!init){
      await customs.initialize();
      setState(() {
        init = !init;
      });

      // get deductions
      getDeductions();
    }
  }

  // get deductions
  Future<void> getDeductions() async {
    setState(() {
      load_deductions = true;
    });
    ApiConnection apiConnection = ApiConnection();
    var response = await apiConnection.getDeductions();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          deductions = res['deductions'];
          for(int index = 0; index < deductions.length; index++){
            _isLightMode[deductions[index]['deduction_id']] = deductions[index]['status'] == 1;
          }
        });
      }else{
        setState(() {
          deductions = [];
        });
      }
    }else{
      setState(() {
        deductions = [];
      });
    }
    setState(() {
      load_deductions = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return customs.refreshIndicator(
      onRefresh: ()async{
        await getDeductions();
        HapticFeedback.lightImpact();
      },
      child: Scaffold(
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
            return load_deductions ?
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
                      Text("Loading deductions...", style: customs.primaryTextStyle(size: 12, fontweight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
            )
                :
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: customs.whiteColor,
              ),
              child: Column(
                children: [
                  Container(
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text("Deduction Management", style: customs.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                  ),
                  Container(width: width * 0.8, child: Divider(color: customs.secondaryShade_2,)),
                  Container(
                    width: width,
                    height: height - 57,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: deductions.length > 0 ? ListView.builder(
                        itemCount: deductions.length,
                        itemBuilder: (context, index){
                          var items = deductions[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: customs.secondaryShade_2.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Hero(
                              tag: "modify_deduction_${items['deduction_id']}",
                              child: Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  leading: Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value: _isLightMode[items['deduction_id']],
                                      activeTrackColor: customs.primaryColor,
                                      inactiveThumbColor: customs.primaryColor,
                                      trackOutlineColor: WidgetStateProperty.all<Color>(customs.primaryColor),
                                      onChanged: (bool value) async {
                                        setState(() {
                                          _isLightMode[items['deduction_id']] = value;
                                        });
                                        //change the deduction status
                                        ApiConnection apiConn = ApiConnection();
                                        String status = _isLightMode[items['deduction_id']] ? "1" : "0";
                                        var response = await apiConn.changeDeductionStatus(deduction_id: items['deduction_id'], deduction_status: status);
                                        if(customs.isValidJson(response)){
                                          var res = jsonDecode(response);
                                          if(res['success']){
                                            customs.maruSnackBarSuccess(context: context, text: res['message']);
                                            // REFRESH DEDUCTIONS
                                            getDeductions();
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: res['message']);
                                          }
                                        }
                                      },
                                    )
                                  ),
                                  dense: true,
                                  style: ListTileStyle.drawer,
                                  title: Text( "${items['deduction_name']}", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)),
                                  trailing: PopupMenuButton<String>(
                                    icon: Icon(FontAwesomeIcons.ellipsisVertical, size: 15, color: customs.darkColor,),
                                    onSelected: (String result) async {
                                      // Handle the selection here
                                      if(result == "edit"){
                                        var result = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                          return  EditDeduction(deduction_data: items);
                                        }));
                                        if(result != null){
                                          if(result['success']){
                                            customs.maruSnackBarSuccess(context: context, text: result['message']);

                                            // REFRESH DEDUCTIONS
                                            getDeductions();
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: result['message']);
                                          }
                                        }else{
                                          // customs.maruSnackBarDanger(context: context, text: "Cancelled!");
                                        }
                                      }else if(result == "delete"){
                                        var result = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                          return  DeleteDeduction(deduction_data: items);
                                        }));
                                        if(result != null){
                                          if(result['success']){
                                            customs.maruSnackBarSuccess(context: context, text: result['message']);

                                            // REFRESH DEDUCTIONS
                                            getDeductions();
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
                                    print(items);
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
                              Text("No deductions found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
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
              tag: "add_deduction",
              child: IconButton(
                icon: Icon(Icons.add_circle_rounded, color: customs.primaryColor,),
                onPressed: () async {
                  var result = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                    return  AddDeductions();
                  }));
                  if(result != null){
                    if(result['success']){
                      customs.maruSnackBarSuccess(context: context, text: result['message']);

                      // REFRESH DEDUCTIONS
                      getDeductions();
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


class DeleteDeduction extends StatefulWidget {
  var deduction_data = null;
  DeleteDeduction({super.key, required this.deduction_data});

  @override
  State<DeleteDeduction> createState() => _DeleteDeductionState();
}

class _DeleteDeductionState extends State<DeleteDeduction> {
  CustomThemes customThemes = new CustomThemes();
  bool init = false;

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if(!init){
      await customThemes.initialize();
      setState(() {
        init = true;
      });
    }
  }

  bool saveLoader = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "modify_deduction_${widget.deduction_data['deduction_id']}",
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
                      Text("Are you sure you want to delete \"${customThemes.toCamelCase(widget.deduction_data['deduction_name'])}\" ?", style: customThemes.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
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
                                    setState((){
                                      saveLoader = true;
                                    });
                                    ApiConnection apiConn = ApiConnection();
                                    var response = await apiConn.deleteDeductions(deduction_id: widget.deduction_data['deduction_id'].toString());
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

class EditDeduction extends StatefulWidget {
  var deduction_data = null;
  EditDeduction({super.key, required this.deduction_data});

  @override
  State<EditDeduction> createState() => _EditDeductionState();
}

class _EditDeductionState extends State<EditDeduction> {
  CustomThemes customThemes = new CustomThemes();
  bool init = false;
  TextEditingController deductionAmountController = TextEditingController();

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if(!init){
      await customThemes.initialize();
      setState(() {
        init = !init;
        deductionAmountController.text = widget.deduction_data['deduction_name'];
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
          tag: "modify_deduction_${widget.deduction_data['deduction_id']}",
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
                        Text("Update Deduction", style: customThemes.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          width: width,
                          child: customThemes.maruTextFormField(
                            isChanged: (value){},
                            hintText: "Deduction Name",
                            editingController: deductionAmountController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Provide Deduction Name";
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
                                      setState((){
                                        saveLoader = true;
                                      });
                                      ApiConnection apiConn = ApiConnection();
                                      var response = await apiConn.updateDeduction(deduction_id: widget.deduction_data['deduction_id'].toString(), deduction_name: deductionAmountController.text);
                                      if(customThemes.isValidJson(response)){
                                        var res = jsonDecode(response);
                                        if(res['success']){
                                          Navigator.pop(context, res);
                                        }else{
                                          Navigator.pop(context, res);
                                        }
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

class AddDeductions extends StatefulWidget {
  const AddDeductions({super.key});

  @override
  State<AddDeductions> createState() => _AddDeductionsState();
}

class _AddDeductionsState extends State<AddDeductions> {
  CustomThemes customThemes = new CustomThemes();
  TextEditingController deductionAmountController = TextEditingController();

  bool saveLoader = false;
  bool init = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if(!init){
      await customThemes.initialize();
      setState(() {
        init = true;
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
          tag: "add_deduction",
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
                        Text("Add Deduction", style: customThemes.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            width: width,
                            child: customThemes.maruTextFormField(
                              isChanged: (value){},
                              hintText: "Deduction Name",
                              floatingBehaviour: FloatingLabelBehavior.always,
                              label: "Deduction Name",
                              editingController: deductionAmountController,
                              validator:  (value) {
                                if(value == null || value.isEmpty){
                                  return "Provide Deduction Name";
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
                                        setState((){
                                          saveLoader = true;
                                        });
                                        ApiConnection apiConn = ApiConnection();
                                        var response = await apiConn.addDeductions(deduction_name: deductionAmountController.text);
                                        if(customThemes.isValidJson(response)){
                                          var res = jsonDecode(response);
                                          if(res['success']){
                                            Navigator.pop(context, res);
                                          }else{
                                            Navigator.pop(context, res);
                                          }
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
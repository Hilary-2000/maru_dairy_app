import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditMemberMilkData extends StatefulWidget {
  const EditMemberMilkData({super.key});

  @override
  State<EditMemberMilkData> createState() => _EditMemberMilkDataState();
}

class _EditMemberMilkDataState extends State<EditMemberMilkData> {
  CustomThemes customs = CustomThemes();
  Map<String, dynamic>? args;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  // DateTime? _selectedDate;
  // DateTime? _selectedTime;

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _amountInLitres = TextEditingController();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2101),
  //   );
  //   if (pickedDate != null && pickedDate != _selectedDate)
  //     setState(() {
  //       _selectedDate = pickedDate;
  //       _dateController.text = DateFormat("MMMM d, yyyy").format(_selectedDate!).toString();
  //     });
  // }

  // member data
  String collection_id = "";
  String memberName = "N/A";
  String collection_amount = "N/A";
  String collection_price = "0";
  String date = "N/A";
  String memberShipNumber = "N/A";
  String time = "N/A";
  bool loading = false;
  bool saveLoader = false;
  int index = 0;
  bool accepted = false;
  bool _init = false;
  List<Widget> milkEditHistory = [];

  List<Color> colors_shade = [];
  List<TextStyle> textStyles = [];
  List<TextStyle> textStylesTitle = [];
  List<Color> fullcolor = [];

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: _selectedTime != null
  //         ? TimeOfDay.fromDateTime(_selectedTime!)
  //         : TimeOfDay.now(),
  //   );
  //   if (pickedTime != null) {
  //     setState(() {
  //       _selectedTime = DateTime(
  //         _selectedTime?.year ?? DateTime.now().year,
  //         _selectedTime?.month ?? DateTime.now().month,
  //         _selectedTime?.day ?? DateTime.now().day,
  //         pickedTime.hour,
  //         pickedTime.minute,
  //       );
  //
  //       _timeController.text = DateFormat("h:mm a").format(_selectedTime!).toString();
  //     });
  //   }
  // }

  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }


  String nameAbbr(String name){
    String abbr = "";
    List<String> words = name.split(' ');
    int length = words.length >=2 ? 2 : words.length;
    for(int index = 0; index < length; index++){
      abbr += words[index].substring(0,1);
    }
    return abbr;
  }

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


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!_init){
      double width = MediaQuery.of(context).size.width;
      setState(() {
        _init = true;
        colors_shade = [
          customs.primaryShade,
          customs.secondaryShade,
          customs.warningShade,
          customs.darkShade,
          customs.successShade
        ];
        fullcolor = [
          customs.primaryColor,
          customs.secondaryColor,
          customs.warningColor,
          customs.darkColor,
          customs.successColor
        ];
        textStylesTitle = [
          customs.primaryTextStyle(
              size: 30, fontweight: FontWeight.bold
          ),
          customs.secondaryTextStyle(
              size: 30, fontweight: FontWeight.bold
          ),
          customs.warningTextStyle(
              size: 30, fontweight: FontWeight.bold
          ),
          customs.darkTextStyle(
              size: 30, fontweight: FontWeight.bold
          ),
          customs.secondaryTextStyle(
              size: 30, fontweight: FontWeight.bold
          ),
        ];
        textStyles = [
          customs.primaryTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
          customs.secondaryTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
          customs.warningTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
          customs.darkTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
          customs.secondaryTextStyle(
              size: 18, fontweight: FontWeight.bold
          ),
        ];
        milkEditHistory = [
          GestureDetector(
            onTap : (){

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
                    child: Skeleton.ignore(child: Text("PM", style: customs.primaryTextStyle(size: 18, fontweight: FontWeight.bold),)),
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
                      Text("edit", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
          GestureDetector(
            onTap : (){
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
                    child: Skeleton.ignore(child: Text("OM", style: customs.successTextStyle(size: 18, fontweight: FontWeight.bold),)),
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
                      Text("edit", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
          GestureDetector(
            onTap : (){
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
                    child: Skeleton.ignore(child: Text("EB", style: customs.secondaryTextStyle(size: 18, fontweight: FontWeight.bold),)),
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
                      Text("initial", style: customs.successTextStyle(size: 10, fontweight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),];
      });
      getCollectionDetails();
    }
  }

  Future<void> getCollectionDetails() async {
    setState(() {
      _amountInLitres.text = "0";
      loading = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    String? token = await _storage.read(key: 'token');
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if(args != null){
      index = args!['index'];
      var response = await apiConnection.collectionDetails(token!, args!["collection_id"].toString());
      if(isValidJson(response)){
        var res = jsonDecode(response);
        if(res['success']){
          print(res['collection_history']);
          // var listHistory = res['collection_history'];
          double width = MediaQuery.of(context).size.width;
          List<Widget> history = (res['collection_history'] as List<dynamic>).asMap().entries.map((entry) {
            var item = entry.value;
            var index = entry.key;
            return Column(
              children: [
                Container(
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
                        backgroundColor: colors_shade[index % colors_shade.length],
                        child: Skeleton.ignore(child: Text(nameAbbr(item['collector_name']), style: textStyles[index % textStyles.length],)),
                      ),
                      title: Text(
                        toCamelCase(item['collector_name']),
                        style: customs.darkTextStyle(size: 14),
                      ),
                      subtitle: Text(
                        "${item['reading']} Litres",
                        style: customs.secondaryTextStyle(size: 12),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item['full_time'],
                              style: customs.darkTextStyle(size: 10)),
                          Text(
                            item['full_date'],
                            style: customs.secondaryTextStyle(
                                size: 10, fontweight: FontWeight.normal),
                          ),
                          index == (res['collection_history'].length - 1) ? Text("Initial", style: customs.successTextStyle(size: 10, fontweight: FontWeight.bold)) : Text("edit", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(width: width * 0.5, child: Divider(color: customs.secondaryShade_2.withOpacity(0.2),),),
              ],
            );
          }).toList();

          setState(() {
            milkEditHistory = history;
            memberName = toCamelCase(res['collection']['fullname'].toString());
            collection_id = res['collection']['collection_id'].toString();
            memberShipNumber = res['collection']['membership'].toString();
            collection_amount = res['collection']['collection_amount'].toString()+" Litres";
            date = res['collection'] != null ? res['collection']['date'].toString() : "N/A";
            time = res['collection'] != null ? res['collection']['time'].toString() : "N/A";
            _amountInLitres.text = res['collection']['collection_amount'].toString();
            accepted = res['collection']['collection_status'] == 1;
            collection_price = res['collection']['price'] ?? "0";
          });
        }
      }
    }else{
      Navigator.pop(context);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _timeController.text = DateFormat("h:mm a").format(DateTime.now());
    _dateController.text = DateFormat("MMMM d, yyyy").format(DateTime.now());
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
      body: SafeArea(child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          double calculatedWidth = width / 2 - 170;
          calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
          return Container(
            height: height,
            width: width,
            color: customs.secondaryShade_2.withOpacity(0.2),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Edit Milk Data",
                          style: customs.darkTextStyle(
                              size: 15, fontweight: FontWeight.bold),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(FontAwesomeIcons.ellipsisVertical, size: 20,),
                          onSelected: (String result) {
                            // Handle the selection here
                            print(result);
                            if(result == "delete"){

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
                      ],
                    ),
                  ),
                  Skeletonizer(
                    enabled: loading,
                    child: Stack(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width: width,
                        height: 437,
                        child: Column(
                          children: [
                            Container(
                              width: width * 0.9,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8)),
                                  color: fullcolor[index % fullcolor.length]),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              width: width * 0.9,
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
                                    offset: const Offset(
                                        0, 1), // Offset in the x and y direction
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  Text(
                                    memberName,
                                    style: customs.darkTextStyle(
                                        size: 20, fontweight: FontWeight.bold),
                                  ),
                                  Text(
                                    memberShipNumber,
                                    style: customs.secondaryTextStyle(
                                        size: 12, fontweight: FontWeight.normal),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 235,
                                    color: customs.whiteColor,
                                    child: DefaultTabController(
                                      length: 2, // Number of tabs
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          TabBar(
                                            labelColor: customs.primaryColor,
                                            unselectedLabelColor: customs.secondaryColor,
                                            indicatorColor: customs.primaryColor,
                                            labelStyle: customs.secondaryTextStyle(
                                              size: 12,
                                              fontweight: FontWeight.normal,
                                              underline: false
                                            ),
                                            tabs: [
                                              Tab(icon: Icon(Icons.info_outline, size: 20)),
                                              Tab(icon: Icon(Icons.history, size: 20)),
                                            ],
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                      children: [
                                                        // its the widest container
                                                        Container(),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Collection Date : ",
                                                              style: customs.secondaryTextStyle(
                                                                  size: 12,
                                                                  fontweight: FontWeight.bold),
                                                            ),
                                                            Text(
                                                              "$date @ $time",
                                                              style: customs.secondaryTextStyle(
                                                                  size: 12,
                                                                  fontweight: FontWeight.normal),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Collection Amount",
                                                              style: customs.secondaryTextStyle(
                                                                  size: 12,
                                                                  fontweight: FontWeight.bold),
                                                            ),
                                                            Text(
                                                              "$collection_amount",
                                                              style: customs.secondaryTextStyle(
                                                                  size: 12,
                                                                  fontweight: FontWeight.normal),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Price",
                                                              style: customs.secondaryTextStyle(
                                                                  size: 12,
                                                                  fontweight: FontWeight.bold),
                                                            ),
                                                            Text(
                                                              "Kes $collection_price",
                                                              style: customs.secondaryTextStyle(
                                                                  size: 12,
                                                                  fontweight: FontWeight.normal),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Status",
                                                              style: customs.secondaryTextStyle(
                                                                  size: 12,
                                                                  fontweight: FontWeight.bold),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.all(2),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(2),
                                                                  color: accepted ? customs.successColor : customs.secondaryColor
                                                              ),
                                                              child: Text(
                                                                accepted ? "Accepted" : "Not-Accepted",
                                                                style: customs.whiteTextStyle(
                                                                    size: 10,
                                                                    fontweight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: milkEditHistory
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 65, // Adjust this value to move the CircleAvatar up
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CircleAvatar(
                              radius: width * 0.1,
                              backgroundColor: colors_shade[index % colors_shade.length],
                              child: Text(nameAbbr(memberName), style: textStylesTitle[index % textStylesTitle.length],)
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      padding: EdgeInsets.all(8),
                      width: width*0.9,
                      decoration: BoxDecoration(
                        color: customs.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: customs.secondaryShade,
                              blurRadius: 5,
                              spreadRadius: 1
                          )
                        ]
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text("Edit Milk Data", style: customs.secondaryTextStyle(size: 15, fontweight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            Container(
                              child: customs.maruTextFormField(
                                isChanged: (value){},
                                hintText: "Milk amount in Litres",
                                label: "Milk amount in Litres",
                                textType: TextInputType.number,
                                editingController: _amountInLitres,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter Milk quantity!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              width: width*0.9,
                              child: customs.maruButton(
                                showLoader: saveLoader,
                                disabled: saveLoader,
                                fontSize: 15,
                                type: Type.success,
                                text: "Update",
                                onPressed: () async {
                                  setState(() {
                                    saveLoader = true;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    ApiConnection apiConnection = new ApiConnection();
                                    final FlutterSecureStorage _storage = const FlutterSecureStorage();
                                    String? token = await _storage.read(key: 'token');
                                    var response = await apiConnection.updateCollection(token!, _amountInLitres.text, collection_id);
                                    print(response);
                                    if(isValidJson(response)){
                                      // this mean everything is fine!
                                      var res = jsonDecode(response);
                                      if(res['success'] == true){
                                        customs.maruSnackBarSuccess(
                                            context: context,
                                            text: res['message']
                                        );
                                        // get collection details
                                        getCollectionDetails();
                                      }else{
                                        customs.maruSnackBarDanger(
                                            context: context,
                                            text: res['message']
                                        );
                                      }
                                    }else{
                                      customs.maruSnackBarDanger(
                                          context: context,
                                          text: "An error has occured!"
                                      );
                                    }
                                  }else{
                                    customs.maruSnackBarDanger(
                                        context: context,
                                        text: "An error has occured!"
                                    );
                                  }
                                  setState(() {
                                    saveLoader = false;
                                  });
                                }
                              )
                            )
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

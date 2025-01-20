import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdministratorList extends StatefulWidget {
  const AdministratorList({super.key});

  @override
  State<AdministratorList> createState() => _AdministratorListState();
}

class _AdministratorListState extends State<AdministratorList> {
  CustomThemes customs = CustomThemes();
  List<Widget> technician = [];
  bool loading = false;
  bool _init = false;
  var administrator_list = [];
  var display_list = [];
  List<Color> colors_shade = [];
  List<TextStyle> textStyles = [];
  TextEditingController searchTechnician = TextEditingController();

  Future<void> getAdministrators() async {
    setState(() {
      loading = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.displayAdministrators();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          administrator_list = res['administrators'];
          display_list = administrator_list;
        });
      }else{
        customs.maruSnackBarDanger(context: context, text: "Fatal error occurred!");
      }
    }else{
      customs.maruSnackBarDanger(context: context, text: "An error occurred!");
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if(!_init){
      await customs.initialize();
      // double width
      double width = MediaQuery.of(context).size.width;
      setState(() {
        colors_shade = [customs.primaryShade, customs.secondaryShade.withOpacity(0.2), customs.warningShade, customs.successShade.withOpacity(0.2), customs.successShade.withOpacity(0.2)];
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
      });

      //get the technician
      getAdministrators();

      // setState
      setState(() {
        _init = true;
      });
    }
  }

  void findKeyWord(keyword){
    var newHistory = [];
    for(var item in administrator_list){
      int present = 0;
      if(item['fullname'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['phone_number'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['email'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }
      if(item['residence'].toString().toLowerCase().contains(keyword.toString().toLowerCase())){
        present++;
      }

      // present
      if(present > 0){
        newHistory.add(item);
      }
    }

    setState(() {
      display_list = newHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return customs.refreshIndicator(
      onRefresh: ()async{
        await getAdministrators();
        HapticFeedback.lightImpact();
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
        body: SafeArea(child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            double calculatedWidth = width / 2 - 170;
            calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
            return Container(
              height: height,
              width: width,
              color: customs.whiteColor,
              child: Column(
                children: [
                  Container(
                    width: width,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text("Our Administrators", style: customs.secondaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: width,
                    child: Material(
                      child: Container(
                        color: customs.whiteColor,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: customs.maruSearchTextField(
                            isChanged: (value) {
                              findKeyWord(value);
                            },
                            editingController: searchTechnician,
                            hintText: "Start typing to search!"),
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(
                      color: customs.secondaryShade_2,
                    ),
                  ),
                  Skeletonizer(
                    enabled: loading,
                    effect: customs.maruShimmerEffect(),
                    child: Container(
                      width: width * 0.95,
                      padding: const EdgeInsets.all(8),
                      height: height - 125,
                      decoration: BoxDecoration(
                          color: customs.whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border(
                            right: BorderSide(color: customs.secondaryShade_2),
                            top: BorderSide(color: customs.secondaryShade_2),
                            bottom: BorderSide(color: customs.secondaryShade_2),
                            left: BorderSide(color: customs.secondaryShade_2),
                          )
                      ),
                      child: Container(
                        height: height - 130,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: display_list.length > 0 ?
                        ListView.builder(
                            itemCount: display_list.length,
                            itemBuilder: (context, index){
                              var item = display_list[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.pushNamed(
                                          context, "/admin_details", arguments: {"index" : index , "admin_id": item['user_id']});
                                      getAdministrators();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.symmetric(vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: customs.secondaryShade_2.withOpacity(0.2),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: ListTile(
                                          dense: true,
                                          leading: CircleAvatar(
                                            backgroundColor: colors_shade[index % colors_shade.length],
                                            child: Text(
                                              customs.nameAbbr("${item['fullname']}"),
                                              style: textStyles[index % textStyles.length],
                                            ),
                                          ),
                                          title: Text(
                                            customs.toCamelCase("${item['fullname']}"),
                                            style: customs.darkTextStyle(size: 14),
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${item['phone_number']}",
                                                style: customs.secondaryTextStyle(
                                                    size: 12,
                                                    fontweight: FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.5,
                                    child: Divider(
                                      color: customs.secondaryShade_2.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              );
                            }
                        )
                            :
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                width: width - 50,
                                height: width - 100,
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
                                    Text("No Administrator found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                                    Spacer(),
                                    SizedBox(
                                      width: width,
                                      child: Image(
                                        image: AssetImage("assets/images/search.jpg"),
                                        height: width/3,
                                        width: width/3,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: CircleAvatar(
                                        backgroundColor: customs.primaryShade_2,
                                        child: IconButton(
                                          onPressed: () async {
                                            await Navigator.pushNamed(context, "/new_administrator");
                                            getAdministrators();
                                          },
                                          icon: Icon(Icons.person_add_alt_outlined, color: customs.primaryColor,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
          radius: 25,
          child: IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, "/new_administrator");
              getAdministrators();
            },
            icon: Icon(Icons.add_circle_rounded, size: 30, color: customs.secondaryColor,),
          ),
        ),
      ),
    );
  }
}

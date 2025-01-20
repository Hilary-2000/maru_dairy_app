import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

String tags = "edit_earning";

class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}
class _MembershipState extends State<Membership> {
  CustomThemes customs = CustomThemes();
  Map<String, dynamic>? args;
  var member_details = null;
  var last_month = "N/A";
  var curr_month = "N/A";
  var last_month_pay = "0";
  var current_month_pay = "0";
  var joining_fees_balance = "0";
  var membership_amount_balance = "0";
  var annual_subscription_balance = "0";
  var annual_sub_n_payment = [];
  var monthly_payments = [];
  bool initialized = false;
  bool loading = false;

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if(!initialized){
      await customs.initialize();
      // get membership details
      getMembershipDetails();
      // set state
      setState(() {
        initialized = true;
      });
    }

  }

  // member data
  Future<void> getMembershipDetails() async {
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if(args != null){
      String member_id = args!['member_id'].toString();
      setState(() {
        loading = true;
      });
      ApiConnection apiConnection = ApiConnection();
      var response = await apiConnection.getMemberMembership(member_id);
      if(customs.isValidJson(response)){
        var res = jsonDecode(response);
        if(res['success']){
          setState(() {
            member_details = res['member_details'];
            last_month = res['last_month'];
            curr_month = res['curr_month'];
            last_month_pay = res['last_month_pay'];
            current_month_pay = res['current_month_pay'];
            joining_fees_balance = res['joining_fees_balance'];
            membership_amount_balance = res['membership_amount_balance'];
            annual_subscription_balance = res['annual_subscription_balance'];
            annual_sub_n_payment = res['annual_sub_n_payment'];
            monthly_payments = res['monthly_payments'];
          });
        }else{
          setState(() {
            member_details = null;
            last_month = "N/A";
            curr_month = "N/A";
            last_month_pay = "Kes 0";
            current_month_pay = "Kes 0";
            joining_fees_balance = "Kes 0";
            membership_amount_balance = "Kes 0";
            annual_subscription_balance = "Kes 0";
            annual_sub_n_payment = [];
            monthly_payments = [];
          });
        }
      }
      setState(() {
        loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            decoration: BoxDecoration(
              color: customs.secondaryShade_2.withOpacity(0.2),
            ),
            child: Container(
              height: height - 5,
              width: width,
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Skeletonizer(
                      enabled: loading,
                      effect: customs.maruShimmerEffect(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: width,
                        decoration: BoxDecoration(
                            color: customs.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: customs.secondaryShade_2, spreadRadius: 2),
                              BoxShadow(color: customs.secondaryShade_2, ),
                              BoxShadow(color: customs.secondaryShade_2, )
                            ]
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: width * 0.08,
                              backgroundColor: customs.primaryShade,
                              child: ClipOval(
                                child: (member_details != null) ?
                                Image.network(
                                  "${customs.apiURLDomain}${member_details['profile_photo']}",
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
                              ),
                            ),
                            SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${customs.toCamelCase(member_details != null ? member_details['fullname'] ?? "N/A" : "N/A")}", style: customs.secondaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                                Text("${member_details != null ? member_details['membership'] ?? "N/A" : "N/A"}", style: customs.secondaryTextStyle(size: 13, fontweight: FontWeight.bold),),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Skeletonizer(
                      enabled: loading,
                      effect: customs.maruShimmerEffect(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: width,
                        decoration: BoxDecoration(
                          color: customs.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: customs.secondaryShade_2, spreadRadius: 2),
                            BoxShadow(color: customs.secondaryShade_2, ),
                            BoxShadow(color: customs.secondaryShade_2, )
                          ]
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: width / 2.4,
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Info", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold, underline: true),),
                                  SizedBox(height: 5,),
                                  Container(
                                    width: width / 2.4,
                                    child: RichText(
                                      text:TextSpan(
                                        text: "Member Since: \n",
                                        style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold),
                                        children: [TextSpan(
                                          text: "${member_details != null ? member_details['date_joined'] ?? "N/A" : "N/A"}",
                                          style: customs.secondaryTextStyle(size: 12),
                                        )]
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    width: width / 2.4,
                                    child: RichText(
                                      text:TextSpan(
                                        text: "This Month Pay (${curr_month}): \n",
                                        style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                            text: "Kes ${current_month_pay}",
                                            style: customs.secondaryTextStyle(size: 12),
                                          )
                                        ]
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    width: width / 2.4,
                                    child: RichText(
                                      text:TextSpan(
                                        text: "Last Month Pay ($last_month): \n",
                                        style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                            text: "Kes $last_month_pay",
                                            style: customs.secondaryTextStyle(size: 12),
                                          )
                                        ]
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 150,
                              width: width/15,
                              child: VerticalDivider(
                                  color: customs.secondaryShade_2, // Color of the divider
                                  thickness: 2, // Thickness of the line
                                  width: 20, // Total width occupied by the divider
                                  indent: 20, // Empty space at the top of the divider
                                  endIndent: 20,
                              ),
                            ),
                            Container(
                              width: width / 2.4,
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Balances", style: customs.primaryTextStyle(size: 14, fontweight: FontWeight.bold, underline: true),),
                                  SizedBox(height: 10,),
                                  Container(
                                    width: width / 2.4,
                                    child: RichText(
                                      text:TextSpan(
                                          text: "Joining Fees: \n",
                                          style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold),
                                          children: [TextSpan(
                                            text: "Kes ${joining_fees_balance}",
                                            style: customs.secondaryTextStyle(size: 12),
                                          )]
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    width: width / 2.4,
                                    child: RichText(
                                      text:TextSpan(
                                          text: "Membership Fees: \n",
                                          style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold),
                                          children: [TextSpan(
                                            text: "Kes ${membership_amount_balance}",
                                            style: customs.secondaryTextStyle(size: 12),
                                          )]
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    width: width / 2.4,
                                    child: RichText(
                                      text:TextSpan(
                                        text: "Annual Subscription: \n",
                                        style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                            text: "Kes ${annual_subscription_balance}",
                                            style: customs.secondaryTextStyle(size: 12),
                                          )
                                        ]
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
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Payments & Deductions",
                        style: customs.secondaryTextStyle(
                          size: 14,
                          fontweight: FontWeight.bold
                        ),
                      ),
                    ),
                    Skeletonizer(
                      enabled: loading,
                      effect: customs.maruShimmerEffect(),
                      child: Container(
                        height: height - 300,
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
                                  Tab(child: Text("Annual Subscription", style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold),),),
                                  Tab(child: Text("Earnings", style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold),),),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: annual_sub_n_payment.length > 0 ? ListView.builder(
                                        itemCount: annual_sub_n_payment.length,
                                        itemBuilder: (context, index){
                                          return Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                width: width,
                                                child: Text("${annual_sub_n_payment[index]['year']}", style: customs.secondaryTextStyle(size: 12),),
                                              ),
                                              Container(
                                                height: double.parse(((annual_sub_n_payment[index]['subscription'].length) * 65).toString()),
                                                child: ListView.builder(
                                                    itemCount: annual_sub_n_payment[index]['subscription'].length,
                                                    itemBuilder: (contexts, indexes){
                                                      var items = annual_sub_n_payment[index]['subscription'][indexes];
                                                    return Container(
                                                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                    padding: EdgeInsets.symmetric(vertical: 5),
                                                    decoration: BoxDecoration(
                                                        color: customs.secondaryShade_2.withOpacity(0.2),
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: ListTile(
                                                      leading: CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor: customs.primaryShade_2,
                                                        child: Icon(
                                                          FontAwesomeIcons.dollarSign,
                                                          size: 20,
                                                          color: customs.primaryColor,
                                                        ),
                                                      ),
                                                      dense: true,
                                                      style: ListTileStyle.drawer,
                                                      title: RichText(
                                                          text: TextSpan(
                                                              text: "",
                                                              style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                                              children: [
                                                                TextSpan(
                                                                    text: "Kes ${items['deduction_type'] == "increase" ? "+" : "-"}${items['deduction_amount']}",
                                                                    style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                                                )
                                                              ]
                                                          )
                                                      ),
                                                      trailing: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text("${items['clear_date']}", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.bold),),
                                                          Text("Bal: Kes ${items['balance']}", style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.bold),),
                                                        ],
                                                      ),
                                                      onTap: (){
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
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
                                            height: height - 400,
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
                                                Text("No annual subscription found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                                                SizedBox(height: height / 8,),
                                                SizedBox(
                                                  width: width,
                                                  child: Image(
                                                    image: AssetImage("assets/images/search.jpg"),
                                                    height: width/4,
                                                    width: width/4,
                                                  ),
                                                ),
                                                Spacer()
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      color: customs.whiteColor,
                                      child: monthly_payments.length > 0 ? ListView.builder(
                                        itemCount: monthly_payments.length,
                                        itemBuilder: (context, index){
                                            var item = monthly_payments[index];
                                            return item['confirmed'] ?
                                            Hero(
                                              tag: "reject-${item['month_paid_for']}",
                                              child: GestureDetector(
                                                child: Container(
                                                  width: width,
                                                  height: 110,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                        width: width,
                                                        child: Text("${item['month_paid_for']}", style: customs.secondaryTextStyle(size: 12),),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                        decoration: BoxDecoration(
                                                            color: customs.secondaryShade_2.withOpacity(0.2),
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                        child: Material(
                                                          color: Colors.transparent,
                                                          child: ListTile(
                                                            leading: CircleAvatar(
                                                              radius: 30,
                                                              backgroundColor: item['confirmed'] ? customs.successShade_2 : customs.secondaryShade_2,
                                                              child: Icon(
                                                                FontAwesomeIcons.dollarSign,
                                                                size: 20,
                                                                color: item['confirmed'] ? customs.successColor : customs.secondaryColor,
                                                              ),
                                                            ),
                                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                            dense: true,
                                                            style: ListTileStyle.drawer,
                                                            title: RichText(
                                                              text: TextSpan(
                                                                  text: "Kes ${item['total_payment']}",
                                                                  style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                                              )
                                                            ),
                                                            subtitle: Text("Kes ${item['payment_amount']}", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.normal)),
                                                            trailing: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Text("${item['publish_date']}", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.normal),),
                                                                Text("X-Cost: Kes ${item['transaction_cost']}", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.normal),),
                                                                item['confirmed'] ? Container(
                                                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                                  child: Text("confirmed", style: customs.successTextStyle(size: 8.6, fontweight: FontWeight.bold),),
                                                                ) : SizedBox()
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                onTap: () async {
                                                  //confirm payment by saving it to the database
                                                  var result = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                                    return  _editEarnings(earning_data: item, member_data: member_details,);
                                                  }));
                                                  if(result != null){
                                                    if(result['success']){
                                                      // get membership details
                                                      getMembershipDetails();
                                                      customs.maruSnackBarSuccess(context: context, text: result['message']);
                                                    }else{
                                                      customs.maruSnackBarDanger(context: context, text: result['message']);
                                                    }
                                                  }
                                                },
                                              ),
                                            )
                                                :
                                            Hero(
                                              tag: "accept-${item['month_paid_for']}",
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    width: width,
                                                    child: Text("${item['month_paid_for']}", style: customs.secondaryTextStyle(size: 12),),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                    decoration: BoxDecoration(
                                                        color: customs.secondaryShade_2.withOpacity(0.2),
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: ListTile(
                                                        leading: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor: item['confirmed'] ? customs.successShade_2 : customs.secondaryShade_2,
                                                          child: Icon(
                                                            FontAwesomeIcons.dollarSign,
                                                            size: 20,
                                                            color: item['confirmed'] ? customs.successColor : customs.secondaryColor,
                                                          ),
                                                        ),
                                                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                        dense: true,
                                                        style: ListTileStyle.drawer,
                                                        title: RichText(
                                                            text: TextSpan(
                                                                text: "Kes ${item['payment_amount']}",
                                                                style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.bold)
                                                            )
                                                        ),
                                                        trailing: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("${item['publish_date']}", style: customs.secondaryTextStyle(size: 10, fontweight: FontWeight.normal),),
                                                            Text("X-Cost: Kes ${item['transaction_cost']}", style: customs.secondaryTextStyle(size: 12, fontweight: FontWeight.normal),),
                                                            item['confirmed'] ? Container(
                                                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                              child: Text("confirmed", style: customs.successTextStyle(size: 8.6, fontweight: FontWeight.bold),),
                                                            ) : SizedBox()
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          print("Reject");
                                                          //confirm payment by saving it to the database
                                                          var result = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                                            return  rejectEarnings(earning_data: item, member_data: member_details,);
                                                          }));

                                                          if(result != null){
                                                            if(result['success']){
                                                              // get membership details
                                                              getMembershipDetails();
                                                              customs.maruSnackBarSuccess(context: context, text: result['message']);
                                                            }else{
                                                              customs.maruSnackBarDanger(context: context, text: result['message']);
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                      ) :
                                      Column(
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
                                                Text("No Earnings found!", style: customs.primaryTextStyle(size: 20, fontweight: FontWeight.bold),),
                                                Spacer(),
                                                SizedBox(
                                                  width: width,
                                                  child: Image(
                                                    image: AssetImage("assets/images/search.jpg"),
                                                    height: width/4,
                                                    width: width/4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
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
              ),
            ),
          );
        },
      )),
    );
  }
}

class rejectEarnings extends StatefulWidget {
  var earning_data = null;
  var member_data = null;
  rejectEarnings({Key? key, required this.earning_data, required this.member_data}) : super(key: key);

  @override
  State<rejectEarnings> createState() => _rejectEarningsState();
}

class _rejectEarningsState extends State<rejectEarnings> {
  CustomThemes customThemes = new CustomThemes();
  final _formKey = GlobalKey<FormState>();
  List deductions = [];
  var deductionType = [];

  String deduction_type(String deduction_type){
    for(int index = 0; index < deductionType.length; index++){
      if("${deductionType[index]['deduction_id']}" == "$deduction_type"){
        return deductionType[index]['deduction_name'];
      }
    }
    if("$deduction_type" == "transaction_cost"){
      return "Transaction Cost";
    }
    return "N/A";
  }

  void removeDeduction(int index){
    setState(() {
      deductions.removeAt(index);
    });
  }

  bool addDeductions = false;
  bool isChecked = true;
  var paymentType = "";
  List<DropdownMenuItem<String>> paymentTypes = [
    // const DropdownMenuItem(child: Text("Select Deduction Type"), value: ""),
    // const DropdownMenuItem(child: Text("Subscription"), value: "subscription"),
    // const DropdownMenuItem(child: Text("Joining Fees"), value: "joining_fees"),
    // const DropdownMenuItem(child: Text("Membership Fees"), value: "membership_fees"),
    // const DropdownMenuItem(child: Text("Advance"), value: "advance"),
    // const DropdownMenuItem(child: Text("Balance Carry-Over"), value: "balance_carry_over"),
  ];
  TextEditingController howMuch = TextEditingController();
  bool saveLoader = false;
  bool load_deductions = false;
  bool init = false;

  void initState(){
    super.initState();
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if(!init){
      await customThemes.initialize();
      setState(() {
        howMuch.text = "0";
        init = true;
      });
      // get the deduction types
      getDeductions();
    }
  }

  Future<void> getDeductions() async {
    setState(() {
      load_deductions = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getActiveDeductions();
    if(customThemes.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          paymentTypes = (res['deductions'] as List).map((deduction) {
            return DropdownMenuItem(child: Text("${deduction['deduction_name']}"), value: "${deduction['deduction_id']}");
          }).toList();
          deductionType = res['deductiontype'];
        });
      }else{
        setState(() {
          paymentTypes = [];
        });
      }
    }
    setState(() {
      load_deductions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "accept-${widget.earning_data['month_paid_for']}",
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
                      Container(
                        width: width,
                        child: Text("Confirm this payment?", style: customThemes.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: width,
                        child: RichText(
                            text: TextSpan(
                              text: "Full Payment : ",
                              style: customThemes.primaryTextStyle(size: 15, fontweight: FontWeight.bold),
                              children: [TextSpan(
                                text: "Kes ${widget.earning_data['payment_amount']}",
                              )]
                            )
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: width,
                        child: Row(
                          children: [
                            Container(
                              child: Checkbox(
                                  activeColor: customThemes.primaryColor,
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  }
                              ),
                            ),
                            Text(
                              "deduct transaction fees",
                              style: customThemes.secondaryTextStyle(
                                  size: 14
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      deductions.length > 0 ? Column(
                        children: [
                          Text("Deductions", style: customThemes.darkTextStyle(size: 15, fontweight: FontWeight.bold),),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: customThemes.secondaryColor, width: 1),
                                    bottom: BorderSide(color: customThemes.secondaryColor, width: 1),
                                    left: BorderSide(color: customThemes.secondaryColor, width: 1),
                                    right: BorderSide(color: customThemes.secondaryColor, width: 1)
                                ),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            height: deductions.length * 55,
                            child: ListView.builder(
                                itemCount: deductions.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index){
                                  var item = deductions[index];
                                  String deductionType = deduction_type(item['deduction_type'].toString());
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: customThemes.secondaryShade_2,
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("${index+1} .", style: customThemes.darkTextStyle(size: 12, fontweight: FontWeight.normal)),
                                          ],
                                        ),
                                        SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: "${deductionType}",
                                                style: customThemes.darkTextStyle(size: 12, fontweight: FontWeight.normal),
                                              ),
                                            ),
                                            SizedBox(height: 3,),
                                            RichText(
                                              text: TextSpan(
                                                text: "Kes ${item['deduction_amount']}",
                                                style: customThemes.darkTextStyle(size: 10, fontweight: FontWeight.normal),
                                              ),
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          child: CircleAvatar(
                                            backgroundColor: customThemes.dangerShade_2,
                                            radius: 15,
                                            child: Icon(Icons.close, size: 15, color: customThemes.whiteColor,),
                                          ),
                                          onTap: (){
                                            removeDeduction(index);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          Container(
                            width: width/2,
                            child: Divider()
                          )
                        ],
                      ):SizedBox(height: 0, width: 0,),
                      SizedBox(height: 10),
                      !addDeductions ? Container(
                        child: customThemes.maruIconButton(
                            icons: Icons.add,
                            text: "Add Deductions",
                            iconSize: 20,
                            fontWeight: FontWeight.bold,
                            onPressed: (){
                              setState(() {
                                addDeductions = true;
                              });
                            }
                        ),
                      ):SizedBox(height: 0, width: 0,),
                      SizedBox(height: 10),
                      addDeductions ? Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: customThemes.secondaryColor, width: 1),
                            bottom: BorderSide(color: customThemes.secondaryColor, width: 1),
                            left: BorderSide(color: customThemes.secondaryColor, width: 1),
                            right: BorderSide(color: customThemes.secondaryColor, width: 1)
                          ),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: Text("Add Deduction", style: customThemes.secondaryTextStyle(size: 14, fontweight: FontWeight.bold),),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: customThemes.maruTextFormField(
                                    isChanged: (values){
                                      setState(() {
                                        howMuch.text = values;
                                      });
                                    },
                                    label: "How much?",
                                    editingController: howMuch,
                                    textType: TextInputType.number,
                                    validator: (value){
                                      if(value == null || value.isEmpty || double.parse(value) <= 0){
                                        return "How much is the member deducted?";
                                      }
                                      return null;
                                    }
                                ),
                              ),
                              SizedBox(height: 10),
                              load_deductions ?
                              Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      SpinKitCircle(
                                        size: 25,
                                        color: customThemes.primaryColor,
                                      ),
                                      Text("Load earnings!", style: customThemes.primaryTextStyle(size: 10),)
                                    ],
                                  ),
                                ),
                              )
                                  :
                              customThemes.maruDropdownButtonFormField(
                                  defaultValue: paymentType,
                                  onChange: (value) {
                                    setState(() {
                                      paymentType = value!;
                                    });
                                  },
                                  items: paymentTypes,
                                  validator: (value) {
                                    if(value == null || value.isEmpty){
                                      return "Select payment type!";
                                    }
                                    return null;
                                  }
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    customThemes.maruIconButton(
                                      icons: Icons.add,
                                      text: "Add",
                                      fontSize: 12,
                                      iconSize: 20,
                                      onPressed: (){
                                        if (_formKey.currentState!.validate()){
                                          var elem = {
                                            "deduction_type": paymentType,
                                            "deduction_amount": howMuch.text
                                          };
                                          setState(() {
                                            deductions.add(elem);
                                            paymentType = "";
                                            howMuch.text = "0";
                                            addDeductions = false;
                                          });
                                        }
                                      },
                                      type: Type.success
                                    ),
                                    customThemes.marOutlineuButton(
                                      text: "Cancel",
                                      fontSize: 12,
                                      onPressed: (){
                                        setState(() {
                                          paymentType = "";
                                          howMuch.text = "0";
                                          addDeductions = false;
                                        });
                                      },
                                      type: Type.danger
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ) : SizedBox(height: 0, width: 0,),
                      SizedBox(height: 10),
                      Container(
                        width: width/2,
                        child: Divider(),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width/3,
                              child: customThemes.maruButton(
                                  text: "Confirm",
                                  showLoader: saveLoader,
                                  disabled: saveLoader,
                                  onPressed: () async {
                                    LocalAuthentication auth = LocalAuthentication();
                                    bool proceed = await customThemes.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to confirm payments!");
                                    if(proceed){
                                      setState((){
                                        saveLoader = true;
                                      });
                                      ApiConnection apiConn = ApiConnection();
                                      var datapass = {
                                        "payment_amount": widget.earning_data['raw_amount'],
                                        "transaction_cost": widget.earning_data['transaction_cost'],
                                        "member_id": widget.member_data['user_id'],
                                        "month_paid_for": widget.earning_data['month_paid_for'],
                                        "litres_amount": widget.earning_data['litres_collected'],
                                        "deductions": deductions,
                                        "transaction_amount": isChecked ? "yes" : "no"
                                      };
                                      var response = await apiConn.acceptMemberPayment(datapass);
                                      if(customThemes.isValidJson(response)){
                                        var res = jsonDecode(response);
                                        if(res['success']){
                                          Navigator.pop(context, res);
                                        }else{
                                          Navigator.pop(context, res);
                                        }
                                      }
                                      setState((){
                                        saveLoader = false;
                                      });
                                    }else{
                                      customThemes.maruSnackBarDanger(context: context, text: "Authenticated failed!");
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
    );
  }
}

class _editEarnings extends StatefulWidget {
  var earning_data = null;
  var member_data = null;
  _editEarnings({Key? key, required this.earning_data, required this.member_data}) : super(key: key);

  @override
  State<_editEarnings> createState() => _editEarningsState();
}

class _editEarningsState extends State<_editEarnings> {
  CustomThemes customThemes = new CustomThemes();
  bool saveLoader = false;
  bool init = false;
  var payment_data = null;
  var deductionType = [];
  bool loading = false;
  String pdfUrl = "";
  bool downloading = false;
  bool downloaded = false;
  String? localFilePath;


  void openPDF() {
    if (localFilePath != null) {
      OpenFile.open(localFilePath!);
    } else {
      customThemes.maruSnackBarDanger(context: context, text: "No file available to open!");
    }
  }

  Future<void> downloadPDF1() async {
    setState(() {
      downloading = true;
    });
    try {
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final downloadDir = Directory('${directory!.path}/Download/MaruDairy');

        // Create the directory if it doesn't exist
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }

        // file path
        final filePath = '${downloadDir.path}/${widget.earning_data['month_paid_for']}-receipt.pdf';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // set file path
        setState(() {
          localFilePath = filePath;
          downloaded = true;
        });

        // Check if the file exists
        if (await file.exists()) {
          customThemes.maruSnackBarSuccess(context: context, text: "Receipt downloaded successfully!");
          print("File saved at: $filePath"); // Print the file path to the console
        } else {
          customThemes.maruSnackBarSuccess(context: context, text: "Failed to save the receipt!");
        }
      } else {
        customThemes.maruSnackBarDanger(context: context, text: "Couldn't download the receipt!");
      }
    } catch (e) {
      customThemes.maruSnackBarDanger(context: context, text: "An error occurred: $e");
    }
    setState(() {
      downloading = false;
    });
  }

  String deduction_type(String deduction_type){
    for(int index = 0; index < deductionType.length; index++){
      if("${deductionType[index]['deduction_id']}" == "$deduction_type"){
        return deductionType[index]['deduction_name'];
      }
    }
    if("$deduction_type" == "transaction_cost"){
      return "Transaction Cost";
    }
    return "N/A";
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if(!init){
      await customThemes.initialize();
      await getEarningDetails();
      setState(() {
        init = true;
      });
    }
  }

  Future<bool> _requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      if (await Permission.storage.request().isGranted) {
        print("Permission granted.");
        return true;
      } else {
        print("Permission denied.");
        return false;
      }
    }
    return true;
  }

  Future<void> downloadPDF() async {
    setState(() {
      downloading = true;
    });

    // Request storage permissions
    if (await _requestPermission()) {
      try {
        final response = await http.get(Uri.parse(pdfUrl));
        if (response.statusCode == 200) {
          // Get the directory for the external storage
          final directory = Directory('/storage/emulated/0/Download/MaruDairy');

          // Create the directory if it doesn't exist
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }

          // Set the file path
          final filePath = '${directory.path}/member-receipt.pdf';

          // Write the file
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          // Set the file path and update UI
          setState(() {
            localFilePath = filePath;
            downloaded = true;
          });

          // Check if the file exists and show a success message
          if (await file.exists()) {
            customThemes.maruSnackBarSuccess(context: context, text: "Receipt downloaded successfully!");
            print("File saved at: $filePath");
          } else {
            customThemes.maruSnackBarDanger(context: context, text: "Failed to save the receipt!");
          }
        } else {
          customThemes.maruSnackBarDanger(context: context, text: "Couldn't download the receipt!");
        }
      } catch (e) {
        customThemes.maruSnackBarDanger(context: context, text: "An error occurred: $e");
      }
    } else {
      customThemes.maruSnackBarDanger(context: context, text: "Storage permission is required to download the receipt.");
    }

    setState(() {
      downloading = false;
    });
  }

  Future<void> getEarningDetails() async {
    setState(() {
      loading = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.paymentData(widget.earning_data['id'].toString());
    if(customThemes.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        setState(() {
          payment_data = res['payment'];
          deductionType = res['deduction_type'];
          pdfUrl = "${customThemes.apiURLDomain}/api/admin/payment/receipt/${res['payment']['payment_id']}";
        });
      }else{
        setState(() {
          payment_data = null;
          deductionType = [];
          pdfUrl = "";
        });
      }
    }else{
      setState(() {
        payment_data = null;
        pdfUrl = "";
        deductionType = [];
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "reject-${widget.earning_data['month_paid_for']}",
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
                child: Skeletonizer(
                  enabled: loading,
                  effect: customThemes.maruShimmerEffect(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30,),
                        Center(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: customThemes.successColor,
                            child: Icon(Icons.check, color: customThemes.whiteColor,),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text("Payment done successfully!", style: customThemes.secondaryTextStyle(size: 16, fontweight: FontWeight.normal),),
                        SizedBox(height: 5,),
                        Text("Kes ${payment_data != null ? payment_data['total_payment'] ?? "N/A" : "N/A"}", style: customThemes.darkTextStyle(size: 20, fontweight: FontWeight.bold),),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child:Text("${payment_data != null ? payment_data['date_paid'] ?? "N/A" : "N/A"}", style: customThemes.darkTextStyle(size: 12, fontweight: FontWeight.bold),),
                        ),
                        Divider(
                          height: 50,
                          color: customThemes.secondaryShade_2,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Gross Pay", style: customThemes.primaryTextStyle(size: 12),),
                              Text("Kes ${payment_data != null ? payment_data['payment_amount'] ?? "N/A" : "N/A"}", style: customThemes.primaryTextStyle(size: 12, fontweight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        (payment_data != null ? payment_data['deductions'].length : 0) > 0 ? Container(
                          width: width/3,
                          child: Center(child: Divider()),
                        ) : SizedBox(height: 0,),
                        (payment_data != null ? payment_data['deductions'].length : 0) > 0 ? Container(
                          height: (payment_data != null ? double.parse(payment_data['deductions'].length.toString()) : 0) * 30,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: payment_data['deductions'].length,
                            itemBuilder: (context, index){
                              var item = payment_data != null ? payment_data['deductions'][index] ?? {"deduction_type" : "null", "deduction_amount" : "0"} : {"deduction_type" : "null", "deduction_amount" : "0"};
                              return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${deduction_type(item['deduction_type'].toString())}", style: customThemes.secondaryTextStyle(size: 12),),
                                      Text("Kes -${item['deduction_amount']}", style: customThemes.secondaryTextStyle(size: 12, fontweight: FontWeight.bold),),
                                    ],
                                  ),
                                );
                            }
                          ),
                        ) : SizedBox(height: 0,),
                        Container(
                          child: Center(child: Divider()),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Payment", style: customThemes.secondaryTextStyle(size: 12),),
                              Text("Kes ${payment_data != null ? payment_data['total_payment'] ?? "N/A" : "N/A"}", style: customThemes.darkTextStyle(size: 12, fontweight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        Container(
                          child: customThemes.maruIconButton(
                            icons: Icons.download,
                            iconSize: 20,
                            text: downloading ? "Downloading..." : "Download Receipt",
                            onPressed: downloadPDF
                          ),
                        ),
                        downloaded ?
                        Container(
                          child: customThemes.maruIconButton(
                            icons: Icons.remove_red_eye_outlined,
                            iconSize: 20,
                            text: "View Receipt",
                            type: Type.secondary,
                            onPressed: openPDF
                          ),
                        ) : SizedBox(),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width/3,
                                child: customThemes.marOutlineuButton(
                                    text: "Nullify",
                                    showLoader: saveLoader,
                                    disabled: saveLoader,
                                    onPressed: () async {
                                      LocalAuthentication auth = LocalAuthentication();
                                      bool proceed = await customThemes.BiometricAuthenticate(auth: auth, context: context, auth_msg: "Please authenticate to nullify payments!");
                                      if(proceed){
                                        setState((){
                                          saveLoader = true;
                                        });
                                        ApiConnection apiConn = ApiConnection();
                                        var response = await apiConn.declineMemberPayment(widget.earning_data['id'].toString());
                                        if(customThemes.isValidJson(response)){
                                          var res = jsonDecode(response);
                                          if(res['success']){
                                            Navigator.pop(context, res);
                                          }else{
                                            Navigator.pop(context, res);
                                          }
                                        }
                                        setState((){
                                          saveLoader = false;
                                        });
                                      }else{
                                        customThemes.maruSnackBarDanger(context: context, text: "Authenticated failed!");
                                      }
                                    },
                                    type: Type.danger
                                ),
                              ),
                              Container(
                                width: width/3,
                                child: customThemes.marOutlineuButton(
                                    text: "Close",
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
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

class MemberReports extends StatefulWidget {
  const MemberReports({super.key});

  @override
  State<MemberReports> createState() => _MemberReportsState();
}

class _MemberReportsState extends State<MemberReports> {
  // CUSTOM THEME
  CustomThemes customs = CustomThemes();
  var member_data = null;
  bool _init = false;
  bool loading = false;
  var reportType = "";
  DateTime min_date = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String pdfUrl = "http://192.168.88.236:8000/api/member/reports";
  bool downloading = false;
  bool downloaded = false;
  String buttonMessage = "Generate Reports";
  String? localFilePath;


  void openPDF() {
    if (localFilePath != null) {
      OpenFile.open(localFilePath!);
    } else {
      customs.maruSnackBarDanger(context: context, text: "No file available to open!");
    }
  }

  Future<bool> _requestPermission() async {
    // Check the status of the permission
    var status = await Permission.manageExternalStorage.status;

    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      // If permission is denied, request it
      if (await Permission.manageExternalStorage.request().isGranted) {
        print("Permission granted.");
        return true;
      } else {
        print("Permission denied.");
        return false;
      }
    }
    // If already granted, return true
    return true;
  }

  Future<void> downloadPDF() async {
    setState(() {
      downloading = true;
      buttonMessage = "Request Permission...";
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
          final filePath = '${directory.path}/${reportType}-details.pdf';

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
            customs.maruSnackBarSuccess(context: context, text: "Receipt downloaded successfully!");
            print("File saved at: $filePath");
          } else {
            customs.maruSnackBarDanger(context: context, text: "Failed to save the receipt!");
          }
        } else {
          customs.maruSnackBarDanger(context: context, text: "Couldn't download the receipt!");
        }
      } catch (e) {
        customs.maruSnackBarDanger(context: context, text: "An error occurred: $e");
      }
    } else {
      customs.maruSnackBarDanger(context: context, text: "Storage permission is required to download the receipt.");
    }

    setState(() {
      downloading = false;
    });
  }

  // text editing controller
  TextEditingController start_date = new TextEditingController();
  TextEditingController end_date = new TextEditingController();

  List<DropdownMenuItem<String>> reportTypes = [
    const DropdownMenuItem(child: Text("Select Report Type"), value: ""),
    const DropdownMenuItem(child: Text("Collections"), value: "collections"),
    const DropdownMenuItem(child: Text("Payment Reports"), value: "payments"),
  ];

  void didChangeDependencies(){
    // change dependencies
    super.didChangeDependencies();

    if(!_init){
      // get member details
      getMemberDetails();

      // set state
      setState(() {
        _init = true;
        min_date = DateTime.now().subtract(Duration(days: 30));
        start_date.text = addDaysOrMonthsToDate(dateTime: DateTime.now(), monthsToAdd: -1);
        end_date.text = createDate(dateTime: DateTime.now());
      });
    }
  }


  Future<void> getMemberDetails() async {
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getMemberDetails();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        // set state
        setState(() {
          member_data = res['member_details'];
        });
      }else{

      }
    }
  }

  String addDaysOrMonthsToDate({
    required DateTime dateTime,
    int? daysToAdd,
    int? monthsToAdd,
  }) {
    DateTime newDate = dateTime;

    // Add days if specified
    if (daysToAdd != null) {
      newDate = newDate.add(Duration(days: daysToAdd));
    }

    // Add months if specified
    if (monthsToAdd != null) {
      int newYear = newDate.year;
      int newMonth = newDate.month + monthsToAdd;

      // Adjust the year if the month goes beyond December
      while (newMonth > 12) {
        newYear += 1;
        newMonth -= 12;
      }

      // Handle case where day of the month might not exist (e.g., February 30)
      int newDay = newDate.day;
      int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day; // Get the last day of the new month
      if (newDay > daysInNewMonth) {
        newDay = daysInNewMonth;
      }

      newDate = DateTime(newYear, newMonth, newDay);
    }

    // Format the new date as a string
    String formattedDate = DateFormat('dd/MM/yyyy').format(newDate);

    return formattedDate;
  }

  String createDate({DateTime? dateTime}) {
    // If no date is provided, use the current date
    DateTime date = dateTime ?? DateTime.now();

    // Format the date as a string
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);

    return formattedDate;
  }

  String convertDate({required String dateString}) {
    // Example date in dd/MM/yyyy format
    dateString = dateString.replaceAll("/", "");

    // Extract day, month, and year
    String day = dateString.substring(0, 2);
    String month = dateString.substring(2, 4);
    String year = dateString.substring(4, 8);

    // Reformat to yyyy-MM-dd
    String reformattedDate = "$year$month$day";

    return reformattedDate;
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
            decoration: BoxDecoration(
                color: customs.whiteColor
            ),
            child: Skeletonizer(
              enabled: loading,
              child: Container(
                height: height - 5,
                width: width,
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: CircleAvatar(
                            radius: width * 0.1,
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
                            )
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        child: Text(
                          customs.toCamelCase(member_data != null ? member_data['fullname'] ?? "N/A" : "N/A"),
                          style: customs.darkTextStyle(
                              size: 20,
                              fontweight: FontWeight.bold
                          ),
                        ),
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
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                width: width * 0.9,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Report Type:",
                                      style: customs.darkTextStyle(
                                          size: 12, fontweight: FontWeight.bold),
                                    ),
                                    customs.maruDropdownButtonFormField(
                                        defaultValue: reportType,
                                        onChange: (value) {
                                          setState(() {
                                            reportType = value!;
                                          });
                                        },
                                        items: reportTypes,
                                        validator: (value) {
                                          if(value == null || value.isEmpty){
                                            return "Select report type";
                                          }
                                          return null;
                                        }
                                    ),
                                    Divider(
                                      color: customs.secondaryShade_2,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: width * 0.9,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Start:",
                                      style: customs.darkTextStyle(
                                          size: 12, fontweight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        String dateString = start_date.text; // Example date in dd/MM/yyyy format
                                        dateString = dateString.replaceAll("/", "");

                                        // Extract day, month, and year
                                        String day = dateString.substring(0, 2);
                                        String month = dateString.substring(2, 4);
                                        String year = dateString.substring(4, 8);

                                        // Reformat to yyyy-MM-dd
                                        String reformattedDate = "$year-$month-$day";
                                        DateTime parsedDate = DateTime.parse(reformattedDate);

                                        BottomPicker.date(
                                          pickerTitle: Text(
                                            'Select Start Date',
                                            style: customs.secondaryTextStyle(
                                              fontweight: FontWeight.bold,
                                              size: 15,
                                            ),
                                          ),
                                          dateOrder: DatePickerDateOrder.dmy,
                                          initialDateTime: parsedDate,
                                          maxDateTime: DateTime.now().add(Duration(seconds: 1)),
                                          minDateTime: DateTime.now().subtract(Duration(days: 5000)),
                                          pickerTextStyle: customs.secondaryTextStyle(
                                              size: 13, fontweight: FontWeight.bold),
                                          onChange: (index) {
                                            print(index);
                                          },
                                          onSubmit: (selected_date) {
                                            setState(() {
                                              start_date.text = addDaysOrMonthsToDate(dateTime: selected_date, daysToAdd: 0);
                                            });
                                          },
                                          bottomPickerTheme: BottomPickerTheme.blue,
                                        ).show(context);
                                      },
                                      child: customs.maruTextFormField(
                                          isChanged: (value) {},
                                          enabled: false,
                                          textType: TextInputType.text,
                                          floatingBehaviour: FloatingLabelBehavior.always,
                                          hintText: "01/09/2024",
                                          editingController: start_date,
                                          validator: (value) {
                                            if(value == null || value.isEmpty){
                                              return "Set Start date";
                                            }
                                            return null;
                                          }
                                      ),
                                    ),
                                    Divider(
                                      color: customs.secondaryShade_2,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: width * 0.9,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "End:",
                                      style: customs.darkTextStyle(
                                          size: 12, fontweight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        String dateString = end_date.text; // Example date in dd/MM/yyyy format
                                        dateString = dateString.replaceAll("/", "");

                                        // Extract day, month, and year
                                        String day = dateString.substring(0, 2);
                                        String month = dateString.substring(2, 4);
                                        String year = dateString.substring(4, 8);

                                        // Reformat to yyyy-MM-dd
                                        String reformattedDate = "$year-$month-$day";
                                        DateTime parsedDate = DateTime.parse(reformattedDate);

                                        BottomPicker.date(
                                          pickerTitle: Text(
                                            'Select End Date',
                                            style: customs.secondaryTextStyle(
                                              fontweight: FontWeight.bold,
                                              size: 15,
                                            ),
                                          ),
                                          dateOrder: DatePickerDateOrder.dmy,
                                          initialDateTime: parsedDate,
                                          maxDateTime: DateTime.now().add(Duration(seconds: 1)),
                                          minDateTime: DateTime.now().subtract(Duration(days: 5000)),
                                          pickerTextStyle: customs.secondaryTextStyle(
                                              size: 13, fontweight: FontWeight.bold),
                                          onChange: (index) {
                                            print(index);
                                          },
                                          onSubmit: (selected_date) {
                                            setState(() {
                                              end_date.text = addDaysOrMonthsToDate(dateTime: selected_date, daysToAdd: 0);
                                            });
                                          },
                                          bottomPickerTheme: BottomPickerTheme.blue,
                                        ).show(context);
                                      },
                                      child: customs.maruTextFormField(
                                          isChanged: (value) {},
                                          enabled: false,
                                          textType: TextInputType.text,
                                          floatingBehaviour: FloatingLabelBehavior.always,
                                          hintText: "31/09/2024",
                                          editingController: end_date,
                                          validator: (value) {
                                            if(value == null || value.isEmpty){
                                              return "Set Start date";
                                            }
                                            return null;
                                          }
                                      ),
                                    ),
                                    Divider(
                                      color: customs.secondaryShade_2,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: width * 0.9,
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: customs.maruButton(
                                    type: Type.success,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    text: buttonMessage,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()){
                                        // set url
                                        setState(() {
                                          pdfUrl = "${customs.apiURLDomain}/api/member/reports?report_type=${reportType}&start_date=${convertDate(dateString: start_date.text)}&end_date=${convertDate(dateString: end_date.text)}&member_id=${member_data != null ? member_data['user_id'] ?? "0" : "0"}";
                                          print(pdfUrl);
                                          downloading = true;
                                        });

                                        // download pdf
                                        await downloadPDF();

                                        setState(() {
                                          downloading = false;
                                          buttonMessage = "Done!";
                                        });

                                        // open the file
                                        openPDF();

                                        // openning
                                        setState(() {
                                          downloading = false;
                                          buttonMessage = "Openning File..";
                                        });

                                        // back to normal
                                        setState(() {
                                          downloading = false;
                                          buttonMessage = "Generate Reports";
                                        });
                                      }
                                    }
                                ),
                              ),
                            ],
                          )
                      ),
                      SizedBox(
                        height: height/4,
                      ),
                      Center(
                        child:
                        Text(
                          "Find your documents on /Downloads/MaruDairy",
                          style: customs.secondaryTextStyle(
                              size: 12, fontweight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )),
    );
  }
}

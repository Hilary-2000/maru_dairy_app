import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class AdminEditProfile extends StatefulWidget {
  const AdminEditProfile({super.key});

  @override
  State<AdminEditProfile> createState() => _AdminEditProfileState();
}

class _AdminEditProfileState extends State<AdminEditProfile> {
  CustomThemes customs = CustomThemes();
  var admin_data = null;
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController FullName = TextEditingController();
  TextEditingController admin_username = TextEditingController();
  String regionDV = "";
  String genderDV = "";
  bool loading = false;
  bool save_member = false;
  bool _init = false;
  final _formKey = GlobalKey<FormState>();


  File? _image;
  bool loading_image = false;
  double progress = 0.0;

  // Image picker function to select the image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // upload image
  Future<void> _uploadImage(BuildContext context) async {
    if (_image == null) {
      customs.maruSnackBarDanger(context: context, text: "Please select an image");
      return;
    }

    setState(() {
      loading_image = true;
      progress = 0.0;
    });

    final url = Uri.parse("${customs.apiURLDomain}/api/admin/dp/update");
    final request = http.MultipartRequest("POST", url);

    // Add custom header
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    if (token == null) {
      customs.maruSnackBarDanger(context: context, text: "Authentication token is missing");
      setState(() {
        loading_image = false;
      });
      return;
    }

    request.headers['maru-authentication-code'] = "$token";

    try {
      // Add user_id as part of the fields (replace with actual user_id)
      request.fields['user_id'] = "${admin_data['user_id']}";
      // Replace with the actual user_id

      // Attach the image file
      final mimeTypeData = lookupMimeType(_image!.path)!.split('/');
      request.files.add(await http.MultipartFile.fromPath(
        'mine_dp',
        _image!.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ));

      // Send the request
      final response = await request.send();

      // Track progress
      int totalBytes = response.contentLength ?? 0;
      int bytesTransferred = 0;

      await response.stream.listen(
            (chunk) {
          bytesTransferred += chunk.length;
          setState(() {
            progress = totalBytes != 0 ? bytesTransferred / totalBytes : 0;
          });
        },
        onDone: () async {
          // Once done, read the response body
          final responseBody = await response.stream.bytesToString();

          if (response.statusCode == 200) {
            customs.maruSnackBarSuccess(context: context, text: "Upload successful: $responseBody");
            setState(() {
              progress = 1.0;
            });
          } else {
            // customs.maruSnackBarDanger(context: context, text: "Failed to upload image. Status: ${response.statusCode}");
            customs.maruSnackBarDanger(context: context, text: "Failed to upload image.");
            setState(() {
              progress = 0.0;
            });
          }
        },
        onError: (e) {
          customs.maruSnackBarDanger(context: context, text: "An error occurred: $e");
          setState(() {
            progress = 0.0;
          });
        },
        cancelOnError: true, // Cancel if there's an error
      );

      // done
      customs.maruSnackBarSuccess(context: context, text: "Profile photo uploaded successfully!");
    } catch (e) {
      setState(() {
        progress = 0.0;
      });
      customs.maruSnackBarDanger(context: context, text: "An error occurred: $e");
    }

    setState(() {
      loading_image = false;
    });
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
  bool loading_regions = false;
  List<DropdownMenuItem<String>> regions = [];
  List<DropdownMenuItem<String>> genderList = [
    const DropdownMenuItem(child: Text("Select Gender"), value: ""),
    const DropdownMenuItem(child: Text("Male"), value: "male"),
    const DropdownMenuItem(child: Text("Female"), value: "female"),
  ];

  Future<void> getRegions() async {
    setState(() {
      loading_regions = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.getActiveRegions();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        // regions
        if(res['regions'].length > 0){
          setState(() {
            regions = (res['regions'] as List).map((region){
              return DropdownMenuItem(child: Text("${region['region_name']}"), value: "${region['region_id']}");
            }).toList();
          });
        }else{
          setState(() {
            regions = [const DropdownMenuItem(child: Text("Select your region"), value: "")];
          });
        }
      }else{
        customs.maruSnackBarDanger(context: context, text: res['message']);
      }
    }

    // set state
    setState(() {
      loading_regions = false;
    });
  }

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if(!_init){
      await getRegions();
      // get member details
      getAdminDetails();

      setState(() {
        _init = true;
      });
    }
  }

  // get the member details
  Future<void> getAdminDetails() async {
    setState(() {
      loading = true;
    });
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.viewAdminProfile();
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        // set state
        setState(() {
          admin_data = res['administrator'] ?? null;

          // phone number
          phoneNumber.text = admin_data != null ? (admin_data['phone_number'] ?? "") : "";
          email.text = admin_data != null ? (admin_data['email'] ?? "") : "";
          location.text = admin_data != null ? (admin_data['residence'] ?? "") : "";
          genderDV = admin_data != null ? (admin_data['gender'] ?? "") : "";
          regionDV = admin_data != null ? (admin_data['region'] ?? "") : "";
          FullName.text = admin_data != null ? (admin_data['fullname'] ?? "") : "";
          admin_username.text = admin_data != null ? admin_data['username'] ?? "" : "";
        });
      }else{
        // Navigator.pop(context);
      }
    }else{
      // Navigator.pop(context);
    }
    setState(() {
      loading = false;
    });
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
                Container(
                  height: height - 5,
                  width: width,
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: SingleChildScrollView(
                    child: Skeletonizer(
                      enabled: loading,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Stack(children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      width: width,
                                      height: 200,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: width * 0.9,
                                            height: 100,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight: Radius.circular(8)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromRGBO(1, 176, 241, 1),
                                                    Color.fromRGBO(255, 193, 7, 1),
                                                    Color.fromRGBO(20, 72, 156, 1),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                )),
                                          ),
                                          Container(
                                            width: width * 0.9,
                                            height: 100,
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
                                                  toCamelCase(admin_data != null ? admin_data['fullname'] ?? "N/A" : "N/A"),
                                                  style: customs.darkTextStyle(
                                                      size: 20,
                                                      fontweight: FontWeight.bold),
                                                ),
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
                                          radius: 44,
                                          child: ClipOval(
                                            child: (admin_data != null) ?
                                            Image.network(
                                              "${customs.apiURLDomain}${admin_data['profile_photo']}",
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
                                    ),
                                    Positioned(
                                      left: (width * 0.5) + 15,
                                      top: 125,
                                      child: Skeleton.ignore(
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: customs.secondaryColor,
                                          child: IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.penFancy,
                                              size: 10,
                                            ),
                                            onPressed: () async {
                                              // pick image
                                              await _pickImage();
                                              await _uploadImage(context);

                                              //get the technician data
                                              getAdminDetails();
                                            },
                                            color: customs.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 65, // Adjust this value to move the CircleAvatar up
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: loading_image ? CircleAvatar(
                                          radius: 44,
                                          backgroundColor: customs.secondaryShade_2.withOpacity(0.4),
                                          child: SpinKitCircle(
                                            color: customs.secondaryShade,
                                            size: 40.0,
                                          ),
                                        ) : SizedBox(),
                                      )
                                    )
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(
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
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Fullname:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                      editingController: FullName,
                                      isChanged: (value){},
                                      floatingBehaviour: FloatingLabelBehavior.always,
                                      hintText: "Full name",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter Fullname!";
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
                                    "Phone Number:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                      editingController: phoneNumber,
                                      isChanged: (value){},
                                      floatingBehaviour: FloatingLabelBehavior.always,
                                      hintText: "Phone Number",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter Phonenumber!";
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
                                    "Gender:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruDropdownButtonFormField(
                                      defaultValue: genderDV,
                                      onChange: (value){
                                        setState(() {
                                          genderDV = value!;
                                        });
                                      },
                                      items: genderList
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
                                    "Email:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                      editingController: email,
                                      isChanged: (value){},
                                      textType: TextInputType.emailAddress,
                                      floatingBehaviour: FloatingLabelBehavior.always,
                                      hintText: "Email Address",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter Email Address!";
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
                                    "Location:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruTextFormField(
                                      editingController: location,
                                      isChanged: (value){},
                                      textType: TextInputType.text,
                                      floatingBehaviour: FloatingLabelBehavior.always,
                                      hintText: "Thika, Kiambu County",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter Residence!";
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
                              child: loading_regions ?
                              Column(
                                children: [
                                  SpinKitCircle(
                                    color: customs.primaryColor,
                                    size: 25,
                                  ),
                                  Text(
                                    "Please wait loading regions...",
                                    style: customs.primaryTextStyle(size: 10, fontweight: FontWeight.bold),
                                  )
                                ],
                              )
                                  :
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Region:",
                                    style: customs.darkTextStyle(
                                        size: 12, fontweight: FontWeight.bold),
                                  ),
                                  customs.maruDropdownButtonFormField(
                                      defaultValue: regionDV,
                                      onChange: (value) {
                                        setState(() {
                                          regionDV = value!;
                                        });
                                      },
                                      items: regions,
                                      validator: (value) {
                                        if(value == null || value.isEmpty){
                                          return "Select region";
                                        }
                                        return null;
                                      }),
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
                                  customs.maruTextFormField(
                                      editingController: admin_username,
                                      isChanged: (value){},
                                      textType: TextInputType.text,
                                      floatingBehaviour: FloatingLabelBehavior.always,
                                      hintText: "Thika, Kiambu County",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter Residence!";
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
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                child: customs.maruButton(
                                    text: "Save",
                                    disabled: save_member,
                                    showLoader: save_member,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()){
                                        setState(() {
                                          save_member = true;
                                        });
                                        var body = {
                                          "fullname": FullName.text,
                                          "gender": genderDV,
                                          "phone_number": phoneNumber.text,
                                          "email": email.text,
                                          "residence": location.text,
                                          "region": regionDV,
                                          "username": admin_username.text
                                        };
                                        ApiConnection apiConnection = new ApiConnection();
                                        var response = await apiConnection.updateAdminProfile(body);
                                        if(customs.isValidJson(response)){
                                          var res = jsonDecode(response);
                                          if(res['success']){
                                            customs.maruSnackBarSuccess(context: context, text: res['message']);
                                            getAdminDetails();
                                          }else{
                                            customs.maruSnackBarDanger(context: context, text: res['message']);
                                          }
                                        }else{
                                          customs.maruSnackBarDanger(context: context, text: "An error has occured!");
                                        }
                                        setState(() {
                                          save_member = false;
                                        });
                                      }
                                    }
                                )
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
    );
  }
}

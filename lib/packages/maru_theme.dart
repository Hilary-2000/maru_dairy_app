import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maru/packages/api_connection.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum Type { primary, secondary, warning, danger, info, dark, white, success }

enum Sizes { lg, md, sm, xm }

class CustomThemes{
  String apiURLDomain = "http://192.168.88.234:8000";
  // String apiURLDomain = "https://maru.ladybirdsmis.com";
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String color_mode = "light";
  List<Color> colors = [];


  // colors
  Color primaryColor = const Color.fromRGBO(1, 176, 241, 1);
  Color secondaryColor = const Color.fromRGBO(90, 98, 104, 1);
  Color dangerColor = const Color.fromRGBO(247, 14, 13, 1);
  Color warningColor = const Color.fromRGBO(255, 193, 7, 1);
  Color infoColor = const Color.fromRGBO(23, 162, 184, 1);
  Color successColor = const Color.fromRGBO(8, 157, 55, 1);
  Color whiteColor = const Color.fromRGBO(255, 255, 255, 1);
  Color darkColor = const Color.fromRGBO(0, 0, 0, 1);

//   light
  Color primaryShade = const Color.fromRGBO(184, 232, 249, 1);
  Color secondaryShade = const Color.fromRGBO(182, 186, 188, 1);
  Color dangerShade = const Color.fromRGBO(251, 114, 114, 1);
  Color warningShade = const Color.fromRGBO(240, 230, 172, 1);
  Color infoShade = const Color.fromRGBO(149, 213, 223, 1);
  Color successShade = const Color.fromRGBO(159, 216, 172, 1);
  Color whiteShade = const Color.fromRGBO(255, 255, 255, 1);
  Color darkShade = const Color.fromRGBO(121, 121, 121, 1);


// light
  Color primaryShade_2 = const Color.fromRGBO(184, 232, 249, 0.5);
  Color secondaryShade_2 = const Color.fromRGBO(182, 186, 188, 0.5);
  Color dangerShade_2 = const Color.fromRGBO(251, 114, 114, 0.5);
  Color warningShade_2 = const Color.fromRGBO(240, 230, 172, 0.5);
  Color infoShade_2 = const Color.fromRGBO(149, 213, 223, 0.5);
  Color successShade_2 = const Color.fromRGBO(8, 157, 55, 0.5);
  Color whiteShade_2 = const Color.fromRGBO(255, 255, 255, 0.5);
  Color darkShade_2 = const Color.fromRGBO(121, 121, 121, 0.5);

  // CustomThemes._();
  //
  // static Future<CustomThemes> create() async {
  //   final instance = CustomThemes._();
  //   await instance.initialize();
  //   return instance;
  // }

  Future <void> initialize() async{
    color_mode = (await _storage.read(key: 'bright_mode'))!;
    print("Status : ${color_mode}");
    // colors
    primaryColor = const Color.fromRGBO(1, 176, 241, 1);
    secondaryColor = color_mode == "light" ? const Color.fromRGBO(90, 98, 104, 1) : const Color.fromRGBO(210, 210, 210, 1);
    dangerColor = const Color.fromRGBO(247, 14, 13, 1);
    warningColor = const Color.fromRGBO(255, 193, 7, 1);
    infoColor = const Color.fromRGBO(23, 162, 184, 1);
    successColor = const Color.fromRGBO(40, 167, 69, 1);
    whiteColor = color_mode == "light" ? const Color.fromRGBO(255, 255, 255, 1) : const Color.fromRGBO(41, 41, 41, 1);
    darkColor = color_mode == "light" ? const Color.fromRGBO(41, 41, 41, 1) : const Color.fromRGBO(255, 255, 255, 1);

//   light
    primaryShade = const Color.fromRGBO(184, 232, 249, 1);
    secondaryShade = color_mode == "light" ? const Color.fromRGBO(182, 186, 188, 1) : const Color.fromRGBO(210, 210, 210, 1);
    dangerShade = const Color.fromRGBO(251, 114, 114, 1);
    warningShade = const Color.fromRGBO(240, 230, 172, 1);
    infoShade = const Color.fromRGBO(149, 213, 223, 1);
    successShade = const Color.fromRGBO(159, 216, 172, 1);
    whiteShade = color_mode == "light" ? const Color.fromRGBO(255, 255, 255, 1) : const Color.fromRGBO(121, 121, 121, 1);
    darkShade = color_mode == "light" ? const Color.fromRGBO(121, 121, 121, 1) : const Color.fromRGBO(255, 255, 255, 1);


//   light
    primaryShade_2 = const Color.fromRGBO(184, 232, 249, 0.5);
    secondaryShade_2 = color_mode == "light" ? const Color.fromRGBO(182, 186, 188, 0.5) : const Color.fromRGBO(210, 210, 210, 1);
    dangerShade_2 = const Color.fromRGBO(251, 114, 114, 0.5);
    warningShade_2 = const Color.fromRGBO(240, 230, 172, 0.5);
    infoShade_2 = const Color.fromRGBO(149, 213, 223, 0.5);
    successShade_2 = const Color.fromRGBO(159, 216, 172, 0.5);
    whiteShade_2 = color_mode == "light" ? const Color.fromRGBO(255, 255, 255, 0.5) : const Color.fromRGBO(121, 121, 121, 0.5);
    darkShade_2 = color_mode == "light" ? const Color.fromRGBO(121, 121, 121, 0.5) : const Color.fromRGBO(255, 255, 255, 0.5);
    colors = [primaryShade, secondaryShade.withOpacity(0.2), warningShade, successShade.withOpacity(0.2), successShade.withOpacity(0.2)];
  }

  TextStyle primaryTextStyle(
      {double size = 10, FontWeight fontweight = FontWeight.normal, bool underline = false}) {
    return TextStyle(
      fontFamily: "Nunito",
      fontSize: size,
      fontWeight: fontweight,
      color: primaryColor,
      letterSpacing: 0.5,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: primaryColor, // Optional: Change the underline color
      decorationThickness: 2, // Optional: Change the underline thickness
    );
  }


  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> BiometricAuthenticate ({
    required LocalAuthentication auth,
    required BuildContext context,
    String auth_msg = "Ooops! Authenticate before you proceed!"
  }) async {
    late bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: auth_msg,
        options: const AuthenticationOptions(
          biometricOnly: false, // Allows PIN/Pattern/Password as well
          stickyAuth: true,
        ),
      );
    } on PlatformException catch  (e) {
      // Handle specific exceptions based on error codes
      switch (e.code) {
        case 'NotAvailable':
          authenticated = await _askForPassword('Biometric authentication is not available on this device.', context);
          break;
        case 'NotEnrolled':
          maruSnackBarDanger( text: 'No biometric data is enrolled. Please set up biometrics and try again.', context: context);
          break;
        case 'LockedOut':
          authenticated = await _askForPassword('You`ve been locked out due to many attempts, Try again later!', context);
          break;
        case 'PermanentlyLockedOut':
          authenticated = await _askForPassword('Biometric authentication is not set. Provide your login password.', context);
          break;
        case 'UserCanceled':
          authenticated = await _askForPassword('Provide your login password.', context);
          break;
        case 'AuthenticationFailed':
          authenticated = await _askForPassword('Authentication failed! Provide your login password.', context);
          break;
        case 'auth_in_progress':
          print("Doing!");
          break;
        default:
          authenticated = await _askForPassword('Provide your login password to proceed!', context);
          break;
      }
    }
    return authenticated;
  }

  Future<bool> _askForPassword (String message, BuildContext context) async{
    return await showDialog(
      context: context,
      builder: (context) => PasswordDialog(message: message),
    );
  }

  Future<bool> _validatePassword(String password) async {
    // Replace this with actual password validation logic
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.authenticatePassword(password: password);
    if(isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        return true;
      }
    }
    return false;
  }

  bool checkRegion(List<dynamic> regions, String region){
    bool isValid = false;
    for(int index = 0; index < regions.length; index++){
      if(regions[index]['region_id'].toString() == region){
        isValid = true;
        break;
      }
    }
    return isValid;
  }


  String nameAbbr(String name){
    String abbr = "";

    // remove unwanted spaces in words
    List<String> words = name.split(' ');
    String formatted_text = "";
    for(int index = 0; index < words.length; index++){
      formatted_text += words[index].trim().length > 0 ? words[index].trim()+" " : "";
    }
    formatted_text = formatted_text.trim();
    words = formatted_text.split(" ");
    //end of formatting words

    int length = words.length >=2 ? 2 : words.length;
    for(int index = 0; index < length; index++){
      abbr += words[index].length > 0 ? words[index].substring(0,1) : "";
    }
    return abbr;
  }

  String message_split(String name){
    String abbr = "";
    abbr = name.length > 30 ? name.substring(0, 30)+"..." : name;
    return abbr.toUpperCase();
  }

  // change to camel case
  String toCamelCase(String text) {
    if(text.length == 0){
      return "";
    }
    // Step 1: Split the string by spaces or underscores
    List<String> words = text.split(RegExp(r'[\s_]+'));

    // Step 2: Capitalize the first letter of each word and lowercase the rest
    List<String> capitalizedWords = words.map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    // Step 3: Join the capitalized words with spaces
    return capitalizedWords.join(' ');
  }

  TextStyle secondaryTextStyle(
      {double size = 10, FontWeight fontweight = FontWeight.normal, bool underline = false}) {
    return TextStyle(
      fontFamily: "Nunito",
      fontSize: size,
      fontWeight: fontweight,
      color: secondaryColor,
      letterSpacing: 0.5,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: secondaryColor, // Optional: Change the underline color
      decorationThickness: 2, // Optional: Change the underline thickness
    );
  }

  TextStyle warningTextStyle(
      {double size = 10, FontWeight fontweight = FontWeight.normal, bool underline = false}) {
    return TextStyle(
      fontFamily: "Nunito",
      fontSize: size,
      fontWeight: fontweight,
      color: warningColor,
      letterSpacing: 0.5,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: warningColor, // Optional: Change the underline color
      decorationThickness: 2, // Optional: Change the underline thickness
    );
  }

  TextStyle infoTextStyle(
      {double size = 10, FontWeight fontweight = FontWeight.normal, bool underline = false}) {
    return TextStyle(
      fontFamily: "Nunito",
      fontSize: size,
      fontWeight: fontweight,
      color: infoColor,
      letterSpacing: 0.5,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: infoColor, // Optional: Change the underline color
      decorationThickness: 2, // Optional: Change the underline thickness
    );
  }

  TextStyle successTextStyle(
      {double size = 10, FontWeight fontweight = FontWeight.normal, bool underline = false}) {
    return TextStyle(
      fontFamily: "Nunito",
      fontSize: size,
      fontWeight: fontweight,
      color: successColor,
      letterSpacing: 0.5,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: successColor, // Optional: Change the underline color
      decorationThickness: 2, // Optional: Change the underline thickness
    );
  }

  TextStyle dangerTextStyle(
      {double size = 10, FontWeight fontweight = FontWeight.normal, bool underline = false}) {
    return TextStyle(
      fontFamily: "Nunito",
      fontSize: size,
      fontWeight: fontweight,
      color: dangerColor,
      letterSpacing: 0.5,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: dangerColor, // Optional: Change the underline color
      decorationThickness: 2, // Optional: Change the underline thickness
    );
  }

  TextStyle whiteTextStyle(
      {double size = 10, FontWeight fontweight = FontWeight.normal, bool underline = false}) {
    return TextStyle(
      fontFamily: "Nunito",
      fontSize: size,
      fontWeight: fontweight,
      color: whiteColor,
      letterSpacing: 0.5,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: whiteColor, // Optional: Change the underline color
      decorationThickness: 2, // Optional: Change the underline thickness
    );
  }

  TextStyle darkTextStyle(
      {double size = 10, FontWeight fontweight = FontWeight.normal, bool underline = false}) {
    return TextStyle(
      fontFamily: "Nunito",
      fontSize: size,
      fontWeight: fontweight,
      color: darkColor,
      letterSpacing: 0.5,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: darkColor, // Optional: Change the underline color
      decorationThickness: 2, // Optional: Change the underline thickness
    );
  }

  TextButton maruButton(
      {Sizes size = Sizes.sm,
        Type type = Type.primary,
        required String text,
        double fontSize = 15,
        double iconSize = 15,
        bool showArrow = false,
        bool showLoader = false,
        bool disabled = false,
        FontWeight fontWeight = FontWeight.normal,
        required void Function()? onPressed}) {
    Color foreground = whiteColor;
    Color background = primaryColor;
    Color disabledForeground = secondaryShade;
    Color disabledBackground = primaryShade;
    TextStyle Function({double size, FontWeight fontweight}) textStyle =
        whiteTextStyle;
    switch (type) {
      case Type.primary:
        foreground = whiteColor;
        background = primaryColor;
        disabledForeground = secondaryShade_2;
        disabledBackground = primaryShade;
        textStyle = whiteTextStyle;
        break;
      case Type.secondary:
        foreground = whiteColor;
        background = secondaryColor;
        disabledForeground = secondaryShade_2;
        disabledBackground = secondaryShade;
        textStyle = whiteTextStyle;
        break;
      case Type.success:
        foreground = whiteColor;
        background = successColor;
        disabledForeground = secondaryShade_2;
        disabledBackground = successShade;
        textStyle = whiteTextStyle;
        break;
      case Type.danger:
        foreground = darkColor;
        background = dangerColor;
        disabledForeground = darkShade;
        disabledBackground = dangerShade;
        textStyle = whiteTextStyle;
        break;
      case Type.warning:
        foreground = darkColor;
        background = warningColor;
        disabledForeground = darkShade;
        disabledBackground = warningShade;
        textStyle = darkTextStyle;
        break;
      case Type.info:
        foreground = darkColor;
        background = infoColor;
        disabledForeground = darkShade;
        disabledBackground = infoShade;
        textStyle = whiteTextStyle;
        break;
      case Type.dark:
        foreground = whiteColor;
        background = darkColor;
        disabledForeground = secondaryShade_2;
        disabledBackground = darkShade;
        textStyle = whiteTextStyle;
        break;
      case Type.white:
        foreground = darkColor;
        background = whiteColor;
        disabledForeground = secondaryShade;
        disabledBackground = secondaryShade_2;
        textStyle = darkTextStyle;
        break;
      default:
        foreground = whiteColor;
        background = darkColor;
        disabledForeground = secondaryShade_2;
        disabledBackground = darkShade;
        textStyle = whiteTextStyle;
        break;
    }
    EdgeInsets edgeInsets =
    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0);
    switch (size) {
      case (Sizes.lg):
        edgeInsets =
        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0);
      case (Sizes.md):
        edgeInsets =
        const EdgeInsets.symmetric(vertical: 6.0, horizontal: 18.0);
      case (Sizes.sm):
        edgeInsets = const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0);
      case (Sizes.xm):
        edgeInsets = const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0);
      default:
        edgeInsets = const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0);
        break;
    }

    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (disabled) {
            return disabledForeground; // Color when the button is disabled
          }
          return foreground; // Color when the button is enabled
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (disabled) {
            return disabledBackground; // Background color when disabled
          }
          return background; // Background color when enabled
        }),
        padding: WidgetStateProperty.all<EdgeInsets>(edgeInsets),
        textStyle: WidgetStateProperty.all<TextStyle>(
          textStyle(size: fontSize, fontweight: fontWeight),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      onPressed: disabled ? null : onPressed,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: textStyle(size: fontSize, fontweight: fontWeight),
            ),
            SizedBox(width: 2,),
            showLoader ? SpinKitCircle(
              color: foreground,
              size: 30.0,
            ) : SizedBox(),
            SizedBox(width: 3,),
            showArrow ? Icon(Icons.keyboard_double_arrow_right_outlined, size: iconSize,) : SizedBox()
          ]
      ),
    );
  }

  TextButton marOutlineuButton(
      {Sizes size = Sizes.sm,
        Type type = Type.primary,
        double iconSize = 15,
        bool showArrow = false,
        bool showLoader = false,
        required String text,
        double fontSize = 15,
        bool disabled = false,
        FontWeight fontWeight = FontWeight.normal,
        required void Function()? onPressed}) {
    Color foreground = whiteColor;
    Color background = primaryColor;
    Color disabledForeground = secondaryShade;
    Color disabledBackground = primaryShade;
    TextStyle Function({double size, FontWeight fontweight})
    textStyle = whiteTextStyle;
    switch (type) {
      case Type.primary:
        foreground = primaryColor;
        background = whiteColor;
        disabledForeground = primaryShade;
        disabledBackground = whiteShade;
        textStyle = primaryTextStyle;
        break;
      case Type.secondary:
        foreground = secondaryColor;
        background = whiteColor;
        disabledForeground = secondaryShade;
        disabledBackground = whiteShade;
        textStyle = secondaryTextStyle;
        break;
      case Type.success:
        foreground = successColor;
        background = whiteColor;
        disabledForeground = successShade;
        disabledBackground = whiteShade;
        textStyle = successTextStyle;
        break;
      case Type.danger:
        foreground = dangerColor;
        background = whiteShade_2;
        disabledForeground = dangerShade;
        disabledBackground = whiteShade;
        textStyle = dangerTextStyle;
        break;
      case Type.warning:
        foreground = warningColor;
        background = whiteColor;
        disabledForeground = warningShade;
        disabledBackground = whiteShade;
        textStyle = warningTextStyle;
        break;
      case Type.info:
        foreground = infoColor;
        background = whiteColor;
        disabledForeground = infoShade;
        disabledBackground = whiteShade;
        textStyle = infoTextStyle;
        break;
      case Type.dark:
        foreground = darkColor;
        background = whiteColor;
        disabledForeground = darkShade;
        disabledBackground = whiteShade;
        textStyle = darkTextStyle;
        break;
      case Type.white:
        foreground = whiteColor;
        background = darkColor;
        disabledForeground = whiteShade;
        disabledBackground = darkShade_2;
        textStyle = whiteTextStyle;
        break;
      default:
        foreground = whiteColor;
        background = darkColor;
        disabledForeground = whiteShade;
        disabledBackground = darkShade_2;
        textStyle = whiteTextStyle;
        break;
    }
    EdgeInsets edgeInsets =
    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0);
    switch (size) {
      case (Sizes.lg):
        edgeInsets =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0);
      case (Sizes.md):
        edgeInsets =
        const EdgeInsets.symmetric(vertical: 9.0, horizontal: 12.0);
      case (Sizes.sm):
        edgeInsets = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0);
      case (Sizes.xm):
        edgeInsets = const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0);
      default:
        edgeInsets = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0);
        break;
    }

    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (disabled) {
            return disabledForeground; // Color when the button is disabled
          }
          return foreground; // Color when the button is enabled
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (disabled) {
            return disabledBackground; // Background color when disabled
          }
          return background; // Background color when enabled
        }),
        padding: WidgetStateProperty.all<EdgeInsets>(edgeInsets),
        textStyle: WidgetStateProperty.all<TextStyle>(
          textStyle(size: fontSize, fontweight: fontWeight),
        ),
        side:
        WidgetStateProperty.all(BorderSide(color: foreground, width: 1.0)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      onPressed: disabled ? null : onPressed,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 1,),
            Text(
              text,
              style: textStyle(size: fontSize, fontweight: fontWeight),
            ),
            SizedBox(width: 2,),
            showLoader ? SpinKitCircle(
              color: foreground,
              size: 30.0,
            ) : SizedBox(),
            SizedBox(width: 1,),
            showArrow ? Icon(Icons.arrow_circle_right, size: iconSize,) : SizedBox()
          ]
      ),
    );
  }

//   textButton Icon
  TextButton maruIconButton(
      {Sizes size = Sizes.sm,
        double iconSize = 15,
        bool showArrow = true,
        Type type = Type.primary,
        required IconData icons,
        required String text,
        double fontSize = 12,
        FontWeight fontWeight = FontWeight.normal,
        required void Function()? onPressed}) {
    Color foreground = whiteColor;
    Color background = primaryColor;
    TextStyle Function({double size, FontWeight fontweight}) textStyle =
        whiteTextStyle;
    switch (type) {
      case Type.primary:
        foreground = whiteColor;
        background = primaryColor;
        textStyle = whiteTextStyle;
        break;
      case Type.secondary:
        foreground = whiteColor;
        background = secondaryColor;
        textStyle = whiteTextStyle;
        break;
      case Type.success:
        foreground = whiteColor;
        background = successColor;
        textStyle = whiteTextStyle;
        break;
      case Type.danger:
        foreground = darkColor;
        background = dangerColor;
        textStyle = whiteTextStyle;
        break;
      case Type.warning:
        foreground = darkColor;
        background = warningColor;
        textStyle = darkTextStyle;
        break;
      case Type.info:
        foreground = darkColor;
        background = infoColor;
        textStyle = whiteTextStyle;
        break;
      case Type.dark:
        foreground = whiteColor;
        background = darkColor;
        textStyle = whiteTextStyle;
        break;
      case Type.white:
        foreground = darkColor;
        background = whiteColor;
        textStyle = darkTextStyle;
        break;
      default:
        foreground = whiteColor;
        background = darkColor;
        textStyle = whiteTextStyle;
        break;
    }
    EdgeInsets edgeInsets =
    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0);
    switch (size) {
      case (Sizes.lg):
        edgeInsets =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0);
      case (Sizes.md):
        edgeInsets =
        const EdgeInsets.symmetric(vertical: 9.0, horizontal: 12.0);
      case (Sizes.sm):
        edgeInsets = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0);
      case (Sizes.xm):
        edgeInsets = const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0);
      default:
        edgeInsets = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0);
        break;
    }

    return TextButton.icon(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(foreground),
        backgroundColor: WidgetStateProperty.all<Color>(background),
        padding: WidgetStateProperty.all<EdgeInsets>(edgeInsets),
        textStyle: WidgetStateProperty.all<TextStyle>(
          textStyle(size: fontSize, fontweight: fontWeight),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      onPressed: onPressed,
      label: Text(
        text,
        style: textStyle(size: fontSize, fontweight: fontWeight),
      ),
      icon: Icon(icons, size: iconSize,),
    );
  }

  TextField maruTextField(
      {String? hintText,
        TextEditingController? editingController,
        required void Function(String)? isChanged,
        TextInputType textType = TextInputType.text,
        bool hideText = false,
        FloatingLabelBehavior floatingBehaviour = FloatingLabelBehavior.auto,
        String label = "",
        bool enabled = true}) {
    return TextField(
      keyboardType: textType,
      obscureText: hideText,
      enabled: enabled,
      controller: editingController,
      style: darkTextStyle(size: 15),
      decoration: InputDecoration(
        label: Text(
          label,
          style: darkTextStyle(size: 15.0),
        ),
        hintText: hintText,
        hintStyle: secondaryTextStyle(
          size: 15,
        ),
        floatingLabelBehavior: floatingBehaviour,
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: secondaryColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: primaryColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: dangerColor)),
        disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: secondaryShade)),
      ),
      onChanged: isChanged,
    );
  }



  ShimmerEffect maruShimmerEffect(){
    return ShimmerEffect(
        baseColor: secondaryShade.withOpacity(0.2),
        highlightColor: secondaryShade.withOpacity(0.2),
        duration: const Duration(seconds: 1)
    );
  }

  TextFormField maruSearchTextField(
      {String? hintText,
        TextEditingController? editingController,
        required void Function(String)? isChanged,
        TextInputType textType = TextInputType.text,
        bool hideText = false,
        TextAlign textAlign = TextAlign.center,
        String label = "",
        String? Function(String?)? validator,
        bool enabled = true
      }) {
    return TextFormField(
      keyboardType: textType,
      obscureText: hideText,
      enabled: enabled,
      controller: editingController,
      textAlign: textAlign,
      validator: validator,
      style: darkTextStyle(size: 14),
      decoration: InputDecoration(
        label: Text(
          label,
          style: darkTextStyle(size: 14.0),
        ),
        hintText: hintText,
        hintStyle: secondaryTextStyle(
          size: 14,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: secondaryShade)),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: primaryColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: dangerColor)),
        disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: secondaryShade)),
      ),
      onChanged: isChanged,
    );
  }

  void maruSnackBar({String? text, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: secondaryColor,
        duration: const Duration(seconds: 2),
        // width: MediaQuery.of(context).size.width,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              child: Text(
                text!,
                style: whiteTextStyle(size: 15, fontweight: FontWeight.bold),
              ),
            )
          ],
        )
    )
    );
  }

  void maruSnackBarSuccess({String? text, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: successColor,
        duration: const Duration(seconds: 2),
        // width: MediaQuery.of(context).size.width,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              child: Text(
                text!,
                style: whiteTextStyle(size: 15, fontweight: FontWeight.bold),
              ),
            )
          ],
        )
    )
    );
  }

  void maruSnackBarDanger({String? text, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: dangerColor,
        duration: const Duration(seconds: 2),
        // width: MediaQuery.of(context).size.width,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              child: Text(
                text!,
                style: whiteTextStyle(size: 15, fontweight: FontWeight.bold),
              ),
            )
          ],
        )
    )
    );
  }

  Container maruPassword({
    TextEditingController? editingController,
    bool? hidePassword,
    void Function(String)? isChanged,
    void Function()? passwordStatus,
    String? Function(String?)? validator,
    String label = "",
    String hintText = "",
    FloatingLabelBehavior floatingBehaviour = FloatingLabelBehavior.always,
    bool enabled = true
  }){
    return Container(
      child: Stack(
        alignment: Alignment(1,0),
        children: [
          maruTextFormField(
              label: label,
              enabled: enabled,
              editingController: editingController,
              textType: TextInputType.text,
              hideText: hidePassword!,
              isChanged: isChanged,
              validator: validator,
              floatingBehaviour: floatingBehaviour,
              hintText: hintText
          ),
          Container(
            width: 60,
            child: IconButton(onPressed: passwordStatus, icon: Icon(hidePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash), iconSize: 15, color: secondaryShade,),
          )
        ],
      ),
    );
  }

  TextFormField maruTextFormField(
      {String? hintText,
        TextEditingController? editingController,
        required void Function(String)? isChanged,
        TextInputType textType = TextInputType.text,
        bool hideText = false,
        String label = "",
        bool enabled = true,
        FloatingLabelBehavior floatingBehaviour = FloatingLabelBehavior.auto,
        String? Function(String?)? validator}) {
    return TextFormField(
      enabled: enabled,
      validator: validator,
      keyboardType: textType,
      obscureText: hideText,
      controller: editingController,
      style: darkTextStyle(size: 15),
      decoration: InputDecoration(
        label: Text(
          label,
          style: darkTextStyle(size: 15.0),
        ),
        hintText: hintText,
        hintStyle: secondaryTextStyle(
          size: 15,
        ),
        filled: true,
        fillColor: enabled ? whiteColor : secondaryShade_2.withOpacity(0.3),
        isDense: true,
        floatingLabelBehavior: floatingBehaviour,
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: dangerColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: secondaryColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: primaryColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: dangerColor)),
        disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: secondaryShade)),
      ),
      onChanged: isChanged,
    );
  }

  DropdownButtonFormField<String> maruDropdownButtonFormField({
    required String? defaultValue,
    List<DropdownMenuItem<String>>? items,
    required void Function(String?)? onChange,
    String? Function(String?)? validator,
    String? hintText,
  }) {
    return DropdownButtonFormField<String>(
      items: items,
      validator: validator,
      onChanged: onChange,
      value: defaultValue,
      focusColor: primaryColor,
      isExpanded: true,
      dropdownColor: whiteColor,
      iconEnabledColor: primaryColor,
      style: darkTextStyle(size: 15),
      elevation: 0,
      decoration: InputDecoration(
        fillColor: whiteColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: dangerColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: dangerColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
    );
  }

  Container maruDropDownButton({
    required String? defaultValue,
    List<DropdownMenuItem<String>>? items,
    required void Function(String?)? onChange,
    String? hintText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: secondaryColor), // Change the border color as needed
        borderRadius: BorderRadius.circular(4), // Optional: add rounded corners
      ),
      child: DropdownButton<String>(
        items: items,
        onChanged: onChange,
        value: defaultValue,
        focusColor: primaryColor,
        isExpanded: true,
        isDense: true,
        dropdownColor: whiteColor,
        iconEnabledColor: secondaryColor,
        style: secondaryTextStyle(size: 15),
        elevation: 0,
        underline: Container(),
      ),
    );
  }
  RefreshIndicator refreshIndicator({
    required Widget child,
    required Future<void> Function() onRefresh,
  }){
    return RefreshIndicator(
        backgroundColor: primaryColor,
        color: whiteColor,
        child: child,
        onRefresh: onRefresh
    );
  }
}

class PasswordDialog extends StatefulWidget {
  final String message;

  PasswordDialog({required this.message});

  @override
  _PasswordDialogState createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CustomThemes customs = CustomThemes();
  bool loading = false;
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> _validatePassword(String password) async {
    // Replace this with actual password validation logic
    ApiConnection apiConnection = new ApiConnection();
    var response = await apiConnection.authenticatePassword(password: password);
    if(customs.isValidJson(response)){
      var res = jsonDecode(response);
      if(res['success']){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: customs.whiteColor,
      title: Text(
        'Provide Password',
        style: customs.darkTextStyle(size: 20, fontweight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.message,
              style: customs.darkTextStyle(size: 12, fontweight: FontWeight.normal),
            ),
            SizedBox(height: 12),
            customs.maruPassword(
              passwordStatus: (){
                setState(() {
                  hidePassword = !hidePassword!;
                });
              },
              hidePassword: hidePassword,
              editingController: passwordController,
              label: "Enter Password!",
              hintText: "Enter Password!",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your password!";
                }
                return null;
              },
              isChanged: (value) {},
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: customs.maruButton(
                text: "Confirm",
                type: Type.success,
                showLoader: loading,
                disabled: loading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    String password = passwordController.text.trim();
                    bool authenticate = await _validatePassword(password);
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context, authenticate);
                  }
                },
              ),
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: customs.marOutlineuButton(
                text: "Cancel",
                type: Type.danger,
                onPressed: () {
                  Navigator.pop(context, false); // Close the dialog
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
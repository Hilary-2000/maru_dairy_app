import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Type { primary, secondary, warning, danger, info, dark, white, success }

enum Sizes { lg, md, sm, xm }

class CustomThemes {
  // colors
  Color primaryColor = const Color.fromRGBO(1, 176, 241, 1);
  Color secondaryColor = const Color.fromRGBO(90, 98, 104, 1);
  Color dangerColor = const Color.fromRGBO(247, 14, 13, 1);
  Color warningColor = const Color.fromRGBO(255, 193, 7, 1);
  Color infoColor = const Color.fromRGBO(23, 162, 184, 1);
  Color successColor = const Color.fromRGBO(40, 167, 69, 1);
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


//   light
  Color primaryShade_2 = const Color.fromRGBO(184, 232, 249, 0.5);
  Color secondaryShade_2 = const Color.fromRGBO(182, 186, 188, 0.5);
  Color dangerShade_2 = const Color.fromRGBO(251, 114, 114, 0.5);
  Color warningShade_2 = const Color.fromRGBO(240, 230, 172, 0.5);
  Color infoShade_2 = const Color.fromRGBO(149, 213, 223, 0.5);
  Color successShade_2 = const Color.fromRGBO(159, 216, 172, 0.5);
  Color whiteShade_2 = const Color.fromRGBO(255, 255, 255, 0.5);
  Color darkShade_2 = const Color.fromRGBO(121, 121, 121, 0.5);

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
        background = whiteColor;
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
      String label = ""}) {
    return TextField(
      keyboardType: textType,
      obscureText: hideText,
      controller: editingController,
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

  TextField maruSearchTextField(
      {String? hintText,
        TextEditingController? editingController,
        required void Function(String)? isChanged,
        TextInputType textType = TextInputType.text,
        bool hideText = false,
        TextAlign textAlign = TextAlign.center,
        String label = ""}) {
    return TextField(
      keyboardType: textType,
      obscureText: hideText,
      controller: editingController,
      textAlign: textAlign,
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
    FloatingLabelBehavior floatingBehaviour = FloatingLabelBehavior.always
  }){
    return Container(
      child: Stack(
        alignment: Alignment(1,0),
        children: [
          maruTextFormField(
            label: label,
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
            child: IconButton(onPressed: passwordStatus, icon: Icon(hidePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash), iconSize: 15,),
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
      FloatingLabelBehavior floatingBehaviour = FloatingLabelBehavior.auto,
      String? Function(String?)? validator}) {
    return TextFormField(
      validator: validator,
      keyboardType: textType,
      obscureText: hideText,
      controller: editingController,
      decoration: InputDecoration(
        label: Text(
          label,
          style: darkTextStyle(size: 15.0),
        ),
        hintText: hintText,
        hintStyle: secondaryTextStyle(
          size: 15,
        ),
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

  DropdownButton<String> maruDropDownButton({
    required String? defaultValue,
    List<DropdownMenuItem<String>>? items,
    required void Function(String?)? onChange,
    String? hintText,
  }) {
    return DropdownButton<String>(
      items: items,
      onChanged: onChange,
      value: defaultValue,
      focusColor: primaryColor,
      isExpanded: true,
      dropdownColor: whiteColor,
      iconEnabledColor: primaryColor,
      style: darkTextStyle(size: 15),
      elevation: 0,
      underline: Container(),
    );
  }
}

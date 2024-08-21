import 'package:flutter/material.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:numberpicker/numberpicker.dart';

class EditMilkPrice extends StatefulWidget {
  const EditMilkPrice({super.key});

  @override
  State<EditMilkPrice> createState() => _EditMilkPriceState();
}

class _EditMilkPriceState extends State<EditMilkPrice> {
  // customs
  CustomThemes customs = CustomThemes();
  double _currentDoubleValue = 45.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customs.primaryShade,
      appBar: AppBar(
        backgroundColor: customs.whiteColor,
        elevation: 1,
        title: Builder(builder: (context) {
          double screenWidth = MediaQuery.of(context).size.width;
          double calculatedWidth = screenWidth / 2 - 210;
          calculatedWidth = calculatedWidth > 0 ? calculatedWidth : 0;
          return Container(
            margin: EdgeInsets.fromLTRB(calculatedWidth, 0, 0, 0),
            child: Row(
              children: [
                SizedBox(
                  height: 45,
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
            decoration: BoxDecoration(color: customs.whiteColor),
            child: Column(
              children: [
                Container(
                  height: height - 5,
                  width: width,
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "Change Milk Price",
                                style: customs.darkTextStyle(
                                    size: 20, fontweight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: "Current Milk Price",
                                      style: customs.secondaryTextStyle(
                                          size: 14,
                                          fontweight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text: ": @ Kes 45 per Litre",
                                        style: customs.secondaryTextStyle(
                                            size: 14))
                                  ]
                                )
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: width * 0.5,
                            child: Divider(
                              color: customs.secondaryShade_2,
                              height: 30,
                            )
                        ),
                        DecimalNumberPicker(
                          value: _currentDoubleValue,
                          minValue: 0,
                          maxValue: 1000,
                          decimalPlaces: 2,
                          textStyle: customs.secondaryTextStyle(size: 20,),
                          selectedTextStyle: customs.secondaryTextStyle(size: 30,),
                          haptics: true,
                          onChanged: (value) => setState(() => _currentDoubleValue = value),
                        ),
                        SizedBox(
                            width: width * 0.5,
                            child: Divider(
                              color: customs.secondaryShade_2,
                              height: 30,
                            )
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "New Milk Price Per Litre",
                                style: customs.secondaryTextStyle(
                                    size: 14,
                                    fontweight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: ": \nKes $_currentDoubleValue per Litre",
                                      style: customs.primaryTextStyle(
                                          size: 30
                                      )
                                  )
                                ]
                            )
                        ),
                        Container(
                            padding: EdgeInsets.all(8.0),
                            width: width,
                            child: customs.maruIconButton(
                                icons: Icons.save,
                                text: "Save Milk Price",
                                onPressed: () {},
                                fontSize: 14
                            )
                        ),
                      ],
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maru/packages/maru_theme.dart';

class notificationWindow extends StatefulWidget {
  const notificationWindow({super.key});

  @override
  State<notificationWindow> createState() => _notificationWindowState();
}

class _notificationWindowState extends State<notificationWindow> {
  CustomThemes customs = CustomThemes();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: LayoutBuilder(
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
          child: false ? Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notifications",
                      style: customs.darkTextStyle(
                          size: 20, fontweight: FontWeight.bold),
                    ),
                    Text(
                      "Mark all as reads",
                      style: customs.primaryTextStyle(
                          size: 12, fontweight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                height: height - 50,
                width: width,
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, "/read_member_notification");
                        },
                        child: Container(
                          height: height * 0.15 < 100 ? 100 : height * 0.15,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: width * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: customs.whiteColor,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.15,
                                height: height * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(15)),
                                  color: customs.primaryShade_2,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.notifications_active_outlined,
                                    size: width * 0.06,
                                    color: customs.primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.7,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "New Update Alert!",
                                      style: customs.darkTextStyle(
                                          size: 15, fontweight: FontWeight.bold),
                                      softWrap: true,
                                    ),
                                    Text(
                                      "You can now be able to upload you milk details by taking a photo of...",
                                      style:
                                          customs.secondaryTextStyle(size: 12.0),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: width * 0.11,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(15)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "1 hr",
                                      style: customs.secondaryTextStyle(size: 10),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_horiz_outlined),
                                      onSelected: (String result) {
                                        // Handle the selection here
                                        print(result);
                                      },
                                      color: customs.secondaryColor,
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'Delete',
                                          height: 15,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .restore_from_trash_sharp,
                                                    size: 15,
                                                    color: customs.whiteColor,
                                                  ),
                                                  Text(
                                                    'Delete',
                                                    style: customs.whiteTextStyle(
                                                        size: 12),
                                                  ),
                                                ],
                                              ),
                                              Divider()
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Option 2',
                                          height: 15,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.remove_red_eye_outlined,
                                                    size: 15,
                                                    color: customs.whiteColor,
                                                  ),
                                                  Text(
                                                    'View',
                                                    style: customs.whiteTextStyle(
                                                        size: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: customs.primaryColor,
                                      size: 5,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, "/member_inbox");
                        },
                        child: Container(
                          height: height * 0.15 < 100 ? 100 : height * 0.15,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: width * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: customs.whiteColor,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.15,
                                height: height * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(15)),
                                  color: customs.warningShade_2,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.send_outlined,
                                    size: width * 0.06,
                                    color: customs.warningColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.7,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Message From Joseph!",
                                      style: customs.darkTextStyle(
                                          size: 15, fontweight: FontWeight.bold),
                                      softWrap: true,
                                    ),
                                    Text(
                                      "Welcome! You are now part of our big Family at Maru D...",
                                      style:
                                          customs.secondaryTextStyle(size: 12.0),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: width * 0.11,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(15)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "1 hr",
                                      style: customs.secondaryTextStyle(size: 10),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_horiz_outlined),
                                      onSelected: (String result) {
                                        // Handle the selection here
                                        print(result);
                                      },
                                      color: customs.secondaryColor,
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'Delete',
                                          height: 15,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .restore_from_trash_sharp,
                                                    size: 15,
                                                    color: customs.whiteColor,
                                                  ),
                                                  Text(
                                                    'Delete',
                                                    style: customs.whiteTextStyle(
                                                        size: 12),
                                                  ),
                                                ],
                                              ),
                                              Divider()
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Option 2',
                                          height: 15,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.remove_red_eye_outlined,
                                                    size: 15,
                                                    color: customs.whiteColor,
                                                  ),
                                                  Text(
                                                    'View',
                                                    style: customs.whiteTextStyle(
                                                        size: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: customs.primaryColor,
                                      size: 5,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          print("Tapped!");
                        },
                        child: Container(
                          height: height * 0.15,
                          margin: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: width * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: customs.whiteColor,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.15,
                                height: height * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(15)),
                                  color: customs.successShade_2,
                                ),
                                child: Center(
                                  child: Icon(
                                    FontAwesomeIcons.sackDollar,
                                    size: width * 0.09,
                                    color: customs.successColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.7,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Account credited Successfully!!",
                                      style: customs.darkTextStyle(
                                          size: 15, fontweight: FontWeight.bold),
                                      softWrap: true,
                                    ),
                                    Text(
                                      "We are pleased to inform you that your account has been credited...",
                                      style:
                                          customs.secondaryTextStyle(size: 12.0),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: width * 0.11,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(15)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "1 hr",
                                      style: customs.secondaryTextStyle(size: 10),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_horiz_outlined),
                                      onSelected: (String result) {
                                        // Handle the selection here
                                        print(result);
                                      },
                                      color: customs.secondaryColor,
                                      itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'Delete',
                                          height: 15,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.restore_from_trash_sharp, size: 15, color: customs.whiteColor,),
                                                  Text('Delete', style: customs.whiteTextStyle(size: 12),),
                                                ],
                                              ),
                                              Divider()
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Option 2',
                                          height: 15,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.remove_red_eye_outlined, size: 15, color: customs.whiteColor,),
                                                  Text('View', style: customs.whiteTextStyle(size: 12),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: customs.primaryColor,
                                      size: 5,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ) : Column(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notifications",
                      style: customs.darkTextStyle(
                          size: 20, fontweight: FontWeight.bold),
                    ),
                    Text(
                      "Mark all as reads",
                      style: customs.primaryTextStyle(
                          size: 12, fontweight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                child: Text("No notifications present!", style: customs.secondaryTextStyle(size: 14, fontweight: FontWeight.normal),),
              )
            ],
          ),
        );
      },
    ));
  }
}

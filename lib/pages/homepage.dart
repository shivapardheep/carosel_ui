import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carosel_ui/pages/styles/colors.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentindex = 0;
  String buttontext = "submit";
  bool notificationenable = false;
  String primaryColor = "0xff34ebe8";
  var jsonChecking;
  List imageslist = [
    ["assets/first.jpeg", "Hugo Boss Oxygen", "100 \$"],
    ["assets/second.jpeg", "Hugo Boss Signature", "80 \$"],
    ["assets/third.jpeg", "Casio G-Shock Premium", "120 \$"],
  ];

  next() {
    setState(() {
      if (currentindex < imageslist.length - 1) {
        currentindex++;
      } else {
        currentindex = currentindex;
      }
    });
  }

  prev() {
    setState(() {
      if (currentindex > 0) {
        currentindex--;
      } else {
        currentindex = 0;
      }
    });
  }

  _caroselfun(isactive) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 5,
      width: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isactive ? Colors.black54 : Colors.white,
      ),
    );
  }

  final remoteConfig = FirebaseRemoteConfig.instance;
  alertFunction() {
    AlertDialog alert = AlertDialog(
      title: Text(remoteConfig.getString("HnotifyTitle")),
      content: Text(remoteConfig.getString("HnotifyContent")),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text("ok"),
        ),
      ],
    );
    return alert;
  }

  _remoteConfigData() async {
    await remoteConfig.fetchAndActivate();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 0),
      minimumFetchInterval: const Duration(seconds: 5),
    ));
    setState(() {
      buttontext = remoteConfig.getString("ButtonText");
      notificationenable = remoteConfig.getBool("HomeNotificationEnable");
      primaryColor = remoteConfig.getString("primaryColor");
      jsonChecking = remoteConfig.getString("jsonChecking");
      print("+++++++++++++${jsonDecode(jsonChecking)['employees']}");
    });
    if (notificationenable == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertFunction();
        },
      );
    }
  }

  // Future<>

  @override
  void initState() {
    _remoteConfigData();
    showAlert(context, remoteConfig);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: _height,
        width: _width,
        child: Stack(
          children: [
            Container(
              height: _height * 0.7,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imageslist[currentindex][0]),
                      fit: BoxFit.cover)),
              child: GestureDetector(
                onHorizontalDragEnd: (DragEndDetails details) {
                  if (details.velocity.pixelsPerSecond.dx > 0) {
                    prev();
                  } else if (details.velocity.pixelsPerSecond.dx < 0) {
                    next();
                  }
                },
                child: Container(
                  height: _height * 0.7,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey.withOpacity(.1),
                        Colors.grey.withOpacity(.3),
                        Colors.grey[500]!.withOpacity(.9),
                      ],
                    ),
                  ),
                  child: Transform.translate(
                    offset: Offset(0, _height * 0.22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < imageslist.length; i++) ...{
                          if (currentindex == i) ...{
                            _caroselfun(true),
                          } else ...{
                            _caroselfun(false),
                          }
                        }
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: bottumContainer(_height, _width),
            ),
          ],
        ),
      ),
    );
  }

  Container bottumContainer(double _height, double _width) {
    return Container(
      height: _height * 0.40,
      width: _width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                imageslist[currentindex][1],
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87.withOpacity(0.7)),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    imageslist[currentindex][2],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(int.parse(primaryColor))),
                  ),
                  SizedBox(width: 10),
                  RatingBar.builder(
                    initialRating: 4.5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 25,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Color(int.parse(primaryColor)),
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  SizedBox(width: 10),
                  const Text(
                    "(4.2/70 reviews)",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(int.parse(primaryColor))),
                // color: AppColor.primarycolor,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _width * 0.25, vertical: 15),
                  child: Text(
                    buttontext,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

AlertDialog showAlert(BuildContext context, FirebaseRemoteConfig remoteConfig) {
  Widget cancel = TextButton(onPressed: () {}, child: Text("Cancel"));
  Widget Update = TextButton(onPressed: () {}, child: Text("Update"));
  return AlertDialog(
    title: Text(remoteConfig.getString("HnotifyTitle")),
    content: Text(remoteConfig.getString("HnotifyContent")),
    actions: [cancel, Update],
  );
}

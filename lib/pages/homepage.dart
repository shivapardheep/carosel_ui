import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ui_designs/pages/styles/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentindex = 0;
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
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColor.primarycolor),
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
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: AppColor.primarycolor,
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
              RaisedButton(
                onPressed: () {},
                color: AppColor.primarycolor,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _width * 0.25, vertical: 15),
                  child: const Text(
                    'ADD TO CARD',
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

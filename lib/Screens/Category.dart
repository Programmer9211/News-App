import 'dart:math';

import 'package:flutter/material.dart';
import 'package:news_app/Screens/HomePage.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with SingleTickerProviderStateMixin {
  final List<Color> getColors = [
    Color.fromRGBO(255, 125, 93, 1),
    Color.fromRGBO(255, 171, 55, 1),
    Color.fromRGBO(248, 122, 90, 1),
    Color.fromRGBO(8, 192, 220, 1),
  ];

  Animation<double> animation;
  AnimationController controller;

  Random _rand = Random();
  Color color;

  @override
  void initState() {
    super.initState();
    color = getColors[_rand.nextInt(getColors.length)];
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: color,
      body: Column(
        children: [
          SizedBox(
            height: size.height / 30,
          ),
          Container(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(
                  width: size.width / 4.6,
                ),
                Text(
                  "News App",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: animation.value,
            child: Tile(
              title: "Business",
              url:
                  "https://pas-wordpress-media.s3.amazonaws.com/content/uploads/2020/01/16152228/bigstock-Flat-Design-Concept-Of-Consult-311989798-min.jpg",
              color: color,
              function: () => Navigator.of(context).pushAndRemoveUntil(
                  Routes(
                      page: HomePage(
                    url:
                        "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=8ec588cc35214f56a291d99025b7eeff",
                  )),
                  (Route<dynamic> route) => false),
            ),
          ),
          Transform.scale(
            scale: animation.value,
            child: Tile(
              color: color,
              function: () => Navigator.of(context).pushAndRemoveUntil(
                  Routes(
                      page: HomePage(
                    url:
                        "http://newsapi.org/v2/everything?q=apple&from=2021-01-29&to=2021-01-29&sortBy=popularity&apiKey=8ec588cc35214f56a291d99025b7eeff",
                  )),
                  (Route<dynamic> route) => false),
              title: "Popularity",
              url:
                  "https://www.investopedia.com/thmb/MT20HhmgTlw5GUqDuRKTamY-KZg=/2121x0/filters:no_upscale():max_bytes(150000):strip_icc()/low-angle-view-of-modern-financial-skyscrapers-in-central-business-district--hong-kong-at-sunrise-955431124-1719951714ea42f29987d37c2edeeabb.jpg",
            ),
          ),
          Transform.scale(
            scale: animation.value,
            child: Tile(
              color: color,
              function: () => Navigator.of(context).pushAndRemoveUntil(
                  Routes(
                      page: HomePage(
                    url:
                        "http://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=8ec588cc35214f56a291d99025b7eeff",
                  )),
                  (Route<dynamic> route) => false),
              title: "Tech Crunch",
              url:
                  "https://pas-wordpress-media.s3.amazonaws.com/content/uploads/2016/02/21091755/free-small-business-ideas.jpg",
            ),
          ),
          Transform.scale(
            scale: animation.value,
            child: Tile(
              color: color,
              function: () => Navigator.of(context).pushAndRemoveUntil(
                  Routes(
                      page: HomePage(
                    url:
                        "http://newsapi.org/v2/everything?domains=wsj.com&apiKey=8ec588cc35214f56a291d99025b7eeff",
                  )),
                  (Route<dynamic> route) => false),
              title: "Random",
              url:
                  "https://storage.googleapis.com/afs-prod/media/afs:Medium:2132040614/415.jpeg",
            ),
          )
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final String title, url;
  final Color color;
  final Function function;

  Tile({this.title, this.color, this.url, this.function});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: GestureDetector(
        onTap: function,
        child: Container(
          height: size.height / 6.5,
          width: size.width / 1.2,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(url)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.w500, color: color),
          ),
        ),
      ),
    );
  }
}

class Routes extends PageRouteBuilder {
  final Widget page;

  Routes({this.page})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                page,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animation, curve: Curves.fastOutSlowIn)),
                  child: child,
                ));
}

import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/Screens/ReadArticle.dart';
import 'package:news_app/Services/Network.dart';

import 'Drawer.dart';

class HomePage extends StatefulWidget {
  final String url;
  HomePage({this.url});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Network network = Network();

  List newsList = List();

  bool isLoading;
  Timer _timer;

  final List<Color> getColors = [
    Color.fromRGBO(255, 125, 93, 1),
    Color.fromRGBO(255, 171, 55, 1),
    Color.fromRGBO(248, 122, 90, 1),
    Color.fromRGBO(8, 192, 220, 1),
  ];

  Color _backgroundColor;

  Random _rand = Random();

  void changeColor() {
    _timer = Timer.periodic(Duration(seconds: 20), (s) {
      setState(() {
        _backgroundColor = getColors[_rand.nextInt(getColors.length)];
      });
    });
    
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _backgroundColor = getColors[_rand.nextInt(getColors.length)];
    isLoading = true;
    network.getNewsFeed(widget.url).then((list) {
      print(list.length);
      setState(() {
        newsList = list;
        isLoading = false;
      });
    });
    changeColor();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    network.getNewsFeed(widget.url).then((list) {
      print(list.length);
      setState(() {
        newsList = list;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            SearchField(),
            isLoading == true
                ? Container(
                    height: MediaQuery.of(context).size.height / 1.58,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            "Loading please wait...",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        )
                      ],
                    ))
                : NewsCard(newsList, _backgroundColor)
          ],
        ),
      ),
      floatingActionButton: isLoading != true
          ? FloatingActionButton(
              tooltip: "Refresh",
              onPressed: () => getData(),
              child: Icon(
                Icons.refresh,
                size: 32,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            )
          : Container(),
    );
  }
}

class Header extends StatelessWidget {
  void onPressed(BuildContext context) {
    Navigator.of(context).push(DrawerRoute(page: CustomDrawer()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        height: size.height / 4,
        width: size.width,
        child: Column(
          children: [
            SizedBox(
              height: size.height / 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  height: size.height / 15,
                  width: size.width / 1.5,
                  child: Text(
                    "News Feed",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                Container(
                  height: size.height / 15,
                  width: size.width / 5,
                  child: IconButton(
                    onPressed: () => onPressed(context),
                    icon: Icon(
                      Icons.alt_route_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Container(
              height: size.height / 7,
              width: size.width / 1.1,
              alignment: Alignment.bottomLeft,
              child: Text(
                "Discover Popular\nNews Daily",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            )
          ],
        ));
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: size.height / 11,
        width: size.width / 1.1,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: size.height / 15,
                width: size.width / 1.45,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 2.1,
                          )),
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search..."),
                )),
            Container(
              height: size.height / 15,
              width: size.height / 11,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(400)),
                color: Colors.white,
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {},
                label: Text(""),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewsCard extends StatefulWidget {
  final List list;
  final Color color;

  NewsCard(this.list, this.color);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  void onTap(data) {
    Navigator.of(context).push(NavigateArticle(page: ReadArticle(data)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 1.58,
      width: size.width,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.list.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
            child: Transform.scale(
              scale: animation.value,
              child: GestureDetector(
                onTap: () => onTap(widget.list[index]),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      color: widget.color,
                      border: Border.all(width: 5.0, color: Colors.white)),
                  child: Column(
                    children: [
                      Container(
                        height: size.height / 2.5,
                        width: size.width / 1.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: widget.list[index]['urlToImage'] != null
                            ? CachedNetworkImage(
                                imageUrl: widget.list[index]['urlToImage'],
                                placeholder: (context, st) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      // Text("Loading...")
                                    ],
                                  );
                                },
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                      Container(
                        color: Colors.white,
                        height: size.height / 100,
                        width: size.width / 1.1,
                      ),
                      Container(
                        width: size.width / 1.15,
                        child: Text(
                          widget.list[index]['title'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 40,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class DrawerRoute extends PageRouteBuilder {
  final Widget page;

  DrawerRoute({this.page})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                page,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                SlideTransition(
                  transformHitTests: false,
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: new SlideTransition(
                    position: new Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1.0, 0.0),
                    ).animate(secondaryAnimation),
                    child: child,
                  ),
                ));
}

class NavigateArticle extends PageRouteBuilder {
  final Widget page;

  NavigateArticle({this.page})
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

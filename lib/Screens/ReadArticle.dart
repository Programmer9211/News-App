import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ReadArticle extends StatefulWidget {
  final data;
  ReadArticle(this.data);

  @override
  _ReadArticleState createState() => _ReadArticleState();
}

class _ReadArticleState extends State<ReadArticle>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animcontroller;

  final List<Color> getColors = [
    Color.fromRGBO(255, 125, 93, 1),
    Color.fromRGBO(255, 171, 55, 1),
    Color.fromRGBO(248, 122, 90, 1),
    Color.fromRGBO(8, 192, 220, 1),
  ];

  Color _backgroundColor;

  Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _backgroundColor = getColors[_rand.nextInt(getColors.length)];
    animcontroller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animcontroller)
      ..addListener(() {
        setState(() {});
      });

    animcontroller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                width: size.width / 1.05,
                child: Transform.scale(
                  scale: animation.value,
                  child: Text(
                    widget.data['title'] == null ? "" : widget.data['title'],
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 35,
            ),
            Container(
                height: size.height / 2,
                width: size.width,
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: animation.value,
                  child: Container(
                    width: size.width / 1.05,
                    child: widget.data['urlToImage'] != null
                        ? CachedNetworkImage(
                            imageUrl: widget.data['urlToImage'],
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
                        : Container(
                            child: Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 50,
                          )),
                  ),
                )),
            Container(
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                width: size.width / 1.05,
                child: Transform.scale(
                  scale: animation.value,
                  child: Text(
                    widget.data['content'] == null
                        ? "Error in Loading Content"
                        : widget.data['content'],
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animcontroller.dispose();
    super.dispose();
  }
}

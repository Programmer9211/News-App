import 'package:flutter/material.dart';

import 'Category.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
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
                width: size.width / 1.4,
                child: Text(
                  "News Feed",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.yellow),
                ),
              ),
              Container(
                height: size.height / 15,
                width: size.width / 5,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height / 30,
          ),
          Tile(
            title: "Home",
            function: () => Navigator.pop(context),
          ),
          Tile(
            title: "Category",
            function: () =>
                Navigator.of(context).push(Routes(page: Category())),
          ),
          SizedBox(
            height: size.height / 5,
          ),
          Container(
            height: size.height / 2.5,
            width: size.width,
            child: Column(
              children: [
                Container(
                  height: size.height / 8,
                  width: size.width,
                  child: Image.asset("assets/head.png"),
                ),
                Container(
                  height: size.height / 8,
                  width: size.width,
                  child: Image.asset("assets/torse.png"),
                ),
                Container(
                  height: size.height / 8,
                  width: size.width,
                  child: Image.asset("assets/legs.png"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Tile extends StatefulWidget {
  final String title;
  final Function function;

  Tile({this.title, this.function});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    final CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutQuad);

    animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {}
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
          onTap: widget.function,
          title: Transform.scale(
            scale: animation.value,
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.yellow[400],
                fontSize: 30,
              ),
            ),
          )),
    );
  }
}

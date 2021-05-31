
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/pages/FirstPage/workPage.dart';
import 'package:homework/tools/SizeFit.dart';

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FirstPageState();
  }
}

class _FirstPageState extends State<FirstPage> {
  List<Tab> topBars = [
    new Tab(text: "文学"),
    new Tab(text: "影视"),
    new Tab(text: "绘画"),
    new Tab(text: "音乐"),
  ];

  @override
  Widget build(BuildContext context) {
    SizeFit.initialize(context);
    return DefaultTabController(
      length: topBars.length,
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: CommonColors.getThemeColor(),
          centerTitle: true,
          title: Text('首页'),
          bottom: new TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: topBars,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: SizeFit.setRpx(40)),
          ),
        ),
        body: new TabBarView(
            children: [
              WorkList(0),
              WorkList(1),
              WorkList(2),
              WorkList(3),
            ]
        ),
      ),
    );
  }

}
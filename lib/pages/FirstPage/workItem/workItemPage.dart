
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/pages/FirstPage/workComment/commitCreatePage.dart';
import 'package:homework/pages/FirstPage/workComment/workComments.dart';
import 'package:homework/pages/FirstPage/workItem/workScore.dart';
import 'package:homework/pages/FirstPage/workItem/workSingal.dart';
import 'package:homework/tools/SizeFit.dart';

class WorkItemPage extends StatefulWidget {
  dynamic data;
  WorkItemPage(this.data);
  @override
  _WorkItemPage createState() => _WorkItemPage();
}

class _WorkItemPage extends State<WorkItemPage> {
  dynamic data;
  int type;
  List<Tab> topBars = [
    new Tab(text: "评分"),
    new Tab(text: "评论"),
  ];
  @override
  void initState() {
    super.initState();
    this.data = widget.data;
    this.type = data['type'];
  }

  Widget build(BuildContext context) {
    SizeFit.initialize(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading:  new IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
            //_nextPage(-1);
          },
        ),
        title: Text('详情', style: TextStyle(color: Colors.white),),
        backgroundColor: CommonColors.getThemeColor(),
        actions: [
          IconButton(
            icon: Icon(Icons.add_comment_outlined),
            tooltip: '发表评论',
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => CommitCreatePage(data['workId']),
                ),
              );
            },
          ),],
      ),
      body: Column(
        children: [
          WorkSingal(data),
          Expanded(
            child: DefaultTabController(
                length: topBars.length,
                child: Scaffold(
                  appBar: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: topBars,
                    labelColor: CommonColors.getTextBasicColor(),
                    labelStyle: TextStyle(fontSize: SizeFit.setRpx(50)),
                  ),
                  body: new TabBarView(
                      children: [
                        new WorkScore(data),
                        new CommentList(data['workId'])
                      ]
                  ),
                )
            ),
          )
        ],
      ),
    );
  }

}


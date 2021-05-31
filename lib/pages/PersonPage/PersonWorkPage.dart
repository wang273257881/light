
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/pages/FirstPage/workPage.dart';
import 'package:homework/tools/SizeFit.dart';

class PersonWorkPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PersonWorkPageState();
  }
}

class _PersonWorkPageState extends State<PersonWorkPage> {

  @override
  Widget build(BuildContext context) {
    SizeFit.initialize(context);
    return Scaffold(
      appBar:AppBar(
        backgroundColor: CommonColors.getThemeColor(),
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            }
        ),
        centerTitle: true,
        title: Text('我发起的评分'),
      ),
      body: WorkList(-1),
    );
  }

}
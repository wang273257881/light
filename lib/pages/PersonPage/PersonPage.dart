
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/Tecent/profile/profile.dart';

class PersonPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PersonPageState();
  }
}

class _PersonPageState extends State<PersonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title:
          Text("个人中心", style: TextStyle(color: Colors.white, fontSize: 20)),
          backgroundColor: CommonColors.getThemeColor(),
        ),
        body: Profile()
    );
  }

}
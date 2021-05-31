import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/tools/SizeFit.dart';

class WorkScore extends StatelessWidget {
  Map<String, dynamic> data;
  List<double> scorePe;
  List<dynamic> scoreList;
  
  WorkScore(ls) {
    data = ls;
    scorePe = [];
    scoreList = data['scoreArray'];
    for (int  i = 0; i < 5; i += 1) {
      scorePe.add(scoreList[i] / data['totalNum']);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: SizeFit.setRpx(150), left: SizeFit.setRpx(30), right: SizeFit.setRpx(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: SizeFit.setRpx(20)),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                SizedBox(width: SizeFit.setRpx(50),),
                Text(scoreList[4].toString(), style: TextStyle(fontSize: SizeFit.setRpx(80)),),
                SizedBox(width: SizeFit.setRpx(50),),
                SizedBox(
                  height: SizeFit.setRpx(20),
                  width: SizeFit.setRpx(400),
                  child: LinearProgressIndicator(
                    value: scorePe[4],
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amberAccent)),
                  ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: SizeFit.setRpx(20)),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                SizedBox(width: SizeFit.setRpx(50),),
                Text(scoreList[3].toString(), style: TextStyle(fontSize: SizeFit.setRpx(80)),),
                SizedBox(width: SizeFit.setRpx(50),),
                SizedBox(
                  height: SizeFit.setRpx(20),
                  width: SizeFit.setRpx(400),
                  child: LinearProgressIndicator(
                      value: scorePe[3],
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amberAccent)),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: SizeFit.setRpx(20)),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                SizedBox(width: SizeFit.setRpx(50),),
                Text(scoreList[2].toString(), style: TextStyle(fontSize: SizeFit.setRpx(80)),),
                SizedBox(width: SizeFit.setRpx(50),),
                SizedBox(
                  height: SizeFit.setRpx(20),
                  width: SizeFit.setRpx(400),
                  child: LinearProgressIndicator(
                      value: scorePe[2],
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amberAccent)),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: SizeFit.setRpx(20)),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                SizedBox(width: SizeFit.setRpx(50),),
                Text(scoreList[1].toString(), style: TextStyle(fontSize: SizeFit.setRpx(80)),),
                SizedBox(width: SizeFit.setRpx(50),),
                SizedBox(
                  height: SizeFit.setRpx(20),
                  width: SizeFit.setRpx(400),
                  child: LinearProgressIndicator(
                      value: scorePe[1],
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amberAccent)),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: SizeFit.setRpx(20)),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(80),),
                SizedBox(width: SizeFit.setRpx(50),),
                Text(scoreList[0].toString(), style: TextStyle(fontSize: SizeFit.setRpx(80)),),
                SizedBox(width: SizeFit.setRpx(50),),
                SizedBox(
                  height: SizeFit.setRpx(20),
                  width: SizeFit.setRpx(400),
                  child: LinearProgressIndicator(
                      value: scorePe[0],
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amberAccent)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}
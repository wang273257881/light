
import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/pages/FirstPage/workItem/workItemPage.dart';
import 'package:homework/pages/FirstPage/workItem/workSingal.dart';
import 'package:homework/tools/GlobalInfo.dart';
import 'package:homework/tools/SizeFit.dart';
import 'package:toast/toast.dart';

class WorkList extends StatefulWidget {
  dynamic type;
  WorkList(this.type);
  @override
  _WorkList createState() => _WorkList();
}

class _WorkList extends State<WorkList>{
  int type;
  List<dynamic> myInfoData;
  bool hasWork, isInit;
  @override
  void initState() {
    super.initState();
    this.type = widget.type;
    this.isInit = false;
    this.hasWork = true;
    if (type != -1) {
      fetchData();
    } else {
      fetchDataUser();
    }
  }

  fetchData() async {
    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    await cloudbase.callFunction('getWorkList', {'type': type})
        .then((value) {
      myInfoData = value.data;
      if (myInfoData.isEmpty) {
        this.setState(() {
          hasWork = false;
        });
      }
      this.setState(() {
        isInit = true;
      });
      print(myInfoData);
    });
  }

  fetchDataUser() async {
    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    await cloudbase.callFunction('getWorkOfUser', {'userId': userInfoGlobal.u_id})
        .then((value) {
      myInfoData = value.data;
      if (myInfoData.isEmpty) {
        this.setState(() {
          hasWork = false;
        });
      }
      this.setState(() {
        isInit = true;
      });
      print(myInfoData);
    });
  }

  Widget build(BuildContext context) {
    print("List built");
    return Container(
      color: Colors.grey[200],
      child: isInit? hasWork? ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: myInfoData.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> data = myInfoData[index];
            int totalNum = 0;
            double totalScore = 0;
            List<dynamic> scoreList = data['scoreArray'];
            for (int i = 0; i < 5; i += 1) {
              totalNum += scoreList[i];
              totalScore += scoreList[i] * (i + 1);
            }
            data['totalNum'] = totalNum == 0?1:totalNum;
            data['realNum'] = totalNum;
            data['totalScore'] = totalScore;
            return WorkSingal(data);
          })
              :Center(
                child: Text('暂无作品', style: TextStyle(fontSize: SizeFit.setRpx(60)),),
              )
              :Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(CommonColors.getThemeColor())
                ),
              ),
    );
  }
}

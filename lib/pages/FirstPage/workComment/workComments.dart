import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/pages/FirstPage/workComment/commentSingal.dart';
import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:homework/tools/GlobalInfo.dart';
import 'package:homework/tools/SizeFit.dart';

class CommentList extends StatefulWidget {
  String workId;
  CommentList(this.workId);

  @override
  _CommentList createState() => _CommentList();
}

class _CommentList extends State<CommentList>{
  String workId;
  bool isLoading, hasWork;
  List<dynamic> myInfoData;

  @override
  void initState() {
    super.initState();
    this.workId = widget.workId;
    this.isLoading = true;
    this.hasWork = true;
    fetchData();
  }

  fetchData() async {
    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    await cloudbase.callFunction('getCommitList', {'workId': workId})
        .then((value) {
      myInfoData = value.data;
      if (myInfoData.isEmpty) {
        this.setState(() {
          hasWork = false;
        });
      }
      this.setState(() {
        isLoading = false;
      });
      print(myInfoData);
    });
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child:
      isLoading?
      Center(
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(CommonColors.getThemeColor())
          )
      ) :hasWork?
      ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: myInfoData.length,
          itemBuilder: (BuildContext context, int index) {
            return Comment(myInfoData[index]);
          }) :
      Center(
        child: Text('暂无评论', style: TextStyle(fontSize: SizeFit.setRpx(60)),),
      ),
    );
  }
}

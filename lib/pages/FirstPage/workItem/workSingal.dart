
import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/pages/FirstPage/workItem/workItemPage.dart';
import 'package:homework/tools/GlobalInfo.dart';
import 'package:homework/tools/SizeFit.dart';
import 'package:toast/toast.dart';

class WorkSingal extends StatefulWidget {
  Map<String, dynamic> data;
  WorkSingal(this.data);
  @override
  _WorkSingal createState() => _WorkSingal();
}

class _WorkSingal extends State<WorkSingal>{
  Map<String, dynamic> data;
  int type;
  @override
  void initState() {
    super.initState();
    this.data = widget.data;
    this.type = data['type'];
  }

  deleteWork() async {
    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    await cloudbase.callFunction('deleteWork', {
      'workId': data['workId'],
      'type': type,
    })
        .then((value) {
      print(value);
      Toast.show('删除成功！', context);
    });
    CloudBaseStorage storage = CloudBaseStorage(core);
    CloudBaseStorageRes<List<DownloadMetadata>> res;
    res = await storage.deleteFiles(
        [cloudBaseInfoGlobal.fileStorge + '/work/' + data['workId'] + '.jpg']
    );
  }

  void showAlertDialog(value) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('提示信息'),
            //可滑动
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(value),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteWork();
                },
              ),
              new FlatButton(
                child: new Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    SizeFit.initialize(context);
    return GestureDetector(
      child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              Image.network(
                data['workCover'],
                width: SizeFit.setRpx(300),
                height: SizeFit.setRpx(400),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.center,
                // color: Colors.amberAccent,
                // height: SizeFit.setRpx(300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: SizeFit.setRpx(40)),
                      child: Row(
                        children: [
                          Icon(
                            type == 0?
                            Icons.book:
                            type == 1?
                            Icons.video_collection:
                            type == 2?
                            Icons.format_paint_outlined:
                            Icons.music_note_outlined,
                            size: SizeFit.setRpx(70),
                          ),
                          SizedBox(width: SizeFit.setRpx(10),),
                          Container(
                            child: Text(data['workName'].length > 7?data['workName'].substring(0, 7)+ '···':data['workName'], maxLines: null, style: TextStyle(fontSize: SizeFit.setRpx(70), fontWeight: FontWeight.bold),),
                            constraints: BoxConstraints(
                              maxHeight: SizeFit.setRpx(200),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: SizeFit.setRpx(20), bottom: SizeFit.setRpx(20), left: SizeFit.setRpx(10)),
                      child: Row(
                        children: [
                          Icon(Icons.star_border, size: SizeFit.setRpx(50),),
                          SizedBox(width: SizeFit.setRpx(20),),
                          Text('评分：' + (data['totalScore'] / data['totalNum']).toStringAsFixed(1), style: TextStyle(fontSize: SizeFit.setRpx(50), fontWeight: FontWeight.normal),),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: SizeFit.setRpx(40), left: SizeFit.setRpx(10)),
                      child: Row(
                        children: [
                          Icon(Icons.mode_comment_outlined, size: SizeFit.setRpx(50),),
                          SizedBox(width: SizeFit.setRpx(20),),
                          Text('评论人数：' + data['realNum'].toString(), style: TextStyle(fontSize: SizeFit.setRpx(50), fontWeight: FontWeight.normal),)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
      ),
      onTap: () => Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => WorkItemPage(data),
        ),
      ),
      onLongPress: () {
        if (data['createrId'] == userInfoGlobal.u_id) {
          showAlertDialog('确认删除作品评分？');
        }
      },
    );
  }
}

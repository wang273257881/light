import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/tools/GlobalInfo.dart';
import 'package:homework/tools/SizeFit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class WorkCreatePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => WorkCreatePageState();
}

class WorkCreatePageState extends State<WorkCreatePage> {
  String workName, workCover, newWorkId;
  int type;
  bool isLoading;

  void initState() {
    super.initState();
    this.workName = '';
    this.workCover = '';
    this.type = 0;
    this.isLoading = true;
    this.newWorkId = '';
    fetchData();
  }

  fetchData() async {
    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    await cloudbase.callFunction('getWorkCount')
        .then((value) {
          String count = (value.data + 1).toString();
          for (int i = 0; i < 6 - count.length; i += 1) {
            newWorkId += '0';
          }
          newWorkId += count;
      this.setState(() {
        isLoading = false;
      });
    });
  }

  Container BuildConfirmButton() {
    return Container(
      child:
      MaterialButton(
        color: CommonColors.getThemeColor(),
        textColor: Colors.white,
        child: new Text('提交', style: TextStyle(fontSize: SizeFit.setRpx(60)),),
        onPressed: () async {
          if (workName == '') {
            Toast.show('请填写作品名称！', context);
          } else if (workCover == '') {
            Toast.show('请上传作品封面！', context);
          } else {
            this.setState(() {
              isLoading = true;
            });
            CloudBaseFunction cloudbase = CloudBaseFunction(core);
            await cloudbase.callFunction('addWork', {
              'userId': userInfoGlobal.u_id,
              'workId': newWorkId,
              'workName': workName,
              'workCover': workCover,
              'type': type
            })
                .then((value) {
              this.setState(() {
                isLoading = false;
              });
              if (value.code == null) {
                Toast.show('提交成功！', context);
                Navigator.of(context).pop();
              }
            });

          }
        },
      ),
      width: SizeFit.setRpx(900),
      height: SizeFit.setRpx(120),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:AppBar(
        backgroundColor: CommonColors.getThemeColor(),
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            }
        ),
        centerTitle: true,
        title: Text('发起评分'),
      ),
      body: isLoading?
      Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(CommonColors.getThemeColor())
        )
      ):
      Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: SizeFit.setRpx(70), top: SizeFit.setRpx(50), right: SizeFit.setRpx(50)),
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "作品名称",
                  hintText: "请尽量不要超过7个字",
                  icon: Icon(
                    type == 0?
                    Icons.book:
                    type == 1?
                    Icons.video_collection:
                    type == 2?
                    Icons.format_paint_outlined:
                    type == 3?
                    Icons.music_note_outlined:
                    Icons.adjust,),
                ),
                // keyboardType: TextInputType.,
                onChanged: (v) {
                  setState(() {
                    workName = v;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: SizeFit.setRpx(50), left: SizeFit.setRpx(70)),
              child: Row(
                children: [
                  Text('作品类型：', style: TextStyle(fontSize: SizeFit.setRpx(50)),),
                  SizedBox(width: SizeFit.setRpx(50),),
                  DropdownButton(
                    items: [
                      DropdownMenuItem(child: Text('文学', style: TextStyle(fontSize: SizeFit.setRpx(50)),), value: 0,),
                      DropdownMenuItem(child: Text('影视', style: TextStyle(fontSize: SizeFit.setRpx(50)),), value: 1,),
                      DropdownMenuItem(child: Text('绘画', style: TextStyle(fontSize: SizeFit.setRpx(50)),), value: 2,),
                      DropdownMenuItem(child: Text('音乐', style: TextStyle(fontSize: SizeFit.setRpx(50)),), value: 3,)
                    ],
                    onChanged: (value) {
                      this.setState(() {
                        type = value;
                      });
                    },
                    value: type,
                  ),
                ],
              )

            ),
            Container(
                margin: EdgeInsets.only(top: SizeFit.setRpx(50), left: SizeFit.setRpx(70)),
                child: Row(
                  children: [
                    Text('作品封面：', style: TextStyle(fontSize: SizeFit.setRpx(50)),),
                    SizedBox(width: SizeFit.setRpx(50),),
                    TextButton(
                      child: Text('点击上传', style: TextStyle(fontSize: SizeFit.setRpx(50), color: CommonColors.getThemeColor()),),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.getImage(
                            source: ImageSource.gallery);
                        if (image == null) {
                          return;
                        }
                        String path = image.path;
                        CloudBaseStorage storage = CloudBaseStorage(core);
                        CloudBaseStorageRes<List<DeleteMetadata>> resDel;
                        resDel = await storage.deleteFiles(
                            [cloudBaseInfoGlobal.fileStorge + '/work/' + newWorkId + '.jpg']
                        );
                        Toast.show('准备上传图片···', context);
                        await storage.uploadFile(
                            cloudPath: 'work/' + newWorkId + '.jpg',
                            filePath: path,
                            onProcess: (int count, int total) {
                              if (count % 50 == 0) {
                                Toast.show('$count / $total', context);
                              }
                              if (count == total) {
                                Toast.show('上传成功！', context);
                              }
                            }
                        );
                        CloudBaseStorageRes<List<DownloadMetadata>> res;
                        res = await storage.getFileDownloadURL(
                            [cloudBaseInfoGlobal.fileStorge + '/work/' + newWorkId + '.jpg']
                        );
                        this.setState(() {
                          workCover = res.data[0].downloadUrl;
                        });
                      },
                    )
                  ],
                )

            ),
            Container(
                margin: EdgeInsets.only(top: SizeFit.setRpx(50), left: SizeFit.setRpx(70), bottom: SizeFit.setRpx(50)),
                child: Row(
                  children: [
                    SizedBox(width: SizeFit.setRpx(275),),
                    workCover == ''?
                    SizedBox():
                    Image.network(
                      workCover,
                      width: SizeFit.setRpx(450),
                      height: SizeFit.setRpx(600),
                    )
                  ],
                )

            ),
            BuildConfirmButton()
          ],
        ),
      )
    );
  }

}

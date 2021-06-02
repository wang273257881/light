import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/arrowRight.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/pages/FirstPage/workCreatePage.dart';
import 'package:homework/pages/PersonPage/PersonWorkPage.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:homework/Tecent/profile/component/listGap.dart';
import 'package:homework/Tecent/profile/component/profilePanel.dart';
import 'package:homework/Tecent/provider/user.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import '../userProfile.dart';
import 'component/textWithCommonStyle.dart';
import 'component/userSign.dart';
import 'package:homework/tools/GlobalInfo.dart';

class Profile extends StatefulWidget {
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  int type = 0; // 0 1 2,0=>自己打开个人中心，1=>单聊资料卡，2=>群聊资料卡

  Widget build(BuildContext context) {
    V2TimUserFullInfo info = Provider.of<UserModel>(context).info;
    print("个人信息${info.toJson()}");
    if (info == null) {
      return Container();
    }

    return Column(
      children: [
        ProfilePanel(info, true),
        ListGap(),
        UserName(info),
        ListGap(),
        FaceUpload(info),
        ListGap(),
        UserSign(info),
        ListGap(),
        UserSearch(),
        ListGap(),
        WorkAdd(),
        ListGap(),
        MyWork(),
        ListGap(),
        // if (type == 0) NewMessageSetting(info),
        // if (type == 0) Logout(),
      ],
    );
  }
}

class UserName extends StatelessWidget {
  UserName(this.userInfo);
  final V2TimUserFullInfo userInfo;

  getSelfNickName() {
    if (userInfo.nickName == '' || userInfo.nickName == null) {
      return userInfo.userID;
    } else {
      return userInfo.nickName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: CommonColors.getWitheColor(),
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Alert(0);
              });
          },
          child: Container(
            height: 55,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                TextWithCommonStyle(
                  text: '用户昵称',
                ),
                Expanded(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ArrowRight(),
                      Expanded(
                        child: Text(
                          getSelfNickName(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            color: CommonColors.getTextWeakColor(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Alert extends StatefulWidget {
  dynamic type;
  Alert(this.type);
  @override
  State<StatefulWidget> createState() => AlertDialogState();
}

class AlertDialogState extends State<Alert> {
  String name;
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(widget.type == 0?'修改昵称':'查询用户'),
      content: TextField(
        controller: controller,
        onChanged: (s) {
          setState(() {
            name = s;
          });
        },
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text('确定'),
          onPressed: () {
            if (widget.type == 0) {
              TencentImSDKPlugin.v2TIMManager
                  .setSelfInfo(nickName: name)
                  .then((value) {
                if (value.code == 0) {
                  Navigator.of(context).pop();
                  Toast.show('修改成功', context);
                }
              });
            } else {
              TencentImSDKPlugin.v2TIMManager
                  .getFriendshipManager()
                  .addFriend(
                userID: name,
                addType: 1,
              ).then((value) {
                Navigator.of(context).pop();
                if (value.code != 0) {
                  Toast.show('该Id的用户不存在！', context);
                } else {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => UserProfile(name),
                    ),
                  );
                }
              }
                );
            }
          },
        )
      ],
    );
  }

  addFriend() async{
    V2TimValueCallback<V2TimFriendOperationResult> data =
        await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .addFriend(
      userID: name,
      addType: 1,
    );
    if (data.code != 0) {
      Toast.show('${data.code}-${data.desc}', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
}

class UserSearch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: CommonColors.getWitheColor(),
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Alert(1);
                });
          },
          child: Container(
            height: 55,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                TextWithCommonStyle(
                  text: '用户查询',
                ),
                Expanded(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ArrowRight(),
                      Expanded(child: SizedBox())
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FaceUpload extends StatefulWidget {
  FaceUpload(this.userInfo);
  final V2TimUserFullInfo userInfo;

  @override
  State<StatefulWidget> createState() => FaceUploadState();
}

class FaceUploadState extends State<FaceUpload> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: CommonColors.getWitheColor(),
        child: InkWell(
          onTap: () async{
            final picker = ImagePicker();
            final image = await picker.getImage(
                source: ImageSource.gallery);
            if (image == null) {
              return;
            }
            String path = image.path;
            CloudBaseStorage storage = CloudBaseStorage(core);
            await storage.uploadFile(
                cloudPath: 'user/face/' + userInfoGlobal.u_id + '.jpg',
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
            CloudBaseStorageRes<List<DownloadMetadata>> res = await storage.getFileDownloadURL(
                [cloudBaseInfoGlobal.fileStorge + '/user/face/' + userInfoGlobal.u_id + '.jpg']
            );
            await TencentImSDKPlugin.v2TIMManager.setSelfInfo(
                faceUrl: res.data[0].downloadUrl
            )
                .then((value) {
              Toast.show('头像设置成功！', context);
            });
          },
          child: Container(
            height: 55,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                TextWithCommonStyle(
                  text: '头像上传',
                ),
                Expanded(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ArrowRight(),
                      Expanded(child: SizedBox())
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class WorkAdd extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: CommonColors.getWitheColor(),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => WorkCreatePage(),
              ),
            );
          },
          child: Container(
            height: 55,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                TextWithCommonStyle(
                  text: '发起评分',
                ),
                Expanded(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ArrowRight(),
                      Expanded(
                        child: SizedBox(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyWork extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        color: CommonColors.getWitheColor(),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => PersonWorkPage(),
              ),
            );
          },
          child: Container(
            height: 55,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                TextWithCommonStyle(
                  text: '我的发起',
                ),
                Expanded(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ArrowRight(),
                      Expanded(
                        child: SizedBox(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

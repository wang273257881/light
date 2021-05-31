import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info_result.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:homework/Tecent/common/colors.dart';

class UserNick extends StatefulWidget {
  UserNick(this.userInfo, this.getUserInfo);
  final V2TimFriendInfoResult userInfo;
  final Function getUserInfo;
  @override
  State<StatefulWidget> createState() => UserNickState();
}

class UserNickState extends State<UserNick> {
  V2TimFriendInfoResult userInfo;
  void initState() {
    this.userInfo = widget.userInfo;
    super.initState();
  }

  String nick = '';
  @override
  Widget build(Object context) {
    if (userInfo == null) {
      return Container();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('设置备注'),
          backgroundColor: CommonColors.getThemeColor(),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) {
                    setState(() {
                      nick = v;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        color: CommonColors.getThemeColor(),
                        onPressed: () async {
                          V2TimCallback res = await TencentImSDKPlugin
                              .v2TIMManager
                              .getFriendshipManager()
                              .setFriendInfo(
                                userID: userInfo.friendInfo.userID,
                                friendRemark: nick,
                              );
                          await widget.getUserInfo();
                          if (res.code == 0) {
                            Navigator.pop(context);
                          } else {
                            print(res);
                          }
                        },
                        textColor: CommonColors.getWitheColor(),
                        child: Text("确定"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

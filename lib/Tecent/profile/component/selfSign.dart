import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:toast/toast.dart';

import '../../userProfile.dart';

class SelfSign extends StatefulWidget {
  int type;
  SelfSign(this.type);
  @override
  State<StatefulWidget> createState() => SelfSignState();
}

class SelfSignState extends State<SelfSign> {
  String sign = '';
  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 0?'设置签名':widget.type == 1?'修改昵称':'查询用户'),
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
                    sign = v;
                  });
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      color: CommonColors.getThemeColor(),
                      onPressed: () async {
                        if (widget.type == 0) {
                          V2TimCallback res =
                          await TencentImSDKPlugin.v2TIMManager.setSelfInfo(
                            selfSignature: sign,
                          );
                          if (res.code == 0) {
                            print("succcess");
                            Navigator.pop(context);
                          } else {
                            print(res);
                          }
                        } else if (widget.type == 1) {
                        TencentImSDKPlugin.v2TIMManager
                            .setSelfInfo(nickName: sign)
                        .then((value) {
                        if (value.code == 0) {
                        Navigator.pop(context);
                        Toast.show('修改成功', context);
                        }
                        });
                        } else {
                          TencentImSDKPlugin.v2TIMManager
                              .getFriendshipManager()
                              .addFriend(
                            userID: sign,
                            addType: 1,
                          ).then((value) {
                            if (value.code != 0) {
                        Navigator.pop(context);
                              Toast.show('该Id的用户不存在！', context);
                            } else {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => UserProfile(sign),
                                ),
                              );
                            }
                          }
                          );
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
      ),
    );
  }
}

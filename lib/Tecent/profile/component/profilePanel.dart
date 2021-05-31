import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:homework/Tecent/common/avatar.dart';
import 'package:homework/Tecent/common/colors.dart';

//自己查看自己的资料
class ProfilePanel extends StatelessWidget {
  ProfilePanel(this.userInfo, this.isSelf);
  final V2TimUserFullInfo userInfo;
  final bool isSelf;
  getSelfSignature() {
    if (userInfo.selfSignature == '' || userInfo.selfSignature == null) {
      return "";
    } else {
      return userInfo.selfSignature;
    }
  }

  hasNickName() {
    return !(userInfo.nickName == '' || userInfo.nickName == null);
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) {
      return Container(
        height: 112,
      );
    }
    return Material(
      child: Container(
        height: 112,
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              child: Avatar(
                avtarUrl: userInfo.faceUrl == null || userInfo.faceUrl == ''
                    ? 'images/default.jpg'
                    : userInfo.faceUrl,
                width: 80,
                height: 80,
                radius: 9.6,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 昵称
                    Container(
                      height: 33,
                      child: Text(
                        (userInfo.nickName == null ||
                            userInfo.nickName == '')
                            ? userInfo.userID
                            : userInfo.nickName,
                        style: TextStyle(
                          fontSize: 24,
                          color: CommonColors.getTextBasicColor(),
                        ),
                      ),
                    ),
                    Container(
                      height: 23,
                      child: Text(
                        '用户ID：${userInfo.userID}',
                        style: TextStyle(
                          fontSize: 14,
                          color: CommonColors.getTextWeakColor(),
                        ),
                      ),
                    ),
                    Container(
                      height: 23,
                      child: Text(
                        '个性签名：${getSelfSignature()}',
                        style: TextStyle(
                          fontSize: 14,
                          color: CommonColors.getTextWeakColor(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Icon(Icons.person, size: 30,)
          ],
        ),
      ),
    );
  }
}

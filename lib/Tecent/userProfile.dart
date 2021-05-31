import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/Tecent/common/hexToColor.dart';
import 'package:homework/Tecent/conversion/conversion.dart';
import 'package:homework/Tecent/profile/component/addToBlackList.dart';
import 'package:homework/Tecent/profile/component/friendProfilePanel.dart';
import 'package:homework/Tecent/profile/component/listGap.dart';
import 'package:homework/Tecent/profile/component/userRemak.dart';
import 'package:homework/Tecent/provider/friend.dart';
import 'package:toast/toast.dart';


class UserProfile extends StatefulWidget {
  UserProfile(this.userID);
  final String userID;
  @override
  State<StatefulWidget> createState() => UserProfileState();
}

class SendMessage extends StatelessWidget {
  SendMessage(this.userID);
  final String userID;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              height: 44,
              color: CommonColors.getThemeColor(),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => Conversion('c2c_$userID'),
                  ),
                );
              },
              child: Text(
                '发送消息',
                style: TextStyle(
                  color: CommonColors.getWitheColor(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DeleteFriend extends StatelessWidget {
  DeleteFriend(this.userID);
  final String userID;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              height: 44,
              color: hexToColor('FA5151'),
              onPressed: () async {
                V2TimValueCallback<List<V2TimFriendOperationResult>> res =
                    await TencentImSDKPlugin.v2TIMManager
                        .getFriendshipManager()
                        .deleteFromFriendList(
                  userIDList: [userID],
                  deleteType: 2, //双向好友
                );
                if (res.code == 0) {
                  // 删除成功
                  Toast.show('删除成功', context);
                  V2TimValueCallback<List<V2TimFriendInfo>> friendRes =
                      await TencentImSDKPlugin.v2TIMManager
                          .getFriendshipManager()
                          .getFriendList();
                  if (friendRes.code == 0) {
                    List<V2TimFriendInfo> list = friendRes.data;
                    if (list != null && list.length > 0) {
                      Provider.of<FriendListModel>(context, listen: false)
                          .setFriendList(list);
                    } else {
                      Provider.of<FriendListModel>(context, listen: false)
                          .setFriendList(new List<V2TimFriendInfo>());
                    }
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(
                '删除好友',
                style: TextStyle(
                  color: CommonColors.getWitheColor(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HandleButtons extends StatelessWidget {
  HandleButtons(this.userID);
  final String userID;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Column(
        children: [
          SendMessage(userID),
          // DeleteFriend(userID),
        ],
      ),
    );
  }
}

class UserProfileState extends State<UserProfile> {
  String userID;
  V2TimFriendInfoResult userInfo;
  void initState() {
    userID = widget.userID;
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    V2TimValueCallback<List<V2TimFriendInfoResult>> data =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .getFriendsInfo(userIDList: [userID]);
    if (data.code == 0) {
      V2TimFriendInfoResult info = data.data[0];

      setState(() {
        userInfo = info;
      });
    }
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户资料'),
        backgroundColor: CommonColors.getThemeColor(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: CommonColors.getGapColor(),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          FriendProfilePanel(userInfo, false),
                          ListGap(),
                          AddToBlackList(userInfo),
                          UserRemark(userInfo, getUserInfo)
                        ],
                      ),
                    ),
                    HandleButtons(userID),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

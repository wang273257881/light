import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/Tecent/conversion/component/conversationInner.dart';
import 'package:homework/Tecent/conversion/component/msgInput.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:homework/Tecent/userProfile.dart';
import 'package:homework/Tecent/provider/currentMessageList.dart';

class Conversion extends StatefulWidget {
  Conversion(this.conversationID);
  final String conversationID;
  @override
  State<StatefulWidget> createState() => ConversionState(conversationID);
}

class ConversionState extends State<Conversion> {
  String conversationID;
  String lastMessageId = '';
  String userID = '';
  String groupID = '';
  List<V2TimMessage> msgList = [];

  Icon righTopIcon;
  bool isreverse = true;
  List<V2TimMessage> currentMessageList = new List<V2TimMessage>();
  ConversionState(this.conversationID);

  void initState() {
    super.initState();
    print('++++++++++++++++++++++++++++Dart in+++++++++++++++++++++++++++++');
    print(this.runtimeType);

    getConversion();
  }

  openProfile(context) {
    String id = userID;
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) =>
            UserProfile(id)
      ),
    );
  }

  getConversion() async {
    V2TimValueCallback<V2TimConversation> data = await TencentImSDKPlugin
        .v2TIMManager
        .getConversationManager()
        .getConversation(conversationID: conversationID);
    String _msgID;
    int _type;
    String _groupID;
    String _userID;

    if (data.code == 0) {
      _msgID = data.data.lastMessage.msgID;
      _groupID = data.data.groupID;
      _userID = data.data.userID;
      print('_userID ${_userID}');
      print('_groupID ${_groupID}');
      setState(() {
        lastMessageId = _msgID;
        groupID = _groupID;
        userID = _userID;
        righTopIcon = _type == 1
            ? Icon(
                Icons.account_box,
                color: CommonColors.getWitheColor(),
              )
            : Icon(
                Icons.supervisor_account,
                color: CommonColors.getWitheColor(),
              );
      });
    }

    //判断会话类型，c2c or group

      // c2c
      TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .getC2CHistoryMessageList(
            userID: _userID,
            count: 100,
          )
          .then((listRes) {
        if (listRes.code == 0) {
          List<V2TimMessage> list = listRes.data;
          if (list == null || list.length == 0) {
            print('没有消息啊！！！');
            list = new List<V2TimMessage>();
          }
          print("conversationID $conversationID 消息数量 ${listRes.data.length}");
          Provider.of<CurrentMessageListModel>(context, listen: false)
              .addMessage(conversationID, list);
        } else {
          print('conversationID 获取历史消息失败 ${listRes.desc}');
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("会话"),
        backgroundColor: CommonColors.getThemeColor(),
        actions: [
          IconButton(
            icon: righTopIcon,
            onPressed: () {
              openProfile(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ConversationInner(conversationID, userID, groupID),
          ),
          MsgInput(userID),
          Container(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/Tecent/provider/currentMessageList.dart';
import 'package:homework/Tecent/provider/keybooadshow.dart';
import 'package:toast/toast.dart';

class TextMsg extends StatefulWidget {
  final String toUser;
  final int type;
  TextMsg(this.toUser, this.type);

  @override
  State<StatefulWidget> createState() => TextMsgState();
}

class TextMsgState extends State<TextMsg> {
  bool isRecording = false;
  bool isSend = true;
  TextEditingController inputController = new TextEditingController();
  OverlayEntry overlayEntry;
  String voiceIco = "images/voice_volume_1.png";
  void initState() {
    print("widget.toUser${widget.toUser}");
    super.initState();
  }

  buildOverLayView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = new OverlayEntry(builder: (content) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.5 - 80,
          left: MediaQuery.of(context).size.width * 0.5 - 80,
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xff77797A),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: new Image.asset(
                          voiceIco,
                          width: 100,
                          height: 100,
                          package: 'flutter_plugin_record',
                        ),
                      ),
                      Container(
//                      padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                        child: Text(
                          "手指上滑,取消发送",
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context).insert(overlayEntry);
    }
  }

  onSubmitted(String s, context) async {
    if (s == '' || s == null) {
      return;
    }
    V2TimValueCallback<V2TimMessage> sendRes;
    if (widget.type == 1) {
      sendRes = await TencentImSDKPlugin.v2TIMManager
          .sendC2CTextMessage(text: s, userID: widget.toUser);
    } else {
      sendRes = await TencentImSDKPlugin.v2TIMManager
          .sendGroupTextMessage(text: s, groupID: widget.toUser, priority: 1);
    }

    if (sendRes.code == 0) {
      print('发送成功');
      String key = (widget.type == 1
          ? "c2c_${widget.toUser}"
          : "group_${widget.toUser}");
      List<V2TimMessage> list = new List<V2TimMessage>();
      list.add(sendRes.data);
      Provider.of<CurrentMessageListModel>(context, listen: false)
          .addMessage(key, list);
      inputController.clear();
    } else {
      print(sendRes.desc);
      Toast.show("发送失败 ${sendRes.code} ${sendRes.desc}", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboradshow = Provider.of<KeyBoradModel>(context).show;
    return Expanded(
      child: PhysicalModel(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: inputController,
                  onSubmitted: (s) {
                    onSubmitted(s, context);
                  },
                  autocorrect: false,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.send,
                  cursorColor: CommonColors.getThemeColor(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    isDense: true,
                    contentPadding: EdgeInsets.only(
                      top: 9,
                      bottom: 0,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  minLines: 1,
                ),
              ),
            )
    );
  }
}

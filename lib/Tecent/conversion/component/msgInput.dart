import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/Tecent/provider/currentMessageList.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:toast/toast.dart';


class MsgInput extends StatefulWidget {
  final String toUser;
  MsgInput(this.toUser);

  @override
  State<StatefulWidget> createState() => MsgInputState();

}
class MsgInputState extends State<MsgInput> {
  dynamic input;
  String toUser;

  void initState() {
    super.initState();
    this.toUser = widget.toUser;
    this.input = '';
  }
  TextEditingController inputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("toUser${toUser} ***** MsgInput");
    return Container(
      height: 55,
      child:
      // TextMsg(toUser, type),
      Row(
        children: [
          TextMsg(),
          TextButton(onPressed: () => onSubmitted(input, context), child: Text('确认'))
        ],
      ),
    );
  }


  onSubmitted(String s, context) async {
    if (s == '' || s == null) {
      return;
    }
    V2TimValueCallback<V2TimMessage> sendRes;
    sendRes = await TencentImSDKPlugin.v2TIMManager
        .sendC2CTextMessage(text: s, userID: widget.toUser);

    if (sendRes.code == 0) {
      print('发送成功');
      String key = "c2c_${widget.toUser}";
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

  Widget TextMsg() {
    // bool isKeyboradshow = Provider.of<KeyBoradModel>(context).show;
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
              onChanged: (s) {
                print(s.runtimeType);
                // print(s.toString());
                input = s;
              },
              onSubmitted: (s) => print(s),
              autocorrect: false,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.multiline,
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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homework/Tecent/common/hexToColor.dart';
import 'package:homework/Tecent/models/emoji/emoji.dart';
import 'package:homework/Tecent/provider/currentMessageList.dart';
import 'package:homework/Tecent/utils/emojiData.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class FaceMsg extends StatelessWidget {
  FaceMsg(this.toUser, this.type);
  final String toUser;
  final int type;

  Future<int> openPanel(context) {
    close() {
      Navigator.pop(context);
    }

    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 246,
          color: hexToColor('ededed'),
          padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              childAspectRatio: 1,
              // mainAxisSpacing: 23,
              // crossAxisSpacing: 12,
            ),
            children: emojiData.map(
              (e) {
                var item = Emoji.fromJson(e);
                return new EmojiItem(
                  name: item.name,
                  unicode: item.unicode,
                  toUser: toUser,
                  type: type,
                  close: close,
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      child: IconButton(
          icon: Icon(
            Icons.tag_faces,
            size: 28,
            color: Colors.black,
          ),
          onPressed: () async {
            await openPanel(context);
          }),
    );
  }
}


class EmojiItem extends StatelessWidget {
  EmojiItem({name, unicode, toUser, type, close}) {
    this.name = name;
    this.unicode = unicode;
    this.toUser = toUser;
    this.type = type;
    this.close = close;
  }
  String name;
  int unicode;
  String toUser;
  int type;
  Function close;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print("表情touser$toUser");
        V2TimValueCallback<V2TimMessage> sendRes;
        if (type == 1) {
          sendRes = await TencentImSDKPlugin.v2TIMManager.sendC2CTextMessage(
              text: String.fromCharCode(unicode), userID: toUser);
        } else if (type == 2) {
          sendRes = await TencentImSDKPlugin.v2TIMManager.sendGroupTextMessage(
            text: String.fromCharCode(unicode),
            groupID: toUser,
            priority: 0,
          );
        }
        if (sendRes.code == 0) {
          String key = (type == 1 ? "c2c_$toUser" : "group_$toUser");
          print("key $key");
          List<V2TimMessage> list = new List<V2TimMessage>();
          list.add(sendRes.data);
          Provider.of<CurrentMessageListModel>(context, listen: false)
              .addMessage(key, list);
          print('发送成功');
          close();
        } else {
          print('发送失败${sendRes.desc}');
        }
      },
      child: Container(
        child: Text(
          String.fromCharCode(unicode),
          style: TextStyle(
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}

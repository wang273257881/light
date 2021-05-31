import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/Tecent/userProfile.dart';
import 'package:homework/tools/SizeFit.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';

class Comment extends StatefulWidget {
  Map<String, dynamic> data;
  Comment(this.data);
  @override
  _Comment createState() => _Comment();
}

class _Comment extends State<Comment>{
  Map<String, dynamic> data;
  List<Widget> stars;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    this.data = widget.data;
    this.stars = [
      Row(
        children: [
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
        ],
      ),
      Row(
        children: [
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
        ],
      ),
      Row(
        children: [
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
        ],
      ),
      Row(
        children: [
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
        ],
      ),
      Row(
        children: [
          Icon(Icons.star, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
          Icon(Icons.star_border, color: Colors.amberAccent, size: SizeFit.setRpx(60),),
        ],
      ),
    ];
    this.isLoading = true;
    getUserInfo();
  }

  getUserInfo() async {
    await TencentImSDKPlugin.v2TIMManager.getUsersInfo(userIDList: [data['userId']])
        .then((value) {
      data['faceUrl'] = value.data[0].faceUrl;
      data['nickName'] = value.data[0].nickName == ''?data['userId']:value.data[0].nickName;
      this.setState(() {
        isLoading = false;
      });
    });
  }
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      // height: SizeFit.setRpx(400),
      child: isLoading?
      Center(
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(CommonColors.getThemeColor())
          )
      ):
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => UserProfile(data["userId"]),
              ),
            ),
            child: PersonInfo(data["nickName"], data["faceUrl"], data["createTime"]),
          ),
          Container(
            margin: EdgeInsets.only(left: SizeFit.setRpx(75), bottom: SizeFit.setRpx(20)),
            child: stars[4 - data['score']],
          ),
          TitleInfo(data["content"]),
        ],
      ),
    );
  }

}

class PersonInfo extends StatelessWidget {
  String nickName, faceUrl, createTime;

  PersonInfo(nickName, faceUrl, createTime) {
    this.nickName = nickName;
    this.faceUrl = faceUrl;
    this.createTime = createTime == null?'':createTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: SizeFit.setRpx(50), top: SizeFit.setRpx(50), bottom: SizeFit.setRpx(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: SizeFit.setRpx(150),
            height: SizeFit.setRpx(150),
            child: faceUrl == ''?
                Image(
                  image: AssetImage("images/logo.png"),
                ):
                Image.network(
                    faceUrl,
                ),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(SizeFit.setRpx(150))),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: SizeFit.setRpx(50)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                      nickName,
                      style:
                      TextStyle(fontSize: SizeFit.setRpx(50), fontWeight: FontWeight.w600)
                  ),
                ),
                SizedBox(height: SizeFit.setRpx(20),),
                Container(
                    child: Text(
                        createTime.substring(0, 10) + ' ' + createTime.substring(11, 19),
                        style: TextStyle(
                          fontSize: SizeFit.setRpx(40),
                          color: Colors.grey,
                        )
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TitleInfo extends StatelessWidget {
  String content;
  TitleInfo(this.content);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeFit.setRpx(40), left: SizeFit.setRpx(60), right: SizeFit.setRpx(40)),
      child: Text(content, maxLines: null, style: TextStyle(fontSize: SizeFit.setRpx(45), fontWeight: FontWeight.bold)),
      // alignment: Alignment.topLeft,
      constraints: BoxConstraints(
        maxHeight: SizeFit.setRpx(200),
      ),
    );
  }
}

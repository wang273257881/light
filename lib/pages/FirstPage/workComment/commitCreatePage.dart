import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework/Tecent/common/colors.dart';
import 'package:homework/tools/GlobalInfo.dart';
import 'package:homework/tools/SizeFit.dart';
import 'package:toast/toast.dart';

class CommitCreatePage extends StatefulWidget {
  String workId;
  CommitCreatePage(this.workId);

  @override
  State<StatefulWidget> createState() => CommitCreatePageState();
}

class CommitCreatePageState extends State<CommitCreatePage> {
  String workId, content, newCommitId;
  int score;
  bool isLoading;

  void initState() {
    super.initState();
    this.workId = widget.workId;
    this.content = '';
    this.score = -1;
    this.isLoading = true;
    this.newCommitId = '';
    fetchData();
  }

  fetchData() async {
    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    await cloudbase.callFunction('getCommitCount')
        .then((value) {
      String count = (value.data + 1).toString();
      for (int i = 0; i < 7 - count.length; i += 1) {
        newCommitId += '0';
      }
      newCommitId += count;
      this.setState(() {
        isLoading = false;
      });
    });
  }

  Container BuildConfirmButton() {
    return Container(
      child:
      MaterialButton(
        color: CommonColors.getThemeColor(),
        textColor: Colors.white,
        child: new Text('确认发表', style: TextStyle(fontSize: SizeFit.setRpx(60)),),
        onPressed: () async {
          if (score == -1) {
            Toast.show('评分不能为空！', context);
            return;
          }
          this.setState(() {
            isLoading = true;
          });
          CloudBaseFunction cloudbase = CloudBaseFunction(core);
          await cloudbase.callFunction('addCommit', {
            'userId': userInfoGlobal.u_id,
            'workId': workId,
            'commitId': newCommitId,
            'content': content,
            'score': score
          })
              .then((value) {
            this.setState(() {
              isLoading = false;
            });
            if (value.code == null) {
              Toast.show('发表成功！', context);
              Navigator.of(context).pop();
            }
          });
        },
      ),
      width: SizeFit.setRpx(900),
      height: SizeFit.setRpx(120),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          backgroundColor: CommonColors.getThemeColor(),
          leading: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
          centerTitle: true,
          title: Text('发表评论'),
        ),
        body: isLoading?
        Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(CommonColors.getThemeColor())
            )
        ):
        Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: SizeFit.setRpx(70), top: SizeFit.setRpx(50), right: SizeFit.setRpx(50)),
                child: TextField(
                  autofocus: false,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: "评论",
                    hintText: "请文明表述您对作品的看法",
                    icon: Icon(Icons.add_comment,),
                  ),
                  // keyboardType: TextInputType.,
                  onChanged: (v) {
                    setState(() {
                      content = v;
                    });
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: SizeFit.setRpx(100), left: SizeFit.setRpx(70), bottom: SizeFit.setRpx(100)),
                  child: Row(
                    children: [
                      Text('评分：', style: TextStyle(fontSize: SizeFit.setRpx(50)),),
                      SizedBox(width: SizeFit.setRpx(50),),
                      Row(
                        children: [
                          GestureDetector(
                              child: Icon(
                                score > -1?Icons.star:Icons.star_border,
                                color: Colors.amberAccent,
                                size: SizeFit.setRpx(60),
                              ),
                              onTap: () => this.setState(() {
                                score = 0;
                              })
                          ),
                          GestureDetector(
                              child: Icon(
                                score > 0?Icons.star:Icons.star_border,
                                color: Colors.amberAccent,
                                size: SizeFit.setRpx(60),
                              ),
                              onTap: () => this.setState(() {
                                score = 1;
                              })
                          ),
                          GestureDetector(
                              child: Icon(
                                score > 1?Icons.star:Icons.star_border,
                                color: Colors.amberAccent,
                                size: SizeFit.setRpx(60),
                              ),
                              onTap: () => this.setState(() {
                                score = 2;
                              })
                          ),
                          GestureDetector(
                              child: Icon(
                                score > 2?Icons.star:Icons.star_border,
                                color: Colors.amberAccent,
                                size: SizeFit.setRpx(60),
                              ),
                              onTap: () => this.setState(() {
                                score = 3;
                              })
                          ),
                          GestureDetector(
                              child: Icon(
                                score > 3?Icons.star:Icons.star_border,
                                color: Colors.amberAccent,
                                size: SizeFit.setRpx(60),
                              ),
                              onTap: () => this.setState(() {
                                score = 4;
                              })
                          ),
                        ],
                      ),
                    ],
                  )

              ),
              BuildConfirmButton()
            ],
          ),
        )
    );
  }

}

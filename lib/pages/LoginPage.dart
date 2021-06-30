import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_function/cloudbase_function.dart';
import 'package:homework/tools/GlobalInfo.dart';
import 'package:homework/Tecent/provider/user.dart';
import 'package:homework/pages/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/enum/log_level.dart';
import 'package:tencent_im_sdk_plugin/manager/v2_tim_manager.dart';
import 'package:tencent_im_sdk_plugin/tencent_im_sdk_plugin.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:homework/Tecent/provider/conversion.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'package:homework/Tecent/utils/GenerateTestUserSig.dart';
import 'package:homework/Tecent/utils/config.dart';
import 'package:toast/toast.dart';
import '../Tecent/common/colors.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;


class LoginPageTecent extends StatefulWidget {
  @override
  _LoginPageTecentState createState() => _LoginPageTecentState();
}

class _LoginPageTecentState extends State<LoginPageTecent> {
  bool isinit = false;
  String oppoRegId;

  void initState() {
    super.initState();
    init();
    setState(() {
      this.isinit = true;
    });
  }

  init() async {
    await initSDK();
    await initCloud();
  }

  initCloud() async {
    core = CloudBaseCore.init({
      'env': cloudBaseInfoGlobal.env,
      'appAccess': {
        'key': cloudBaseInfoGlobal.accessKey,
        'version': cloudBaseInfoGlobal.version
      },
      'timeout': 3000
    });
    CloudBaseAuth auth = CloudBaseAuth(core);
    CloudBaseAuthState authState = await auth.getAuthState();
    if (authState == null) {
      await auth.signInAnonymously()
          .then((success) {
          })
          .catchError((err) {
            print(err);
          });
    }
  }

  listener(data) async {
    if (data.type == 'onSelfInfoUpdated') {
      //自己信息更新，从新获取自己的信息；
      V2TimValueCallback<String> usercallback =
      await TencentImSDKPlugin.v2TIMManager.getLoginUser();
      V2TimValueCallback<List<V2TimUserFullInfo>> infos =
      await TencentImSDKPlugin.v2TIMManager
          .getUsersInfo(userIDList: [usercallback.data]);
      if (infos.code == 0) {
        Provider.of<UserModel>(context, listen: false).setInfo(infos.data[0]);
      }
    }
  }

  Map<String, V2TimConversation> conversationlistToMap(
      List<V2TimConversation> list) {
    Map<int, V2TimConversation> convsersationMap = list.asMap();
    Map<String, V2TimConversation> newConversation = new Map();
    convsersationMap.forEach((key, value) {
      newConversation[value.conversationID] = value;
    });
    return newConversation;
  }

  conversationListener(data) {
    String type = data.type;

    if (type == 'onNewConversation' || type == 'onConversationChanged') {
      print("$type emit");
      try {
        List<V2TimConversation> list = data.data;

        Provider.of<ConversionModel>(context, listen: false)
            .setConversionList(list);
        //如果当前会话在使用中，也更新一下

      } catch (e) {}
    } else {
      print("$type emit but no nerver use");
    }
  }

  signalingListener(data) {
  }

  simpleMsgListener(data) {
    //这里区分消息
  }

  initSDK() async {
    V2TIMManager timManager = TencentImSDKPlugin.v2TIMManager;
    await timManager.initSDK(
      sdkAppID: Config.sdkappid,
      loglevel: LogLevel.V2TIM_LOG_DEBUG,
      listener: listener
    );

    //简单监听
    timManager.addSimpleMsgListener(
      listener: simpleMsgListener
    );
    //会话监听
    timManager.getConversationManager().setConversationListener(
      listener: conversationListener,
    );
    timManager.getSignalingManager().addSignalingListener(
      listener: signalingListener,
    );
  }

  @override
  Widget build(BuildContext context) {
    return (!isinit) ? new WaitHomeWidget() : new HomeWidget();
  }
}

class HomeWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {

  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: new AppLayout(),
    );
  }
}

class WaitHomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WaitHomeWidgetState();
}

class WaitHomeWidgetState extends State<WaitHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}

class AppLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppLogo(),
        Expanded(
          child: LoginForm(),
        )
      ],
    );
  }
}

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Container(
        child: Image(
          image: AssetImage("images/default.jpg"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.565,
        ),
      )
    );
  }
}

class LoginForm extends StatefulWidget {
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  void initState() {
    super.initState();
  }

  bool isLoading = false;
  String u_id = '';
  String pwd = '';
  TextEditingController telEtController = TextEditingController();
  TextEditingController telEtController0 = TextEditingController();

  SignIN () async {
    GenerateTestUserSig usersig = new GenerateTestUserSig(
      sdkappid: Config.sdkappid,
      key: Config.key,
    );
    String pwdStr =
    usersig.genSig(identifier: u_id, expire: 86400);
    TencentImSDKPlugin.v2TIMManager.login(
      userID: u_id,
      userSig: pwdStr,
    ).then((res) async {
      if (res.code == 0) {
        V2TimValueCallback<List<V2TimUserFullInfo>> infos =
        await TencentImSDKPlugin.v2TIMManager
            .getUsersInfo(userIDList: [u_id]);

        if (infos.code == 0) {
          Provider.of<UserModel>(context, listen: false)
              .setInfo(infos.data[0]);
        }
        userInfoGlobal.u_id = u_id;
        this.setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        Toast.show("${res.code} ${res.desc}", context);
        this.setState(() {
          isLoading = false;
        });
      }
    });
  }

  AccountCheck() async {
    if (u_id == '' || pwd == '') {
      Toast.show('账号及密码不能为空！', context);
      return;
    }
    this.setState(() {
      isLoading = true;
    });
    var rsa = RsaKeyHelper();
    crypto.AsymmetricKeyPair keyPair = await getKeyPair();
    String private_key = rsa.encodePrivateKeyToPemPKCS1(keyPair.privateKey);
    String pwd_store = encrypt(pwd, keyPair.publicKey);
    CloudBaseFunction cloudbase = CloudBaseFunction(core);
    await cloudbase.callFunction('login', {
      'userId': u_id,
      'password': pwd_store,
      'privateKey': private_key
    })
        .then((value) {
      dynamic result = value.data;
      if (result == null) {
        SignIN();
      } else {
        result = result[0];
        String storedPwd = decrypt(result['password'], RsaKeyHelper().parsePrivateKeyFromPem(result['privateKey']));
        if (storedPwd == pwd) {
          SignIN();
        } else {
          showAlertDialog("账号已被注册且密码输入错误！");
        }
      }
    });
    this.setState(() {
      isLoading = false;
    });
  }

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>> getKeyPair()
  {
    var helper = RsaKeyHelper();
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }


  void showAlertDialog(value) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('提示信息'),
            //可滑动
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(value),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? Center(
      child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(CommonColors.getThemeColor())
      ),
    ):
    Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Form(
        child: Column(
          children: [
            TextField(
              autofocus: false,
              controller: telEtController,
              decoration: InputDecoration(
                labelText: "账号",
                hintText: "账号应为英文或数字的组合",
                icon: Icon(Icons.person),
              ),
              // keyboardType: TextInputType.,
              onChanged: (v) {
                setState(() {
                  u_id = v;
                });
              },
            ),
            TextField(
              autofocus: false,
              controller: telEtController0,
              decoration: InputDecoration(
                labelText: "密码",
                hintText: "密码应为英文或数字的组合",
                icon: Icon(Icons.lock),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onChanged: (v) {
                setState(() {
                  pwd = v;
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              alignment: Alignment.center,
              child: Text("首次登录将自动进行注册", style: TextStyle(fontSize: 20),),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 28,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                        padding: EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                        ),
                        child: Text("登录"),
                        color: CommonColors.getThemeColor(),
                        textColor: Colors.white,
                        onPressed: () {
                          AccountCheck();
                        }
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(),
            )
          ],
        ),
      ),
    );
  }

}

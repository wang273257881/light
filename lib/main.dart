import 'package:flutter/material.dart';
import 'package:homework/Tecent/provider/user.dart';
import 'package:provider/provider.dart';

import 'pages/LoginPage.dart';
import 'Tecent/provider/conversion.dart';
import 'Tecent/provider/currentMessageList.dart';
import 'Tecent/provider/friend.dart';
import 'Tecent/provider/friendApplication.dart';
import 'Tecent/provider/groupApplication.dart';
import 'Tecent/provider/keybooadshow.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ConversionModel()),
          ChangeNotifierProvider(create: (_) => UserModel()),
          ChangeNotifierProvider(create: (_) => CurrentMessageListModel()),
          ChangeNotifierProvider(create: (_) => FriendListModel()),
          ChangeNotifierProvider(create: (_) => FriendApplicationModel()),
          ChangeNotifierProvider(create: (_) => GroupApplicationModel()),
          ChangeNotifierProvider(create: (_) => KeyBoradModel()),
        ],
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Tutorial',
          home: new LoginPageTecent(),
        ),
      )
  );
}

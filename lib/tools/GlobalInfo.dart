import 'dart:core';

import 'package:cloudbase_core/cloudbase_core.dart';

class CloudBaseInfo {
  final String env = 'hello-cloudbase-5gi3uj3na440e761';
  final String accessKey = '6ae58e54e140bee62e9f3c7d811a9368';
  final String version = '1';
  final String fileStorge = 'cloud://hello-cloudbase-5gi3uj3na440e761.6865-hello-cloudbase-5gi3uj3na440e761-1259751014';
}

class UserInfo {
  dynamic u_id;
}

class Administrator {
  final String account = 'root';
  final password = '%%%%A&(DJKSS)QJMMSJ';
}

final cloudBaseInfoGlobal = CloudBaseInfo();
final userInfoGlobal = UserInfo();
final administrator = Administrator();

CloudBaseCore core;

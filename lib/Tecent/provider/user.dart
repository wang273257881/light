import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';

class UserModel with ChangeNotifier, DiagnosticableTreeMixin {
  V2TimUserFullInfo _info;
  get info => _info;
  setInfo(newInfo) {
    _info = newInfo;
    notifyListeners();
    return _info;
  }

  clear() {
    _info = null;
    notifyListeners();
  }

  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('info', info));
  }
}

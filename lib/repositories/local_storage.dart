import 'package:get_storage/get_storage.dart';

class DBHelper {
  static DBHelper? _helper;

  static DBHelper? getInstance() {
    if (_helper == null) _helper = new DBHelper();
    return _helper;
  }

  void setIsLogin(bool? isLogin) async {
    var ref = GetStorage();
    ref.write("isLogin", isLogin);
  }

  static Future<bool?> isLogin() async {
    var ref = GetStorage();
    return ref.read("isLogin");
  }
}

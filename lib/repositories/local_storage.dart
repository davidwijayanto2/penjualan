import 'package:get_storage/get_storage.dart';
import 'package:penjualan/model/user.dart';

class LocalStorage {
  static LocalStorage? _helper;

  static LocalStorage? getInstance() {
    if (_helper == null) _helper = new LocalStorage();
    return _helper;
  }

  void setIsLogin(bool? isLogin) async {
    var ref = GetStorage();
    ref.write("isLogin", isLogin);
  }

  static bool? isLogin() {
    var ref = GetStorage();
    return ref.read("isLogin");
  }

  void setUser(Map<String, dynamic>? mapUser) {
    var ref = GetStorage();
    if (mapUser != null) {
      ref.write('userLogin', mapUser);
    }
  }

  static User? userLogin() {
    var ref = GetStorage();
    return User.fromMap(ref.read('userLogin'));
  }
}

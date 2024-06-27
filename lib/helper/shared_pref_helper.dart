import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static Future<void> setEmail(String mailAddress) async {
    var sPref = await SharedPreferences.getInstance();
    sPref.setString("pref_mail_address", mailAddress);
  }

  static Future<String?> getEmail() async {
    var sPref = await SharedPreferences.getInstance();
    return sPref.getString("pref_mail_address");
  }

  static Future<void> setUserName(String userName) async {
    var sPref = await SharedPreferences.getInstance();
    sPref.setString("pref_user_name", userName);
  }

  static Future<String?> getUsername() async {
    var sPref = await SharedPreferences.getInstance();
    return sPref.getString("pref_user_name");
  }

  static Future<void> setUserImageUrl(String userImageUrl) async {
    var sPref = await SharedPreferences.getInstance();
    sPref.setString("pref_user_image_url", userImageUrl);
  }

  static Future<String?> getUserImageUrl() async {
    var sPref = await SharedPreferences.getInstance();
    return sPref.getString("pref_user_image_url");
  }

  static Future<void> setDocId(String userName) async {
    var sPref = await SharedPreferences.getInstance();
    sPref.setString("pref_doc_id", userName);
  }

  static Future<String?> getDocId() async {
    var sPref = await SharedPreferences.getInstance();
    return sPref.getString("pref_doc_id");
  }

  static Future<void> setUserType(int userType) async {
    var sPref = await SharedPreferences.getInstance();
    sPref.setInt("pref_user_type", userType);
  }

  static Future<int?> getUserType() async {
    var sPref = await SharedPreferences.getInstance();
    return sPref.getInt("pref_user_type");
  }
}

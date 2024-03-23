import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  List<String> data = [];
   saveLocalData({required localSave, required dynamicList}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    data = (await prefs.setStringList(localSave, dynamicList)) as List<String>;
    return data;
  }
}



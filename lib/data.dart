import 'package:shared_preferences/shared_preferences.dart';

String? malToken;

Future<void> loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  malToken = prefs.getString("malToken");
}
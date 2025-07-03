// import 'dart:convert';
// import 'dart:developer';
 


// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:to_do_list/core/models/app_user.dart';

 
// class SessionController {
//   static final _session = SessionController._internal();
//   LocalStorage storage = LocalStorage();
//     UserModel userDataModel = UserModel(email: '',password: '');
//   bool? isLogin;
  
//   SessionController._internal() {
//     isLogin = false; 
//   }
//   factory SessionController() {
//     return _session;
//   }

//   Future<void> saveUserPreference(dynamic userData) async {
//     await storage.setData(key: 'userData', value: jsonEncode(userData));
//     await storage.setData(key: 'isLogin', value: jsonEncode(true)); 
//   }

//   Future<void> getUserPreference() async {
//     try {
//       final onValue = await storage.getData(key: 'userData');
//       if (onValue != null && onValue.isNotEmpty) {
//         SessionController().userDataModel = AppUser.fromJson(
//           jsonDecode(onValue),
//         );
//         log(
//           "${SessionController().userDataModel.id} id token ",
//         );
//       }
//       final myLogin = (await storage.getData(key: 'isLogin'))?.toString(); 
//       SessionController().isLogin = myLogin == 'true'; 
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
   
   
  
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('userData'); 
//     await prefs.remove('isLogin'); 
//   }
// }
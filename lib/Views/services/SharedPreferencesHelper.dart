// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesHelper {
//   static Future<void> saveTotalOrders(int totalOrders) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('totalOrders', totalOrders);
//   }

//   static Future<int?> getTotalOrders() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('totalOrders');
//   }

//   static Future<void> saveTotalSales(double totalSales) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('totalSales', totalSales);
//   }

//   static Future<double?> getTotalSales() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getDouble('totalSales');
//   }

//   static Future<void> saveCompletedOrdersCount(int count) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('completedOrdersCount', count);
//   }

//   static Future<int?> getCompletedOrdersCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('completedOrdersCount');
//   }

//   static Future<void> saveActiveOrdersCount(int count) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('activeOrdersCount', count);
//   }

//   static Future<int?> getActiveOrdersCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('activeOrdersCount');
//   }
// }

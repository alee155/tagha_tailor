// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:flutter_svg/flutter_svg.dart';


// class BottomW extends StatefulWidget {
//   @override
//   State<BottomW> createState() => _BottomWState();
// }

// class _BottomWState extends State<BottomW> {
//   int current = 0;
//   final tabs = [
//    DashboarScreen(),
//    Customizekandora(),
//    Tailor(),
//    Cart(),
//    Profile(),

//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Material(
//           elevation: 20.0, 
//           child: BottomNavigationBar(
//           backgroundColor: Colors.white,
//           type: BottomNavigationBarType.fixed,
//           currentIndex: current,
//           showUnselectedLabels: true,
//           showSelectedLabels: true,
//           selectedFontSize: 12.sp,
//           unselectedFontSize: 12.sp,
//           selectedItemColor: AppColors.Appcolor,
//           unselectedItemColor: Colors.grey,
//           items: [
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 AppIcons.Home,
//                 width: 20.w,
//                 height: 20.h,
//                 color: current == 0 ? AppColors.Appcolor : Colors.grey,
//               ),
//               label: "Home",
//             ),
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 AppIcons.Favorite,
//                 width: 20.w,
//                 height: 20.h,
//                 color: current == 1 ? AppColors.Appcolor : Colors.grey,
//               ),
//               label: "Customize",
//             ),
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 AppIcons.Scissor,
//                 width: 20.w,
//                 height: 20.h,
//                 color: current == 2 ? AppColors.Appcolor : Colors.grey,
//               ),
//               label: "Tailor",
//             ),
//             BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 AppIcons.cart,
//                 color: current == 3 ? AppColors.Appcolor: Colors.grey,
//                 width: 20.w,
//                 height: 20.h,
//               ),
//               label: "Cart",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.person_3_outlined,
//                 size: 25.sp,
//                 color: current == 4 ? AppColors.Appcolor : Colors.grey,
//               ),
//               label: "Profile",
//             ),
//           ],
//           onTap: (index) {
//             setState(() {
//               current = index;
//             });
//           },
//         ),
//       ),
//       body: tabs[current],
//     );
//   }
// }



// // outlined button 

// class CustomOutlinedButton extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final VoidCallback onPressed;

//   CustomOutlinedButton({
//     required this.icon,
//     required this.text,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton.icon(
//       onPressed: onPressed,
//       icon: Icon(icon),
//       label: Text(text,style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold),),
//       style: OutlinedButton.styleFrom(
//         side: BorderSide(color: Theme.of(context).primaryColor),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0.r),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 12.0.w),
//       ),
//     );
//   }
// }

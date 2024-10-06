import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/fonts.dart';
import 'package:tagha_tailor/Constants/icons.dart';
import 'package:tagha_tailor/Views/Profileeeee.dart';
import 'package:tagha_tailor/Views/TabScreens/active.dart';
import 'package:tagha_tailor/Views/TabScreens/complete.dart';
import 'package:tagha_tailor/Views/TabScreens/inprocess.dart';
import 'package:tagha_tailor/Views/services/user_service.dart';
import 'package:tagha_tailor/model/user_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  UserModel? userModel;
  late Future<int> activeUsersCountFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    UserService userService = UserService();
    UserModel? user = await userService.getUserData();
    setState(() {
      userModel = user;
    });
  }

  Future<bool> _onWillPop() async {
    // Show a dialog or handle the back navigation here
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you really want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle the back navigation
      child: Scaffold(
        body: Column(
          children: [
            // Top Container with Avatar and Greeting
            Container(
              height: 127.h,
              width: MediaQuery.of(context).size.width,
              color: AppColors.Appcolor,
              child: Padding(
                padding: EdgeInsets.only(top: 30.h, left: 10.w, right: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyScreen()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 35.0.r,
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset('assets/Tagah Logo.svg'),
                          ),
                        ),
                        SizedBox(width: 30.0.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WhiteText(
                              'Good Morning',
                              fontsize: 20.sp,
                            ),
                            WhiteText(
                              userModel?.name ?? 'Loading...',
                              fontsize: 20.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.w, right: 12.w),
                      child: SvgPicture.asset(
                        AppIcons.Notification,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            // TabBar with Tabs
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: EdgeInsets.zero,
                dividerColor: Colors.transparent,
                tabs: [
                  _buildTab('Active', _tabController.index == 0),
                  _buildTab('In-Process', _tabController.index == 1),
                  _buildTab('Complete', _tabController.index == 2),
                ],
                onTap: (index) {
                  setState(() {});
                },
              ),
            ),
            // TabBarView for Tab Screens
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ActiveTabs(),
                  InprocessTabs(),
                  CompleteTabs(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build Tab
  Widget _buildTab(String text, bool isSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.Appcolor : Colors.grey,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Center(
          child: WhiteText(
            text,
            fontsize: 16.sp,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/fonts.dart';
import 'package:tagha_tailor/Views/WelcomeDashBoardTabs/WelcomeActive.dart';
import 'package:tagha_tailor/Views/WelcomeDashBoardTabs/WelcomeCompleted.dart';
import 'package:tagha_tailor/Views/WelcomeDashBoardTabs/WelcomeProcess.dart';
import 'package:tagha_tailor/Views/services/user_service.dart';
import 'package:tagha_tailor/model/user_model.dart';

class WelcomeDashboardScreen extends StatefulWidget {
  const WelcomeDashboardScreen({super.key});

  @override
  State<WelcomeDashboardScreen> createState() => _WelcomeDashboardScreenState();
}

class _WelcomeDashboardScreenState extends State<WelcomeDashboardScreen>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Appcolor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            'All Orders',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
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
                WelcomeActiveTabs(),
                WelcomeInprocessTabs(),
                WelcomeCompleteTabs(),
              ],
            ),
          ),
        ],
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

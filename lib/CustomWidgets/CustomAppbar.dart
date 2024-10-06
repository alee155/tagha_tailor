import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tagha_tailor/Constants/colors.dart';
import 'package:tagha_tailor/Constants/fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String backIconPath;

  CustomAppBar({required this.title, required this.backIconPath});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.Appcolor,
      leading: IconButton(
        icon: SvgPicture.asset(
          backIconPath,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      centerTitle: true,
      title: WhiteText(title),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomSheetWidget extends StatefulWidget {
  final List<dynamic> TextList;
  final List<dynamic>? IconForEdit;
  final dynamic title;
  final bool? isIconToShowForEdit;
  Function(String) updateOption; // Add this property

  BottomSheetWidget({
    super.key,
    required this.TextList,
    required this.updateOption,
    this.isIconToShowForEdit,
    this.title,
    this.IconForEdit, // Update the constructor
  });

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return makeDismissable(
      context: context,
      child: Container(
        margin: const EdgeInsets.only(top: 106),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
            color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 17.h, left: 20.w),
              child: Row(
                children: [
                  Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Expanded(child: SizedBox(width: 1.w)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      CupertinoIcons.xmark,
                      size: 20.h,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 20.w)
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 1.h,
              width: double.infinity,
              color: Colors.grey,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: widget.TextList.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      widget.updateOption(
                        widget.TextList[index],
                      ); // Update the hint text
                      Navigator.pop(context, widget.TextList[index]);
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: ItemWidget(
                      index: index,
                      textList: [widget.TextList[index]],
                      isSelected: index == selectedIndex,
                      imagesList: [widget.IconForEdit?[index]],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemWidget extends StatefulWidget {
  final int index;
  final List<String>? textList;
  final List<dynamic>? imagesList;
  final bool isSelected;

  const ItemWidget({
    super.key,
    required this.index,
    required this.textList,
    required this.isSelected,
    required this.imagesList,
  });

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          if (widget.imagesList != null &&
              widget.imagesList!.isNotEmpty &&
              widget.imagesList!.first !=
                  null) // Add null check and isEmpty check
            SvgPicture.asset(widget.imagesList!.first!, height: 24.h),
          SizedBox(width: 12.w),
          Text(
            widget.textList != null &&
                    widget.textList!.isNotEmpty // Add null check
                ? widget.textList!
                    .first // Add null check and use ! operator to access first element
                : '', // Return empty string if TextList is null or empty
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

Widget makeDismissable({required BuildContext context, required Widget child}) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(onTap: () {}, child: child),
  );
}

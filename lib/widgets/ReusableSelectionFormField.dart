import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tagha_tailor/widgets/BottomSheetWidget.dart';

class ReusableSelectionFormField extends StatefulWidget {
  final String hintText;
  final List<dynamic> options;
  final Function(String) chooseOption;

  const ReusableSelectionFormField({
    super.key,
    required this.hintText,
    required this.options,
    required this.chooseOption,
  });

  @override
  State<ReusableSelectionFormField> createState() =>
      _ReusableSelectionFormFieldState();
}

class _ReusableSelectionFormFieldState
    extends State<ReusableSelectionFormField> {
  late String selectedValue;

  @override
  void initState() {
    setState(() {
      selectedValue = widget.hintText;
    });
    // Utils.printData("selectedValue = $selectedValue");
    // Initialize with selected option
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            final selected = await showModalBottomSheet<String>(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder: (context) => BottomSheetWidget(
                TextList: widget.options,
                updateOption: widget.chooseOption,
              ),
            );

            if (selected != null) {
              setState(() {
                selectedValue = selected;
              });
            }
          },
          child: Container(
            height: 45.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: selectedValue.isNotEmpty
                  ? Colors.transparent
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            // padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              selectedValue.isEmpty ? widget.hintText : selectedValue,
              style: TextStyle(
                color: selectedValue == "Select value"
                    ? Colors.grey
                    : Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              // overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

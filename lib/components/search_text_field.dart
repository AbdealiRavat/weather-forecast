import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/screens/home_screen.dart';

import '../controller/location_list_controller.dart';

class SearchTextField extends StatelessWidget {
  TextEditingController controller;
  LocationListController locationListController;
  SearchTextField({super.key, required this.controller, required this.locationListController});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45.h,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(22.r)),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: controller,
              maxLines: 1,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
              ],
              cursorColor: Colors.grey.shade800,
              style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600, fontSize: 18.sp),
              onSubmitted: (value) {
                print(value.toString());
                if (!locationListController.locationList.contains(controller.text.trimRight().trimLeft().toUpperCase())) {
                  Get.to(() => HomeScreen(
                        cityName: value.trimLeft().trimRight(),
                      ));
                  locationListController.locationList.add(value.trimLeft().trimRight().toUpperCase());
                }
                controller.clear();
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(9.w, 0.h, 0.w, 8.h),
                  border: const UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 18.sp, color: Colors.grey.shade700)),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: InkWell(
                onTap: () async {
                  if (!locationListController.locationList.contains(controller.text.trimRight().trimLeft().toUpperCase())) {
                    print(controller.text.toString());
                    locationListController.locationList.add(controller.text.trimLeft().trimRight().toUpperCase());
                    await Get.to(() => HomeScreen(
                          cityName: controller.text.trimLeft().trimRight(),
                        ));
                  }
                  controller.clear();
                },
                child: Image.asset(
                  'assets/search.png',
                  height: 25.h,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ));
  }
}

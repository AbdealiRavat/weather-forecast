import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/screens/location_list_screen.dart';

import '../components/location_list_title.dart';
import '../components/toast.dart';
import '../controller/location_list_controller.dart';

class SavedLocationsScreen extends StatefulWidget {
  const SavedLocationsScreen({super.key});

  @override
  State<SavedLocationsScreen> createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  LocationListController locationListController = Get.put(LocationListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff391A49), Color(0xff262171), Color(0xff391A49)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: ListView(
          // physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 10.h),
          children: [
            _myAppBar(),
            // InkWell(
            //   onTap: () {
            //     Get.to(() => HomeScreen());
            //   },
            //   child: Container(
            //     margin: EdgeInsets.symmetric(
            //       vertical: 8.w,
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            //     decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //           colors: [Colors.white.withOpacity(0.28), const Color(0xffaaa5a5).withOpacity(0.28)],
            //         ),
            //         borderRadius: BorderRadius.circular(18.r)),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           'Current Location',
            //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18.sp),
            //         ),
            //         Icon(
            //           Icons.gps_fixed,
            //           color: Colors.white,
            //           size: 25.h,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: locationListController.locationList.length + 1,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // for (var location in locationListModel) {
                  //   locationsList.add(location.cityName);
                  // }
                  return index == locationListController.locationList.length
                      ? addNewButton()
                      : LocationListTile(
                          icon: locationListController.locationIcon[index].toString(),
                          index: index,
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                          cityName: locationListController.locationList[index],
                                        )));
                          },
                          onLongPress: () {
                            if (index != 0) {
                              // locationListController.locationList.removeAt(index);
                              // locationListController.locationWeather.removeAt(index);
                              // locationListController.locationTemp.removeAt(index);
                              // locationListController.locationIcon.removeAt(index);
                              // locationListController.locationHumidty.removeAt(index);
                              // locationListController.locationWind.removeAt(index);
                              // setState(() {});
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(Toast('Current Location'));
                            }
                          },
                          cityName: locationListController.locationList[index].toString(),
                          weather: locationListController.locationWeather[index].toString(),
                          humidity: locationListController.locationHumidty[index].toString(),
                          wind: locationListController.locationWind[index].toString(),
                          temp: locationListController.locationTemp[index].toString());
                })
          ],
        ),
      ),
    );
  }
}

Widget _myAppBar() {
  return Container(
    margin: EdgeInsets.only(top: 30.h),
    // color: Colors.red.shade200,
    height: 50.h,
    child: Text(
      'Saved Locations',
      style: TextStyle(color: Colors.white, fontSize: 18.sp),
    ),
  );
}

Widget addNewButton() {
  return InkWell(
    onTap: () {
      Get.to(() => const LocationListScreen());
    },
    child: Column(
      children: [
        Container(
          height: 60.h,
          margin: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.28), borderRadius: BorderRadius.circular(24.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/add.png',
                height: 24.h,
                color: Colors.white,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                'Add New',
                style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.w,
        ),
      ],
    ),
  );
}

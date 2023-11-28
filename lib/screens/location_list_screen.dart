import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/controller/location_list_controller.dart';

import '../models/all_locations_model.dart';
import 'home_screen.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key});

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  LocationListController locationListController = Get.put(LocationListController());

  @override
  Widget build(BuildContext context) {
    List<AllLocationsListModel> allLocationListModel = [
      AllLocationsListModel(cityName: 'London'),
      AllLocationsListModel(cityName: 'Paris'),
      AllLocationsListModel(cityName: 'New York'),
      AllLocationsListModel(cityName: 'Mumbai'),
    ];
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 10.h),
        children: [
          _myAppBar(),
          ListView.builder(
              itemCount: allLocationListModel.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    Get.to(() => HomeScreen(
                          cityName: allLocationListModel[index].cityName,
                        ));
                    locationListController.locationList.add(allLocationListModel[index].cityName);
                  },
                  child: Container(
                    // height: 20.h,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allLocationListModel[index].cityName.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        Divider(
                          color: Colors.grey.withOpacity(0.5),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

Widget _myAppBar() {
  return Container(
    margin: EdgeInsets.only(top: 30.h),
    // color: Colors.red.shade200,
    height: 50.h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Locations List',
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
            ),
          ],
        ),
        Image.asset(
          'assets/location.png',
          height: 22.h,
          color: Colors.white,
        ),
      ],
    ),
  );
}

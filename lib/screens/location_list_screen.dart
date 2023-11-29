import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/components/search_text_field.dart';
import 'package:weather_app/controller/location_list_controller.dart';

import '../components/toast.dart';
import '../models/all_locations_model.dart';
import 'home_screen.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key});

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  LocationListController locationListController = Get.put(LocationListController());

  Set<AllLocationsListModel> list = <AllLocationsListModel>{};
  @override
  Widget build(BuildContext context) {
    List<AllLocationsListModel> allLocationListModel = [
      AllLocationsListModel(cityName: 'London'),
      AllLocationsListModel(cityName: 'Paris'),
      AllLocationsListModel(cityName: 'New York'),
      AllLocationsListModel(cityName: 'Dubai'),
      AllLocationsListModel(cityName: 'Berlin'),
      AllLocationsListModel(cityName: 'Tokyo'),
      AllLocationsListModel(cityName: 'Rome'),
      AllLocationsListModel(cityName: 'Sydney'),
      AllLocationsListModel(cityName: 'California'),
    ];
    List<AllLocationsListModel> allLocationListModelI = [
      AllLocationsListModel(cityName: 'New Delhi'),
      AllLocationsListModel(cityName: 'Mumbai'),
      AllLocationsListModel(cityName: 'Bangalore'),
      AllLocationsListModel(cityName: 'Chennai'),
      AllLocationsListModel(cityName: 'Kolkata'),
      AllLocationsListModel(cityName: 'Surat'),
      AllLocationsListModel(cityName: 'Ahmedabad'),
    ];
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 0.h),
        children: [
          _myAppBar(),
          // GridView.extent(
          //   shrinkWrap: true,
          //   maxCrossAxisExtent: 100.0, // maximum item width
          //   mainAxisSpacing: 0.0, // spacing between rows
          //   crossAxisSpacing: 8.0, // spacing between columns
          //   physics: const NeverScrollableScrollPhysics(),
          //   // padding: EdgeInsets.symmetric(vertical: 20.h),
          //   children: allLocationListModelI.map((index) {
          //     return Wrap(
          //       children: [
          //         cityName1(index),
          //       ],
          //     );
          //   }).toList(),
          // ),
          SearchTextField(controller: searchController, locationListController: locationListController),
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Text(
              'Top Cities',
              style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400),
            ),
          ),
          Wrap(
            children: [...allLocationListModelI.map((e) => cityName1(e, locationListController)).toList()],
          ),
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Text(
              'Top Cities - World',
              style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w400),
            ),
          ),
          Wrap(
            children: [...allLocationListModel.map((e) => cityName1(e, locationListController)).toList()],
          ),
        ],
      ),
    );
  }

  Widget _myAppBar() {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      // color: Colors.red.shade200,
      height: 50.h,
      child: Text(
        'Locations',
        style: TextStyle(color: Colors.white, fontSize: 20.sp),
      ),
    );
  }

  Widget cityName(allLocationListModel, index) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      // height: 15.h,
      // width: 20.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
      child: Text(
        index.cityName.toString(),
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
    );
  }

  Widget cityName1(index, LocationListController locationListController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      child: FilterChip(
        elevation: 0,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        color: MaterialStatePropertyAll(Colors.grey.shade700),
        backgroundColor: Colors.grey.shade900,
        labelStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
        label: Text(index.cityName.toString()),
        selected: locationListController.locationList.contains(index.cityName),
        checkmarkColor: Colors.white.withOpacity(0.5),
        onSelected: (value) {
          setState(() {});
          if (value) {
            locationListController.locationList.add(index.cityName);
            Get.to(() => HomeScreen(
                  cityName: index.cityName.toString(),
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(Toast('Location Already Added'));
          }
        },
      ),
    );
  }
}

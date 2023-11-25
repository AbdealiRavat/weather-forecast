import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/models/location_list_model.dart';
import 'package:weather_app/screens/home_screen.dart';

import '../components/location_list_title.dart';

class SavedLocationsScreen extends StatefulWidget {
  const SavedLocationsScreen({super.key});

  @override
  State<SavedLocationsScreen> createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  // WeatherController weatherController = Get.put(WeatherController());
  List locationsList = [];
  String location = '';
  // fetchWeather() async {
  //   try {
  //     await weatherController.getWeather(locationsList[0]);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
  //
  // @override
  // void initState() {
  //   fetchWeather();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    List<LocationListModel> locationListModel = [
      LocationListModel(icon: '02d', cityName: 'London', weather: 'Sunny', humidity: '67', wind: '55', temp: '12'),
      LocationListModel(icon: '50dn', cityName: 'Paris', weather: 'Clear', humidity: '25', wind: '89', temp: '5'),
      LocationListModel(icon: '10n', cityName: 'New York', weather: 'Rain', humidity: '55', wind: '23', temp: '9'),
    ];
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff391A49), Color(0xff262171), Color(0xff391A49)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          ListView(
            // physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 10.h),
            children: [
              _myAppBar(),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: locationListModel.length + 1,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    for (var location in locationListModel) {
                      locationsList.add(location.cityName);
                    }
                    return index == 3
                        ? addNewButton()
                        : LocationListTile(
                            icon: locationListModel[index].icon.toString(),
                            onTap: () {
                              Get.offAll(() => HomeScreen(
                                    cityName: locationListModel[index].cityName,
                                  ));
                              // Navigator.pop(context, locationsList[0]);
                            },
                            cityName: locationListModel[index].cityName.toString(),
                            weather: locationListModel[index].weather.toString(),
                            humidity: locationListModel[index].humidity.toString(),
                            wind: locationListModel[index].wind.toString(),
                            temp: locationListModel[index].temp.toString());
                  })
            ],
          ),
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
              'Saved Locations',
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
          ],
        ),
        InkWell(
          child: Image.asset(
            'assets/search.png',
            height: 25.h,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget addNewButton() {
  return Container(
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
  );
}

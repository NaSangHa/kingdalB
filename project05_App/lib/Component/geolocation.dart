  
  
  // // 위도, 경도 구하기
  // _getCurrentLocation() {
  //   Geolocator
  //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.best,
  //     forceAndroidLocationManager: false)
  //     .then((Position position) {
  //       _currentPosition = position;
  //       setState(() {
  //         lat = '${position.latitude}';
  //         lon = '${position.longitude}';
  //       });
  //     }).catchError((e) {
  //       print(e);
  //     });
  // }

  // // 위도, 경도로 주소 구하기
  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       _currentPosition.latitude,
  //       _currentPosition.longitude
  //       );

  //       Placemark place = placemarks[0];
  //       print(place);

  //       setState(() {
  //         if(Platform.isAndroid) {
  //           currentAddress = "${place.street}";
  //         }
  //         else if(Platform.isIOS) {
  //           currentAddress = "${place.administrativeArea}" + 
  //                             "${place.locality}" +
  //                             "${place.street}";
  //         }
  //       });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
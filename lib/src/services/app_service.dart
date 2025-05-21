import 'dart:io';// تحديد هل االنظام  يعمل عليه التطبيق (Android أو iOS).

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:open_store/open_store.dart';


Future<void> openStore() async{
  await OpenStore.instance.open(
    androidAppBundleId: ''// name in app store
  );
}

Future<dynamic> deviceInfo() async{
  return Platform.isAndroid
      ? DeviceInfoPlugin().androidInfo
      : DeviceInfoPlugin().iosInfo;
}

Future<PackageInfo> packageInfo(){
  return PackageInfo.fromPlatform();
}

Future<String> deviceName() async{
  var device = await deviceInfo();

  if(device is AndroidDeviceInfo){
    return device.model;
  }
  if(device is IosDeviceInfo){
    return device.model;
  }
  return 'Different Platform';
}


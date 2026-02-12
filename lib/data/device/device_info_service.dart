import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    try {
      if (kIsWeb) {
        final WebBrowserInfo webBrowserInfo =
            await _deviceInfoPlugin.webBrowserInfo;
        return webBrowserInfo.vendor ??
            webBrowserInfo.userAgent ??
            'unknown_web_id';
      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo =
            await _deviceInfoPlugin.androidInfo;
        return androidInfo.id; // SSAID or Android ID
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown_ios_id'; // IDFV
      } else {
        return 'unknown_platform';
      }
    } catch (e) {
      return 'error_getting_device_id';
    }
  }
}

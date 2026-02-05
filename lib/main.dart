import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gongbab/app/router/app_router.dart';
import 'package:gongbab/di/injection.dart'; // DI 설정 파일 임포트

void main() async { // 비동기 초기화를 위해 main 함수를 async로 변경
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화 보장
  await configureDependencies();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: (context, child) => MaterialApp.router(
              routerConfig: AppRouter.router,
              title: 'gongbab',
              theme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF1a1f2e),
                primaryColor: const Color(0xFF3b82f6),
                fontFamily: 'Pretendard',
              ),
              debugShowCheckedModeBanner: false,
            ));
  }
}

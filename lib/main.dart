import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gongbab/app/router/app_router.dart';

void main() {
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

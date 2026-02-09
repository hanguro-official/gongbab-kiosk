import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gongbab/app/router/app_router.dart';
import 'package:gongbab/di/injection.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = getIt<AppRouter>().router;
    return ScreenUtilInit(
        builder: (context, child) => MaterialApp.router(
              routerConfig: router,
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

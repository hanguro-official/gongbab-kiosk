import 'package:flutter/material.dart';
import 'package:gongbab/app/ui/login/login_screen.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_screen.dart';
import 'package:gongbab/app/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab/app/ui/success/success_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.root,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.root,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.phoneNumberInput,
        builder: (BuildContext context, GoRouterState state) {
          return const PhoneNumberInputScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.success,
        builder: (BuildContext context, GoRouterState state) {
          return const SuccessScreen();
        },
      ),
    ],
  );
}

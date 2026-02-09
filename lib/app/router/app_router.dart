import 'package:flutter/material.dart';
import 'package:gongbab/app/ui/login/login_screen.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_screen.dart';
import 'package:gongbab/app/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab/app/ui/success/success_screen.dart';
import 'package:injectable/injectable.dart';
import 'package:gongbab/data/auth/auth_token_manager.dart';

@singleton
class AppRouter {
  final AuthTokenManager _authTokenManager;
  late final GoRouter router;

  AppRouter(this._authTokenManager) {
    router = GoRouter(
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
      redirect: (BuildContext context, GoRouterState state) async {
        final accessToken = await _authTokenManager.getAccessToken();
        final refreshToken = await _authTokenManager.getRefreshToken();

        final loggedIn = accessToken != null && refreshToken != null;
        final goingToLogin = state.matchedLocation == AppRoutes.root;

        // If not logged in and not going to login, redirect to login
        if (!loggedIn && !goingToLogin) {
          return AppRoutes.root;
        }
        // If logged in and going to login, redirect to phone number input
        if (loggedIn && goingToLogin) {
          return AppRoutes.phoneNumberInput;
        }

        // No redirect
        return null;
      },
    );
  }
}

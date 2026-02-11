import 'package:flutter/foundation.dart';
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
      redirect: (BuildContext context, GoRouterState state) => redirectLogic(context, state),
    );
  }

  @visibleForTesting // Make it visible for testing
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final accessToken = _authTokenManager.getAccessToken();
    final refreshToken = _authTokenManager.getRefreshToken();

    final loggedIn = accessToken != null && refreshToken != null;
    final goingToLogin = state.matchedLocation == AppRoutes.root;

    if (!loggedIn && !goingToLogin) {
      return AppRoutes.root;
    }
    if (loggedIn && goingToLogin) {
      return AppRoutes.phoneNumberInput;
    }
    return null;
  }
}

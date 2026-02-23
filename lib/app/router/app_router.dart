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
      refreshListenable: _authTokenManager,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.login,
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
    final loggedIn = _authTokenManager.getAccessToken() != null &&
        _authTokenManager.getRefreshToken() != null;
    final loggingIn = state.matchedLocation == AppRoutes.login;
    final currentPath = state.matchedLocation; // Get the current path

    // if the user is not logged in, they need to login
    if (!loggedIn) {
      return loggingIn ? null : AppRoutes.login;
    }

    // if the user is logged in but still on the login page, send them to
    // the home page
    if (loggingIn) {
      return AppRoutes.phoneNumberInput;
    }

    // If logged in and not on the login page, and the token was just refreshed,
    // we want to stay on the current page.
    // This is the crucial part to prevent unwanted navigation after a successful refresh.
    if (loggedIn && !loggingIn) {
      return currentPath; // Stay on the current path
    }

    // Fallback: no need to redirect at all (should ideally not be reached with the above logic)
    return null;
  }
}

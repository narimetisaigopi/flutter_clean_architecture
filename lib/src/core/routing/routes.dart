import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/src/core/core_exports.dart';
import 'package:flutter_clean_architecture/src/features/auth/auth_exports.dart';
import 'package:flutter_clean_architecture/src/features/home/home_exports.dart';
import 'package:flutter_clean_architecture/src/features/splash/splash_exports.dart';
import 'package:flutter_clean_architecture/src/shared/shared_exports.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final NetworkCubit network = getIt<NetworkCubit>();

bool isLoggedIn = true;

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteConstants.kSplashScreen.path,
  debugLogDiagnostics: true,
  refreshListenable: kIsWeb ? null : network.connectivityStatusNotifier,
  routes: <RouteBase>[
    GoRoute(
      name: RouteConstants.kSplashScreen.name,
      path: RouteConstants.kSplashScreen.path,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return MaterialPage<dynamic>(
          key: state.pageKey,
          child: const SplashScreen(),
        );
      },
    ),
    GoRoute(
      name: RouteConstants.kLoginScreen.name,
      path: RouteConstants.kLoginScreen.path,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return MaterialPage<dynamic>(
          key: state.pageKey,
          child: const LoginScreen(),
        );
      },
    ),
    GoRoute(
      name: RouteConstants.kSignUpScreen.name,
      path: RouteConstants.kSignUpScreen.path,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return MaterialPage<dynamic>(
          key: state.pageKey,
          child: const SignUpScreen(),
        );
      },
    ),
    GoRoute(
      name: RouteConstants.kOTPScreen.name,
      path: RouteConstants.kOTPScreen.path,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return MaterialPage<dynamic>(
          key: state.pageKey,
          child: const OTPScreen(),
        );
      },
    ),
    GoRoute(
      name: RouteConstants.kHomeScreen.name,
      path: RouteConstants.kHomeScreen.path,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return MaterialPage<dynamic>(
          key: state.pageKey,
          child: const ArticlesPage(),
        );
      },
    ),
    GoRoute(
      name: RouteConstants.kNoInternetScreen.name,
      path: RouteConstants.kNoInternetScreen.path,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return MaterialPage<dynamic>(
          key: state.pageKey,
          child: const NoInternetScreen(),
        );
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    final bool isOnLogginScreen =
        state.uri.toString() == RouteConstants.kLoginScreen.path;
    // Get the AppSharedPrefs instance using dependency injection
    final AppSharedPrefs sharedPref = getIt<AppSharedPrefs>();

    // Check if the network is disconnected
    if (!kIsWeb) {
      if (network.state.status == ConnectivityStatus.disconnected) {
        // Avoid storing the 'no-internet' route to prevent redirection loop
        if (state.fullPath != RouteConstants.kNoInternetScreen.path) {
          // Store the current route path for future redirection
          // sharedPref.setCurrentRoute(state.uri.path);
        }

        // Redirect to the 'no-internet' screen
        return RouteConstants.kNoInternetScreen.path;
      }
    }

    // If connected, check for a stored route
    final String storedRoute = await sharedPref.getCurrentRoute();

    if (storedRoute.isNotEmpty) {
      // Clear the stored route after retrieving it
      sharedPref.setCurrentRoute('');
      return storedRoute; // Redirect to the stored route
    }

    // Allow the default behavior if no stored route

    if (isLoggedIn && isOnLogginScreen) {
      return RouteConstants.kHomeScreen.path;
    }

    return null;
  },
);

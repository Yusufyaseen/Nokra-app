import 'package:get/get.dart';
import 'package:road_damage/logic/bindings/auth_biniding.dart';
import 'package:road_damage/view/screens/auth/confirm_password_screen.dart';
import 'package:road_damage/view/screens/auth/forgot_password_screen.dart';
import 'package:road_damage/view/screens/auth/login_screen.dart';
import 'package:road_damage/view/screens/auth/otp.dart';
import 'package:road_damage/view/screens/auth/profile.dart';
import 'package:road_damage/view/screens/auth/signup_screen.dart';
import 'package:road_damage/view/screens/data.dart';
import 'package:road_damage/view/screens/maps/maps.dart';
import 'package:road_damage/view/screens/pageView.dart';
import 'package:road_damage/view/screens/welcomescreen.dart';
import 'package:road_damage/view/splash_screen.dart';
import 'package:road_damage/view/widgets/loading_widget.dart';

class AppRoutes {
  // intial routes
  static const loadScreen = Routes.loadScreen;
  static const welcome = Routes.welcomeScreen;
  static const pageView = Routes.pageView;
  static const login = Routes.loginScreen;
  static const signUp = Routes.signUpScreen;
  static const forgetPass = Routes.forgetPassScreen;
  static const verificationScreen = Routes.verificationScreen;
  static const confirmPassword = Routes.confirmPasswordScreen;
  static const splashScreen = Routes.splashScreen;
  static const appdata = Routes.appdata;
  static const maps = Routes.maps;
  static const profileScreen = Routes.profileScreen;

  // get pages

  static final routes = [
    GetPage(
        name: Routes.loadScreen,
        page: () => const LoadingScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.splashScreen,
        page: () => const SplashScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.welcomeScreen,
        page: () => const WelcomeScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.pageView,
        page: () => PageViewInit(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.loginScreen,
        page: () => const LoginScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.signUpScreen,
        page: () => SignUpScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.forgetPassScreen,
        page: () => ForgotPasswordScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.profileScreen,
        page: () => ProfileScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.verificationScreen,
        page: () => const confirmSignUpScreen(
              email: '',
            ),
        binding: AuthBinding()),
    GetPage(
        name: Routes.confirmPasswordScreen,
        page: () => const confirmPasswordScreen(
              email: '',
            ),
        binding: AuthBinding()),
    GetPage(
        name: Routes.appdata,
        page: () => const Appdata(),
        binding: AuthBinding()),
    GetPage(name: Routes.maps, page: () => const Maps(), binding: AuthBinding())
  ];
}

class Routes {
  static const splashScreen = '/splashScreen';
  static const loadScreen = '/loadScreen';
  static const welcomeScreen = '/WelcomeScreen';
  static const pageView = '/pageView';

  static const loginScreen = '/LoginScreen';
  static const signUpScreen = '/signUpScreen';
  static const forgetPassScreen = '/forgetPassScreen';
  static const verificationScreen = '/verificationScreen';
  static const confirmPasswordScreen = '/confirmPasswordScreen';
  static const profileScreen = '/profilecreen';
  static const appdata = '/Appdata';
  static const maps = '/Maps';
}

import '../screens/AuthScreens/login_screen.dart';
import '../screens/HomeScreens/home_screen.dart';
import 'Routes_constants.dart';

class Routes {
  static final routes = {
    RoutesConstants.login: (context) =>  LoginScreen(),
    RoutesConstants.home: (context) => const HomeScreen(),
  };
}

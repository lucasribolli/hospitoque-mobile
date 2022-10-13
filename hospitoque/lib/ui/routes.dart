import 'package:flutter/material.dart';
import 'package:hospitoque/ui/auth_screen.dart';
import 'package:hospitoque/ui/home_screen.dart';
import 'package:hospitoque/ui/search_medicine_screen.dart';

class HospitoqueRouter {
  static const AUTH_ROUTE = '/';
  static const HOME_ROUTE = '/home';
  static const SEARCH_MEDICINE_ROUTE = '/search-medicine';
  static const LIST_MEDICINES_ROUTE = '/list-medicines';
  static const REGISTER_MEDICINE_CHECK_IN_ROUTE = '/check-in-medicine';
  static const REGISTER_MEDICINE_ROUTE = '/register-medicine';
  static const DISCARD_MEDICINE_ROUTE = '/discard-medicine';
  static const EDIT_MEDICINE_ROUTE = '/edit-medicine';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AUTH_ROUTE:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case HOME_ROUTE:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case SEARCH_MEDICINE_ROUTE:
        return MaterialPageRoute(builder: (_) => const SearchMedicineScreen());
      default:
        return _defaultRoute('404');
    }
  }

  static Route<dynamic> _defaultRoute(String text) => MaterialPageRoute(
    builder: (_) => Scaffold(
      body: Center(child: Text(text)),
    ),
  );
}
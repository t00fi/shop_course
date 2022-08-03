import 'package:flutter/material.dart';
import 'package:shop_course/screens/auth_screen.dart';
import 'package:shop_course/screens/cart_screen.dart';
import 'package:shop_course/screens/edit_products.dart';
import 'package:shop_course/screens/orders_screen.dart';
import 'package:shop_course/screens/product_detail.dart';
import 'package:shop_course/screens/products_overview.dart';
import 'package:shop_course/screens/user_product.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //this variable holds the data which passed by the Navigator.pushNamed() or others arguments
    //in thi app we dont need it since we dont have any variable (property) in any widget to be require to pass arguments to its constructor.
    /*
    final args = settings.arguments;
    */
    //settings.name-> means route name
    switch (settings.name) {
      case ProductOverview.routeName:
        return MaterialPageRoute(builder: (_) => const ProductOverview());
      case ProductDetail.routName:
        return MaterialPageRoute(builder: (_) => const ProductDetail());
      case CartScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case OrderScreen.routeName:
        return MaterialPageRoute(builder: (_) => const OrderScreen());
      case UserProduct.routeName:
        return MaterialPageRoute(builder: (_) => const UserProduct());
      case EditProducts.routeName:
        return MaterialPageRoute(builder: (_) => const EditProducts());
      case AuthScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Route Error'),
            centerTitle: true,
          ),
          body: const Center(
            child: Text('Erorr'),
          ),
        );
      },
    );
  }
}

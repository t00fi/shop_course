import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/cart.dart';
import 'package:shop_course/providers/orders.dart';
import 'package:shop_course/providers/product_provider.dart';
import 'package:shop_course/screens/auth_screen.dart';
import 'package:shop_course/screens/cart_screen.dart';
import 'package:shop_course/screens/edit_products.dart';
import 'package:shop_course/screens/orders_screen.dart';
import 'package:shop_course/screens/product_detail.dart';
import 'package:shop_course/screens/products_overview.dart';
import 'package:shop_course/screens/user_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Is an important difference between ChangeNotifierProvider.value and with the create function. When you're using Provider in a single list or grid item, Flatter removes items when they leave the screen and re adds them when they reentered the screen in such situations what actually happens is that the widget itself is reused by Flutter and just the data that's attached to it changes. So Flatter recycles the same widget it doesn't destroy it and recreate it. when we are using Provider with the create function.
///when ever we reuse an class mre than one place we shoud use ChangeNotifierProvider without .value()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///Providers are like a store for datas and used to change the state of a single state not to rebuild the entire child widget.
    ///ChangeNotifierProvider widget in Provider dependency which is used to create a provider for our app.
    ///because materialApp widget Or MyAPP Widget they are Root widget and ProductDetail and ProductOverview widget they are child of it then we use here.
    ///
    //when the data are in list use .value() is better because of widget recycle
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => ProdcutProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => Cart()),
        ),
        ChangeNotifierProvider(
          create: ((ctx) => Orders()),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber,
            primary: Colors.red[300],
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        //home: ProductOverview(),
        initialRoute: AuthScreen.routeName,
        routes: {
          ProductOverview.routeName: (context) => const ProductOverview(),
          ProductDetail.routName: (ctx) => const ProductDetail(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrderScreen.routeName: (context) => const OrderScreen(),
          UserProduct.routeName: (context) => const UserProduct(),
          EditProducts.routeName: (context) => const EditProducts(),
          AuthScreen.routeName: (context) => const AuthScreen(),
        },
      ),
    );
  }
}

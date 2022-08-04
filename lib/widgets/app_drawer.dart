import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/auth.dart';
import 'package:shop_course/screens/orders_screen.dart';
import 'package:shop_course/screens/products_overview.dart';
import 'package:shop_course/screens/user_product.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Shop Your Favorites'),
            //this property will not add (<-  back) to app bar because we dont have anything to back to it in drawer
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          //back to HProductOverview (home) screen
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductOverview.routeName);
            },
          ),
          const Divider(),
          //go to orders screen
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
          ),
          const Divider(),
          //go to orders screen
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProduct.routeName);
            },
          ),
          const Divider(),
          //logout
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('LogOut'),
            onTap: () {
              //close the drawer
              Navigator.of(context).pop();
              //go back to login
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/product_provider.dart';
import 'package:shop_course/screens/edit_products.dart';
import 'package:shop_course/widgets/app_drawer.dart';
import 'package:shop_course/widgets/user_product_item.dart';

class UserProduct extends StatelessWidget {
  const UserProduct({Key? key}) : super(key: key);
  static const routeName = '/user-product-screen';

  //a function when the user want to refresh screen with pulling the screen down fetch newest data
  //but we dont need this function because we already have all data in manage products its just for learning.
  Future<void> _refresData(BuildContext context) async {
    await Provider.of<ProdcutProvider>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final userProduct = Provider.of<ProdcutProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProducts.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      //just for learning
      body: //RefreshIndicator(
          // onRefresh: () => _refresData(context),
          // child:
          Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: userProduct.items.length,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  UserProductItem(
                    id: userProduct.items[index].id,
                    title: userProduct.items[index].title,
                    imageurl: userProduct.items[index].imageUrl,
                  ),
                  const Divider(),
                ],
              );
            }),
      ),
      // ),
    );
  }
}

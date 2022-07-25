import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/product_provider.dart';

import 'product_item.dart'; //the designed grid is here

//because only this widget is changeable so we extractt as a single widget to make more readble and work on it by our provide
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
    required this.showFav,
  }) : super(key: key);

  final bool showFav;
  @override
  Widget build(BuildContext context) {
    //get all product from provider class
    final productsData = Provider.of<ProdcutProvider>(context);
    //check which products to show if isFavorite is true just show favorite else all
    final products = showFav ? productsData.showFavorites : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //number of columns
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: products.length,
      //because each product it has fav button so we should create provider for it
      //when the data are in list use .value() is better because of widget recycle
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        //i pass products.items[index] to [create] property because its for each product
        //this is not wrong but our value doesnt depend on context so we use .value()
        //create: (ctx or _) => products.items[index],
        value: products[index],
        child: ProductItem(
            // id: products.items[index].id,
            // title: products.items[index].title,
            // price: products.items[index].price,
            // imageUrl: products.items[index].imageUrl,
            ),
      ),
    );
  }
}

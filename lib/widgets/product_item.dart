import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/products.dart';
import 'package:shop_course/screens/product_detail.dart';

import '../providers/cart.dart';

/// this class is used to create each item by grid and pass the dummy value to it.
/// then call this widget in product_overview widgt to create the grid and show it
/// so basiclly this widget is what what we see in screen all design is here
/// we will clled in ItemBuilder property in GridView.Builder() in ProductOverview widget

class ProductItem extends StatelessWidget {
  //these variables are used to pass dummydata to this widget from ProductOverview
  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;
  // constructor
  ProductItem({
    Key? key,
    //   required this.id,
    //   required this.title,
    //   required this.price,
    //   required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //the reason of listen:false is we dont want to rebuild our method and call build method again just because the favorite button is changed .
    //here i used only to get data and show it the favorite button we will use Consumer instead
    final eachProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        header: Text(
          eachProduct.title,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        footer: GridTileBar(
          //only iconButton will rebuld not the entire widget
          //the child parameter we can pass custom created widget
          //the child widget is not changed after consumer is executed
          //we use it in child property of Consumer widget
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              //if isFavorite is true fill if not put favorite icon border
              icon: Icon(
                eachProduct.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                //method to check value of isFavorite for the product in Product.dart
                eachProduct.toggleFavorite(eachProduct.id);
              },
            ),
          ),
          backgroundColor: Colors.black54,
          title: Text(
            '${eachProduct.price}',
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              //if the cart contain the specified item no need to show the snack bar every time when user preess on cart icon under product
              if (cart.items.containsKey(eachProduct.id)) {
                return;
              }
              //add items to cart
              cart.addItem(
                eachProduct.id,
                eachProduct.price,
                eachProduct.title,
                eachProduct.imageUrl,
              );

              ///adding snackbar when ever user add item to cart it shows a message that product added to cart.
              ///if you see we dont have Scaffold widget here and nether its parent which is ProductGrid widget but productGrid's parent (ProductOverview) has Scaffold widget which is nearest scaffold widget to productItem widget.
              ///because scaffold control entire page so we can added things to page

              //this line is used to hide any snack message before it says succesfully added cart
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Successfully Added To Cart!'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      //delete if user additem to cart
                      cart.removeItem(eachProduct.id);
                    },
                  ), //uses to to action for example undo
                ),
              );
            },
          ),
        ),
        //make the picture touchable to go to detail screen
        child: GestureDetector(
          onTap: () {
            //pass only the id of product to ProductDetail widget then we can see all its detail just by it id
            Navigator.of(context)
                .pushNamed(ProductDetail.routName, arguments: eachProduct.id);
          },
          child: Image.network(
            eachProduct.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

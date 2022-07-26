import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/product_provider.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key}) : super(key: key);
  static const routName = '/productDetail';
  @override
  Widget build(BuildContext context) {
    //get the id from Product_Item widget by arugemnts of routeName then we can get all data of the product by this id
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    //i used findProductId method from ProductProvider to compare the recieved product id with orginal item id
    final loadedProduct =
        //set the listen arguemnt to false because i dont want to rebuild it its just showing
        Provider.of<ProdcutProvider>(context, listen: false)
            .findProductId(productId);
    return Scaffold(
      //before sliver widget
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      //   centerTitle: true,
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            //when scroll the app bar will appear
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              //size of the z axis of the title (gawra krdn u gchka krd bo nawawa u darawa)
              expandedTitleScale: 1,
              title: Text(
                loadedProduct.title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Text(
                  '\$${loadedProduct.price}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
                //this is just for see our sliver effect
                const SizedBox(height: 800),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

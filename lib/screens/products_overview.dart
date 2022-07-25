import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/product_provider.dart';
import 'package:shop_course/screens/cart_screen.dart';
import 'package:shop_course/widgets/app_drawer.dart';
import 'package:shop_course/widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/product_grid.dart';

//this enum is more easier than selected value of popUpMenuItems
enum FilterOptions {
  favorites,
  all,
}

class ProductOverview extends StatefulWidget {
  const ProductOverview({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  //to control if statement in didchangeDependencies() to not run more than one time
  bool _isInit = true;
  //to see if loaded or not to show indicator
  bool _isLoading = false;
  //********************* */
  //we cant use context in initState() but there is another way which we can use future delay to use context inside it
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<ProdcutProvider>(context).fetchData();
  //   });
  //   super.initState();
  // }
  //********************* */
//or we can use didchangeDependencies()
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProdcutProvider>(context).fetchData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool _showOnlyFvorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Shop'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showOnlyFvorites = true;
                  } else {
                    _showOnlyFvorites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOptions.favorites,
                      child: Text('Show Favorites'),
                    ),
                    const PopupMenuItem(
                      value: FilterOptions.all,
                      child: Text('Show All'),
                    ),
                  ],
              icon: const Icon(Icons.more_vert)),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              //tostring() because in badge the int value is as string
              value: cart.itemCount.toString(),
              child: ch as Widget,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      //if the data is loading show indicator if its finished show our grid of product.
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFav: _showOnlyFvorites),
    );
  }
}

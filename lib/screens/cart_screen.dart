import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/orders.dart';

///here bot cart.dart and cart_item.dart has widget with the name CartItem
///so how we can access CartItem we want in which file:
///1- we can use (show) keyword for cart.dart file which there is two class in it but i want to pick the Cart widget which we only ysed for provider in build() method.
///2-we can ass (ass "any name") to make object for the file and access the CartItem of that file
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart'; //as CI

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    //i removed listen:false because we i order products all items will be deleted in cart so it should rebuild the widget
    final cart = Provider.of<Cart>(
      context,
      //listen:false
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) =>
                  //or CI.CartItem
                  CartItem(
                //or CI.CartItem
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys
                    .toList()[index], //or key in map is product id
                title: cart.items.values.toList()[index].title,
                image: cart.items.values.toList()[index].imageUrl,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                index: index,
              ),
              itemCount: cart.items.length,
            ),
          ),
          Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  //take all available space
                  const Spacer(),
                  Consumer<Cart>(
                    builder: (context, value, child) => Chip(
                      label: Text(
                        '\$${cart.totalAmount}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              ?.color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///we only use this button in this file not outside thats why its in same filewith stateLess widget.
///its satefull widget because its rebuild just its build method in above statelss widget, its better practice like this to not rebuild all the widget.
class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                //add order and clear the cart
                await Provider.of<Orders>(context, listen: false).addOrders(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                );
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clearCart();
              } catch (err) {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      content: const Text('Failed to order!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: const Text('Okay'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
    );
  }
}

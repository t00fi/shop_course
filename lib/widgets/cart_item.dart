import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/cart.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.id,
    required this.title,
    required this.productId,
    required this.image,
    required this.price,
    required this.quantity,
    required this.index,
  }) : super(key: key);

  final String id;
  final String title;
  final String image;
  final double price;
  final int quantity;
  final String productId;
  //this index is used in icons() method to get the quantity of that index
  final int index;
//method to create two icon button for increment and decreament
  Widget icons(IconData icon, Cart cart, BuildContext context) {
    return IconButton(
      onPressed: () {
        if (icon == Icons.add) {
          cart.increament(index);
        } else {
          cart.decreament(index);
        }
      },
      icon: Icon(
        icon,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    //dismissible is a widget which we can make our widget to bi swipable
    return Dismissible(
      key: ValueKey(id),
      //is the background of swapable
      background: Container(
        //this margin is like Card() widget in child of dismissible() wodget to make the container same size of the card
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.only(right: 10),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      //make only swipe to left
      direction: DismissDirection.endToStart,
      //confirm if the user want to remove or not
      //show dialog for that
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Are You Sure?'),
                content: const Text(
                    'Do you want to  remove the item from the cart ?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        //dialog need to return future
                        //the returned {false-true} are for future 
                        Navigator.pop(ctx, false);
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx, true);
                      },
                      child: const Text('Yes')),
                ],
              );
            });
      },
      //the parameter of ondismissed() method could be direction of swipe
      onDismissed: (direction) {
        //call removeItem() method from Cart Class in cart.dart file
        cart.removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Image.network(image),
            trailing: FittedBox(
              child: Column(
                children: [
                  icons(Icons.add, cart, context),
                  Consumer<Cart>(
                    builder: (ctx, c, child) => Text(
                      '${cart.items.values.toList()[index].quantity}',
                      style: const TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                  icons(Icons.remove, cart, context),
                ],
              ),
            ),
            title: Text(title),
            //toStringAsFixed() to show 2 digits after fariza
            subtitle: Text('Total \$${(price * quantity).toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }
}

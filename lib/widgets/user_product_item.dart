import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/product_provider.dart';
import 'package:shop_course/screens/edit_products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageurl,
  }) : super(key: key);

  final String id;
  final String title;
  final String imageurl;
  @override
  Widget build(BuildContext context) {
    //the reason to initialze this scaffold variable because context not work correctly in future callbacks.
    //we will use it in onPressed(){} function for delete product
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing: SizedBox(
        width: 96,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProducts.routeName, arguments: id);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  //delete item
                  await Provider.of<ProdcutProvider>(context, listen: false)
                      .removeItem(id);
                } catch (err) {
                  //hide if there is any other snackbar.
                  scaffold.hideCurrentSnackBar();
                  //show new snackbar
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text('Deleting Failed!'),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//show Orders because we also have OrderItem class in orders.dart file which is reflects with OrderItem in orders_screen.dart file
import 'package:shop_course/providers/orders.dart' show Orders;
import 'package:shop_course/widgets/app_drawer.dart';
import 'package:shop_course/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ///  we can use this provider without future property because we use listen:false.
  //     await Provider.of<Orders>(context, listen: false).fetchOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }
//******************** */
//the following codes until build method is for:
//- when ever we have any change in listenres or change state i dont want to send get request all time in futureBuilder() widget so :
  late Future _orderFuture;
  Future _obtainOrderFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('err occured'));
            //do some err stuff
          } else {
            return Consumer<Orders>(
              builder: (ctx, orders, child) => ListView.builder(
                itemCount: orders.orederItems.length,
                itemBuilder: (ctx, index) {
                  return OrderItem(orderedStructure: orders.orederItems[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

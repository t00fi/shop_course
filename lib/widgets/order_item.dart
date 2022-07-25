import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    Key? key,
    required this.orderedStructure,
  }) : super(key: key);
  final OrderStructure orderedStructure;
  @override
  Widget build(BuildContext context) {
    final orderedProduct = orderedStructure.cartProducts;
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text('${orderedStructure.amount}'),
        subtitle:
            Text(DateFormat('dd/MM/yyyy').format(orderedStructure.dateTime)),
        children: [
          ListView.builder(
            itemCount: orderedProduct.length,
            itemBuilder: (ctx, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    orderedProduct[index].title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${orderedProduct[index].quantity}x \$${orderedProduct[index].price}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  )
                ],
              );
            },
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
///i improve my code this is bad practice

// import 'package:flutter/material.dart';
// import '../providers/orders.dart' as oi;
// import 'package:intl/intl.dart';
// import 'dart:math'; //used to min() method

// class OrderItem extends StatefulWidget {
//   const OrderItem({
//     Key? key,
//     required this.orders,
//   }) : super(key: key);
//   //this orderItem is from orders.dart file we use prefix for it because we dont want to clash with this file orderItem
//   final oi.OrderItem orders;
//   @override
//   State<OrderItem> createState() => _OrderItemState();
// }

// class _OrderItemState extends State<OrderItem> {
//   //this variable is used for each card is expande(growed) when we click on the icon to see more data of our each order in orderScreen
//   bool _expanded = false;

//   ///instead of using all these code and _expanded variable to expand and open container we can user ExpansionTile widget is more simpler and cleaner.
//   @override
//   Widget build(BuildContext context) {
//     final orderdProducts = widget.orders.cartProducts;
//     return Card(
//       margin: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           ListTile(
//             title: Text('\$${widget.orders.amount}'),
//             subtitle:
//                 Text(DateFormat('dd/MM/yyyy').format(widget.orders.dateTime)),
//             trailing: IconButton(
//               onPressed: () {
//                 setState(() {
//                   _expanded = !_expanded;
//                 });
//               },
//               icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
//             ),
//           ),
//           //when we click on arrow button the _expanded will be true and the container will show like its expandable card
//           if (_expanded)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//               //the max will 100 pixel
//               height: min(orderdProducts.length * 20.0 + 10.0, 100),
//               child: ListView.builder(
//                   itemCount: orderdProducts.length,
//                   itemBuilder: (ctx, index) {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           orderdProducts[index].title,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           '${orderdProducts[index].quantity}x \$${orderdProducts[index].price}',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             color: Colors.grey,
//                           ),
//                         )
//                       ],
//                     );
//                   }),
//             )
//         ],
//       ),
//     );
//   }
// }

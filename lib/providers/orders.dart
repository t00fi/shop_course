import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_course/providers/cart.dart';

class OrderStructure {
  final String id;
  final double amount;
  List<CartItem> cartProducts;
  final DateTime dateTime;

  OrderStructure({
    required this.id,
    required this.amount,
    required this.cartProducts,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderStructure> _orders = [];

  List<OrderStructure> get orederItems {
    return [..._orders];
  }

  //fetch orders from firebase
  Future<void> fetchOrders() async {
    const url =
        'https://shopappcourse-4f632-default-rtdb.firebaseio.com/orders.json';
    //send get() request
    final response = await http.get(Uri.parse(url));
    final extractedOrders = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedOrders.isEmpty) {
      return;
    }
    List<OrderStructure> loadedOrders = [];
    extractedOrders.forEach(
      (keyId, orderStructData) {
        loadedOrders.add(
          OrderStructure(
            id: keyId,
            amount: orderStructData['amount'],
            dateTime: DateTime.parse(orderStructData['datetime']),
            cartProducts: (orderStructData['products'] as List<dynamic>)
                .map(
                  (cart) => CartItem(
                    id: cart['id'],
                    title: cart['title'],
                    price: cart['price'],
                    quantity: cart['quantity'],
                    imageUrl: cart['imageUrl'],
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    //reversed to show it newest orders first in order_secreen.
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> items, double total) async {
    //i wrtoe 0 to parameter because last order i want to be most recent one to be add not add to last one
    //timeStamp variable is used because when we add orders it will wait for a seconds so the time which will be added to the firebase will be different with time added to orderStructure().
    final timeStamp = DateTime.now();
    const url =
        'https://shopappcourse-4f632-default-rtdb.firebaseio.com/orders.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'amount': total,
            //method toIso8601String() is good for when we fetch data later to convert it back to datetime.
            'datetime': timeStamp.toIso8601String(),
            'products': items
                .map(
                  (products) => {
                    'id': products.id,
                    'title': products.title,
                    'quantity': products.quantity,
                    'price': products.price,
                    'imageUrl': products.imageUrl,
                  },
                )
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderStructure(
          id: json.decode(response.body)['name'],
          amount: total,
          cartProducts: items,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }
}
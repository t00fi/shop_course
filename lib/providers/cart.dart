import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;
  final String imageUrl;
  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  //the key of map is String because we use Product id is string and we use as a key for each CartItem
  final Map<String, CartItem> _items = {};

  //method tp put the items in orginal map _items
  Map<String, CartItem> get items {
    return {..._items};
  }

  //method to count the number of product added to cart
  int get itemCount {
    return _items.length;
  }

  //getter method for tootal amount of cart
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cart) {
      total += (cart.price * cart.quantity);
    });
    return total;
  }

  //method to add items to cart
  void addItem(String productId, double price, String title, String image) {
    //if the item not in the cart
    if (!(_items.containsKey(productId))) {
      //putIfAbsent() is a method which check the key in the map if absent (not exist) it will add to the map
      _items.putIfAbsent(
        productId,
        () => CartItem(
          //for the id we will add datetime.now() we can change it too
          id: DateTime.now().toString(),
          title: title,
          price: price,
          imageUrl: image,
          //because there isnt item in cart so first time the quntity is 1
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void increament(int index) {
    _items.values.toList()[index].quantity++;
    notifyListeners();
  }

  void decreament(int index) {
    if (!(_items.values.toList()[index].quantity == 1)) {
      _items.values.toList()[index].quantity--;
      notifyListeners();
    }
  }

  //method to remove product from cart according to product id
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  //remove item from cart when user press undo button from snackbar
  void removeWithUndo(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
    }
    notifyListeners();
  }

  //after we ordered we should clear the cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

//before was like that  if product was exist when ever we press cart icon on the product grid it will add by one so i deleted like that .

//method to add items to cart
  // void addItem(String productId, double price, String title, String image) {
  //   //if the key is exist (productId) in the map we will just add quantity by one
  //   if (_items.containsKey(productId)) {
  //     //update of the provided key which passed here and add quantity by 1
  //     _items.update(
  //         productId,
  //         //existingValue is holding same values but we only add quantity by 1
  //         (existingValue) => CartItem(
  //               id: existingValue.id,
  //               title: existingValue.title,
  //               price: existingValue.price,
  //               imageUrl: existingValue.imageUrl,
  //               quantity: existingValue.quantity + 1,
  //             ));
  //   } //if the item not in the cart
  //   else {
  //     //putIfAbsent() is a method which check the key in the map if absent (not exist) it will add to the map
  //     _items.putIfAbsent(
  //       productId,
  //       () => CartItem(
  //         //for the id we will add datetime.now() we can change it too
  //         id: DateTime.now().toString(),
  //         title: title,
  //         price: price,
  //         imageUrl: image,
  //         //because there isnt item in cart so first time the quntity is 1
  //         quantity: 1,
  //       ),
  //     );
  //   }
  //   notifyListeners();
  // }
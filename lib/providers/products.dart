import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  //this is not final because after the product is created the state of this var is changed from fav->unFav and vice versa
  bool isFavorite;

  //constructor
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite =
        false, //not neccasry reqired to create a product and its default value is false
  });

  //function to update values
  void copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
    notifyListeners();
  }

//passing user token  to see each user's favorite products
  Future<void> toggleFavorite(String token) async {
    final url =
        'https://shopappcourse-4f632-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
    //get old value of favorite before chnge it
    final oldStatus = isFavorite;
    //if its false make it true else make it true
    isFavorite = !isFavorite;
    notifyListeners();
    //http reques will not throw excepton for (delete,patch) request so we check for err by if statement to check the http status code.
    //the catch() is for network errs in case we have it not fot http request as we said it will not throw exception.
    try {
      //send patch() request to toggle favorite
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        _setNewValue(oldStatus);
      }
    } catch (err) {
      //if there is network err also i need old value of isFavorite variable..
      _setNewValue(oldStatus);
    }
  }

  //function to set the same value of isFavorite.
  void _setNewValue(bool newalue) {
    isFavorite = newalue;
    notifyListeners();
  }
}

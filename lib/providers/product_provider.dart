import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_course/models/http_exception.dart';
import 'products.dart';

class ProdcutProvider with ChangeNotifier {
  List<Product> _items = [
    //before we used for static data but now we will get from firebase
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  //this getter is used to take a copy of original list of product because we dont want to modify orginal first the copy of it then send to orginal
  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFavorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  //a method return the the product by its id we used in ProductDetails screen
  Product findProductId(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

//the variable authToken here is needed for sending the request to fetch our data.
////we get the token by setter method.
  late String _authToken;
  late String _userId;

  //setters
  set setAuthToken(String authToken) {
    _authToken = authToken;
  }

  set setUserId(String userId) {
    _userId = userId;
  }

//getters
  String get _getAuthToken => _authToken;
  String get _getUserId => _userId;

//fetch data from firebase
//to set the default value for positinal paramaeter we should wrap it the variable in [] and specify its default value
  Future<void> fetchData([bool isFiltered = false]) async {
    //sending the authToken to the query parameter.
    //some other Api's require to send the token by headers in post() request method.
    //order by creatorId where user=userId logged in
    /**
     * but we should add index to my products because we have orderBy:
     * 
     * {
     * "rules": {
                ".read":"auth!=null" ,	 // 2022-8-12
                ".write":"auth!=null", 	// 2022-8-12
                 "products":{
                  ".indexOn":["creatorId"],
      }
  }
}
     * 
     */
    final filterString =
        isFiltered ? '&orderBy="creatorId"&equalTo="$_getUserId"' : '';
    var url =
        'https://shopappcourse-4f632-default-rtdb.firebaseio.com/products.json?auth=$_getAuthToken$filterString';

    try {
      final response = await http.get(Uri.parse(url.toString()));
      //if your print the response you will get data as Map<String, dynamic>
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      //fav url
      url =
          'https://shopappcourse-4f632-default-rtdb.firebaseio.com/userFavorites/$_getUserId.json/?auth=$_getAuthToken';
      //fetching favorite products for each user
      final favoriteResponse = await http.get(Uri.parse(url));
      final favResponseData = json.decode(favoriteResponse.body);
      final List<Product> loadedProduct = [];
      //for the map we got we will go through each product to add to our list
      extractedData.forEach(
        (key, productData) {
          loadedProduct.insert(
            0,
            Product(
              id: key,
              title: productData['title'],
              description: productData['description'],
              price: productData['price'],
              imageUrl: productData['imageUrl'],
              isFavorite: favResponseData == null
                  ? false
                  : favResponseData[key] ?? false,
            ),
          );
        },
      );
      _items = loadedProduct;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

//the reason we made this function from void to future void is in adding product screen when we add products we want to make a better user interaction we want to make a indicator after request which indicator will spin is finish then show the list of products .
//when adding this to future we can also make addProducts().then() to execute something in future
//the function became  future  with keyword async so it will automatically return Future value no need to type return in http.post() request
  Future<void> addProduct(Product product) async {
    //sending post request to firebase
    //and create a file with name poriducts.json
    //first we should bring the url in fire stor then specify the file.json
    // (/products.json) added to firebase link not all databases is work like that with endpoints.
    final url =
        'https://shopappcourse-4f632-default-rtdb.firebaseio.com/products.json?auth=$_getAuthToken';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'id': DateTime.now().toString(),
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': _getUserId,
        }),
        //the reason i didnt call catError() here because if there is an error from the request this method will call then then() method will call and because if its error it mean i dont want to add anything thats why i dont want call then() method if there is err i will call it after then() mthod and if there is an error then() method will be skiped
      ); //.catchError((err){
      //print(response.body);
      final newproduct = Product(
        //the id will the response key we see in each products key
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      //adding the product to last index
      _items.add(newproduct);
      //this function is inbuilt its used when ever the product is aded it will notify the widget and create it self again it uses with ChangeNotifier mixin
      notifyListeners();
    } catch (err) {
      rethrow;
    }

    //})
    // .then((response) {
    ///then() method is for future and it has response parameter.
    ///it works when the post() request finished.
    ///the response has its value which it is a key we see it in firebase for each product.
    ///when we add the product it will not imediatly added to the list it will wait unit request is finished so we will bring below code inside then() method.

    //we will se in responose.body there is a key which is identical to the key of each product in firebase and we will make it as id for products we added to firebase.
    //the response is a map its key is {'name':''}

    // })
    //if there is error then() method willbe skiped and the error will be hundled here.
    //.catchError((err) {
    //we will create another object for the err parameter with keyword (throw) which we can hundle this error in another place with this addProduct Method().
    //we will use this err object in edit_product screen.
    //throw err;
    // });
    /******************************** */
    //we will take this code inside try Catch method above.
    //  final newproduct = Product(
    //   id: DateTime.now().toString(),
    //   title: product.title,
    //   description: product.description,
    //   price: product.price,
    //   imageUrl: product.imageUrl,
    // );
    //adding the product to last index
    // _items.add(newproduct);
    //this function is inbuilt its used when ever the product is aded it will notify the widget and create it self again it uses with ChangeNotifier mixin
    //notifyListeners();
    /******************************** */
  }

  Future<void> update(String id, Product product) async {
    final productindex = _items.indexWhere((element) => element.id == id);
    if (productindex >= 0) {
      //for addProduct() and fetchData() we use url and its path refrenced to all products but here i want to work with specific product which we specify it id.
      final url =
          'https://shopappcourse-4f632-default-rtdb.firebaseio.com/products/$id.json?auth=$_getAuthToken';
      //sending patch() request to firebase which is a request merge old value with new value
      await http.patch(
        Uri.parse(url.toString()),
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.title,
          },
        ),
      );
      _items[productindex] = product;
      notifyListeners();
    } else {
      debugPrint('Index not in boundary');
    }
  }

//method to delete item from manage products section
  Future<void> removeItem(String id) async {
    final url =
        'https://shopappcourse-4f632-default-rtdb.firebaseio.com/products/$id.json?auth=$_getAuthToken';
    /** implementing optimistic update
     * 1- create a variable to get the index of the specific product by id
     * 2- create a variable which holds a copy of the product. which will be added again to the _items list if the    request is failed , if successed will be null.
     * 
     */

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    //this variable is helper when ever the request is failed this product will be added to list again.
    //Product? existingProduct = _items[existingProductIndex];

    final response = await http.delete(Uri.parse(url));
    //if >=400 means there is an error
    if (response.statusCode >= 400) {
      // _items[existingProductIndex] = existingProduct;
      //because we add it again
      // notifyListeners();
      //throw custom exception we created in models folder
      throw HttpException('Could not delete the product!');
    }
    //if throw not executed so we will reach this line
    //we equaled to null means successfully deleted.
    //existingProduct = null;
    //remove from the list before the request
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }
}

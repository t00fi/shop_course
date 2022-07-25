import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_course/providers/product_provider.dart';
import 'package:shop_course/providers/products.dart';

class EditProducts extends StatefulWidget {
  const EditProducts({Key? key}) : super(key: key);
  static const routeName = '/edit-products';
  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  //if we want to jump form one input field to another we should create focus node for the field that we want to jump to it
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  //create input controller for image input because i want to upload image url into container and check if the input is empty or not?
  final _imageurlController = TextEditingController();
  //this image focus node is used to listen to change in image url field when ever it lose its focus we want to update the UI.
  final _imageUrlFocusNode = FocusNode();

//regular expression validation for image url
  var urlPattern =
      r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:,.;]*)?";
//create new product with some initial values
  var editedProduct =
      Product(id: '', title: '', description: '', price: 0.0, imageUrl: '');

  ///we should create a globalKey for our {Form} widget to acces it out side of it and check its current state.
  ///globalKey has provider and that provider shoud be statefullWidget.
  ///FormState is a statefulWidget.
  final _editedForm = GlobalKey<FormState>();

  //this variable is for if its true we want to show circular indicator to make user wait until the request or edit is finished.
  bool _isLoading = false;
  //variable used in didChangeDependecies() to store prodcut id
  var productId;

  //function to save our Form data
  Future<void> saveForm() async {
    //fire the Validator function in each TextField if all validator is correct so it will save if not jjust return.
    final isValid = _editedForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    //save the form
    _editedForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    //this if statement is for if we have id means we want to edit the product we click on edit icon not add button in action bar in manage products screen.
    if (editedProduct.id != '') {
      //when we tap save icon we will call update function in productprovider file
      await Provider.of<ProdcutProvider>(context, listen: false)
          .update(productId, editedProduct);
      /**************** */
      //we took it below if statement because its same fo all if statement we dont need to call it for each of them and since we waiting for the operation to complete so take it below if statements.
      //       setState(() {
      //   _isLoading = false;
      // });
      // //save and exit to edit your products.
      // Navigator.of(context).pop();
      /**************** */
    } else {
      try {
        //add the product if its not edtitng
        await Provider.of<ProdcutProvider>(context, listen: false)
            .addProduct(editedProduct);
      } catch (err) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('An error occured'),
                content: const Text('Something went wrong!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            });
        //finally will be called when ever there is error or not
        //before we add setState() below it wa un-commented but since we wait for each request above then this opration will happen no need to call setState() for each of them
      } //finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }

    }
    setState(() {
      _isLoading = false;
    });
    //save and exit to edit your products.
    Navigator.of(context).pop();

    //the err object created with keyword throw in provider file will be hundled here .
    // i create a dialog if there any error happen
    //.catchError((err) {
    //     return showDialog(
    //         context: context,
    //         builder: (ctx) {
    //           return AlertDialog(
    //             title: const Text('An error occured'),
    //             content: const Text('Something went wrong!'),
    //             actions: [
    //               TextButton(
    //                 onPressed: () {
    //                   Navigator.of(ctx).pop();
    //                 },
    //                 child: const Text('Okay'),
    //               ),
    //             ],
    //           );
    //         });
    //   }).then((_) {
    // setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    //   });
    // }

    //save and exit to edit your products.
    //before adding indicator  we imediatly pop when adding products to list and firebase
    //Navigator.of(context).pop();
  }

//used for control our if statement in didChangeDependicies because it run multiple times.
  var _init = true;
  //function to check if the imageurl field focus has been changed
  void _updateImageUrl() {
    //when ever image url has lost focus update ui
    if (!(_imageUrlFocusNode.hasFocus)) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      //this if statement when we click on add button in manage products screen we dont pass any arguments by navigator and we cant cast null value to string so we should first check if its not null.
      if (ModalRoute.of(context)!.settings.arguments != null) {
        productId = ModalRoute.of(context)!.settings.arguments as String;
      }
      //this if statement is for when ever we want to add product we will not get ProductId  ABOVE tofind a product.
      //productId will only not be null when we click on edit button for existed products, otherwise it means we want to add product.
      if (productId != null) {
        editedProduct = Provider.of<ProdcutProvider>(context, listen: false)
            .findProductId(productId);
        _imageurlController.text = editedProduct.imageUrl;
      } else {}
    }
    _init = false;
    super.didChangeDependencies();
  }

  //init state i used to when widget is created i check if the the imageurl lost its focus and fire my function
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  //when we work with FocusNode() we should dispose them because when ever user leave the screen it will make memory leaks.
  @override
  void dispose() {
    //then we should remove our listener
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageurlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              //when using Forms if we have long list/ landScape mode is better to use column combined with SingleChildScrollView widget .
              //here we have small list and its portrait mode so we use listview inside form.
              child: Form(
                key: _editedForm,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: editedProduct.title,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        //errorStyle:  we can style our error for validator function.
                      ),
                      //this property is used when sometime in bottom right of your keyboard you have (done,next..etc)
                      //will go to next text field
                      textInputAction: TextInputAction.next,
                      //this method i used  for jump to price field
                      onFieldSubmitted: (_) {
                        //request focus to price
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                          id: editedProduct.id,
                          title: value.toString(),
                          description: editedProduct.description,
                          price: editedProduct.price,
                          imageUrl: editedProduct.imageUrl,
                          isFavorite: editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Provide a Value.';
                        }
                        //means no eeror
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: editedProduct.price.toString(),
                      decoration: const InputDecoration(
                        hintText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      //specify our focus node that we initialized above
                      focusNode: _priceFocusNode,
                      //on (next) button keyboard will go to description field
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                          id: editedProduct.id,
                          title: editedProduct.title,
                          description: editedProduct.description,
                          price: double.parse(value.toString()),
                          imageUrl: editedProduct.imageUrl,
                          isFavorite: editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter a Number.';
                        }
                        //used tryParse() method to check its parsable or not
                        if (double.tryParse(value) == null) {
                          return 'Please Enter a Valid Number.';
                        }
                        //here we know that tryparse() is successed but we will check if the price is >=0
                        if (double.parse(value) <= 0) {
                          return 'Please Enter a Number greater than zero.';
                        }
                        //mean successs
                        return null;
                      },
                    ),
                    //adding multi line input
                    TextFormField(
                      initialValue: editedProduct.description,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      //textInputAction: TextInputAction.next,
                      ///we dont need (TextInputAction.next) because its multiline and we dont know when the user wil finisht its texsting and ther is only enter keyboard in the bottom right of the keyboard.
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      //specify our focus node that we initialized above
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        editedProduct = Product(
                          id: editedProduct.id,
                          title: editedProduct.title,
                          description: value.toString(),
                          price: editedProduct.price,
                          imageUrl: editedProduct.imageUrl,
                          isFavorite: editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'should be 10 character long.';
                        }
                        //mean success
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 15, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageurlController.text.isEmpty
                              ? const Text('Please enter Image Url')
                              : FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.network(
                                    _imageurlController.text,
                                  ),
                                ),
                        ),
                        //wrap the textfield with expanded because row doesnt have constraint boundry and textfied doesnt have width boundry.
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Image Url',
                            ),
                            controller: _imageurlController,
                            focusNode: _imageUrlFocusNode,
                            onSaved: (value) {
                              editedProduct = Product(
                                id: editedProduct.id,
                                title: editedProduct.title,
                                description: editedProduct.description,
                                price: editedProduct.price,
                                imageUrl: value.toString(),
                                isFavorite: editedProduct.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Image URL.';
                              }
                              //using regExp class to check our url value
                              if (!(RegExp(urlPattern, caseSensitive: false)
                                  .hasMatch(value.toString()))) {
                                return 'Please enter valid URL';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

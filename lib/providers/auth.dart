import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  //all these variable will change during lifetime especcially the token
  late String _token;
  late DateTime
      _expiryDateToken; //token usuallly expire after one hour and this is security mechanism
  late String userId; //each user has its id;

  //signup method
  Future<void> signup(String email, String password) async {
    ///search for {firebase auth rest api -singup with email/password} in google to get this url.
    ///the api key i bring it from my firebase {project overview-project setting-web api key} .
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBrPeJywtlVfMd8LfDvBjvoPz5vi0sCWt8';
    //the post request also is in the {firebase auth rest api} website watch to learn more.
    final resposne = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true, //always true
        },
      ),
    );
  }
}

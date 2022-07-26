import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  //all these variable will change during lifetime especcially the token
  String _token = '';
  late DateTime
      _expiryDateToken; //token usuallly expire after one hour and this is security mechanism
  String _userId = ''; //each user has its id;
  late Timer _authTimer;
//getter method to check the token
  bool get isAuth {
    //if getter token is not empty so its authinticated.
    return token != '';
  }

//getter to check the expire date and token and call it in (isAuth) getter above.
  String get token {
    if (_token != '' && _expiryDateToken.isAfter(DateTime.now())) {
      return _token;
    }
    return '';
  }

  //get user id
  String get userId {
    return _userId;
  }

//authinticate method
//the url link is same for signup and sign in just the segment change .
  Future<void> _authinticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBrPeJywtlVfMd8LfDvBjvoPz5vi0sCWt8';
    try {
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
      //as we know the http package doesnt have error hundling so we should check if any error happens with (statuscode).
      //check the response body thats why i created this variable
      //print(response.body);
      final responseData = json.decode(resposne.body);
      //the if statement means if we have error object its value means we have problem even if its statuscode 200.
      //if we dont have it error object in map means no problems
      if (responseData['error'] != null) {
        //call the httpException bject in htt_exception.dart file.
        throw HttpException(responseData['error']['message']);
      }
      //so if we dont have any exception we will assign tokens from post request response
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      //as in firebase documentation is eplained the date should be integer so we parse it to integer and add these secondes.
      _expiryDateToken = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      //storing auth data in memory by shared preference package.
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDateToken.toIso8601String(),
        },
      );
      //create a key with the name userData and store userData variable values in it.
      prefs.setString('userData', userData);
      //call tryAutoLogin() method
    } catch (err) {
      //this catch hundling error is for other error not statuscode of http request
    }
  }

  //auto login mthod
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    //if we dont have data return false.
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryDateToken = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  //signup method
  Future<void> signup(String email, String password) async {
    ///search for {firebase auth rest api -singup with email/password} in google to get this url.
    ///the api key i bring it from my firebase {project overview-project setting-web api key} .
    return _authinticate(email, password, 'signUp');
  }

  //signin method
  Future<void> signin(String email, String password) async {
    return _authinticate(email, password, 'signInWithPassword');
  }

  //logout by user when click on logout
  Future<void> logout() async {
    _token = '';
    _userId = '';
    if (_authTimer.isActive) {
      _authTimer.cancel();
    }
    notifyListeners();
    //clean shared preference
    final prefs = await SharedPreferences.getInstance();
    //since we only have user data to clear so we use clear() method to clear all references.
    //if we had multiple instance we would use remove() method to only remove this reference user data.
    prefs.clear();
  }

  void _autoLogout() {
    try {
      //if there is a timer cancel it
      // if (_authTimer.isActive) {
      //   _authTimer.cancel();
      // }
      //set seconds to logout after these sconds
      final expirein = _expiryDateToken.difference(DateTime.now()).inSeconds;
      _authTimer = Timer(Duration(seconds: expirein), logout);
    } catch (err) {
      rethrow;
    }
  }
}

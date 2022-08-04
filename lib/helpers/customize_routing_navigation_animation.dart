import 'package:flutter/material.dart';

//this class we can use it for whatever pagee we want inside our Navigator.
//Navigator.of(context).pushReplacement(CustomRouteTransition(builder(ctx)=>ourScreen()));
class CustomRouteTransition<T> extends MaterialPageRoute<T> {
  CustomRouteTransition(
      {required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    //return super.buildTransitions(context, animation, secondaryAnimation, child);
    // TODO: instead of default page transition i will return custom.

    //if its home screen no transition required we just return the widget (page)
    if (settings.name == '/') {
      return child;
    }
    //if not we will fade the page
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

//this class used  in themeData() in main to make fade transition for ios android seperatly
class CustomWholePlatformTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // if home route nothing happens
    if (route.settings.name == '/') {
      return child;
    }
    //if other route
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

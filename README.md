# shop_course

A new Flutter project.

## Getting Started
# - [] user Authintication with http request 
# - [] sending http requests
# - [] state Management
# - [] futures
# - [] adding and deleting product
# - [] adding products to cart

##how to debug:
# - create a project in your firebase.
# - create email/password Authentication.
# - create realtime database.
# - make your rules as:
{
"rules":{
"read":"auth!=null",
"Write":"auth!=null"
}
"products":{
".indexOf":["creatorId"]
}
}

# - overrode firbase url in source code with your realtime database URL
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

class HttpException implements Exception {
  final dynamic message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
    //return super.toString();
  }
}

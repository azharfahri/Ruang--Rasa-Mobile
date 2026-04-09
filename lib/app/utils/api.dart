class BaseUrl {
  static String base = 'https://ruangrasa.web.id/api';
  //static String base = 'http://10.0.2.2:8000/api';

  static String register = '$base/register';
  static String login = '$base/login';
  static String logout = '$base/logout';
  static String profile = '$base/profile';

  static String cabang = '$base/branches'; 
  static String produk = '$base/products'; 
  static String categories = '$base/categories';
  static String orders = '$base/orders';

  static Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Headers with auth token
  static Map<String, String> authHeaders(String token) => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Status codes
  static int success = 200;
  static int created = 201;
  static int badRequest = 400;
  static int unauthorized = 401;
  static int notFound = 404;
  static int serverError = 500;
  static int unprocessableEntity = 422;
}
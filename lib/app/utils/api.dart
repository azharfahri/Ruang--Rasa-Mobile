class BaseUrl {
  // static String register = 'http://localhost:8000/api/register';
  // static String login = 'http://localhost:8000/api/login';
  // static String logout = 'http://localhost:8000/api/logout';

  //buat emulator android inimah
  static String register = 'http://10.0.2.2:8000/api/register';
  static String login = 'http://10.0.2.2:8000/api/login';
  static String logout = 'http://10.0.2.2:8000/api/logout';

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
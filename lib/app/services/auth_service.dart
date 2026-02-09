import 'package:get/get.dart';
import '../utils/api.dart';
import '../utils/api_helper.dart';

class AuthService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(BaseUrl.defaultHeaders);
      return request;
    });
    super.onInit();
  }

  Future<Response> login(String email, String password) {
    return post(BaseUrl.login, {'email': email, 'password': password});
  }

  Future<Response> register(String name, String email, String password) {
    return post(BaseUrl.register, {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<Response> logout(String token) {
    return post(BaseUrl.logout, {}, headers: ApiHelper.getAuthHeaders());
  }

  // Future<Response> getProfile(String token) {
  //   return get(BaseUrl.profile, headers: ApiHelper.getAuthHeaders());
  // }
}
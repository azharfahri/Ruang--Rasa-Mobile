import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ruang_rasa_mobile/app/data/models/profile_model.dart';
import 'package:ruang_rasa_mobile/app/utils/api.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ruang_rasa_mobile/app/modules/auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profile = Rxn<ProfileModel>();

  final authC = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();

    // kalau sudah login langsung
    if (authC.isLoggedIn.value) {
      fetchProfile();
    }

    // kalau login setelah halaman dibuka
    ever(authC.isLoggedIn, (val) {
      if (val == true) {
        fetchProfile();
      }
    });
  }

Future<void> fetchProfile() async {
  try {
    isLoading(true);

    final box = GetStorage();
    final token = box.read('token');

    final response = await http.get(
      Uri.parse(BaseUrl.profile),
      headers: BaseUrl.authHeaders(token),
    );

    print("TOKEN: $token");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      profile.value = ProfileModel.fromJson(body);
    }
  } catch (e) {
    print("ERROR PROFILE: $e");
  } finally {
    isLoading(false);
  }
}
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruang_rasa_mobile/app/modules/auth/controllers/auth_controller.dart';
import 'package:ruang_rasa_mobile/app/routes/app_pages.dart';

class LoginView extends GetView<AuthController> {
  LoginView({super.key});

  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004643),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 48),

                // Logo Ruang Rasa
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFF001E1D),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_cafe_rounded,
                    color: Color(0xFFF9BC60),
                    size: 48,
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Ruang Rasa',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Seduh cerita, nikmati rasa',
                  style: TextStyle(fontSize: 14, color: Color(0xFFABD1C6)),
                ),

                const SizedBox(height: 48),

                // Card Login
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E4E6),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001E1D),
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Login untuk melanjutkan ke Ruang Rasa',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF5F6C6B),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Email
                        _inputBox(
                          child: TextFormField(
                            controller: emailC,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.person_rounded,
                                color: Color(0xFF001E1D),
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'Email wajib diisi'
                                : null,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Password
                        Obx(
                          () => _inputBox(
                            child: TextFormField(
                              controller: passwordC,
                              obscureText: controller.isPasswordHidden.value,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(
                                  Icons.lock_rounded,
                                  color: Color(0xFF001E1D),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordHidden.value
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: const Color(0xFF001E1D),
                                  ),
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                ),
                                border: InputBorder.none,
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Password wajib diisi'
                                  : null,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Button Login
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.login(
                                          emailC.text,
                                          passwordC.text,
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF9BC60),
                                foregroundColor: const Color(0xFF001E1D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF001E1D),
                                      ),
                                    )
                                  : const Text(
                                      'Masuk Ruang Rasa',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: 'Belum punya akun? ',
                                style: TextStyle(
                                  color: Color(0xFF5F6C6B),
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Daftar di sini',
                                    style: TextStyle(
                                      color: Color(0xFFF9BC60),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Center(
                          child: Text(
                            'Nikmati kopi & cerita dalam satu ruang',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  '© Ruang Rasa',
                  style: TextStyle(fontSize: 12, color: Color(0xFFABD1C6)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF001E1D), width: 1),
      ),
      child: child,
    );
  }
}

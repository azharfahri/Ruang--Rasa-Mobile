import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruang_rasa_mobile/app/modules/auth/controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  RegisterView({super.key});

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004643),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Icon(
                Icons.local_cafe_rounded,
                size: 60,
                color: Color(0xFFF9BC60),
              ),

              const SizedBox(height: 16),

              const Text(
                'Buat Akun',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Gabung dan nikmati Ruang Rasa',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFABD1C6),
                ),
              ),

              const SizedBox(height: 40),

              // Card Form
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E4E6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _inputBox(
                        child: TextFormField(
                          controller: nameC,
                          decoration: const InputDecoration(
                            labelText: 'Nama',
                            prefixIcon: Icon(
                              Icons.person_rounded,
                              color: Color(0xFF001E1D),
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                        ),
                      ),

                      const SizedBox(height: 18),

                      _inputBox(
                        child: TextFormField(
                          controller: emailC,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.email_rounded,
                              color: Color(0xFF001E1D),
                            ),
                            border: InputBorder.none,
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Email wajib diisi' : null,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Obx(
                        () => _inputBox(
                          child: TextFormField(
                            controller: passwordC,
                            obscureText:
                                controller.isPasswordHidden.value,
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
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password wajib diisi';
                              }
                              if (v.length < 8) {
                                return 'Password minimal 8 karakter';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.register(
                                nameC.text,
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
                          ),
                          child: const Text(
                            'Daftar Sekarang',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: () => Get.back(),
                child: const Text(
                  'Sudah punya akun? Login',
                  style: TextStyle(
                    color: Color(0xFFABD1C6),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
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
        border: Border.all(
          color: const Color(0xFF001E1D),
        ),
      ),
      child: child,
    );
  }
}

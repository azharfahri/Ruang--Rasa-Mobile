import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/editprofile_controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditprofileController());

    return Scaffold(
      backgroundColor: const Color(0xFF0B5D53),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B5D53),
        elevation: 0,
        title: const Text("Edit Profil"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 🔹 Nama
            buildTextField(
              label: "Nama",
              controller: controller.nameController,
            ),

            // 🔹 Email
            buildTextField(
              label: "Email",
              controller: controller.emailController,
            ),

            // 🔹 Password
            buildTextField(
              label: "Password (opsional)",
              controller: controller.passwordController,
              isPassword: true,
            ),

            const SizedBox(height: 20),

            // BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : const Text("Simpan"),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF063D35),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
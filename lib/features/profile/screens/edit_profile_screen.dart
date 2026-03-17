import 'package:autozy/features/profile/widgets/build_input_field.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController(
    text: "John Kevin",
  );

  final TextEditingController phoneController = TextEditingController(
    text: "+91 9123456789",
  );

  final TextEditingController emailController = TextEditingController(
    text: "johnkevin@gmail.com",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            /// PROFILE AVATAR
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFFF6C431),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 80,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 40),

            /// FULL NAME
            BuildInputField(label: "Full Name", controller: nameController),

            const SizedBox(height: 20),

            /// MOBILE NUMBER
            BuildInputField(
              label: "Mobile Number",
              controller: phoneController,
            ),

            const SizedBox(height: 20),

            /// EMAIL
            BuildInputField(label: "Enter Email", controller: emailController),

            const Spacer(),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String phone = phoneController.text;
                  String email = emailController.text;

                  print(name);
                  print(phone);
                  print(email);

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6C431),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 190),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:autozy/features/profile/widgets/build_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/utils/responsive.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final profile = authProvider.profile;
      final user = authProvider.user;

      final String currentName = (profile?.name != null && profile!.name!.isNotEmpty) ? profile.name! : (user?.name ?? "");
      final String currentPhone = (profile?.phone != null && profile!.phone!.isNotEmpty) ? profile.phone! : (user?.phone ?? "");
      final String currentEmail = (profile?.email != null && profile!.email!.isNotEmpty) ? profile.email! : (user?.email ?? "");

      nameController.text = (currentName == "John Kevin" || currentName == "John Doe") ? "" : currentName;
      phoneController.text = currentPhone;
      emailController.text = (currentEmail == "johnkevin@gmail.com" || currentEmail == "johndoe@gmail.com") ? "" : currentEmail;
      
      setState(() {});
    });
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                "Select Profile Picture",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(15)),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Colors.black87),
                title: const Text("Take Photo", style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Colors.black87),
                title: const Text("Choose from Gallery", style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (source != null) {
      try {
        final picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: source,
          maxWidth: 500,
          maxHeight: 500,
          imageQuality: 85,
        );
        if (image != null && mounted) {
          await context.read<AuthProvider>().updateLocalAvatar(image.path);
        }
      } catch (e) {
        debugPrint("Error picking image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: context.sp(18)),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(20)),
        child: Column(
          children: [
            SizedBox(height: context.h(24)),

            /// PROFILE AVATAR WITH CAMERA SELECTION
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  Container(
                    width: context.w(100),
                    height: context.w(100),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF6C431),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: authProvider.localAvatarPath != null && authProvider.localAvatarPath!.isNotEmpty
                          ? ClipOval(
                              child: Image.file(
                                File(authProvider.localAvatarPath!),
                                width: context.w(100),
                                height: context.w(100),
                                fit: BoxFit.cover,
                              ),
                            )
                          : SvgPicture.asset(
                              'assets/images/profile.svg',
                              height: context.w(52),
                              width: context.w(52),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.h(28)),

            /// FULL NAME
            BuildInputField(label: "Enter Name", controller: nameController),

            SizedBox(height: context.h(12)),

            /// MOBILE NUMBER
            BuildInputField(
              label: "Mobile Number",
              controller: phoneController,
            ),

            SizedBox(height: context.h(12)),

            /// EMAIL
            BuildInputField(label: "Please Enter Email", controller: emailController),

            const Spacer(),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: context.h(46),
              child: ElevatedButton(
                onPressed: authProvider.profileLoading
                    ? null
                    : () async {
                        final navigator = Navigator.of(context);
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        
                        await authProvider.updateUserProfile(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                        );
                        
                        if (authProvider.profileError != null) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(authProvider.profileError!),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Profile Updated Successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                          navigator.pop(true);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6C431),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: authProvider.profileLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                      )
                    : Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: context.sp(14.5),
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),

            SizedBox(height: context.h(20)),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:education_app/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../view_model/provider/profile_provider.dart';
import '../../../view_model/provider/upload_image_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      await Provider.of<UploadImageProvider>(context, listen: false)
          .uploadingImage(context, _selectedImage!);

      Future.delayed(Duration(seconds: 2), () {
        Provider.of<ProfileProvider>(context, listen: false)
            .getUserProfileData(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<ProfileProvider>(context);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: AppColors.primaryColor),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(child: _buildProfilePicture(userData)),
                  const SizedBox(height: 20),
                  _buildProfileField(Icons.person,
                      "${userData.profileModel!.user!.username}", false),
                  _buildProfileField(Icons.email,
                      "${userData.profileModel!.user!.email}", false,
                      keyboardType: TextInputType.emailAddress),
                  _buildProfileField(Icons.phone,
                      "${userData.profileModel!.user!.phone}", false,
                      controller: phoneController,
                      keyboardType: TextInputType.phone),
                  _buildProfileField(Icons.location_on,
                      "${userData.profileModel!.user!.address}", false,
                      controller: addressController),
                  _buildPasswordField(Icons.lock, "Enter current password",
                      currentPasswordController, _obscureCurrentPassword, () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  }),
                  _buildPasswordField(Icons.lock_outline, "Enter new password",
                      newPasswordController, _obscureNewPassword, () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  }),
                  const SizedBox(height: 30),
                  _buildUpdateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(ProfileProvider userData) {
    final String baseUrl = "https://nomore.com.pk/MDCAT_ECAT_Education/API/";
    String? profileImage = userData.profileModel?.user?.profileImage;
    String defaultImageUrl =
        'https://storage.needpix.com/rsynced_images/head-659651_1280.png';

    String imageUrl = (profileImage != null && profileImage.startsWith('http'))
        ? profileImage
        : '$baseUrl$profileImage';

    if (profileImage == null || profileImage.isEmpty) {
      imageUrl = defaultImageUrl;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 20,
          left: 0,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
          ),
        ),
        Center(
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 68,
              backgroundImage:
                  (imageUrl.isNotEmpty && !imageUrl.contains("null"))
                      ? NetworkImage(imageUrl)
                      : const AssetImage('assets/images/default_profile.png')
                          as ImageProvider,
              onBackgroundImageError: (_, __) {
                debugPrint("Error loading image: $imageUrl");
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 78,
          child: GestureDetector(
            onTap: () => _pickImage(context),
            child: CircleAvatar(
              radius: 21,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryColor,
                child: Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileField(IconData icon, String hint, bool isEditable,
      {TextEditingController? controller, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        enabled: isEditable,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      IconData icon,
      String hint,
      TextEditingController controller,
      bool obscureText,
      VoidCallback toggleVisibility) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primaryColor),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    final userData = Provider.of<ProfileProvider>(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (currentPasswordController.text.isEmpty ||
              newPasswordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please fill in all password fields")),
            );
            return;
          }

          final profileProvider =
              Provider.of<ProfileProvider>(context, listen: false);

          await profileProvider.changingPassword(
            context,
            currentPasswordController.text,
            newPasswordController.text,
          );

          if (profileProvider.changePassword != null &&
              profileProvider.changePassword!.success == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Password changed successfully"),
                  backgroundColor: Colors.green),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Old password is incorrect"),
                  backgroundColor: Colors.red),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12)),
        ),
        child: userData.isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                "Update Profile",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
      ),
    );
  }
}

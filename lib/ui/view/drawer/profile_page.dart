// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:education_app/resources/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../resources/text_style.dart';
import '../../../view_model/provider/profile_provider.dart';
import '../../../view_model/provider/upload_image_provider.dart';
import '../../../utils/toast_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    /// Initialize controllers with current values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userData = Provider.of<ProfileProvider>(context, listen: false);
      nameController.text = userData.profileModel?.user?.username ?? '';
      phoneController.text = userData.profileModel?.user?.phone ?? '';
      addressController.text = userData.profileModel?.user?.address ?? '';
    });
  }

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
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        // backgroundColor: AppColors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: AppTextStyle.heading3.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.deepPurple,
                AppColors.lightPurple,
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Profile Picture Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.indigo,
                      AppColors.lightIndigo,
                      // AppColors.indigo,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purpleShadow,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        _buildProfilePicture(userData),
                        SizedBox(height: 20),
                        Text(
                          '${userData.profileModel!.user!.username}',
                          style: AppTextStyle.heading2.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${userData.profileModel!.user!.email}',
                          style: AppTextStyle.bodyText1.copyWith(
                            color: AppColors.whiteOverlay90,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Profile Information Section
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Information Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.whiteColor,
                              AppColors.backgroundColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.indigo
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: AppColors.lightIndigo,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Personal Information',
                                    style: AppTextStyle.heading3.copyWith(
                                      color: AppColors.darkText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              _buildInfoField(
                                'Name',
                                userData.profileModel!.user!.username ??
                                    'Not set',
                                nameController,
                                Icons.person,
                              ),
                              SizedBox(height: 15),
                              _buildInfoField(
                                'Phone',
                                userData.profileModel!.user!.phone ?? 'Not set',
                                phoneController,
                                Icons.phone,
                              ),
                              SizedBox(height: 15),
                              _buildInfoField(
                                'Address',
                                userData.profileModel!.user!.address ??
                                    'Not set',
                                addressController,
                                Icons.location_on,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Change Password Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.whiteColor,
                              AppColors.backgroundColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightIndigo
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.lock_outline,
                                      color: AppColors.lightIndigo,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Change Password',
                                    style: AppTextStyle.heading3.copyWith(
                                      color: AppColors.darkText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              _buildPasswordField(
                                'Current Password',
                                currentPasswordController,
                                _obscureCurrentPassword,
                                () {
                                  setState(() {
                                    _obscureCurrentPassword =
                                        !_obscureCurrentPassword;
                                  });
                                },
                              ),
                              SizedBox(height: 15),
                              _buildPasswordField(
                                'New Password',
                                newPasswordController,
                                _obscureNewPassword,
                                () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              ),
                             SizedBox(height: 15),
                              _buildPasswordField(
                                'Confirm Password',
                                confirmPasswordController,
                                _obscureConfirmPassword,
                                () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Update Button
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.indigo,
                            AppColors.lightIndigo,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purpleShadow,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Only validate password fields if they are filled
                          if (currentPasswordController.text.isNotEmpty ||
                              newPasswordController.text.isNotEmpty || confirmPasswordController.text.isNotEmpty) {
                            if (currentPasswordController.text.isEmpty ||
                                newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                              ToastHelper.showError(
                                  "Please fill in all password fields");
                              return;
                            }
                          }

                          final profileProvider = Provider.of<ProfileProvider>(
                            context,
                            listen: false,
                          );
                          if (currentPasswordController.text.isNotEmpty &&
                              newPasswordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty) {
                            final oldPassword = currentPasswordController.text;
                            final newPassword = newPasswordController.text;
                            final confirmPassword = confirmPasswordController.text;
                            await profileProvider.changingPassword(context,
                                oldPassword, newPassword, confirmPassword);
                          } else {
                            await profileProvider.updateProfile(
                              context,
                              username: nameController.text,
                              phone: phoneController.text,
                              address: addressController.text,
                              currentPassword: currentPasswordController.text,
                              newPassword: newPasswordController.text,
                            );
                          }

                          currentPasswordController.clear();
                          newPasswordController.clear();
                          confirmPasswordController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: userData.isLoading
                            ? CupertinoActivityIndicator(color: Colors.white)
                            : Text(
                                "Update Profile",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: (imageUrl.isNotEmpty && !imageUrl.contains("null"))
                ? NetworkImage(imageUrl)
                : const AssetImage('assets/images/default_profile.png')
                    as ImageProvider,
            onBackgroundImageError: (_, __) {
              debugPrint("Error loading image: $imageUrl");
            },
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _pickImage(context),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                color: AppColors.indigo,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField(
    String label,
    String value,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller..text = value,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.indigo),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.dividerColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscureText,
    VoidCallback toggleVisibility,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: AppColors.indigo),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.lightIndigo,
              ),
              onPressed: toggleVisibility,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.deepPurple),
            ),
          ),
        ),
      ],
    );
  }
}

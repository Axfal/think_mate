import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  String? selectedTestId;

  @override
  void initState() {
    super.initState();
    callSubjectApi();
  }

  void callSubjectApi() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.fetchCoursesList();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error fetching subjects: $e");
      }
      if (kDebugMode) {
        print(stackTrace);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Create Your Account!",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  SizedBox(height: 10),
                  const Text("Sign up to get started",
                      style: TextStyle(fontSize: 16, color: Colors.black54)),
                  SizedBox(height: 30),

                  _buildTextField(
                      usernameController, "Username", Icons.person, false),
                  SizedBox(height: 20),

                  _buildTextField(emailController, "Email", Icons.email, false,
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(height: 20),

                  _buildTextField(phoneController, "Phone", Icons.phone, false,
                      keyboardType: TextInputType.phone),
                  SizedBox(height: 20),

                  _buildTextField(
                      addressController, "Address", Icons.location_on, false),
                  SizedBox(height: 20),

                  _buildTextField(
                      passwordController, "Password", Icons.lock, true),
                  SizedBox(height: 20),

                  // Dropdown for Test ID
                  authProvider.loading
                      ? Center(child:CupertinoActivityIndicator(color: Colors.white))
                      : (authProvider.courseList == null || authProvider.courseList!.data == null || authProvider.courseList!.data!.isEmpty)
                      ? Text("No subjects available", style: TextStyle(color: Colors.red))
                      : DropdownButtonFormField<String>(
                    value: selectedTestId,
                    decoration: InputDecoration(
                      labelText: "Select Subject",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: authProvider.courseList!.data!.map((subject) {
                      return DropdownMenuItem(
                        value: subject.id.toString(),
                        child: Text(subject.testName ?? "Unknown"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTestId = value;
                      });
                    },
                    validator: (value) =>
                    value == null ? "Please select a Subject" : null,
                  ),


                  SizedBox(height: 30),

                  // Signup Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: authProvider.loading
                          ? null : () {
                        if (_formKey.currentState!.validate()) {
                          final data = {
                            "username": usernameController.text.trim(),
                            "email": emailController.text.trim(),
                            "phone": phoneController.text.trim(),
                            "address": addressController.text.trim(),
                            "password": passwordController.text.trim(),
                            "test_id": selectedTestId,
                          };
                          authProvider.signUp(context, data);
                        }
                      },
                      child: authProvider.loading
                          ? Center(child:CupertinoActivityIndicator(color: Colors.white))
                          : Text("Sign Up",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Already have an account?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: TextStyle(color: Colors.black54)),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Login",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, bool isPassword,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.primaryColor),
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label cannot be empty";
        }
        return null;
      },
    );
  }
}

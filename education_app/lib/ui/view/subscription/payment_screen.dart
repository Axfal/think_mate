import 'package:education_app/resources/exports.dart';
import 'package:education_app/view_model/provider/subscription_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shimmer/shimmer.dart';

class UploadPaymentScreen extends StatefulWidget {
  final price;
  final month;
  final subscriptionId;

  const UploadPaymentScreen(
      {super.key,
      required this.price,
      required this.month,
      required this.subscriptionId});

  @override
  State<UploadPaymentScreen> createState() => _UploadPaymentScreenState();
}

class _UploadPaymentScreenState extends State<UploadPaymentScreen> {
  File? _image;
  final _amountController = TextEditingController();

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

  void submitPayment() async {
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please upload a screenshot")));
      return;
    }

    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter amount")));
      return;
    }

    if (selectedTestId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please select a subject")));
      return;
    }

    DateTime now = DateTime.now();

    final subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);

    try {
      await subscriptionProvider.postSubscription(
        context,
        selectedTestId!,
        widget.subscriptionId.toString(),
        _amountController.text.trim(),
        now.toIso8601String(),
        _image!,
      );

      // Check if post was successful
      if (subscriptionProvider.postSubscriptionModel?.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Your request has been submitted successfully. Please wait for admin to set your account as premium.",
            ),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment",
            style: AppTextStyle.heading3.copyWith(
              color: AppColors.whiteColor,
            )),
        centerTitle: true,
        backgroundColor: AppColors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subscription Plan Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: AppColors.deepPurple,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.deepPurple,
                        AppColors.lightPurple,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Premium Plan",
                            style: AppTextStyle.heading2.copyWith(
                              color: AppColors.whiteColor,
                            )),
                        SizedBox(height: 8),
                        Text(
                          "• Access to all quizzes\n• No ads\n• Progress tracking",
                          style: AppTextStyle.bodyText1.copyWith(
                            color: AppColors.whiteOverlay90,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Rs. ${widget.price} / ${widget.month} Months",
                            style: AppTextStyle.bodyText1.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Upload Screenshot
              Text(
                "Upload Payment Screenshot",
                style: AppTextStyle.heading3.copyWith(
                  color: AppColors.darkText,
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                    color: AppColors.backgroundColor,
                  ),
                  child: _image == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file,
                                  size: 40, color: Colors.grey),
                              SizedBox(height: 10),
                              Text("Tap to upload",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!,
                              fit: BoxFit.cover, width: double.infinity),
                        ),
                ),
              ),
              SizedBox(height: 20),

              // Amount Field
              Text("Enter Paid Amount (Rs)",
                  style: AppTextStyle.heading3.copyWith(
                    color: AppColors.darkText,
                  )),
              SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "e.g. 499",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.borderColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.deepPurple)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              SizedBox(height: 20),
              authProvider.loading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),
                    )
                  : (authProvider.courseList == null ||
                          authProvider.courseList!.data == null ||
                          authProvider.courseList!.data!.isEmpty)
                      ? Text("No subjects available",
                          style: TextStyle(color: Colors.red))
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

              SizedBox(height: 20),

              // Submit Button
              SizedBox(
                  width: double.infinity,
                  child: Consumer<SubscriptionProvider>(
                    builder: (context, provider, child) {
                      return ElevatedButton(
                        onPressed: provider.isLoading ? null : submitPayment,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.deepPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: provider.isLoading
                            ? CupertinoActivityIndicator()
                            : Text("Submit",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

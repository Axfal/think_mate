import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';

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
  // final _amountController = TextEditingController();
  final _promoCodeController = TextEditingController();

  String? selectedTestId;

  @override
  void initState() {
    super.initState();
    callSubjectApi();

    Future.delayed(Duration(milliseconds: 300), () {
      showPromoCodeDialog();
    });
  }

  void showPromoCodeDialog() async {
    final provider = Provider.of<SubscriptionProvider>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.local_offer_outlined,
                  size: 40, color: AppColors.deepPurple),
              SizedBox(height: 12),
              Text(
                "Do you have a Promo Code?",
                style: AppTextStyle.heading3.copyWith(
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          content: TextField(
            controller: _promoCodeController,
            decoration: InputDecoration(
              hintText: "Enter Promo Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.deepPurple),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Skip", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final promoCodeText = _promoCodeController.text.trim();
                await provider.verifyPromoCode(context, promoCodeText);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                "Apply",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
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
      ToastHelper.showError("Please upload a screenshot");
      return;
    }

    // if (_amountController.text.isEmpty) {
    //   ToastHelper.showError("Please enter amount");
    //   return;
    // }

    if (selectedTestId == null) {
      ToastHelper.showError("Please select a subject");
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
          widget.price,
          now.toIso8601String(),
          _image!,
          _promoCodeController.text.trim());

      if (subscriptionProvider.postSubscriptionModel?.success == true) {
        ToastHelper.showSuccess(
            "Your request has been submitted successfully. Please wait for admin to set your account as premium.");

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      ToastHelper.showError("Something went wrong. Please try again.");
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
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    double discount = double.tryParse(
            "${subscriptionProvider.verifyPromoCodeModel?.data?.discount ?? 0}") ??
        0.0;
    double totalPrice = double.tryParse("${widget.price ?? 0} ") ?? 0.0;
    double payableAmount = totalPrice - discount;

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Amount Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payable Amount (Rs)",
                    style: AppTextStyle.heading3.copyWith(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.deepPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Rs. $payableAmount",
                        style: AppTextStyle.bodyText1.copyWith(
                          color: AppColors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),

              SizedBox(height: 10),
              // TextField(
              //   controller: _amountController,
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //     hintText: "e.g. 499",
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: BorderSide(color: AppColors.borderColor)),
              //     enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: BorderSide(color: AppColors.borderColor)),
              //     focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: BorderSide(color: AppColors.deepPurple)),
              //     contentPadding:
              //         EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              //   ),
              // ),

              // Promo Field
              // Text("Enter Promo (optional)",
              //     style: AppTextStyle.heading3.copyWith(
              //       color: AppColors.darkText,
              //     )),
              // SizedBox(height: 10),
              // TextField(
              //   controller: _promoCodeController,
              //   keyboardType: TextInputType.text,
              //   decoration: InputDecoration(
              //     hintText: "e.g  Z9A2BE2E",
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: BorderSide(color: AppColors.borderColor)),
              //     enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: BorderSide(color: AppColors.borderColor)),
              //     focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: BorderSide(color: AppColors.deepPurple)),
              //     contentPadding:
              //         EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              //   ),
              // ),
              SizedBox(height: 20),
              // authProvider.loading
              //     ? Shimmer.fromColors(
              //         baseColor: Colors.grey.shade300,
              //         highlightColor: Colors.grey.shade100,
              //         child: Container(
              //           height: 50,
              //           width: double.infinity,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             color: Colors.white,
              //           ),
              //         ),
              //       )
              //     : (authProvider.courseList == null ||
              //             authProvider.courseList!.data == null ||
              //             authProvider.courseList!.data!.isEmpty)
              //         ? Text("No subjects available",
              //             style: TextStyle(color: Colors.red))
              //         : DropdownButtonFormField<String>(
              //             value: selectedTestId,
              //             decoration: InputDecoration(
              //               labelText: "Select Subject",
              //               border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10)),
              //             ),
              //             items: authProvider.courseList!.data!.map((subject) {
              //               return DropdownMenuItem(
              //                 value: subject.id.toString(),
              //                 child: Text(subject.testName ?? "Unknown"),
              //               );
              //             }).toList(),
              //             onChanged: (value) {
              //               setState(() {
              //                 selectedTestId = value;
              //               });
              //             },
              //             validator: (value) =>
              //                 value == null ? "Please select a Subject" : null,
              //           ),
              //
              // SizedBox(height: 20),

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

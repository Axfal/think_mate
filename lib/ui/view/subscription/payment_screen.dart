import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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
    // callSubjectApi();

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

  // void callSubjectApi() async {
  //   try {
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //     await authProvider.fetchCoursesList();
  //   } catch (e, stackTrace) {
  //     if (kDebugMode) {
  //       print("Error fetching subjects: $e");
  //     }
  //     if (kDebugMode) {
  //       print(stackTrace);
  //     }
  //   }
  // }

  void _showPaymentDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(Icons.account_balance_wallet, color: AppColors.primaryColor),
              SizedBox(width: 10),
              Text("Payment Details",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildPaymentTile(
                  title: "Easypaisa",
                  name: "Toheed Ahmad",
                  detail: "0332 6984463",
                  context: context,
                ),
                SizedBox(height: 10),
                _buildPaymentTile(
                  title: "JazzCash",
                  name: "Tauheed Ahmad",
                  detail: "0314 6588261",
                  context: context,
                ),
                SizedBox(height: 10),
                _buildPaymentTile(
                  title: "Bank Alfalah Limited",
                  name: "Tusif Ahmad",
                  detail: "PK04ALFH0358001006064601",
                  context: context,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close",
                  style: TextStyle(color: AppColors.primaryColor)),
            )
          ],
        );
      },
    );
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
        // actions: [
        //   IconButton(onPressed: () => _showPaymentDetailsDialog(context), icon: Icon(Icons.payment_rounded, color: Colors.white,)), SizedBox(width: 5)
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.deepPurple,
                child: Container(
                  width: double.infinity, // covers screen width
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12), // reduced padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // helps make it compact
                      children: [
                        Text(
                          "Premium Plan",
                          style: AppTextStyle.heading2.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 6), // reduced spacing
                        Text(
                          "• Access to all quizzes\n• No ads\n• Progress tracking",
                          style: AppTextStyle.bodyText1.copyWith(
                            color: AppColors.whiteOverlay90,
                          ),
                        ),
                        SizedBox(height: 6), // reduced spacing
                        Text(
                          "Rs. ${widget.price} / ${widget.month} Months",
                          style: AppTextStyle.bodyText1.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
//CLICK FOR ACCOUNT DETAILS
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Stack(
                  children: [
                    // Bottom layer for double effect
                    Positioned(
                      top: 4,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.red.shade800,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    // Top layer (main button with icon)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showPaymentDetailsDialog(context),
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "CLICK FOR ACCOUNT DETAILS",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.touch_app,
                                color: Colors.white,
                                size: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
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
                  height: 160,
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

              SizedBox(height: 20),

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

  Widget _buildPaymentTile({
    required String title,
    required String name,
    required String detail,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.person, size: 18, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(name, style: TextStyle(fontSize: 15)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone_android, size: 18, color: Colors.grey[600]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  detail,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: detail));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Copied $title number"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      Icon(Icons.copy, size: 18, color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

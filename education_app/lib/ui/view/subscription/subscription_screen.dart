// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:education_app/resources/exports.dart';
import 'package:education_app/ui/view/subscription/payment_screen.dart';
import 'package:education_app/ui/view/subscription/subscription_history.dart';
import 'package:education_app/view_model/provider/subscription_provider.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();

    // Safely call provider method after widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  void getData() {
    final provider = Provider.of<SubscriptionProvider>(context, listen: false);
    provider.getSubscription();
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubscriptionProvider>(context);
    final plan = provider.getSubscriptionModel?.subscriptions;

    return Scaffold(
      appBar: AppBar(
        title: Text("Subscription", style: AppTextStyle.appBarText),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Back button functionality
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'Subscription History') {
                            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentHistoryScreen()),
                );
              }
              // You can add more screen routes here
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'Subscription History',
                child: Text('Subscription History'),
              ),
              // Add more PopupMenuItem widgets for more screens
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Allows scrolling if the content overflows
          child: Column(
            children: [
              Text(
                "Go Premium, Learn Better",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Upgrade your experience and unlock more with our premium plans!",
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              // Show shimmer effect if the data is loading
              plan == null ? buildShimmerEffect() : buildSubscriptionList(plan),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build modern shimmer effect for the subscription cards
  Widget buildShimmerEffect() {
    return Column(
      children: List.generate(2, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          period: Duration(milliseconds: 1200),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title container with shimmer effect
                    Container(
                      width: 140,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Price container with shimmer effect
                    Container(
                      width: 100,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Duration container with shimmer effect
                    Container(
                      width: 80,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Feature 1 shimmer effect
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    // Feature 2 shimmer effect
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    // Feature 3 shimmer effect
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Button container with shimmer effect
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Additional visual elements for variety
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 140,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // Function to build the subscription list if data is available
  Widget buildSubscriptionList(List subscriptionList) {
    if (subscriptionList.isEmpty) {
      return Center(child: Text("No subscription plans available"));
    }

    return Column(
      children: subscriptionList.map<Widget>((subscription) {
        return SubscriptionCard(
          title: subscription.subscriptionName!,
          price: "Rs. ${subscription.price}",
          duration: "${subscription.months} Month",
          isRecommended: subscription.id == 2,
          features: [
            "Unlimited Quizzes",
            "Ad-Free Experience",
            "Exclusive Learning Content",
            "Progress Tracking"
          ],
          onTap: () {
            if (subscription.subscriptionName == "Free Plan") {
              Navigator.pop(context);
            } else if (subscription.subscriptionName == "Gold Plan") {
              final goldPlan = subscriptionList.firstWhere(
                (sub) => sub.subscriptionName == "Gold Plan",
                orElse: () =>
                    Subscriptions(), // return an empty/default Subscriptions object if needed
              );

              final month = goldPlan.months ?? 1;
              final price = goldPlan.price ?? 2000;
              final subscriptionId = goldPlan.id;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadPaymentScreen(
                    month: month,
                    price: price,
                    subscriptionId: subscriptionId,
                  ),
                ),
              );
            }
          },
        );
      }).toList(),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String duration;
  final bool isRecommended;
  final List<String> features;
  final VoidCallback onTap;

  const SubscriptionCard(
      {super.key,
      required this.title,
      required this.price,
      required this.duration,
      required this.isRecommended,
      required this.features,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isRecommended ? 6 : 3,
      color: isRecommended ? AppColors.primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRecommended)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Recommended",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isRecommended ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "$price / $duration",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isRecommended ? Colors.white70 : Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: isRecommended
                            ? Colors.white
                            : AppColors.primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        feature,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isRecommended ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isRecommended ? Colors.white : AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onTap,
                child: Text(
                  "Select Plan",
                  style: GoogleFonts.poppins(
                    color:
                        isRecommended ? AppColors.primaryColor : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

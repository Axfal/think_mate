// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:education_app/resources/exports.dart';
import 'package:education_app/view_model/provider/profile_provider.dart';
import 'package:education_app/view_model/provider/subscription_provider.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  Timer? _periodicTimer;
  final NoScreenshot _noScreenshot = NoScreenshot.instance;
  bool isProfileFetched = false;
  bool isCoursesFetched = false;

  @override
  void initState() {
    super.initState();
    _noScreenshot.screenshotOn();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isProfileFetched) getUserData();
      if (!isCoursesFetched) fetchCourses();
      startPeriodicSubscriptionCheck();
    });
  }

  void startPeriodicSubscriptionCheck() async {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);


    await _updateUserSubscription(subscriptionProvider, authProvider);


    _periodicTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
      await _updateUserSubscription(subscriptionProvider, authProvider);
    });
  }

  /// Helper method to fetch and update user subscription and type
  Future<void> _updateUserSubscription(
      SubscriptionProvider subscriptionProvider,
      AuthProvider authProvider,
      ) async {
    await subscriptionProvider.getUserSubscriptionPlan(context);

    final model = subscriptionProvider.checkUserSubscriptionPlanModel;

    if (model != null && model.success == true) {
      final userType = model.userType;
      final subscriptionName = model.subscriptionName;

      if (userType != null && subscriptionName != null) {
        authProvider.setUserType(subscriptionName, userType);
      }
    }
  }


  void getUserData() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.getUserProfileData(context);
    isProfileFetched = true;
  }

  void fetchCourses() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.courseList?.data?.isEmpty ?? true) {
      await authProvider.fetchCoursesList();
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget shimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: AppColors.darkText.withValues(alpha: 0.1),
      highlightColor: AppColors.backgroundColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget fullScreenShimmer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(width: 120, height: 20),
                    SizedBox(height: 8),
                    shimmerBox(width: 180, height: 16),
                  ],
                ),
                Shimmer.fromColors(
                  baseColor: AppColors.darkText.withValues(alpha: 0.1),
                  highlightColor: AppColors.backgroundColor,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.whiteColor,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: shimmerBox(width: double.infinity, height: 45),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 10, left: 20),
            child: shimmerBox(width: 150, height: 18),
          ),
          SizedBox(
            height: 240, // increased safely
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(right: 15),
                child: shimmerBox(width: 200, height: 220),
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(right: 15),
                child: shimmerBox(width: 200, height: 220),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<AuthProvider>(context, listen: false);
    final userData = Provider.of<ProfileProvider?>(context);
    final String baseUrl = "https://nomore.com.pk/MDCAT_ECAT_Education/API/";
    String? profileImage = userData?.profileModel?.user?.profileImage;
    String defaultImageUrl =
        'https://storage.needpix.com/rsynced_images/head-659651_1280.png';

    String imageUrl = (profileImage != null && profileImage.startsWith('http'))
        ? profileImage
        : '$baseUrl$profileImage';

    if (profileImage == null || profileImage.isEmpty) {
      imageUrl = defaultImageUrl;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text(
          'ThinkMatte',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: AppColors.darkText,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.darkText),
      ),
      drawer: userData?.profileModel != null
          ? drawerWidget(context, userData!)
          : Container(),
      body: isLoading
          ? fullScreenShimmer()
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.deepPurple,
                          AppColors.lightPurple,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purpleShadow,
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (userData?.profileModel?.success == true)
                              Text(
                                'Hello ${userData?.profileModel?.user?.username ?? "User"}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteColor,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                        color: AppColors.blackOverlay10,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Text(
                                'User name not found',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: AppColors.errorLight,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.whiteOverlay15,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Welcome to ThinkMatte',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color:
                                        AppColors.whiteColor.withValues(alpha:0.95),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.whiteOverlay90,
                                AppColors.whiteOverlay70,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blackOverlay10,
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage: imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : AssetImage('assets/images/mdcat.png')
                                      as ImageProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.indigo,
                            AppColors.lightIndigo,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.indigoShadow,
                            spreadRadius: 1,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesName.subscriptionScreen);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteOverlay20,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.star,
                                      color: AppColors.whiteColor, size: 30),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Upgrade to Premium',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Get access to all premium features',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: AppColors.whiteColor
                                                .withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteOverlay20,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColors.whiteColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 20, bottom: 10, left: 20),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Courses We Offer',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 280,
                    child: (courseProvider.courseList?.data?.isNotEmpty ??
                            false)
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemCount:
                                courseProvider.courseList?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final courseData =
                                  courseProvider.courseList!.data![index];
                              final int courseId = courseData.id ?? -1;
                              final String courseName =
                                  courseData.testName ?? 'Course';

                              return Container(
                                margin: EdgeInsets.only(right: 15),
                                width: 220,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.whiteColor,
                                      AppColors.backgroundColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.indigo.withOpacity(0.1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.darkShadow,
                                      spreadRadius: 1,
                                      blurRadius: 20,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      if (courseId != -1) {
                                        Navigator.pushNamed(
                                          context,
                                          RoutesName.course,
                                          arguments: {'courseId': courseId},
                                        );
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                              child: Image.asset(
                                                'assets/images/mdcat.png',
                                                height: 140,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                height: 140,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      AppColors.indigo
                                                          .withOpacity(0.4),
                                                      AppColors.indigo
                                                          .withOpacity(0.1),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                courseName,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.darkText,
                                                  ),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Brief description of the course content, highlighting key benefits and features.',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.darkText
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No courses available',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Color(0xFF2D3142).withOpacity(0.6),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}

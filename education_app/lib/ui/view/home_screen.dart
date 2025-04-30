// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:education_app/view_model/provider/profile_provider.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
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
    });
  }

  void getUserData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
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
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
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
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
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
    String defaultImageUrl = 'https://storage.needpix.com/rsynced_images/head-659651_1280.png';

    String imageUrl = (profileImage != null && profileImage.startsWith('http'))
        ? profileImage
        : '$baseUrl$profileImage';

    if (profileImage == null || profileImage.isEmpty) {
      imageUrl = defaultImageUrl;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('ThinkMatte', style: AppTextStyle.appBarText),
        centerTitle: true,
      ),
      drawer: userData?.profileModel != null ? drawerWidget(context, userData!) : Container(),
      body: isLoading
          ? fullScreenShimmer()
          : CustomScrollView  (
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (userData?.profileModel?.success == true)
                          Text(
                            'Hello ${userData?.profileModel?.user?.username ?? "User"}',
                            style: GoogleFonts.poppins(textStyle: AppTextStyle.profileTitleText),
                          )
                        else
                          Text(
                            'User name not found',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Text(
                          'Welcome to ThinkMatte',
                          style: GoogleFonts.poppins(textStyle: AppTextStyle.profileSubTitleText),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : AssetImage('assets/images/mdcat.png') as ImageProvider,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SubscriptionButton(() {
              Navigator.pushNamed(context, RoutesName.subscriptionScreen);
            }),
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 30, bottom: 10, left: 20),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Courses We Offer',
                style: GoogleFonts.poppins(textStyle: AppTextStyle.profileTitleText),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 240,
              child: (courseProvider.courseList?.data?.isNotEmpty ?? false)
                  ? ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: courseProvider.courseList?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final courseData = courseProvider.courseList!.data![index];
                  final int courseId = courseData.id ?? -1;
                  final String courseName = courseData.testName ?? 'Course';

                  return CoursesContainer(
                    courseName,
                    'assets/images/mdcat.png',
                    'Brief description of the course content, highlighting key benefits and features.',
                        () async {
                      if (courseId != -1) {
                        // final userType = courseProvider.userSession?.userType;
                        Navigator.pushNamed(
                          context,
                          RoutesName.course,
                          arguments: {'courseId': courseId},
                        );
                      } else {
                        print("Course id is null");
                      }
                    },
                  );
                },
              )
                  : Center(
                child: Text(
                  "No courses available",
                  style: AppTextStyle.profileSubTitleText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:education_app/resources/exports.dart';
import 'package:no_screenshot/no_screenshot.dart';

class CourseScreen extends StatefulWidget {
  final courseId;
  const CourseScreen({super.key, required this.courseId});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final NoScreenshot _noScreenshot = NoScreenshot.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _noScreenshot.screenshotOn();
  }

  @override
  Widget build(BuildContext context) {
    MockTestProvider provider = Provider.of<MockTestProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.deepPurple,
          elevation: 0,
          title: Text(
            'Courses',
            style: AppTextStyle.heading3.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              provider.restartTest();
              Navigator.pushNamed(context, RoutesName.home);
              final subjectProvider =
                  Provider.of<SubjectProvider>(context, listen: false);
              subjectProvider.disposeChapters();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.whiteColor,
            ),
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
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.school, size: 24),
                text: 'Subjects',
              ),
              Tab(
                icon: Icon(Icons.quiz, size: 24),
                text: 'General Test',
              ),
            ],
            labelColor: AppColors.whiteColor,
            unselectedLabelColor: AppColors.whiteColor.withOpacity(0.7),
            indicatorColor: AppColors.whiteColor,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: AppTextStyle.bodyText1.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: AppTextStyle.bodyText1,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundColor,
                AppColors.whiteColor,
              ],
            ),
          ),
          child: TabBarView(
            children: [
              SubjectScreen(
                courseId: widget.courseId,
              ),
              MockTestScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:education_app/resources/exports.dart';
import 'package:no_screenshot/no_screenshot.dart';
class CourseScreen extends StatefulWidget {
  final courseId;
  const CourseScreen({super.key,required this.courseId});

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
          leading: IconButton(
            onPressed: () {
              provider.restartTest();
              Navigator.pushNamed(context, RoutesName.home);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.school), text: 'Subjects'),
              Tab(icon: Icon(Icons.quiz), text: 'General Test'),
            ],
            labelColor: AppColors.primaryColor,
            indicatorColor: AppColors.primaryColor,
          ),
        ),
        body: TabBarView(
          children: [
            SubjectScreen(courseId: widget.courseId,),
            MockTestScreen(),
          ],
        ),
      ),
    );
  }
}

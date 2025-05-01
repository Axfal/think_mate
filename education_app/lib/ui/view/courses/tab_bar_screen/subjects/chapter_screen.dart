// ignore_for_file: prefer_const_constructors

import 'package:education_app/resources/exports.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:shimmer/shimmer.dart';

class ChaptersScreen extends StatefulWidget {
  const ChaptersScreen({super.key});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  final NoScreenshot _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    _noScreenshot.screenshotOn();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final chapterProvider =
          Provider.of<ChapterProvider>(context, listen: false);
      final subjectProvider =
          Provider.of<SubjectProvider>(context, listen: false);

      while (
          subjectProvider.subject == null || subjectProvider.subject!.isEmpty) {
        await Future.delayed(Duration(milliseconds: 100));
      }

      chapterProvider.setData(
        subjectProvider.testId,
        subjectProvider.selectedSubjectId,
        subjectProvider.subject!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChapterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chapters',
          style: AppTextStyle.heading3.copyWith(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.deepPurple,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            provider.reset();
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
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
        child: provider.chapterName.isEmpty
            ? _buildShimmerList()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: provider.chapterName.length,
                  itemBuilder: (context, index) {
                    final chapterNumber = index + 1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: InkWell(
                        onTap: () => _onChapterTap(context, provider, index),
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.indigo,
                                  AppColors.lightIndigo,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.indigoShadow,
                                  spreadRadius: 1,
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$chapterNumber',
                                    style: AppTextStyle.bodyText1.copyWith(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                provider.chapterName[index],
                                style: AppTextStyle.bodyText1.copyWith(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.whiteColor.withOpacity(0.7),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: 14,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Card(
              elevation: 4,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Shimmer.fromColors(
                baseColor: AppColors.indigo.withOpacity(0.3),
                highlightColor: AppColors.lightIndigo.withOpacity(0.2),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.indigo.withOpacity(0.5),
                        AppColors.lightIndigo.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onChapterTap(
      BuildContext context, ChapterProvider provider, int index) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    provider.openChapter(index);

    if (authProvider.userSession?.userType == "premium") {
      Navigator.pushNamed(context, RoutesName.questionScreen, arguments: {
        "subjectId": provider.subjectId,
        "chapterId": provider.chapterId
      });
    } else {
      _showPremiumAccessDialog(context);
    }
  }

  void _showPremiumAccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Premium Access Required"),
        content: Text(
          "This feature is available only for premium users. Upgrade now to unlock exclusive content and enhance your learning experience!",
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, RoutesName.subscriptionScreen);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text('Get Subscription',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

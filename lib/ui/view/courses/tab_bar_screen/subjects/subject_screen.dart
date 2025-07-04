// ignore_for_file: prefer_const_constructors

import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';

class SubjectScreen extends StatefulWidget {
  final int courseId;
  const SubjectScreen({super.key, required this.courseId});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(widget.courseId);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSubjects();
    });
  }

  void getSubjects() async {
    try {
      final subjectProvider =
          Provider.of<SubjectProvider>(context, listen: false);
      await subjectProvider.setSubjects(widget.courseId);
      subjectProvider.setTestId(widget.courseId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubjectProvider>(context);

    return Scaffold(
      body: provider.isLoading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : provider.subjectId.isEmpty
              ? Center(
                  child: Text(
                    "No chapters available",
                    style: AppTextStyle.heading3.copyWith(
                      color: AppColors.indigo,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: provider.subjects.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
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
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                try {
                                  final subjectProvider =
                                      Provider.of<SubjectProvider>(context,
                                          listen: false);
                                  final chapterProvider =
                                      Provider.of<ChapterProvider>(context,
                                          listen: false);

                                  int subjectId =
                                      subjectProvider.subjectId[index];
                                  subjectProvider
                                      .setSelectedSubjectId(subjectId);
                                  int testId = subjectProvider.testId;
                                  String subjectName = provider.subjects[index];
                                  subjectProvider
                                      .setSelectedSubjectId(subjectId);
                                  Navigator.pushNamed(
                                      context, RoutesName.chapterScreen,
                                      arguments: {'testId': testId});
                                  await chapterProvider.setData(
                                      testId, subjectId, subjectName);
                                } catch (e) {
                                  if (kDebugMode) {
                                    print("Navigation error: $e");
                                  }
                                  rethrow;
                                }
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor
                                            .withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.school,
                                        color: AppColors.whiteColor,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Flexible(
                                      child: Text(
                                        provider.subjects[index],
                                        style: AppTextStyle.bodyText1.copyWith(
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:education_app/resources/exports.dart';
import 'package:shimmer/shimmer.dart';

class SubjectScreen extends StatefulWidget {
  final courseId;
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
    getSubjects();
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
      body: provider.subjectId.isEmpty
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
              child: GridView.builder(
                itemCount: 6, // You can adjust count for shimmer placeholders
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: AppColors.indigo.withOpacity(0.3),
                    highlightColor: AppColors.lightIndigo.withOpacity(0.2),
                    child: Card(
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
                              AppColors.indigo.withOpacity(0.5),
                              AppColors.lightIndigo.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                height: 20,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

                              int subjectId = subjectProvider.subjectId[index];
                              subjectProvider.setSelectedSubjectId(subjectId);
                              int testId = subjectProvider.testId;
                              String subjectName = provider.subjects[index];
                              subjectProvider.setSelectedSubjectId(subjectId);
                              Navigator.pushNamed(
                                  context, RoutesName.chapterScreen);
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
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.whiteColor.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.school,
                                    color: AppColors.whiteColor,
                                    size: 32,
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

// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:education_app/ui/view/drawer/notes/notes_screen.dart';
import 'package:education_app/utils/screenshot_protector.dart';

class NotesSubjectScreen extends StatefulWidget {
  const NotesSubjectScreen({super.key});

  @override
  State<NotesSubjectScreen> createState() => _NotesSubjectScreenState();
}

class _NotesSubjectScreenState extends State<NotesSubjectScreen> {
  @override
  void initState() {
    super.initState();
    // ScreenshotProtector.enableProtection();
    getSubjects();
  }

  @override
  void dispose() {
    // ScreenshotProtector.disableProtection();
    super.dispose();
  }


  void getSubjects() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loadUserSession();
      final testId = authProvider.userSession!.testId;
      final subjectProvider =
          Provider.of<SubjectProvider>(context, listen: false);
      await subjectProvider.setSubjects(testId);
      subjectProvider.setTestId(testId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubjectProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.indigo.withValues(alpha: 0.3),
        title: Text('Subjects',
            style: AppTextStyle.heading3.copyWith(
              color: AppColors.whiteColor,
            )),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
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
      body: provider.subjectId.isEmpty
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
              child: GridView.builder(
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: AppColors.indigo.withValues(alpha: 0.3),
                    highlightColor:
                        AppColors.lightIndigo.withValues(alpha: 0.2),
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
                              AppColors.indigo.withValues(alpha: 0.5),
                              AppColors.lightIndigo.withValues(alpha: 0.3),
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
                                  color: AppColors.whiteColor
                                      .withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                height: 20,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor
                                      .withValues(alpha: 0.15),
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
                              int subjectId = provider.subjectId[index];
                              print("subject id: $subjectId");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotesScreen(
                                            subjectId: subjectId,
                                          )));
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
                                    size: 26,
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

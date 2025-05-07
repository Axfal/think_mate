// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:education_app/utils/screenshot_protector.dart';
import 'package:education_app/utils/toast_helper.dart';

class CreateMockTest extends StatefulWidget {
  const CreateMockTest({super.key});

  @override
  State<CreateMockTest> createState() => _CreateMockTestState();
}

class _CreateMockTestState extends State<CreateMockTest> {
  bool enableTimer = false;
  String? selectedQuestion;
  Set<String> selectedSubjectIds = {};
  Map<String, String> subjects = {};

  @override
  void initState() {
    super.initState();
    ScreenshotProtector.enableProtection();
    fetchSubjects();
  }

  @override
  void dispose() {
    ScreenshotProtector.disableProtection();
    super.dispose();
  }

  void fetchSubjects() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final int testId = authProvider.userSession!.testId;
      print("testId from cutom test screen and auth provider = $testId");

      final subjectProvider =
          Provider.of<SubjectProvider>(context, listen: false);
      await subjectProvider.setSubjects(testId);

      setState(() {
        subjects = Map.fromIterables(
            subjectProvider.subjectId.map((id) => id.toString()),
            subjectProvider.subjects);
      });

      if (kDebugMode) {
        print("subjects are ==> $subjects");
      }
    } catch (e) {
      rethrow;
    }
  }

  final List<String> _questions = [
    'unused',
    'incorrect',
    'marked',
    'all',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Create Mock Test',
            style: AppTextStyle.heading3.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor)),
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
                AppColors.deepPurple.withValues(alpha: 0.1),
                AppColors.lightPurple.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: subjects.isEmpty
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child:
                            Text('Please select options to generate test.',
                                style: AppTextStyle.bodyText1.copyWith(
                                  color: AppColors.redColor,
                                  fontWeight: FontWeight.bold,
                                )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            title: Text('Test Mode',
                                style: AppTextStyle.bodyText1.copyWith(
                                  color: AppColors.blackColor,
                                )),
                            backgroundColor: Colors.transparent,
                            collapsedBackgroundColor: Colors.transparent,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Tutor',
                                        style: AppTextStyle.heading3.copyWith(
                                          color: AppColors.darkText,
                                        ),
                                      ),
                                      trailing: Switch(
                                        activeColor: AppColors.successColor,
                                        inactiveThumbColor:
                                            AppColors.lightIndigo,
                                        inactiveTrackColor:
                                            AppColors.dividerColor,
                                        activeTrackColor:
                                            AppColors.dividerColor,
                                        trackOutlineColor:
                                            WidgetStatePropertyAll(
                                                WidgetStateColor.transparent),
                                        value: !enableTimer,
                                        onChanged: (value) {
                                          setState(() {
                                            enableTimer = !value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Timed',
                                        style: AppTextStyle.heading3.copyWith(
                                          color: AppColors.darkText,
                                        ),
                                      ),
                                      trailing: Switch(
                                        activeColor: AppColors.successColor,
                                        inactiveThumbColor:
                                            AppColors.lightIndigo,
                                        inactiveTrackColor:
                                            AppColors.dividerColor,
                                        activeTrackColor:
                                            AppColors.dividerColor,
                                        trackOutlineColor:
                                            WidgetStatePropertyAll(
                                                WidgetStateColor.transparent),
                                        value: enableTimer,
                                        onChanged: (value) {
                                          setState(() {
                                            enableTimer = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Consumer<CreateMockTestProvider>(
                      builder: (context, provider, child) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                title: Text('Subjects Mode',
                                    style: AppTextStyle.bodyText1.copyWith(
                                      color: AppColors.blackColor,
                                    )),
                                backgroundColor: Colors.transparent,
                                collapsedBackgroundColor: Colors.transparent,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: subjects.entries.map((entry) {
                                      String subjectId = entry.key;
                                      String subjectName = entry.value;
                                      return ListTile(
                                        leading: Checkbox(
                                          activeColor: AppColors.indigo,
                                          value: selectedSubjectIds
                                              .contains(subjectId),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                selectedSubjectIds
                                                    .add(subjectId);
                                              } else {
                                                selectedSubjectIds
                                                    .remove(subjectId);
                                              }

                                              // Check if both fields have valid values and hit API
                                              if (selectedSubjectIds
                                                      .isNotEmpty &&
                                                  selectedQuestion != null) {
                                                provider
                                                    .getMockTestQuestionsCount(
                                                  context,
                                                  selectedSubjectIds
                                                      .map((id) =>
                                                          int.tryParse(id) ??
                                                          -1)
                                                      .toList(),
                                                  selectedQuestion!,
                                                );
                                              }
                                            });
                                          },
                                        ),
                                        title: Text(subjectName,
                                            style:
                                                AppTextStyle.bodyText1.copyWith(
                                              color: AppColors.darkText,
                                            )),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            title: Text('Question Mode',
                                style: AppTextStyle.bodyText1.copyWith(
                                  color: AppColors.blackColor,
                                )),
                            backgroundColor: Colors.transparent,
                            collapsedBackgroundColor: Colors.transparent,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ..._questions.map((question) => ListTile(
                                        leading: Radio<String>(
                                          activeColor: AppColors.indigo,
                                          value: question,
                                          groupValue: selectedQuestion,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedQuestion = value;
                                              final provider = Provider.of<
                                                      CreateMockTestProvider>(
                                                  context,
                                                  listen: false);
                                              if (selectedSubjectIds
                                                      .isNotEmpty &&
                                                  selectedQuestion != null) {
                                                provider
                                                    .getMockTestQuestionsCount(
                                                  context,
                                                  selectedSubjectIds
                                                      .map((id) =>
                                                          int.tryParse(id) ??
                                                          -1)
                                                      .toList(),
                                                  selectedQuestion!,
                                                );
                                              }
                                            });
                                          },
                                        ),
                                        title: Text(
                                          question,
                                          style:
                                              AppTextStyle.bodyText1.copyWith(
                                            color: AppColors.darkText,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Slider with Plus and Minus Buttons
                    Consumer<CreateMockTestProvider>(
                      builder: (context, provider, child) {
                        final totalQuestions = provider.availableQuestions ?? 0;
                        final maxQuestions = totalQuestions > 0
                            ? totalQuestions.toDouble()
                            : 1.0;
                        final minQuestions = 1.0;
                        final clampedValue = provider.numberOfQuestions
                            .toDouble()
                            .clamp(minQuestions, maxQuestions);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                title: Text('Number of Questions',
                                    style: AppTextStyle.bodyText1.copyWith(
                                      color: AppColors.blackColor,
                                    )),
                                backgroundColor: Colors.transparent,
                                collapsedBackgroundColor: Colors.transparent,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove,
                                                  color: provider
                                                              .numberOfQuestions >
                                                          minQuestions
                                                      ? AppColors.blackColor
                                                      : AppColors.darkText
                                                          .withOpacity(0.3)),
                                              onPressed: provider
                                                          .numberOfQuestions >
                                                      minQuestions
                                                  ? () => provider
                                                      .setNumberOfQuestion(provider
                                                              .numberOfQuestions -
                                                          1)
                                                  : null,
                                            ),
                                            Expanded(
                                              child: Slider(
                                                activeColor: AppColors.indigo,
                                                inactiveColor: AppColors
                                                    .lightIndigo
                                                    .withOpacity(0.3),
                                                value: clampedValue,
                                                min: minQuestions,
                                                max: maxQuestions,
                                                divisions: totalQuestions > 1
                                                    ? (maxQuestions -
                                                            minQuestions)
                                                        .toInt()
                                                    : null,
                                                label:
                                                    '${provider.numberOfQuestions.round()}',
                                                onChanged: totalQuestions > 0
                                                    ? (value) => provider
                                                        .setNumberOfQuestion(
                                                            value
                                                                .round()
                                                                .toDouble())
                                                    : null,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add,
                                                  color: provider
                                                              .numberOfQuestions <
                                                          maxQuestions
                                                      ? AppColors.blackColor
                                                      : AppColors.darkText
                                                          .withOpacity(0.3)),
                                              onPressed: provider
                                                          .numberOfQuestions <
                                                      maxQuestions
                                                  ? () => provider
                                                      .setNumberOfQuestion(provider
                                                              .numberOfQuestions +
                                                          1)
                                                  : null,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.0),
                                        Text(
                                          totalQuestions > 0
                                              ? 'Selected: ${provider.numberOfQuestions.round()} questions'
                                              : 'No questions available for the selected criteria',
                                          style:
                                              AppTextStyle.bodyText1.copyWith(
                                            color: AppColors.darkText,
                                            fontWeight: FontWeight.w500,
                                          ),
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
                    ),

                    Consumer<CreateMockTestProvider>(
                        builder: (context, provider, child) {
                      return Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              authProvider.loadUserSession();
                              if (selectedSubjectIds.isNotEmpty &&
                                  selectedQuestion != null) {
                                if (authProvider.userSession!.userType ==
                                    "free") {
                                  _showPremiumAccessDialog(context);
                                } else {
                                  try {
                                    List<int> subjectIds = selectedSubjectIds
                                        .map((id) => int.tryParse(id) ?? -1)
                                        .where((id) => id != -1)
                                        .toList();
                                    print(
                                        "Subjects IDs are these: $subjectIds");
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RoutesName.createdMockTestScreen,
                                      arguments: {
                                        'test_mode': enableTimer,
                                        'question_mode': selectedQuestion,
                                        'subject_mode': subjectIds,
                                        'number_of_questions': provider
                                            .numberOfQuestions
                                            .toDouble()
                                      },
                                    );
                                  } catch (e) {
                                    print("Error converting subject IDs: $e");
                                  }
                                }
                              } else {
                                ToastHelper.showError(
                                    "Please select all options before submitting!");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 32, vertical: 16),
                              elevation: 1,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.whiteColor,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.indigo,
                                    AppColors.lightIndigo,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                child: Text(
                                  'Generate',
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
        ));
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

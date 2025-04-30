// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';

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
    fetchSubjects();
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
          style: AppTextStyle.appBarText,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: AppColors.textColor)),
      ),
      body: subjects.isEmpty
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Text('Please select options to generate mock test.',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    child: ExpansionTile(
                      title: Text('Test Mode'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  'Tutor',
                                  style: AppTextStyle.profileTitleText,
                                ),
                                trailing: Switch(
                                  activeColor: AppColors.primaryColor,
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
                                  style: AppTextStyle.profileTitleText,
                                ),
                                trailing: Switch(
                                  activeColor: AppColors.primaryColor,
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
                Consumer<CreateMockTestProvider>(
                  builder: (context, provider, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        child: ExpansionTile(
                          title: Text('Subjects Mode'),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: subjects.entries.map((entry) {
                                String subjectId = entry.key;
                                String subjectName = entry.value;
                                return ListTile(
                                  leading: Checkbox(
                                    activeColor: AppColors.primaryColor,
                                    value:
                                        selectedSubjectIds.contains(subjectId),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedSubjectIds.add(subjectId);
                                        } else {
                                          selectedSubjectIds.remove(subjectId);
                                        }

                                        // Check if both fields have valid values and hit API
                                        if (selectedSubjectIds.isNotEmpty &&
                                            selectedQuestion != null) {
                                          provider.getMockTestQuestionsCount(
                                            context,
                                            selectedSubjectIds
                                                .map((id) =>
                                                    int.tryParse(id) ?? -1)
                                                .toList(),
                                            selectedQuestion!,
                                          );
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(subjectName),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    child: ExpansionTile(
                      title: Text('Question Mode'),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._questions.map((question) => ListTile(
                                  leading: Radio<String>(
                                    activeColor: AppColors.primaryColor,
                                    value: question,
                                    groupValue: selectedQuestion,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedQuestion = value;
                                        final provider =
                                            Provider.of<CreateMockTestProvider>(
                                                context,
                                                listen: false);
                                        if (selectedSubjectIds.isNotEmpty &&
                                            selectedQuestion != null) {
                                          provider.getMockTestQuestionsCount(
                                            context,
                                            selectedSubjectIds
                                                .map((id) =>
                                                    int.tryParse(id) ?? -1)
                                                .toList(),
                                            selectedQuestion!,
                                          );
                                        }
                                      });
                                    },
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        question,
                                        // style: AppTextStyle.profileSubTitleText,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Slider with Plus and Minus Buttons
                // Slider with Plus and Minus Buttons
                Consumer<CreateMockTestProvider>(
                  builder: (context, provider, child) {
                    final totalQuestions = provider.availableQuestions ?? 0;
                    final maxQuestions =
                        totalQuestions > 0 ? totalQuestions.toDouble() : 1.0;
                    final minQuestions = 1.0;
                    final clampedValue = provider.numberOfQuestions
                        .toDouble()
                        .clamp(minQuestions, maxQuestions);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        child: ExpansionTile(
                          title: Text('Number of Questions'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Row with minus button, slider, and plus button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: provider.numberOfQuestions >
                                                minQuestions
                                            ? () =>
                                                provider.setNumberOfQuestion(
                                                    provider.numberOfQuestions -
                                                        1)
                                            : null,
                                      ),
                                      Expanded(
                                        child: Slider(
                                          activeColor: AppColors.primaryColor,
                                          value: clampedValue,
                                          min: minQuestions,
                                          max: maxQuestions,
                                          divisions: totalQuestions > 1
                                              ? (maxQuestions - minQuestions)
                                                  .toInt()
                                              : null,
                                          label:
                                              '${provider.numberOfQuestions.round()}',
                                          onChanged: totalQuestions > 0
                                              ? (value) =>
                                                  provider.setNumberOfQuestion(
                                                      value.round().toDouble())
                                              : null,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: provider.numberOfQuestions <
                                                maxQuestions
                                            ? () =>
                                                provider.setNumberOfQuestion(
                                                    provider.numberOfQuestions +
                                                        1)
                                            : null,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    totalQuestions > 0
                                        ? 'Selected: ${provider.numberOfQuestions.round()} questions'
                                        : 'No questions available for the selected criteria',
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          authProvider.loadUserSession();
                          if (selectedSubjectIds.isNotEmpty &&
                              selectedQuestion != null) {
                            if (authProvider.userSession!.userType == "free") {
                              _showPremiumAccessDialog(context);
                            } else {
                              try {
                                List<int> subjectIds = selectedSubjectIds
                                    .map((id) => int.tryParse(id) ?? -1)
                                    .where((id) => id != -1)
                                    .toList();
                                print("Subjects IDs are these: $subjectIds");
                                Navigator.pushReplacementNamed(
                                  context,
                                  RoutesName.createdMockTestScreen,
                                  arguments: {
                                    'test_mode': enableTimer,
                                    'question_mode': selectedQuestion,
                                    'subject_mode': subjectIds,
                                    'number_of_questions':
                                        provider.numberOfQuestions.toDouble()
                                  },
                                );
                              } catch (e) {
                                print("Error converting subject IDs: $e");
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Please select all options before submitting!")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: AppColors.textColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text('Generate'),
                      ),
                    ),
                  );
                })
              ],
            ),
    );
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

// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:no_screenshot/no_screenshot.dart';

class CreatedMockTestScreen extends StatefulWidget {
  final bool testMode;
  final String questionMode;
  final List<int> subjectMode;
  final double numberOfQuestions;

  const CreatedMockTestScreen({
    super.key,
    required this.numberOfQuestions,
    required this.questionMode,
    required this.subjectMode,
    required this.testMode,
  });

  @override
  CreatedMockTestScreenState createState() => CreatedMockTestScreenState();
}

class CreatedMockTestScreenState extends State<CreatedMockTestScreen> {
  final NoScreenshot _noScreenshot = NoScreenshot.instance;
  @override
  void initState() {
    super.initState();
    _noScreenshot.screenshotOn();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getQuestions();
    });
  }

  void getQuestions() async {
    final provider =
        Provider.of<CreateMockTestProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final subjectProvider =
        Provider.of<SubjectProvider>(context, listen: false);

    if (!mounted) return;

    final userId = authProvider.userSession?.userId;
    final testId = subjectProvider.testId;

    if (userId == null) {
      print("ERROR: User ID is null! Cannot fetch questions.");
      return;
    }

    print("Fetching Questions for:");
    print("User ID: $userId");
    print("Test ID: $testId");
    print("Subject Mode: ${widget.subjectMode}");
    print("Number of Questions: ${widget.numberOfQuestions}");

    Map<String, dynamic> data = {
      "user_id": userId,
      "test_id": testId,
      "subject_id": widget.subjectMode,
      "no_of_question": widget.numberOfQuestions.toInt(),
      "question_mode": widget.questionMode
    };

    await provider.getQuestions(context, data);
  }

  String removeHtmlTags(String? htmlText) {
    if (htmlText == null) return '';

    var text = htmlText
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');

    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateMockTestProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              provider.restartTest();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor)),
        title: Text(
          'Mock Test',
          style: AppTextStyle.heading2.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.deepPurple.withOpacity(0.1),
              AppColors.lightPurple.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Consumer<CreateMockTestProvider>(
            builder: (context, provider, child) {
              if (provider.loading) {
                return const Center(child: CupertinoActivityIndicator());
              }

              if (provider.questionList.isEmpty) {
                return const Center(
                    child: Text("No questions available. Please try again."));
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    if (!provider.isTestStarted)
                      _buildStartTestSection(provider),
                    if (provider.isTestStarted) _buildTestControls(provider),
                    const SizedBox(height: 10),
                    _buildQuestionCard(provider),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStartTestSection(CreateMockTestProvider provider) {
    int minutes = provider.timeInSeconds ~/ 60;
    int seconds = provider.timeInSeconds % 60;
    String formattedTime =
        'Total Time: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} min';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: provider.startTest,
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.whiteColor,
            backgroundColor: AppColors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            textStyle: AppTextStyle.button.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
          child: Text('Start Test', style: AppTextStyle.button),
        ),
        const SizedBox(height: 20),
        if (widget.testMode)
          Text(
            formattedTime,
            style: AppTextStyle.heading3.copyWith(
              color: AppColors.deepPurple,
            ),
          ),
      ],
    );
  }

  Widget _buildTestControls(CreateMockTestProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.testMode)
          CountdownTimer(
            endTime: provider.endTime,
            onEnd: () => provider.navigate(context),
            widgetBuilder: (_, time) {
              if (time == null) {
                return Text('Time\'s up!',
                    style: AppTextStyle.heading3.copyWith(
                      color: AppColors.deepPurple,
                    ));
              }

              String minutes = (time.min ?? 0).toString();
              String seconds = (time.sec ?? 0).toString().padLeft(2, '0');

              return Text(
                'Time Left: $minutes:$seconds minutes',
                style: AppTextStyle.heading3.copyWith(
                  color: AppColors.deepPurple,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildQuestionCard(CreateMockTestProvider provider) {
    if (provider.questionList.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No questions available'),
        ),
      );
    }

    if (provider.currentIndex >= provider.questionList.length) {
      return const Expanded(
        child: Center(
          child: Text('Invalid question index'),
        ),
      );
    }

    final currentQuestion = provider.questionList[provider.currentIndex];

    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                "${provider.currentIndex + 1}) ${removeHtmlTags(currentQuestion.question)}",
                style: AppTextStyle.heading3.copyWith(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                  title: Text(
                      removeHtmlTags(currentQuestion.option1)
                          .replaceAll(RegExp(r'[a-d]\)'), '')
                          .trim(),
                      style: AppTextStyle.bodyText1.copyWith(
                        color: AppColors.darkText,
                      )),
                  leading: Radio<int>(
                    value: 0,
                    groupValue: provider.selectedOptions[provider.currentIndex],
                    onChanged: !provider.isSubmitted[provider.currentIndex]
                        ? (value) {
                            if (value != null) {
                              provider.onChangeRadio(
                                  provider.currentIndex, value);
                            }
                          }
                        : null,
                  ),
                  trailing: provider.isSubmitted[provider.currentIndex] == false
                      ? null
                      : provider.isTrue![provider.currentIndex] &&
                              0 ==
                                  provider
                                      .selectedOptions[provider.currentIndex]
                          ? Icon(Icons.check, color: Colors.green, weight: 100)
                          : provider.correctAnswerOptionIndex![
                                      provider.currentIndex] ==
                                  0
                              ? Icon(Icons.check,
                                  color: Colors.green, weight: 100)
                              : provider.selectedOptions[
                                          provider.currentIndex] !=
                                      0
                                  ? null
                                  : Icon(Icons.close,
                                      color: Colors.red, weight: 100)),
              ListTile(
                  title: Text(
                      removeHtmlTags(currentQuestion.option2)
                          .replaceAll(RegExp(r'[a-d]\)'), '')
                          .trim(),
                      style: AppTextStyle.bodyText1.copyWith(
                        color: AppColors.darkText,
                      )),
                  leading: Radio<int>(
                    value: 1, // Current option value
                    groupValue: provider.selectedOptions[provider.currentIndex],
                    onChanged: provider.isSubmitted[provider.currentIndex]
                        ? null
                        : (value) {
                            if (value != null) {
                              provider.onChangeRadio(
                                  provider.currentIndex, value);
                            }
                          },
                  ),
                  trailing: provider.isSubmitted[provider.currentIndex] == false
                      ? null
                      : provider.isTrue![provider.currentIndex] &&
                              1 ==
                                  provider
                                      .selectedOptions[provider.currentIndex]
                          ? Icon(Icons.check, color: Colors.green, weight: 100)
                          : provider.correctAnswerOptionIndex![
                                      provider.currentIndex] ==
                                  1
                              ? Icon(Icons.check,
                                  color: Colors.green, weight: 100)
                              : provider.selectedOptions[
                                          provider.currentIndex] !=
                                      1
                                  ? null
                                  : Icon(Icons.close,
                                      color: Colors.red, weight: 100)),
              ListTile(
                  title: Text(
                      removeHtmlTags(currentQuestion.option3)
                          .replaceAll(RegExp(r'[a-d]\)'), '')
                          .trim(),
                      style: AppTextStyle.bodyText1.copyWith(
                        color: AppColors.darkText,
                      )),
                  leading: Radio<int>(
                    value: 2, // Current option value
                    groupValue: provider.selectedOptions[provider.currentIndex],
                    onChanged: provider.isSubmitted[provider.currentIndex]
                        ? null
                        : (value) {
                            if (value != null) {
                              provider.onChangeRadio(
                                  provider.currentIndex, value);
                            }
                          },
                  ),
                  trailing: provider.isSubmitted[provider.currentIndex] == false
                      ? null
                      : provider.isTrue![provider.currentIndex] &&
                              2 ==
                                  provider
                                      .selectedOptions[provider.currentIndex]
                          ? Icon(Icons.check, color: Colors.green, weight: 100)
                          : provider.correctAnswerOptionIndex![
                                      provider.currentIndex] ==
                                  2
                              ? Icon(Icons.check,
                                  color: Colors.green, weight: 100)
                              : provider.selectedOptions[
                                          provider.currentIndex] !=
                                      2
                                  ? null
                                  : Icon(Icons.close,
                                      color: Colors.red, weight: 100)),
              ListTile(
                  title: Text(
                      removeHtmlTags(currentQuestion.option4)
                          .replaceAll(RegExp(r'[a-d]\)'), '')
                          .trim(),
                      style: AppTextStyle.bodyText1.copyWith(
                        color: AppColors.darkText,
                      )),
                  leading: Radio<int>(
                    value: 3,
                    groupValue: provider.selectedOptions[provider.currentIndex],
                    onChanged: !provider.isSubmitted[provider.currentIndex]
                        ? (value) {
                            if (value != null) {
                              provider.onChangeRadio(
                                  provider.currentIndex, value);
                            }
                          }
                        : null,
                  ),
                  trailing: provider.isSubmitted[provider.currentIndex] == false
                      ? null
                      : provider.isTrue![provider.currentIndex] &&
                              3 ==
                                  provider
                                      .selectedOptions[provider.currentIndex]
                          ? Icon(Icons.check, color: Colors.green, weight: 100)
                          : provider.correctAnswerOptionIndex![
                                      provider.currentIndex] ==
                                  3
                              ? Icon(Icons.check,
                                  color: Colors.green, weight: 100)
                              : provider.selectedOptions[
                                          provider.currentIndex] !=
                                      3
                                  ? null
                                  : Icon(Icons.close,
                                      color: Colors.red, weight: 100)),
              const SizedBox(height: 10),
              _buildNavigationButtons(provider),
              const SizedBox(height: 10),
              _buildExplanation(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(CreateMockTestProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: provider.isPrevEnabled ? provider.goToPrevious : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                provider.isPrevEnabled ? AppColors.primaryColor : Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        ElevatedButton(
          onPressed: provider.isTestStarted == false ||
                  provider.isSubmitted[provider.currentIndex]
              ? null
              : () => provider.submitAnswer(context, provider.currentIndex),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: provider.isNxtEnabled ? provider.goToNext : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                provider.isNxtEnabled ? AppColors.primaryColor : Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildExplanation(CreateMockTestProvider provider) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (provider.questionList.isNotEmpty &&
                provider.currentIndex < provider.questionList.length) {
              showFeedbackDialog(
                context,
                authProvider.userSession!.userId,
                authProvider.userSession!.testId,
                provider.questionList[provider.currentIndex].id!,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
            textStyle: TextStyle(fontSize: 18),
          ),
          child: Text('Feedback'),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Show Explanation', style: AppTextStyle.questionText),
            Switch(
              activeColor: AppColors.primaryColor,
              value: provider.showExplanation[provider.currentIndex],
              onChanged: (value) => provider.toggleExplanationSwitch(value),
            ),
          ],
        ),
        if (provider.showExplanation[provider.currentIndex] &&
            provider.isSubmitted[provider.currentIndex])
          Text(
            removeHtmlTags(provider.questionList[provider.currentIndex].detail),
            style: AppTextStyle.answerText,
          ),
      ],
    );
  }

  void showFeedbackDialog(
      BuildContext context, int userId, int testId, int questionId) {
    final formKey = GlobalKey<FormState>();
    TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        title: Center(
          child: Text(
            'Share Feedback',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        contentPadding: EdgeInsets.all(20),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: feedbackController,
                  decoration: InputDecoration(
                    labelText: 'Your Feedback',
                    hintText: 'Enter any issues or suggestions',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100], // Soft background inside input
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25),
                SizedBox(
                    width: double.infinity,
                    child: Consumer<FeedbackProvider>(
                      builder: (context, feedbackProvider, _) {
                        return ElevatedButton(
                          onPressed: feedbackProvider.isLoading
                              ? null
                              : () {
                                  Map<String, dynamic> feedbackData = {
                                    "user_id": "123",
                                    "feedback": "Great app!"
                                  };
                                  feedbackProvider.giveFeedback(
                                      context, feedbackData);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: feedbackProvider.isLoading
                              ? CupertinoActivityIndicator(color: Colors.white)
                              : Text(
                                  'Submit Feedback',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                        );
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

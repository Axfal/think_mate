// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:no_screenshot/no_screenshot.dart';

class MockTestScreen extends StatefulWidget {
  final int subjectId;
  final int chapterId;
  const MockTestScreen({super.key, this.subjectId = 0, this.chapterId = 0});

  @override
  MockTestScreenState createState() => MockTestScreenState();
}

class MockTestScreenState extends State<MockTestScreen> {
  final NoScreenshot _noScreenshot = NoScreenshot.instance;
  @override
  void initState() {
    super.initState();
    _noScreenshot.screenshotOn();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  void fetchData() async {
    try {
      final provider = Provider.of<MockTestProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.loadUserSession();
      final userType = authProvider.userSession?.userType;

      if (userType == "free") {
        await provider.validateUser(context);
        if (provider.validateUserModel?.status == "allowed") {
          await provider.fetchQuestions(context);
        } else {
          debugPrint(
              "You have completed your demo test. Please buy a subscription to continue.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'You have completed the demo test. Buy a subscription to continue.',
              ),
            ),
          );
        }
      } else {
        await provider.fetchQuestions(context);
      }
    } catch (e) {
      debugPrint("Failed to fetch questions: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load questions.')),
      );
    }
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
    final provider = Provider.of<MockTestProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    if (provider.loading) {
      return Scaffold(body: Center(child: CupertinoActivityIndicator()));
    }

    if (provider.questions == null || provider.questions!.questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'No questions available.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    if (provider.currentIndex >= provider.questions!.questions.length) {
      return Scaffold(
        body: Center(
          child: Text(
            'No more questions available.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }


    final currentQuestion = provider.questionList[provider.currentIndex];

    return Scaffold(
        body: provider.loading
            ? Center(child: CircularProgressIndicator())
            : provider.questions == null ||
                    provider.questions!.questions.isEmpty
                ? Center(
                    child: Text(
                      'No questions available.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : provider.currentIndex >= provider.questions!.questions.length
                    ? Center(
                        child: Text('No questions available.',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            if (!provider.isTestStarted)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(
                                  onPressed: provider.startTest,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AppColors.primaryColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15),
                                    textStyle: TextStyle(fontSize: 18),
                                  ),
                                  child: Text('Start Test'),
                                ),
                              ),
                            if (provider.isTestStarted)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(
                                  onPressed: () => provider.navigate(context),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AppColors.primaryColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                    textStyle: TextStyle(fontSize: 18),
                                  ),
                                  child: Text('End Test'),
                                ),
                              ),
                            SizedBox(height: 20),
                            Expanded(
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
                                        AppColors.whiteColor,
                                        AppColors.backgroundColor.withOpacity(0.5),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.purpleShadow,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ListView(
                                      children: [
                                        Text(
                                          "${provider.currentIndex + 1}) ${provider.questions!.questions[provider.currentIndex].question}",
                                          style: AppTextStyle.questionText.copyWith(
                                            color: AppColors.darkText,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        ListTile(
                                            title: Text(
                                                removeHtmlTags(currentQuestion.option1)
                                                    .replaceAll(RegExp(r'[a-d]\)'), '')
                                                    .trim(),
                                                style: AppTextStyle.answerText),
                                            leading: Radio<int>(
                                              value: 0,
                                              groupValue: provider.isTestStarted?
                                              provider.selectedOptions[provider.currentIndex]
                                                  : null,
                                              onChanged: (provider.isTestStarted && !provider.isSubmitted[provider.currentIndex])
                                                  ? (value) {
                                                if (value != null) {
                                                  provider.onChangeRadio(provider.currentIndex, value);
                                                }
                                              }
                                                  : null
                                            ),

                                            trailing: provider.isSubmitted[provider.currentIndex] == false
                                                ? null : provider.isTrue![provider.currentIndex]
                                                && 0 == provider.selectedOptions[provider.currentIndex]?
                                            Icon(Icons.check, color: Colors.green, weight: 100):
                                            provider.correctAnswerOptionIndex![provider.currentIndex] == 0? Icon(Icons.check, color: Colors.green, weight: 100):
                                            provider.selectedOptions[provider.currentIndex] != 0? null: Icon(Icons.close, color: Colors.red, weight: 100)
                                        ),
                                        ListTile(
                                            title: Text(
                                                removeHtmlTags(currentQuestion.option2)
                                                    .replaceAll(RegExp(r'[a-d]\)'), '')
                                                    .trim(),
                                                style: AppTextStyle.answerText),
                                            leading: Radio<int>(
                                              value: 1,
                                                groupValue: provider.isTestStarted
                                                    ? provider.selectedOptions[provider.currentIndex]
                                                    : null,
                                                onChanged: (provider.isTestStarted && !provider.isSubmitted[provider.currentIndex])
                                                    ? (value) {
                                                  if (value != null) {
                                                    provider.onChangeRadio(provider.currentIndex, value);
                                                  }
                                                }
                                                    : null
                                            ),
                                            trailing: provider.isSubmitted[provider.currentIndex] == false
                                                ? null : provider.isTrue![provider.currentIndex]
                                                && 1 == provider.selectedOptions[provider.currentIndex]?
                                            Icon(Icons.check, color: Colors.green, weight: 100):
                                            provider.correctAnswerOptionIndex![provider.currentIndex] == 1? Icon(Icons.check, color: Colors.green, weight: 100):
                                            provider.selectedOptions[provider.currentIndex] != 1? null: Icon(Icons.close, color: Colors.red, weight: 100)
                                        ),
                                        ListTile(
                                            title: Text(
                                                removeHtmlTags(currentQuestion.option3)
                                                    .replaceAll(RegExp(r'[a-d]\)'), '')
                                                    .trim(),
                                                style: AppTextStyle.answerText),
                                            leading: Radio<int>(
                                              value: 2, // Current option value
                                                groupValue: provider.isTestStarted
                                                    ? provider.selectedOptions[provider.currentIndex]
                                                    : null,
                                                onChanged: (provider.isTestStarted && !provider.isSubmitted[provider.currentIndex])
                                                    ? (value) {
                                                  if (value != null) {
                                                    provider.onChangeRadio(provider.currentIndex, value);
                                                  }
                                                }
                                                    : null
                                            ),
                                            trailing: provider.isSubmitted[provider.currentIndex] == false
                                                ? null : provider.isTrue![provider.currentIndex]
                                                && 2 == provider.selectedOptions[provider.currentIndex]?
                                            Icon(Icons.check, color: Colors.green, weight: 100):
                                            provider.correctAnswerOptionIndex![provider.currentIndex] == 2? Icon(Icons.check, color: Colors.green, weight: 100):
                                            provider.selectedOptions[provider.currentIndex] != 2? null: Icon(Icons.close, color: Colors.red, weight: 100)
                                        ),
                                        ListTile(
                                            title: Text(
                                                removeHtmlTags(currentQuestion.option4)
                                                    .replaceAll(RegExp(r'[a-d]\)'), '')
                                                    .trim(),
                                                style: AppTextStyle.answerText),
                                            leading: Radio<int>(
                                              value: 3,
                                                groupValue: provider.isTestStarted
                                                    ? provider.selectedOptions[provider.currentIndex]
                                                    : null,
                                                onChanged: (provider.isTestStarted && !provider.isSubmitted[provider.currentIndex])
                                                    ? (value) {
                                                  if (value != null) {
                                                    provider.onChangeRadio(provider.currentIndex, value);
                                                  }
                                                }
                                                    : null
                                            ),
                                            trailing: provider.isSubmitted[provider.currentIndex] == false
                                                ? null : provider.isTrue![provider.currentIndex]
                                                && 3 == provider.selectedOptions[provider.currentIndex]?
                                            Icon(Icons.check, color: Colors.green, weight: 100):
                                            provider.correctAnswerOptionIndex![provider.currentIndex] == 3? Icon(Icons.check, color: Colors.green, weight: 100):
                                            provider.selectedOptions[provider.currentIndex] != 3? null: Icon(Icons.close, color: Colors.red, weight: 100)
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: provider.isPrevEnabled
                                                  ? provider.goToPrevious
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: provider.isPrevEnabled
                                                    ? AppColors.deepPurple
                                                    : AppColors.lightPurple.withOpacity(0.3),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 15),
                                                elevation: provider.isPrevEnabled ? 4 : 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Icon(Icons.arrow_back_ios,
                                                  color: provider.isPrevEnabled
                                                      ? Colors.white
                                                      : AppColors.darkText.withOpacity(0.3)),
                                            ),
                                            ElevatedButton(
                                              onPressed: provider.isTestStarted == false ||
                                                      provider.isSubmitted[
                                                          provider.currentIndex]
                                                  ? null
                                                  : () => provider.submitAnswer(
                                                      context, provider.currentIndex),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: AppColors.deepPurple,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 15),
                                                elevation: 4,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                'Submit',
                                                style: AppTextStyle.bodyText1.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: provider.isNxtEnabled
                                                  ? provider.goToNext
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: provider.isNxtEnabled
                                                    ? AppColors.deepPurple
                                                    : AppColors.lightPurple.withOpacity(0.3),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 15),
                                                elevation: provider.isNxtEnabled ? 4 : 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Icon(Icons.arrow_forward_ios,
                                                  color: provider.isNxtEnabled
                                                      ? Colors.white
                                                      : AppColors.darkText.withOpacity(0.3)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () => showFeedbackDialog(
                                              context,
                                              authProvider.userSession!.userId,
                                              authProvider.userSession!.testId,
                                              provider
                                                  .questionList[
                                                      provider.currentIndex]
                                                  .id),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            padding: EdgeInsets.symmetric(
                                                // horizontal: 50,
                                                vertical: 15),
                                            textStyle: TextStyle(fontSize: 18),
                                          ),
                                          child: Text('Feedback'),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Show Explanation',
                                                style: AppTextStyle.questionText),
                                            Switch(
                                              activeColor: AppColors.primaryColor,
                                                value: provider.showExplanation[
                                                    provider.currentIndex],
                                                onChanged: (value) => provider
                                                    .toggleExplanationSwitch(
                                                        value)),
                                          ],
                                        ),
                                        if (provider.showExplanation[
                                                provider.currentIndex] &&
                                            provider.isSubmitted[
                                                provider.currentIndex])
                                          Text(
                                            provider
                                                .questions!
                                                .questions[provider.currentIndex]
                                                .detail,
                                            style: AppTextStyle.answerText,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )));
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
                    builder: (context, feedbackProvider, child) {
                      return ElevatedButton(
                        onPressed: feedbackProvider.isLoading
                            ? null
                            : () async {
                          if (formKey.currentState?.validate() ?? false) {
                            Map<String, dynamic> data = {
                              "user_id": userId,
                              "test_id": testId,
                              "question_id": questionId,
                              "detail": feedbackController.text
                            };
                            await feedbackProvider.giveMockTestFeedback(context, data);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: feedbackProvider.isLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CupertinoActivityIndicator(color: Colors.white,),
                        )
                            : const Text(
                          'Submit Feedback',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}

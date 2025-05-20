// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:education_app/utils/screenshot_protector.dart';

class QuestionScreen extends StatefulWidget {
  final int subjectId;
  final int chapterId;
  final int testId;
  const QuestionScreen(
      {super.key,
      required this.subjectId,
      required this.chapterId,
      required this.testId});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  void initState() {
    super.initState();
    ScreenshotProtector.enableProtection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      _showPremiumAccessDialog(context);
    });
  }

  @override
  void dispose() {
    ScreenshotProtector.disableProtection();
    super.dispose();
  }

  void _showPremiumAccessDialog(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.userSession!.userType == 'free' ||
        authProvider.userSession!.testId != widget.testId) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              "Upgrade to Premium",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.successColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Get access to the full question bank, exclusive content, and boost your learning journey.\nEnjoy 5 demo questions for free!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, RoutesName.subscriptionScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: AppColors.successColor,
                    elevation: 4,
                  ),
                  child: Text(
                    'Go Premium',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.greyText,
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  child: const Text("Try Demo"),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> getData() async {
    try {
      final bookMarkProvider =
          Provider.of<BookMarkProvider>(context, listen: false);
      final provider = Provider.of<QuestionsProvider>(context, listen: false);

      await provider.fetchQuestions(
          context, widget.testId, widget.subjectId, widget.chapterId);
      await bookMarkProvider.getBookMarking(context);
      provider.getSelectedOptions();
      await provider.getCheckedQuestions(context);
    } catch (e, stackTrace) {
      debugPrint("Error fetching questions: $e");
      debugPrint("Stack trace: $stackTrace");

      if (mounted) {
        ToastHelper.showError("Error fetching questions: $e");
      }
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
    final bookMarkProvider = Provider.of<BookMarkProvider>(context);
    final provider = Provider.of<QuestionsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final subjectProvider = Provider.of<SubjectProvider>(context);
    final chapterProvider = Provider.of<ChapterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => provider.goBack(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          chapterProvider.chapterName.isNotEmpty &&
                  chapterProvider.chapterId > 0
              ? chapterProvider.chapterName[chapterProvider.chapterData
                  .indexWhere((c) => c.id == chapterProvider.chapterId)]
              : 'Chapter',
          style: AppTextStyle.heading3.copyWith(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
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
        actions: [
          TextButton(
            onPressed: () {
              _showResetConfirmationDialog(context, () async {
                final resetProvider =
                    Provider.of<ResetProvider>(context, listen: false);
                final chapterId = chapterProvider.chapterId;
                await resetProvider.resetQuestions(context, chapterId);
                if (resetProvider.resetModel?.success == true) {
                  provider.restartTest();
                  await provider.removeAllDataByChapterId(chapterId);
                }
              });
            },
            child: Text('Reset', style: AppTextStyle.subscriptionDetailText),
          ),
          PopupMenuButton<FilterType>(
            icon: const Icon(Icons.more_vert),
            onSelected: (filter) {
              print("Selected Filter: $filter");
              provider.applyFilter(context, filter, widget.testId);
            },
            itemBuilder: (context) => FilterType.values
                .map((filter) => PopupMenuItem(
                    value: filter,
                    child: Text(filter.toString().split('.').last)))
                .toList(),
          ),
        ],
      ),
      body: provider.loading
          ? const Center(child: CupertinoActivityIndicator())
          : provider.filteredQuestions.isEmpty
              ? const Center(
                  child: Text('No questions available.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.indigo.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (authProvider.userSession!.userType == 'free' ||
                                  authProvider.userSession!.testId !=
                                      widget.testId)
                              ? Text(
                                  'Total Demo Questions: 5',
                                  style: AppTextStyle.heading3.copyWith(
                                    color: AppColors.darkText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Text(
                                  'Total Questions: ${provider.filteredQuestions.length}',
                                  style: AppTextStyle.heading3.copyWith(
                                      color: AppColors.darkText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                          Text(
                            'Answered: ${provider.isSubmitted.entries.where((entry) => provider.filteredQuestions.any((q) => q.id == entry.key)).length}',
                            style: AppTextStyle.bodyText1.copyWith(
                              fontSize: 12,
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            (authProvider.userSession!.userType == "free" ||
                                    authProvider.userSession!.testId !=
                                        widget.testId)
                                ? 5
                                : provider.filteredQuestions.length,
                        itemBuilder: (context, index) {
                          final question = provider.filteredQuestions[index];
                          Widget buildOption(
                              int optionIndex, String optionText) {
                            return ListTile(
                              title: Text(
                                  removeHtmlTags(optionText)
                                      .replaceAll(RegExp(r'[a-d]\)'), '')
                                      .trim(),
                                  style: AppTextStyle.answerText),
                              leading: Radio<int>(
                                activeColor: AppColors.indigo,
                                value: optionIndex,
                                groupValue:
                                    provider.selectedOptions[question.id] ?? -1,
                                onChanged: (provider.isSubmitted
                                                .containsKey(question.id) &&
                                            provider.isSubmitted[question.id] ==
                                                true) ||
                                        provider.isQuestionAlreadySubmitted(
                                            question.id)
                                    ? null
                                    : (value) => provider.onChangeRadio(
                                        question.id, value!),
                              ),
                              trailing: _buildTrailingIcon(
                                  provider, question, optionIndex),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Card(
                              elevation: 2,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Text('${index + 1}',
                                        style: AppTextStyle.questionText),
                                    title: Text(
                                        removeHtmlTags(question.question),
                                        style: AppTextStyle.questionText),
                                    trailing: Checkbox(
                                      activeColor: AppColors.lightIndigo,
                                      value: provider
                                          .isQuestionChecked(question.id),
                                      onChanged: (value) {
                                        provider.checkTheQuestion(
                                            context, question.id);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  buildOption(0, question.option1),
                                  buildOption(1, question.option2),
                                  buildOption(2, question.option3),
                                  buildOption(3, question.option4),
                                  _buildActionButtons(
                                      context,
                                      provider,
                                      authProvider,
                                      subjectProvider,
                                      chapterProvider,
                                      bookMarkProvider,
                                      index),
                                  _buildExplanation(provider, index)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildExplanation(QuestionsProvider provider, int index) {
    // final authProvider = Provider.of<AuthProvider>(context);
    // final chapterProvider =
    //     Provider.of<ChapterProvider>(context, listen: false);
    final question = provider.filteredQuestions[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Show Explanation', style: AppTextStyle.questionText),
              Switch(
                activeColor: AppColors.successColor,
                inactiveThumbColor: AppColors.lightIndigo,
                inactiveTrackColor: AppColors.dividerColor,
                activeTrackColor: AppColors.dividerColor,
                trackOutlineColor:
                    WidgetStatePropertyAll(WidgetStateColor.transparent),
                value: provider.showExplanation[index],
                onChanged: (value) {
                  if (provider.isQuestionAlreadySubmitted(
                          provider.filteredQuestions[index].id) ||
                      provider.isSubmitted[question.id] == true) {
                    provider.toggleExplanationSwitch(index, value);
                  }
                },
              ),
            ],
          ),
        ),
        if (provider.showExplanation[index])
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
            child: Text(
              removeHtmlTags(provider.filteredQuestions[index].detail),
              style: AppTextStyle.answerText,
            ),
          ),
      ],
    );
  }

  Icon? _buildTrailingIcon(
      QuestionsProvider provider, Question question, int optionIndex) {
    if ((!provider.isSubmitted.containsKey(question.id) ||
            provider.isSubmitted[question.id] == false) &&
        !provider.isQuestionAlreadySubmitted(question.id)) {
      return null;
    }

    String correctAnswerKey = question.correctAnswer.toLowerCase();
    int correctAnswerIndex =
        provider.correctOptionMapping[correctAnswerKey] ?? -1;
    if (provider.selectedOptions[question.id] == optionIndex &&
        provider.isTrue.containsKey(question.id) &&
        provider.isTrue[question.id] == true) {
      return Icon(Icons.check, color: AppColors.successColor);
    } else if (correctAnswerIndex == optionIndex) {
      return Icon(Icons.check, color: AppColors.successColor);
    } else if (provider.selectedOptions[question.id] == optionIndex) {
      return Icon(Icons.close, color: AppColors.errorColor);
    }

    return null;
  }

  Widget _buildActionButtons(
    BuildContext context,
    QuestionsProvider provider,
    AuthProvider authProvider,
    SubjectProvider subjectProvider,
    ChapterProvider chapterProvider,
    BookMarkProvider bookMarkProvider,
    int index,
  ) {
    final question = provider.filteredQuestions[index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.indigo,
              foregroundColor: AppColors.textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => showFeedbackDialog(
              context,
              authProvider.userSession!.userId,
              authProvider.userSession!.testId,
              subjectProvider.selectedSubjectId,
              chapterProvider.chapterId,
              provider.questions!.questions[index].id,
            ),
            child: Icon(Icons.feedback, size: 22, color: AppColors.whiteColor),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.indigo,
              foregroundColor: AppColors.textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: (provider.isSubmitted.containsKey(question.id) &&
                        provider.isSubmitted[question.id] == true) ||
                    provider.isQuestionAlreadySubmitted(question.id)
                ? null
                : () => provider.submitAnswer(context, question.id),
            child: const Text('Submit'),
          ),
          const SizedBox(width: 10),
          _buildBookmarkButton(context, provider, bookMarkProvider, index),
        ],
      ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context, QuestionsProvider provider,
      BookMarkProvider bookMarkProvider, int index) {
    final question = provider.filteredQuestions[index];
    final questionId = question.id;
    final isBookmarked = bookMarkProvider.isBookmarked(questionId);
    final canBookmark = (provider.isSubmitted[questionId] ?? false) ||
        provider.isQuestionAlreadySubmitted(questionId);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.indigo,
        foregroundColor: AppColors.textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: !canBookmark
          ? () => ToastHelper.showError('Submit question before bookmarking')
          : () async {
              if (isBookmarked) {
                await bookMarkProvider.deleteBookMarking(context, questionId);
                ToastHelper.showSuccess('Bookmark removed');
              } else {
                await bookMarkProvider.bookMarking(context, questionId);
                ToastHelper.showSuccess('Bookmark added');
              }
            },
      child: bookMarkProvider.isLoading
          ? SizedBox(
              child: CupertinoActivityIndicator(
              color: AppColors.whiteColor,
            ))
          : Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline_outlined,
              size: 22,
              color: AppColors.whiteColor),
    );
  }

  void showFeedbackDialog(BuildContext context, int userId, int testId,
      int subjectId, int chapterId, int questionId) {
    final formKey = GlobalKey<FormState>();
    TextEditingController feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share Feedback',
                    style: AppTextStyle.heading3.copyWith(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: feedbackController,
                    decoration: InputDecoration(
                      hintText: 'Enter your feedback',
                      hintStyle: AppTextStyle.bodyText1.copyWith(
                        color: AppColors.darkText.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: AppColors.deepPurple.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderColor),
                      ),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your feedback';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          feedbackController.clear();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: AppTextStyle.bodyText1.copyWith(
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Consumer<FeedbackProvider>(
                        builder: (context, feedbackProvider, child) {
                          return ElevatedButton(
                            onPressed: feedbackProvider.isLoading
                                ? null
                                : () async {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      Map<String, dynamic> data = {
                                        "user_id": userId,
                                        "test_id": testId,
                                        "subject_id": subjectId,
                                        "chapter_id": chapterId,
                                        "question_id": questionId,
                                        "detail": feedbackController.text
                                      };
                                      await feedbackProvider.giveFeedback(
                                          context, data);
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.indigo,
                              foregroundColor: AppColors.textColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: feedbackProvider.isLoading
                                ? SizedBox(
                                    child: CupertinoActivityIndicator(
                                        color: AppColors.whiteColor),
                                  )
                                : Text(
                                    'Submit',
                                    style: AppTextStyle.bodyText1.copyWith(
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showResetConfirmationDialog(
      BuildContext context, VoidCallback onConfirm) {
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: Text(
                  'Reset Confirmation',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "You can only reset once in your entire lifetime. If you've already used your reset, please contact the admin to restore this option.",
                    style: AppTextStyle.bodyText1.copyWith(
                      color: AppColors.darkText.withOpacity(0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        child: Text(
                          'Cancel',
                          style: AppTextStyle.bodyText1.copyWith(
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() => isLoading = true);
                                onConfirm();
                                // Wait for a short delay to ensure the API call has time to complete
                                Future.delayed(Duration(milliseconds: 500), () {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          backgroundColor: AppColors.redColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CupertinoActivityIndicator(
                                  color: AppColors.whiteColor,
                                ),
                              )
                            : Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

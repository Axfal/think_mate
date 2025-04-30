// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:education_app/resources/exports.dart';
import 'package:education_app/view_model/provider/reset_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:no_screenshot/no_screenshot.dart';

class QuestionScreen extends StatefulWidget {
  final int subjectId;
  final int chapterId;
  const QuestionScreen(
      {super.key, required this.subjectId, required this.chapterId});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final NoScreenshot _noScreenshot = NoScreenshot.instance;
  @override
  void initState() {
    super.initState();
    _noScreenshot.screenshotOn();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    try {
      final bookMarkProvider =
          Provider.of<BookMarkProvider>(context, listen: false);
      final provider = Provider.of<QuestionsProvider>(context, listen: false);

      await provider.fetchQuestions(
          context, widget.subjectId, widget.chapterId);
      await bookMarkProvider.getBookMarking(context);
      provider.getSelectedOptions();
      await provider.getCheckedQuestions(context);
    } catch (e, stackTrace) {
      debugPrint("Error fetching questions: $e");
      debugPrint("Stack trace: $stackTrace");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching questions: $e")),
        );
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
        backgroundColor: AppColors.primaryColor,
        actions: [
          TextButton(
            onPressed: () async {
              final resetProvider =
                  Provider.of<ResetProvider>(context, listen: false);
              final chapterId = chapterProvider.chapterId;
              await resetProvider.resetQuestions(context, chapterId);
              if (resetProvider.resetModel?.success == true) {
                provider.restartTest();
                await provider.removeAllDataByChapterId(chapterId);
              }
            },
            child: Text('Reset', style: AppTextStyle.subscriptionDetailText),
          ),
          PopupMenuButton<FilterType>(
            icon: const Icon(Icons.more_vert),
            onSelected: (filter) {
              print("Selected Filter: $filter");
              provider.applyFilter(context, filter);
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
              : ListView.builder(
                  itemCount: provider.filteredQuestions.length,
                  itemBuilder: (context, index) {
                    final question = provider.filteredQuestions[index];
                    Widget buildOption(int optionIndex, String optionText) {
                      return ListTile(
                        title: Text(
                            removeHtmlTags(optionText)
                                .replaceAll(RegExp(r'[a-d]\)'), '')
                                .trim(),
                            style: AppTextStyle.answerText),
                            leading: Radio<int>(
                      activeColor: AppColors.primaryColor,
                      value: optionIndex,
                      groupValue: provider.selectedOptions[question.id] ?? -1,
                      onChanged: (provider.isSubmitted.containsKey(question.id) && provider.isSubmitted[question.id] == true) ||
                      provider.isQuestionAlreadySubmitted(question.id)
                      ? null
                          : (value) => provider.onChangeRadio(question.id, value!),),
                        trailing:
                            _buildTrailingIcon(provider, question, optionIndex),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Text('${index + 1}',
                                  style: AppTextStyle.questionText),
                              title: Text(removeHtmlTags(question.question),
                                  style: AppTextStyle.questionText),
                              trailing: Checkbox(
                                activeColor: AppColors.primaryColor,
                                value: provider.isQuestionChecked(question.id),
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
    );
  }

  Widget _buildExplanation(QuestionsProvider provider, int index) {
    final authProvider = Provider.of<AuthProvider>(context);
    final chapterProvider =
        Provider.of<ChapterProvider>(context, listen: false);
    final question = provider.filteredQuestions[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Show Explanation', style: AppTextStyle.questionText),
              Switch(
                activeColor: AppColors.primaryColor,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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

    if ((!provider.isSubmitted.containsKey(question.id) || provider.isSubmitted[question.id] == false) &&
        !provider.isQuestionAlreadySubmitted(question.id)) {
      return null;
    }

    String correctAnswerKey = question.correctAnswer.toLowerCase();
    int correctAnswerIndex = provider.correctOptionMapping[correctAnswerKey] ?? -1;
    if (provider.selectedOptions[question.id] == optionIndex &&
        provider.isTrue.containsKey(question.id) && provider.isTrue[question.id] == true) {
      return const Icon(Icons.check, color: Colors.green);
    } else if (correctAnswerIndex == optionIndex) {
      return const Icon(Icons.check, color: Colors.green);
    } else if (provider.selectedOptions[question.id] == optionIndex) {
      return const Icon(Icons.close, color: Colors.red);
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: () => showFeedbackDialog(
              context,
              authProvider.userSession!.userId,
              authProvider.userSession!.testId,
              subjectProvider.selectedSubjectId,
              chapterProvider.chapterId,
              provider.questions!.questions[index].id,
            ),
            child: const Icon(Icons.feedback_outlined, size: 25, color: Colors.white),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 18),
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
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: TextStyle(fontSize: 18),
      ),
      onPressed: !canBookmark
          ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Submit question before bookmarking')))
          : () async {
        if (isBookmarked) {
          await bookMarkProvider.deleteBookMarking(context, questionId);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Bookmark removed')));
        } else {
          await bookMarkProvider.bookMarking(context, questionId);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Bookmark added')));
        }
      },
      child: bookMarkProvider.isLoading
          ? SizedBox(
          height: 25,
          width: 25,
          child: const CupertinoActivityIndicator(color: Colors.white,))
          : Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_outline_outlined,
          size: 25,
          color: Colors.white),
    );
  }

  void showFeedbackDialog(BuildContext context, int userId, int testId,
      int subjectId, int chapterId, int questionId) {
    final formKey = GlobalKey<FormState>();
    TextEditingController feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
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
                    fillColor: Colors.grey[100],
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
                Consumer<FeedbackProvider>(
                  builder: (context, feedbackProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: feedbackProvider.isLoading
                            ? null
                            : () async {
                                if (formKey.currentState?.validate() ?? false) {
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: feedbackProvider.isLoading
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CupertinoActivityIndicator()
                              )
                            : Text(
                                'Submit Feedback',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

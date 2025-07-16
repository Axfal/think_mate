// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_all/flutter_html_all.dart';

class MockTestScreen extends StatefulWidget {
  final int subjectId;
  final int chapterId;
  final int testId;

  const MockTestScreen({super.key, this.subjectId = 0, this.chapterId = 0, this.testId = 0});

  @override
  MockTestScreenState createState() => MockTestScreenState();
}

class MockTestScreenState extends State<MockTestScreen> {
  @override
  void initState() {
    super.initState();
    ScreenshotProtector.enableProtection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  @override

  void dispose() {
    ScreenshotProtector.disableProtection();
    super.dispose();
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
          if(!mounted) return;
          await provider.fetchQuestions(context, widget.testId);
        } else {
          debugPrint(
              "You have completed your demo test. Please buy a subscription to continue.");
          ToastHelper.showError(
              'You have completed the demo test. Buy a subscription to continue.'
          );
        }
      } else {
        await provider.fetchQuestions(context, widget.testId);
      }
    } catch (e) {
      debugPrint("Failed to fetch questions: $e");
      ToastHelper.showError('Failed to load questions.');
    }
  }

  Widget renderFullHtmlString(
      String? html, {
        GlobalKey? anchorKey,
        TextStyle? defaultTextStyle,
      }) {
    if (html == null || html.trim().isEmpty) return const SizedBox.shrink();

    return Html(
      anchorKey: anchorKey,
      data: html,
      style: {
        "body": Style.fromTextStyle(defaultTextStyle ?? const TextStyle()),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"img"},
          builder: (context) {
            final src = context.attributes['src'];
            if (src == null || !src.startsWith("http")) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  src,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      alignment: Alignment.center,
                      color: Colors.grey[200],
                      child: const CupertinoActivityIndicator(),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                  ),
                ),
              ),
            );
          },
        ),
        // You can keep your other extensions as needed
        const MathHtmlExtension(),
        const AudioHtmlExtension(),
        const VideoHtmlExtension(),
        const IframeHtmlExtension(),
        const TableHtmlExtension(),
        const SvgHtmlExtension(),
      ],
    );
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
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    if (!provider.isTestStarted)
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.indigo,
                              AppColors.lightIndigo,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.purpleShadow,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: provider.startTest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Start Test'),
                        ),
                      ),
                    if (provider.isTestStarted)
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.redColor,
                              AppColors.redColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkShadow,
                              blurRadius: 1,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => provider.navigate(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('End Test'),
                        ),
                      ),

                        buttonWidgets('Calculator:', Icons.calculate_outlined, (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CalculatorScreen()),
                          );
                        }),

                        buttonWidgets('Ref', Icons.lightbulb_outline_rounded, (){
                          final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);
                          final testId = subjectProvider.testId;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HintScreen(testId: testId),
                            ),
                          );
                        })


                      ],),
                ),


                /// main test card
                SizedBox(height: 20),
                Expanded(
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 3.0,
                      panEnabled: true,
                      scaleEnabled: true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.whiteColor,
                              AppColors.backgroundColor,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.purpleShadow,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              Container(
                                width: double.infinity/2,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.indigo.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.indigo.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.book_rounded, color: AppColors.indigo, size: 20),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        provider.questions!.questions[provider.currentIndex].subjectName,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.indigo,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Baseline(
                                    baseline: 45,
                                    baselineType: TextBaseline.alphabetic,
                                    child: Text(
                                      "${provider.currentIndex + 1}) ",
                                      style: AppTextStyle.questionText.copyWith(
                                        color: AppColors.darkText,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: renderFullHtmlString(
                                      provider.questions!.questions[provider.currentIndex].question,
                                      defaultTextStyle: AppTextStyle.questionText.copyWith(
                                        color: AppColors.darkText,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),


                              SizedBox(height: 10),
                              ListTile(
                                  title: renderFullHtmlString(
                                    currentQuestion.option1,
                                    defaultTextStyle: AppTextStyle.answerText,
                                  ),
                                  leading: Radio<int>(
                                      activeColor: AppColors.indigo,
                                      value: 0,
                                      groupValue: provider.isTestStarted ?
                                      provider.selectedOptions[provider
                                          .currentIndex]
                                          : null,
                                      onChanged: (provider.isTestStarted &&
                                          !provider.isSubmitted[provider
                                              .currentIndex])
                                          ? (value) {
                                        if (value != null) {
                                          provider.onChangeRadio(
                                              provider.currentIndex, value);
                                        }
                                      }
                                          : null
                                  ),
                                  trailing: provider.isSubmitted[provider
                                      .currentIndex] == false
                                      ? null : provider.isTrue![provider
                                      .currentIndex]
                                      && 0 == provider.selectedOptions[provider
                                          .currentIndex] ?
                                  Icon(Icons.check, color: AppColors.successColor,
                                      weight: 100) :
                                  provider.correctAnswerOptionIndex![provider
                                      .currentIndex] == 0 ? Icon(
                                      Icons.check, color: AppColors.successColor,
                                      weight: 100) :
                                  provider.selectedOptions[provider
                                      .currentIndex] != 0 ? null : Icon(
                                      Icons.close, color: AppColors.errorColor,
                                      weight: 100)
                              ),
                              ListTile(
                                  title: renderFullHtmlString(
                                    currentQuestion.option2,
                                    defaultTextStyle: AppTextStyle.answerText,
                                  ),
                                  leading: Radio<int>(
                                      activeColor: AppColors.indigo,
                                      value: 1,
                                      groupValue: provider.isTestStarted
                                          ? provider.selectedOptions[provider
                                          .currentIndex]
                                          : null,
                                      onChanged: (provider.isTestStarted &&
                                          !provider.isSubmitted[provider
                                              .currentIndex])
                                          ? (value) {
                                        if (value != null) {
                                          provider.onChangeRadio(
                                              provider.currentIndex, value);
                                        }
                                      }
                                          : null
                                  ),
                                  trailing: provider.isSubmitted[provider
                                      .currentIndex] == false
                                      ? null : provider.isTrue![provider
                                      .currentIndex]
                                      && 1 == provider.selectedOptions[provider
                                          .currentIndex] ?
                                  Icon(Icons.check, color: AppColors.successColor,
                                      weight: 100) :
                                  provider.correctAnswerOptionIndex![provider
                                      .currentIndex] == 1 ? Icon(
                                      Icons.check, color: AppColors.successColor,
                                      weight: 100) :
                                  provider.selectedOptions[provider
                                      .currentIndex] != 1 ? null : Icon(
                                      Icons.close, color: AppColors.errorColor,
                                      weight: 100)
                              ),
                              ListTile(
                                  title: renderFullHtmlString(
                                    currentQuestion.option3,
                                    defaultTextStyle: AppTextStyle.answerText,
                                  ),
                                  leading: Radio<int>(
                                      activeColor: AppColors.indigo,
                                      value: 2,
                                      groupValue: provider.isTestStarted
                                          ? provider.selectedOptions[provider
                                          .currentIndex]
                                          : null,
                                      onChanged: (provider.isTestStarted &&
                                          !provider.isSubmitted[provider
                                              .currentIndex])
                                          ? (value) {
                                        if (value != null) {
                                          provider.onChangeRadio(
                                              provider.currentIndex, value);
                                        }
                                      }
                                          : null
                                  ),
                                  trailing: provider.isSubmitted[provider
                                      .currentIndex] == false
                                      ? null : provider.isTrue![provider
                                      .currentIndex]
                                      && 2 == provider.selectedOptions[provider
                                          .currentIndex] ?
                                  Icon(Icons.check, color: AppColors.successColor,
                                      weight: 100) :
                                  provider.correctAnswerOptionIndex![provider
                                      .currentIndex] == 2 ? Icon(
                                      Icons.check, color: AppColors.successColor,
                                      weight: 100) :
                                  provider.selectedOptions[provider
                                      .currentIndex] != 2 ? null : Icon(
                                      Icons.close, color: AppColors.errorColor,
                                      weight: 100)
                              ),
                              ListTile(
                                  title: renderFullHtmlString(
                                    currentQuestion.option4,
                                    defaultTextStyle: AppTextStyle.answerText,
                                  ),
                                  leading: Radio<int>(
                                      activeColor: AppColors.indigo,
                                      value: 3,
                                      groupValue: provider.isTestStarted
                                          ? provider.selectedOptions[provider
                                          .currentIndex]
                                          : null,
                                      onChanged: (provider.isTestStarted &&
                                          !provider.isSubmitted[provider
                                              .currentIndex])
                                          ? (value) {
                                        if (value != null) {
                                          provider.onChangeRadio(
                                              provider.currentIndex, value);
                                        }
                                      }
                                          : null
                                  ),
                                  trailing: provider.isSubmitted[provider
                                      .currentIndex] == false
                                      ? null : provider.isTrue![provider
                                      .currentIndex]
                                      && 3 == provider.selectedOptions[provider
                                          .currentIndex] ?
                                  Icon(Icons.check, color: AppColors.successColor,
                                      weight: 100) :
                                  provider.correctAnswerOptionIndex![provider
                                      .currentIndex] == 3 ? Icon(
                                      Icons.check, color: AppColors.successColor,
                                      weight: 100) :
                                  provider.selectedOptions[provider
                                      .currentIndex] != 3 ? null : Icon(
                                      Icons.close, color: AppColors.errorColor,
                                      weight: 100)
                              ),
                             if(currentQuestion.option5 != '')
                              ListTile(
                                  title: renderFullHtmlString(
                                    currentQuestion.option5,
                                    defaultTextStyle: AppTextStyle.answerText,
                                  ),
                                  leading: Radio<int>(
                                      activeColor: AppColors.indigo,
                                      value: 4,
                                      groupValue: provider.isTestStarted
                                          ? provider.selectedOptions[provider
                                          .currentIndex]
                                          : null,
                                      onChanged: (provider.isTestStarted &&
                                          !provider.isSubmitted[provider
                                              .currentIndex])
                                          ? (value) {
                                        if (value != null) {
                                          provider.onChangeRadio(
                                              provider.currentIndex, value);
                                        }
                                      }
                                          : null
                                  ),
                                  trailing: provider.isSubmitted[provider
                                      .currentIndex] == false
                                      ? null : provider.isTrue![provider
                                      .currentIndex]
                                      && 4 == provider.selectedOptions[provider
                                          .currentIndex] ?
                                  Icon(Icons.check, color: AppColors.successColor,
                                      weight: 100) :
                                  provider.correctAnswerOptionIndex![provider
                                      .currentIndex] == 4 ? Icon(
                                      Icons.check, color: AppColors.successColor,
                                      weight: 100) :
                                  provider.selectedOptions[provider
                                      .currentIndex] != 4 ? null : Icon(
                                      Icons.close, color: AppColors.errorColor,
                                      weight: 100)
                              ),

                              SizedBox(height: 10),

                              /// buttons row
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: provider.isPrevEnabled
                                        ? provider.goToPrevious
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: AppColors.textColor,
                                      backgroundColor: provider.isPrevEnabled
                                          ? AppColors.indigo
                                          : AppColors.lightIndigo,
                                      elevation: provider.isPrevEnabled ? 0 : 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Icon(Icons.arrow_back,
                                        color: provider.isPrevEnabled
                                            ? AppColors.whiteColor
                                            : AppColors.darkText),
                                  ),
                                  ElevatedButton(
                                    onPressed: provider.isTestStarted == false ||
                                        provider.isSubmitted[
                                        provider.currentIndex]
                                        ? null
                                        : () =>
                                        provider.submitAnswer(
                                            context, provider.currentIndex),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: AppColors.textColor,
                                      backgroundColor: AppColors.indigo,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 35, vertical: 0),
                                      elevation: .5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Submit',
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: AppColors.textColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: provider.isNxtEnabled
                                        ? provider.goToNext
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: AppColors.textColor,
                                      backgroundColor: provider.isNxtEnabled
                                          ? AppColors.indigo
                                          : AppColors.lightIndigo,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20),
                                      elevation: provider.isNxtEnabled ? 0 : 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Icon(Icons.arrow_forward,
                                        color: provider.isNxtEnabled
                                            ? AppColors.whiteColor
                                            : AppColors.darkText),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),

                              /// feedback button
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.indigo,
                                      AppColors.lightIndigo,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.darkShadow,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () =>
                                      showFeedbackDialog(
                                          context,
                                          authProvider.userSession!.userId,
                                          authProvider.userSession!.testId,
                                          provider.questionList[provider
                                              .currentIndex].id),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text('Feedback'),
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Show Explanation',
                                      style: AppTextStyle.questionText),
                                  Switch(
                                      activeColor: AppColors.successColor,
                                      inactiveThumbColor: AppColors.lightIndigo,
                                      inactiveTrackColor: AppColors.dividerColor,
                                      activeTrackColor: AppColors.dividerColor,
                                      trackOutlineColor: WidgetStatePropertyAll(WidgetStateColor.transparent),
                                      value: provider.showExplanation[
                                      provider.currentIndex],
                                      onChanged: (value) =>
                                          provider
                                              .toggleExplanationSwitch(
                                              value)),
                                ],
                              ),
                              if (provider.showExplanation[
                              provider.currentIndex] &&
                                  provider.isSubmitted[
                                  provider.currentIndex])
                                renderFullHtmlString(
                                  provider.questions!.questions[provider.currentIndex].detail,
                                  defaultTextStyle: AppTextStyle.answerText,
                                ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget buttonWidgets(String text, IconData icon, VoidCallback onTap) =>  Container(
    height: 50,
    // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.indigo,
          AppColors.lightIndigo,
        ],
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.darkShadow.withValues(alpha: 0.2),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(width: 10),
          Icon(icon, color: AppColors.whiteColor, size: 20),
        ],
      ),
    ),
  );

  void showFeedbackDialog(BuildContext context, int userId, int testId, int questionId) {
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
                        borderSide: BorderSide(color: AppColors.greyOverlay70),
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
                                    if (formKey.currentState?.validate() ?? false) {
                                      Map<String, dynamic> data = {
                                        "user_id": userId,
                                        "test_id": testId,
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

}


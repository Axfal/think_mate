// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:ffi';

import 'package:education_app/resources/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html_all/flutter_html_all.dart';

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
    _initializeProtection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getQuestions();
    });
  }

  Future<void> _initializeProtection() async {
    try {
      // Force reset protection to ensure clean state
      await ScreenshotProtector.forceReset();
      await _noScreenshot.screenshotOn();
      debugPrint('Screenshot protection initialized for test screen');
    } catch (e) {
      debugPrint('Error initializing screenshot protection: $e');
    }
  }

  void _enableScreenshotProtection() {
    try {
      ScreenshotProtector.enableProtection();
      _noScreenshot.screenshotOn();
      debugPrint('Screenshot protection enabled for test screen');
    } catch (e) {
      debugPrint('Error enabling screenshot protection: $e');
    }
  }

  void _disableScreenshotProtection() {
    try {
      // ScreenshotProtector.disableProtection();
      _noScreenshot.screenshotOff();
      debugPrint('Screenshot protection disabled on leaving test screen');
    } catch (e) {
      debugPrint('Error disabling screenshot protection: $e');
    }
  }

  @override
  void dispose() {
    _disableScreenshotProtection();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    // Re-initialize protection on hot reload
    _initializeProtection();
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
      ToastHelper.showError("User ID is null! Cannot fetch questions.");
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

    // Re-enable protection after questions are fetched
    if (mounted) {
      await _initializeProtection();
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
            if (src == null || !src.startsWith("http"))
              // ignore: curly_braces_in_flow_control_structures
              return const SizedBox.shrink();
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
                    child: const Icon(Icons.broken_image,
                        size: 48, color: Colors.grey),
                  ),
                ),
              ),
            );
          },
        ),
        // You can keep your other extensions as needed
        // const MathHtmlExtension(),
        // const AudioHtmlExtension(),
        // const VideoHtmlExtension(),
        // const IframeHtmlExtension(),
        // const TableHtmlExtension(),
        // const SvgHtmlExtension(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Re-enable protection on any rebuild just to be safe
    _enableScreenshotProtection();

    final provider = Provider.of<CreateMockTestProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            provider.restartTest();
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
        ),
        title: Text(
          'Mock Test',
          style: AppTextStyle.heading3.copyWith(color: AppColors.whiteColor),
        ),
        centerTitle: true,
        elevation: 0,
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
          IconButton(
            icon: Icon(Icons.calculate_outlined,
                size: 25.h, color: AppColors.whiteColor),
            tooltip: 'Calculator',
            onPressed: () {
              // TODO: Navigate to Calculator screen
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CalculatorScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.lightbulb_outline,
                size: 25.h, color: AppColors.whiteColor),
            tooltip: 'Hint',
            onPressed: () {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              authProvider.loadUserSession();
              final testId = authProvider.userSession!.testId;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => HintScreen(testId: testId)));
            },
          ),
        ],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Consumer<CreateMockTestProvider>(
            builder: (context, provider, child) {
              if (provider.loading) {
                return const Center(child: CupertinoActivityIndicator());
              }

              if (provider.questionList.isEmpty) {
                return Center(
                  child: Text(
                    "No questions available. Please try again.",
                    style: AppTextStyle.bodyText1
                        .copyWith(color: AppColors.darkText),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!provider.isTestStarted)
                          _buildStartTestSection(provider),
                        if (provider.isTestStarted)
                          _buildTestControls(provider),
                        // Container(
                        //   height: 50,
                        //   decoration: BoxDecoration(
                        //     gradient: LinearGradient(
                        //       begin: Alignment.topLeft,
                        //       end: Alignment.bottomRight,
                        //       colors: [
                        //         AppColors.indigo,
                        //         AppColors.lightIndigo,
                        //       ],
                        //     ),
                        //
                        //     borderRadius: BorderRadius.circular(12),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: AppColors.darkShadow,
                        //         blurRadius: 1,
                        //         offset: Offset(0, 4),
                        //       ),
                        //     ],
                        //   ),
                        //   child: ElevatedButton(
                        //       onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorScreen())),
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.transparent,
                        //         shadowColor: Colors.transparent,
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(12),
                        //         ),
                        //       ),
                        //       child: Icon(Icons.calculate_outlined, color: AppColors.whiteColor,size: 30)
                        //   ),
                        // ),
                        // Container(
                        //   height: 50,
                        //   decoration: BoxDecoration(
                        //     gradient: LinearGradient(
                        //       begin: Alignment.topLeft,
                        //       end: Alignment.bottomRight,
                        //       colors: [
                        //         AppColors.indigo,
                        //         AppColors.lightIndigo,
                        //       ],
                        //     ),
                        //
                        //     borderRadius: BorderRadius.circular(12),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: AppColors.darkShadow,
                        //         blurRadius: 1,
                        //         offset: Offset(0, 4),
                        //       ),
                        //     ],
                        //   ),
                        //   child: ElevatedButton(
                        //       onPressed: () {
                        //         /// Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorScreen()));
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.transparent,
                        //         shadowColor: Colors.transparent,
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(12),
                        //         ),
                        //       ),
                        //       child: Icon(Icons.lightbulb_outline, color: AppColors.whiteColor,size: 30)
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildQuestionCard(provider),
                ],
              );
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.indigo, AppColors.lightIndigo],
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
            child: Text(
              'Start Test',
              style: AppTextStyle.button.copyWith(color: AppColors.whiteColor),
            ),
          ),
        ),
        SizedBox(width: 20.w),
        if (widget.testMode)
          Text(
            formattedTime,
            style:
                AppTextStyle.heading3.copyWith(color: AppColors.primaryColor),
          ),
      ],
    );
  }

  Widget _buildTestControls(CreateMockTestProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.redColor, AppColors.redColor],
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
            child: Text(
              'End Test',
              style: AppTextStyle.button.copyWith(color: AppColors.whiteColor),
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        if (widget.testMode)
          CountdownTimer(
            endTime: provider.endTime,
            onEnd: () => provider.navigate(context),
            widgetBuilder: (_, time) {
              if (time == null) {
                return Text(
                  'Time\'s up!',
                  style:
                      AppTextStyle.bodyText1.copyWith(color: AppColors.indigo),
                );
              }

              String minutes = (time.min ?? 0).toString();
              String seconds = (time.sec ?? 0).toString().padLeft(2, '0');

              return Text(
                'Time Left: $minutes:$seconds min',
                style: AppTextStyle.bodyText1.copyWith(
                    fontSize: 18,
                    color: AppColors.indigo,
                    fontWeight: FontWeight.w800),
              );
            },
          ),
      ],
    );
  }

  Widget _buildQuestionCard(CreateMockTestProvider provider) {
    if (provider.questionList.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'No questions available',
            style: AppTextStyle.bodyText1.copyWith(color: AppColors.darkText),
          ),
        ),
      );
    }

    if (provider.currentIndex >= provider.questionList.length) {
      return Expanded(
        child: Center(
          child: Text(
            'Invalid question index',
            style: AppTextStyle.bodyText1.copyWith(color: AppColors.darkText),
          ),
        ),
      );
    }

    final currentQuestion = provider.questionList[provider.currentIndex];

    return Expanded(
      child: Card(
        elevation: 1,
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 3.0,
          panEnabled: true,
          scaleEnabled: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Baseline(
                      baseline: 45,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        "${provider.currentIndex + 1}) ",
                        style: AppTextStyle.questionText.copyWith(
                          color: AppColors.darkText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Expanded(
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 3.0,
                        panEnabled: true,
                        scaleEnabled: true,
                        constrained: true,
                        child: renderFullHtmlString(
                          currentQuestion.question,
                          defaultTextStyle: AppTextStyle.questionText.copyWith(
                            color: AppColors.darkText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ...List.generate(currentQuestion.option5 != '' ? 4 : 3,
                    (index) {
                  String? optionText;
                  switch (index) {
                    case 0:
                      optionText = currentQuestion.option1;
                      break;
                    case 1:
                      optionText = currentQuestion.option2;
                      break;
                    case 2:
                      optionText = currentQuestion.option3;
                      break;
                    case 3:
                      optionText = currentQuestion.option4;
                      break;
                    case 4:
                      optionText = currentQuestion.option5;
                      break;
                  }
                  return ListTile(
                    title: renderFullHtmlString(
                      optionText,
                      defaultTextStyle: AppTextStyle.questionText.copyWith(
                        color: AppColors.darkText,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    leading: Radio<int>(
                      activeColor: AppColors.indigo,
                      value: index,
                      groupValue:
                          provider.selectedOptions[provider.currentIndex],
                      onChanged: !provider.isSubmitted[provider.currentIndex]
                          ? (value) {
                              if (value != null) {
                                provider.onChangeRadio(
                                    provider.currentIndex, value);
                              }
                            }
                          : null,
                    ),
                    trailing:
                        provider.isSubmitted[provider.currentIndex] == false
                            ? null
                            : _buildAnswerIcon(provider, index),
                  );
                }),
                SizedBox(height: 16),
                _buildNavigationButtons(provider),
                SizedBox(height: 16),
                _buildExplanation(provider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildAnswerIcon(CreateMockTestProvider provider, int optionIndex) {
    if (provider.isTrue![provider.currentIndex] &&
        optionIndex == provider.selectedOptions[provider.currentIndex]) {
      return Icon(Icons.check, color: AppColors.successColor);
    } else if (provider.correctAnswerOptionIndex![provider.currentIndex] ==
        optionIndex) {
      return Icon(Icons.check, color: AppColors.successColor);
    } else if (provider.selectedOptions[provider.currentIndex] == optionIndex) {
      return Icon(Icons.close, color: AppColors.errorColor);
    }
    return null;
  }

  Widget _buildNavigationButtons(CreateMockTestProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: provider.isPrevEnabled ? provider.goToPrevious : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.whiteColor,
            backgroundColor: provider.isPrevEnabled
                ? AppColors.indigo
                : AppColors.lightIndigo,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Icon(
            Icons.arrow_back,
            color: provider.isPrevEnabled
                ? AppColors.whiteColor
                : AppColors.darkText,
          ),
        ),
        ElevatedButton(
          onPressed: provider.isTestStarted == false ||
                  provider.isSubmitted[provider.currentIndex]
              ? null
              : () => provider.submitAnswer(context, provider.currentIndex),
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.whiteColor,
            backgroundColor: AppColors.indigo,
            padding: EdgeInsets.symmetric(horizontal: 35),
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Submit',
            style: AppTextStyle.button.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: provider.isNxtEnabled ? provider.goToNext : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.whiteColor,
            backgroundColor: provider.isNxtEnabled
                ? AppColors.indigo
                : AppColors.lightIndigo,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Icon(
            Icons.arrow_forward,
            color: provider.isNxtEnabled
                ? AppColors.whiteColor
                : AppColors.darkText,
          ),
        ),
      ],
    );
  }

  Widget _buildExplanation(CreateMockTestProvider provider) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.indigo, AppColors.lightIndigo],
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
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Feedback',
              style: AppTextStyle.button.copyWith(color: AppColors.whiteColor),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Show Explanation',
              style: AppTextStyle.bodyText1.copyWith(
                color: AppColors.darkText,
                fontWeight: FontWeight.w500,
              ),
            ),
            Switch(
              activeColor: AppColors.successColor,
              inactiveThumbColor: AppColors.lightIndigo,
              inactiveTrackColor: AppColors.dividerColor,
              activeTrackColor: AppColors.dividerColor,
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
              value: provider.showExplanation[provider.currentIndex],
              onChanged: (value) => provider.toggleExplanationSwitch(value),
            ),
          ],
        ),
        if (provider.showExplanation[provider.currentIndex] &&
            provider.isSubmitted[provider.currentIndex])
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: renderFullHtmlString(
                provider.questionList[provider.currentIndex].detail,
                defaultTextStyle: AppTextStyle.questionText.copyWith(
                  color: AppColors.darkText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
          ),
      ],
    );
  }

  void showFeedbackDialog(
      BuildContext context, int userId, int testId, int questionId) {
    final formKey = GlobalKey<FormState>();
    TextEditingController feedbackController = TextEditingController();

    // final provider = Provider.of<CreateMockTestProvider>(context, listen: false);

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
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      Map<String, dynamic> data = {
                                        "user_id": userId,
                                        "test_id": testId,
                                        "question_id": questionId,
                                        "detail": feedbackController.text,
                                        "subject_id": widget.subjectMode.first,
                                        "chapter_id": 0
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

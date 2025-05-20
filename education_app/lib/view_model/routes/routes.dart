// ignore_for_file: prefer_const_constructors

import 'package:education_app/resources/exports.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case RoutesName.login:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      case RoutesName.signup:
        return MaterialPageRoute(builder: (context) => SignupScreen());

      case RoutesName.resetPassword:
        return MaterialPageRoute(builder: (context) => ResetPasswordScreen());

      case RoutesName.enterOtpAndResetPassword:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final email = args['email'] as String? ?? '';
        return MaterialPageRoute(
          builder: (context) => EnterOtpAndResetPasswordScreen(email: email),
        );

      case RoutesName.home:
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case RoutesName.course:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final courseId = args['courseId'] ?? 0;
        return MaterialPageRoute(
            builder: (context) => CourseScreen(courseId: courseId));

      case RoutesName.subscriptionScreen:
        return MaterialPageRoute(builder: (context) => SubscriptionScreen());

      case RoutesName.mockTest:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final subjectId = args['subjectId'] ?? 0;
        final chapterId = args['chapterId'] ?? 0;
        return MaterialPageRoute(
            builder: (context) => MockTestScreen(
                  subjectId: subjectId,
                  chapterId: chapterId,
                ));

      case RoutesName.profile:
        return MaterialPageRoute(builder: (context) => ProfilePage());

      case RoutesName.noteScreen:
        return MaterialPageRoute(builder: (context) => NotesSubjectScreen());

      case RoutesName.createMockTest:
        return MaterialPageRoute(builder: (context) => CreateMockTest());

      case RoutesName.previousTestScreen:
        return MaterialPageRoute(builder: (context) => PreviousTestScreen());

      case RoutesName.subjectScreen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final courseId = args['courseId'] ?? 0;
        return MaterialPageRoute(
            builder: (context) => SubjectScreen(courseId: courseId));

      case RoutesName.resultScreen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final subject = args['subject'] ?? 'Demo';
        final correctAnswer = args['correctAns'] ?? 0;
        final incorrectAnswer = args['incorrectAns'] ?? 0;
        final totalQuestion = args['totalQuestion'] ?? 0;
        List<Map<String, dynamic>> questions = args['questions'] ?? [];
        return MaterialPageRoute(
            builder: (context) => ResultScreen(
                  subject: subject,
                  correctAns: correctAnswer,
                  incorrectAns: incorrectAnswer,
                  totalQues: totalQuestion,
                  questions: questions,
                ));

      case RoutesName.chapterScreen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final testId = args['testId'] ?? 0;
        return MaterialPageRoute(builder: (context) => ChaptersScreen(testId: testId));

      case RoutesName.myNoteBookScreen:
        return MaterialPageRoute(builder: (context) => MyNoteBook());

      case RoutesName.questionScreen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final subjectId = args['subjectId'] ?? 0;
        final chapterId = args['chapterId'] ?? 0;
        final testId = args['testId'] ?? 0;
        return MaterialPageRoute(
            builder: (context) => QuestionScreen(
                  subjectId: subjectId,
                  chapterId: chapterId,
              testId: testId,
                ));

      case RoutesName.createdMockTestScreen:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final numberOfQuestions = args['number_of_questions'] as double? ?? 1.0;
        final testMode = args['test_mode'] as bool? ?? false;
        final subjectMode = (args['subject_mode'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [];
        final questionMode = args['question_mode'] as String? ?? 'default';

        return MaterialPageRoute(
          builder: (context) => CreatedMockTestScreen(
            numberOfQuestions: numberOfQuestions,
            testMode: testMode,
            subjectMode: subjectMode,
            questionMode: questionMode,
          ),
        );

      case '/terms':
        return MaterialPageRoute(builder: (context) => const TermsView());

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text("No Route Defined"),
            ),
          );
        });
    }
  }
}

import 'package:education_app/resources/exports.dart';
import 'package:education_app/view_model/provider/post_test_result_provider.dart';
import 'package:education_app/view_model/provider/profile_provider.dart';
import 'package:education_app/view_model/provider/reset_provider.dart';
import 'package:education_app/view_model/provider/subscription_provider.dart';
import 'package:education_app/view_model/provider/upload_image_provider.dart';
import 'model/hive_database_model/previous_test_report_model.dart';
import 'model/hive_database_model/submitted_questions_model.dart';
import 'model/hive_database_model/user_session_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NotesModelAdapter());
  Hive.registerAdapter(UserSessionModelAdapter());
  Hive.registerAdapter(PreviousTestReportModelAdapter());
  Hive.registerAdapter(SubmittedQuestionsModelAdapter());
  await Hive.openBox<SubmittedQuestionsModel>('submittedQuestionsBox');
  await Hive.openBox<PreviousTestReportModel>('previousTests');
  await Hive.openBox<NotesModel>('notes');
  await Hive.openBox<UserSessionModel>('userBox');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavigatorBarProvider()),
        ChangeNotifierProvider(create: (_) => PreviousTestProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => ChapterProvider()),
        ChangeNotifierProvider(create: (_) => MockTestProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => BookMarkProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => QuestionsProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
        ChangeNotifierProvider(create: (_) => ResetProvider()),
        ChangeNotifierProvider(create: (_) => UploadImageProvider()),
        ChangeNotifierProvider(create: (_) => PostTestResultProvider()),
        ChangeNotifierProvider(create: (_) => CreateMockTestProvider(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: GlobalVariables.scaffoldMessengerKey,
        title: 'Education App',
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class GlobalVariables {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}

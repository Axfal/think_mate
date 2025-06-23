import 'package:education_app/resources/exports.dart';
import 'model/hive_database_model/previous_test_report_model.dart';
import 'model/hive_database_model/submitted_questions_model.dart';
import 'model/hive_database_model/user_session_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Mobile Devices only
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
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
            ChangeNotifierProvider(create: (_) => NoteBookProvider()),
            ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
            ChangeNotifierProvider(create: (_) => QuestionsProvider()),
            ChangeNotifierProvider(create: (_) => FeedbackProvider()),
            ChangeNotifierProvider(create: (_) => ResetProvider()),
            ChangeNotifierProvider(create: (_) => UploadImageProvider()),
            ChangeNotifierProvider(create: (_) => NotesProvider()),
            ChangeNotifierProvider(create: (_) => HintProvider()),
            ChangeNotifierProvider(create: (_) => PostTestResultProvider()),
            ChangeNotifierProvider(
              create: (_) => CreateMockTestProvider(),
              lazy: false,
            ),
          ],
          child: MaterialApp(
            scaffoldMessengerKey: GlobalVariables.scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            initialRoute: RoutesName.splash,
            onGenerateRoute: Routes.generateRoute,
            theme: ThemeData(
              primaryColor: AppColors.primaryColor,
              scaffoldBackgroundColor: AppColors.backgroundColor,
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
                secondary: AppColors.secondaryColor,
                surface: AppColors.surfaceColor,
                background: AppColors.backgroundColor,
                error: AppColors.errorColor,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.deepPurple,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: AppColors.whiteColor),
                titleTextStyle: AppTextStyle.appBarText,
              ),
              textTheme: TextTheme(
                headlineLarge: AppTextStyle.heading1,
                headlineMedium: AppTextStyle.heading2,
                headlineSmall: AppTextStyle.heading3,
                bodyLarge: AppTextStyle.bodyText1,
                bodyMedium: AppTextStyle.bodyText2,
                bodySmall: AppTextStyle.caption,
                labelLarge: AppTextStyle.button,
                labelMedium: AppTextStyle.label,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.whiteColor,
                  textStyle: AppTextStyle.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  textStyle: AppTextStyle.button,
                  side: BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  textStyle: AppTextStyle.button,
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                fillColor: AppColors.inputFillColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.errorColor),
                ),
                labelStyle: AppTextStyle.label,
                hintStyle: AppTextStyle.caption,
              ),
              cardTheme: CardThemeData(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.surfaceColor,
              ),
              dividerTheme: DividerThemeData(
                color: AppColors.dividerColor,
                thickness: 1,
                space: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

class GlobalVariables {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
}

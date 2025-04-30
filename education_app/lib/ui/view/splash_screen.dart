import '../../resources/exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bookController;
  late Future<void> _sessionLoader;


  @override
  void initState() {
    super.initState();
    _bookController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Load user session before checking it
    _sessionLoader =
        Provider.of<AuthProvider>(context, listen: false).loadUserSession();
  }

  @override
  void dispose() {
    _bookController.dispose();
    super.dispose();
  }

  void navigateToNextScreen(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    if (provider.userSession != null) {
      Navigator.pushReplacementNamed(context, RoutesName.home);
    } else {
      Navigator.pushReplacementNamed(context, RoutesName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                Icons8.book,
                width: 100,
                height: 100,
                controller: _bookController,
                onLoaded: (composition) {
                  _bookController.duration = composition.duration;
                },
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 300.0,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  child: Center(
                    child: FutureBuilder(
                      future: _sessionLoader,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText('Learn Anytime, Anywhere'),
                              TyperAnimatedText('Learning unlocks potential'),
                              TyperAnimatedText('Learning fuels progress'),
                              TyperAnimatedText('Let\'s Start...'),
                            ],
                            totalRepeatCount: 1,
                            onFinished: () => navigateToNextScreen(context),
                          );
                        }
                        return CircularProgressIndicator(color: Colors.white);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

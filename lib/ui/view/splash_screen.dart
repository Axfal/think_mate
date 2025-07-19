import '../../resources/exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bookController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Future<void> _sessionLoader;

  @override
  void initState() {
    super.initState();

    // Book animation controller
    _bookController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Fade-in animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    _fadeController.forward();

    // Initialize _sessionLoader immediately
    _sessionLoader =
        Provider.of<AuthProvider>(context, listen: false).loadUserSession();

    // Fetch other data safely after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllData();
    });
  }

  @override
  void dispose() {
    _bookController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void fetchAllData() async {
    fetchCourses();
  }

  void getUserData() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.getUserProfileData(context);
  }

  void fetchCourses() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.fetchCoursesList();
  }

  void navigateToNextScreen(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    if (provider.userSession != null) {

      ///api calling then navigate to next screen bro
      getUserData();

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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.deepPurple,
              AppColors.lightPurple,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: CustomPaint(
                  painter: BackgroundPatternPainter(),
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo/icon with shadow
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purpleShadow.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Lottie.asset(
                      Icons8.book,
                      width: 120,
                      height: 120,
                      controller: _bookController,
                      onLoaded: (composition) {
                        _bookController.duration = composition.duration;
                      },
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  // App name with gradient text
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        AppColors.whiteColor,
                        AppColors.whiteColor.withValues(alpha: 0.8),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'ThinkMatte',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Animated text
                  SizedBox(
                    width: 300.0,
                    child: DefaultTextStyle(
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        color: AppColors.whiteOverlay90,
                        fontWeight: FontWeight.w500,
                      ),
                      child: Center(
                        child: FutureBuilder(
                          future: _sessionLoader,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return AnimatedTextKit(
                                animatedTexts: [
                                  FadeAnimatedText(
                                    'Learn Anytime, Anywhere',
                                    duration: Duration(seconds: 2),
                                  ),
                                  FadeAnimatedText(
                                    'Unlock Your Potential',
                                    duration: Duration(seconds: 2),
                                  ),
                                  FadeAnimatedText(
                                    'Let\'s Begin Your Journey',
                                    duration: Duration(seconds: 2),
                                  ),
                                ],
                                totalRepeatCount: 1,
                                onFinished: () => navigateToNextScreen(context),
                              );
                            }
                            return CircularProgressIndicator(
                              color: AppColors.whiteColor,
                              strokeWidth: 3,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for background pattern
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Create a pattern of circles and shapes
    for (var i = 0; i < size.width; i += 100) {
      for (var j = 0; j < size.height; j += 100) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 20, paint);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

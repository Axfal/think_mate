class AppUrl {
  static var baseUrl = 'https://nomore.com.pk/MDCAT_ECAT_Education/API';
  static var signIn = '$baseUrl/SignIn.php';
  static var signUp = '$baseUrl/Signup.php';
  static var fetchTest = '$baseUrl/fetch_test.php';
  static var fetchSubjects = '$baseUrl/fetch_user_subjects.php?test_id=';
  static var fetchChapters = '$baseUrl/fetch_user_chapters.php?test_id=';
  static var fetchQuestions = '$baseUrl/user_test_data.php';
  static var feedback = '$baseUrl/feedback.php';
  static var createMockTest = '$baseUrl/MockTestGenerator.php';
  static var getMockTestQuestionCount =
      '$baseUrl/MockTestGeneratorQuestionCount.php';
  static var mockTestFeedback = '$baseUrl/user_test_feedback.php';
  static var postTestResult = '$baseUrl/submit_result.php';
  static var getTestResult = '$baseUrl/get_test_result.php?user_id=';

  /// https://nomore.com.pk/MDCAT_ECAT_Education/API/get_test_result.php?user_id=9&test_id=3
  static var bookMark = "$baseUrl/book_mark.php";
  static var getBookMark = "$baseUrl/get_bookmarks.php?user_id=";
  static var deleteBookMark = "$baseUrl/delete_book_mark.php";
  static var reset = "$baseUrl/reset_attempt.php";
  static var profile = "$baseUrl/update_profile.php?user_id=";
  static var changePassword = "$baseUrl/update_profile.php";
  static var uploadImage = "$baseUrl/update_profile.php";
  static var incorrectQuestions = "$baseUrl/get_incorrect_questions.php";
  static var checkQuestion = "$baseUrl/check_questions.php";
  static var unCheckQuestion = "$baseUrl/delete_check_questions.php";
  static var getCheckQuestion = "$baseUrl/get_check_questions.php?user_id=";

  /// https://nomore.com.pk/MDCAT_ECAT_Education/API/get_check_questions.php?user_id=10&test_id=3&subject_id=12&chapter_id=3
  static var getSubscription = "$baseUrl/get_subscriptions.php";
  static var postSubscription = "$baseUrl/submit_payment.php";
  static var getSubscriptionHistory = "$baseUrl/payments_history.php?user_id=";

  /// https://nomore.com.pk/MDCAT_ECAT_Education/API/payments_history.php?user_id=11
  static var validateUserForMockTest = "$baseUrl/free_user_test_validate.php";
  static var requestResetPassword = '$baseUrl/request_reset_password.php';
  static var resetPassword = '$baseUrl/reset_password.php';
  static var checkSubscriptionPlan = '$baseUrl/get_user_subscription_info.php';
  static var verifyPromoCode = '$baseUrl/verify_promo.php';
  static var addNotes = '$baseUrl/add_notes.php';
  static var getNotes = '$baseUrl/get_notes.php';

  /// https://nomore.com.pk/MDCAT_ECAT_Education/API/get_notes.php?user_id=10&test_id=3&subject_id=10
  static var deleteNote = '$baseUrl/delete_note.php';
  static var updateNote = '$baseUrl/update_note.php';
  static var getNoteBook = '$baseUrl/get_upload_books.php?user_id=';

  /// maintain user test data session
  static var postUserTestData = '$baseUrl/logout_user_data.php';
  static var getuserTestData = '$baseUrl/get_logout_user_data.php?user_id=';

  /// hint section
  static String generalHint = '$baseUrl/get_hints.php?test_id=';
  // static String subjectiveHint = '$baseUrl/get_hints.php?test_id=3&subject_id=11';
  static String subjectiveHint = '$baseUrl/get_hints.php?test_id=';
}

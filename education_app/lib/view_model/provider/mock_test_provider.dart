// ignore_for_file: avoid_print

import 'package:education_app/model/validate_user_model.dart';
import 'package:education_app/resources/exports.dart';
import 'package:education_app/utils/toast_helper.dart';

import '../../model/hive_database_model/submitted_questions_model.dart';

class MockTestProvider with ChangeNotifier {
  final QuestionRepository _mockTestRepo = QuestionRepository();

  MockTestModel? _questions;
  MockTestModel? get questions => _questions;

  String? _subject;
  String? get subject => _subject;

  List<Question> _questionList = [];
  List<Question> get questionList => _questionList;

  final Map<String, int> correctOptionMapping = {
    "a": 0,
    "b": 1,
    "c": 2,
    "d": 3
  };

  int? _numberOfQuestions;
  int? get numberOfQuestions => _numberOfQuestions;

  List<bool> _isSubmitted = [];
  List<bool> get isSubmitted => _isSubmitted;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  int _incorrectAns = 0;
  int get incorrectAns => _incorrectAns;

  bool _isTestStarted = false;
  bool get isTestStarted => _isTestStarted;

  List<int?> _selectedOptions = [];
  List<int?> get selectedOptions => _selectedOptions;

  List<bool> _showExplanation = [];
  List<bool> get showExplanation => _showExplanation;

  final bool _explanationSwitch = false;
  bool get explanationSwitch => _explanationSwitch;

  bool _isNxtEnabled = false;
  bool get isNxtEnabled => _isNxtEnabled;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _isPrevEnabled = false;
  bool get isPrevEnabled => _isPrevEnabled;

  bool _shouldNavigate = false;
  bool get shouldNavigate => _shouldNavigate;

  List<Map<String, dynamic>> _questionsToPost = [];
  List<Map<String, dynamic>> get questionsToPost => _questionsToPost;

  List<bool>? _isTrue;
  List<bool>? get isTrue => _isTrue;

  List<int>? _correctAnswerOptionIndex;
  List<int>? get correctAnswerOptionIndex => _correctAnswerOptionIndex;

  bool _loading = false;
  bool get loading => _loading;

  ValidateUserModel? _validateUserModel;
  ValidateUserModel? get validateUserModel => _validateUserModel;

  Future<void> validateUser(BuildContext context) async {
    _loading = true;
    notifyListeners();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadUserSession();
    final userId = authProvider.userSession?.userId;

    if (userId == null) {
      print("User ID not found");
      _loading = false;
      notifyListeners();
      return;
    }

    Map<String, dynamic> data = {"user_id": userId};

    try {
      ValidateUserModel response = await _mockTestRepo.validateUser(data);
      if (response.status == "allowed" &&
          response.message == "User can take the test.") {
        _validateUserModel = response;
      } else {
        print("Validation failed: ${response.message}");
      }
    } catch (e) {
      print("Error during validation: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchQuestions(BuildContext context) async {
    try {
      _loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userSession?.userId ?? 0;
      Map<String, dynamic> data = {};
      if (authProvider.userSession?.userType == "premium") {
        data = {'user_id': userId, "status": "mock"};
      } else if (authProvider.userSession?.userType == "free") {
        data = {'user_id': userId};
      } else {
        data = {};
      }

      if (kDebugMode) {
        print(userId);
      }

      final response = await _mockTestRepo.fetchQuestions(data);
      if (response.success) {
        _questions = response;
        _questionList = response.questions;
        _numberOfQuestions = _questionList.length;
        _isSubmitted = List<bool>.filled(_questionList.length, false);
        _selectedOptions = List<int?>.filled(_questionList.length, null);
        _isTrue = List<bool>.filled(_questionList.length, false);
        _correctAnswerOptionIndex = List<int>.filled(_questionList.length, 0);
        _showExplanation = List<bool>.filled(_questionList.length, false);
      } else {
        ToastHelper.showError("Failed to fetch questions");
      }
    } catch (e) {
      print("Error fetching questions: $e");
      ToastHelper.showError("Failed to load questions");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void goBack(context) {
    _questionsToPost = [];
    Navigator.pop(context);
    notifyListeners();
  }

  void setNumberOfQuestion(double value) {
    _numberOfQuestions = value.toInt();
    if (kDebugMode) {
      print("_numberOfQuestions = $_numberOfQuestions");
    }
    notifyListeners();
  }

  void submitAnswer(BuildContext context, int index) {
    if (_selectedOptions.isNotEmpty &&
        index < _selectedOptions.length &&
        _selectedOptions[index] != null) {
      if (_isSubmitted.isNotEmpty &&
          index >= 0 &&
          index < _isSubmitted.length) {
        _isSubmitted[index] = true;
      } else {
        debugPrint('Index out of bounds while submitting answer');
      }

      if (_questionList.isNotEmpty && index < _questionList.length) {
        String correctAnswerKey =
            _questionList[index].correctAnswer.toLowerCase();
        int? correctAnswerIndex = correctOptionMapping[correctAnswerKey];
        _correctAnswerOptionIndex![index] = correctAnswerIndex!;
        String result = (_selectedOptions[index] == correctAnswerIndex)
            ? "correct"
            : "incorrect";

        if (_selectedOptions[index] == correctAnswerIndex) {
          _correctAns++;
          _isTrue![index] = true;
        } else {
          _incorrectAns++;
          _isTrue![index] = false;
        }

        int questionId = _questionList[index].id ?? 0;
        bool exists =
            _questionsToPost.any((q) => q['question_id'] == questionId);

        if (exists) {
          _questionsToPost.firstWhere(
                  (q) => q['question_id'] == questionId)['question_result'] =
              result;
        } else {
          _questionsToPost.add({
            'question_id': questionId,
            'question_result': result,
            "question_status": "Mock"
          });
        }
      }
      notifyListeners();
      print('data of questions is =>>>> $_questionsToPost');

      bool allSubmitted = _isSubmitted.every((submitted) => submitted == true);

      if (allSubmitted) {
        Future.microtask(() {
          Navigator.pushReplacementNamed(
            context,
            RoutesName.resultScreen,
            arguments: {
              'correctAns': _correctAns,
              'incorrectAns': _incorrectAns,
              'totalQuestion': _numberOfQuestions,
              'questions': _questionsToPost
            },
          );
        });
      }
    } else {
      ToastHelper.showInfo("Please select an option before submitting!");
    }

    notifyListeners();
  }

  void onChangeRadio(int index, int? value) {
    if (_isSubmitted.isNotEmpty &&
        index < _isSubmitted.length &&
        !_isSubmitted[index]) {
      if (_selectedOptions.isNotEmpty && index < _selectedOptions.length) {
        _selectedOptions[index] = value;
      }
      notifyListeners();
    }
  }

  void navigate(BuildContext context) async {
    if (_shouldNavigate) {
      _isTestStarted = false;

      final provider = Provider.of<ChapterProvider>(context, listen: false);
      _subject = provider.subject;

      List<Map<String, dynamic>> questionsToSend =
          List<Map<String, dynamic>>.from(_questionsToPost);

      await Navigator.pushReplacementNamed(
        context,
        RoutesName.resultScreen,
        arguments: {
          'subject': _subject,
          'correctAns': _correctAns,
          'incorrectAns': _incorrectAns,
          'totalQuestion': _numberOfQuestions,
          'questions': questionsToSend,
        },
      );

      _questionsToPost = [];

      notifyListeners();
    }
  }

  void restartTest() {
    resetProvider();
    notifyListeners();
  }

  void startTest() {
    if (_questionList.isEmpty) {
      if (kDebugMode) {
        print("Error: Cannot start test, question list is empty!");
      }
      return;
    }

    _isTestStarted = true;
    _isPrevEnabled = false;
    _isNxtEnabled = true;
    _currentIndex = 0;
    _correctAns = 0;
    _incorrectAns = 0;
    _shouldNavigate = true;

    _isSubmitted = List<bool>.filled(_questionList.length, false);
    _selectedOptions = List<int?>.filled(_questionList.length, null);
    _showExplanation = List.generate(_questionList.length, (_) => false);

    notifyListeners();
  }

  void resetProvider() {
    _correctAns = 0;
    _incorrectAns = 0;

    if (_numberOfQuestions != null && _numberOfQuestions! > 0) {
      _isSubmitted = List<bool>.filled(_numberOfQuestions!, false);
      _showExplanation = List.generate(_numberOfQuestions!, (_) => false);
      _selectedOptions = List<int?>.filled(_numberOfQuestions!, null);
    }

    _isTestStarted = false;
    _isNxtEnabled = false;
    _numberOfQuestions = 10;
    _isPrevEnabled = false;
    _currentIndex = 0;
    _shouldNavigate = false;

    notifyListeners();
  }

  void goToNext() {
    print("_currentIndex= $_currentIndex");
    if (_numberOfQuestions != null &&
        _currentIndex < (_numberOfQuestions! - 1)) {
      _currentIndex++;
      _isPrevEnabled = true;
      _isNxtEnabled = _currentIndex < (_numberOfQuestions! - 1);
    } else {
      _isNxtEnabled = false;
    }
    notifyListeners();
  }

  void goToPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _isNxtEnabled = true;
      _isPrevEnabled = _currentIndex > 0;
    } else {
      _isPrevEnabled = false;
    }
    notifyListeners();
  }

  void toggleExplanationSwitch(bool value) {
    if (_selectedOptions.isNotEmpty &&
        _currentIndex < _selectedOptions.length &&
        _selectedOptions[_currentIndex] != null &&
        _isSubmitted.isNotEmpty &&
        _currentIndex < _isSubmitted.length &&
        _isSubmitted[_currentIndex]) {
      _showExplanation[_currentIndex] = value;
    }
    notifyListeners();
  }
}

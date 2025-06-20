// ignore_for_file: avoid_print

import 'package:education_app/repository/mock_test_question_count_repo.dart';
import 'package:education_app/resources/exports.dart';
import '../../model/create_mock_test_model.dart';
import '../../model/hive_database_model/submitted_questions_model.dart';
import '../../model/mock_test_question_count_model.dart';
import '../../repository/create_mock_test_repo.dart';

class CreateMockTestProvider with ChangeNotifier {
  CreateMockTestRepo createMockTestRepo = CreateMockTestRepo();
  MockTestQuestionCountRepo mockTestQuestionRepo = MockTestQuestionCountRepo();

  var box = Hive.box<SubmittedQuestionsModel>('submittedQuestionsBox');

  List<Questions> _questionList = [];
  List<Questions> get questionList => _questionList;

  int _timeInSeconds = 45;
  int get timeInSeconds => _timeInSeconds;

  int _endTime = DateTime.now().millisecondsSinceEpoch + 10000;
  int get endTime => _endTime;

  final Map<String, int> correctOptionMapping = {
    "a": 0,
    "b": 1,
    "c": 2,
    "d": 3,
    "e": 4
  };

  int _numberOfQuestions = 1;
  int get numberOfQuestions => _numberOfQuestions;

  List<bool> _isSubmitted = [];
  List<bool> get isSubmitted => _isSubmitted;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  int _incorrectAns = 0;
  int get incorrectAns => _incorrectAns;

  bool _loading = false;
  bool get loading => _loading;

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

  List<bool>? _isTrue;
  List<bool>? get isTrue => _isTrue;

  List<int>? _correctAnswerOptionIndex;
  List<int>? get correctAnswerOptionIndex => _correctAnswerOptionIndex;

  CreateMockTestModel? _createMockTestModel;
  CreateMockTestModel? get createMockTestModel => _createMockTestModel;

  int? _availableQuestions;
  bool _isLoading = false;
  MockTestQuestionCountModel? _mockTestQuestionCountModel;

  int? get availableQuestions => _availableQuestions;
  bool get isLoading => _isLoading;

  Future<void> getMockTestQuestionsCount(
      BuildContext context, List<int> subjectMode, String questionMode) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userSession?.userId;
    final testId = authProvider.userSession?.testId;

    if (userId == null || testId == null) {
      debugPrint("User or test information is missing.");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "user_id": userId,
        "test_id": testId,
        "subject_id": subjectMode,
        "question_mode": questionMode
      };

      _mockTestQuestionCountModel =
          await mockTestQuestionRepo.getMockTestQuestionCount(data);

      if (_mockTestQuestionCountModel?.success == true &&
          _mockTestQuestionCountModel?.totalAvailable != null) {
        _availableQuestions = _mockTestQuestionCountModel!.totalAvailable;
      } else {
        debugPrint("Failed to fetch question count or invalid response.");
      }
    } catch (e) {
      debugPrint("Error fetching mock test question count: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners after the process is complete
    }
  }

  void setNumberOfQuestion(double value) {
    _numberOfQuestions = value.toInt();
    if (kDebugMode) {
      print("_numberOfQuestions = $_numberOfQuestions");
    }
    notifyListeners();
  }

  Future<void> getQuestions(
      BuildContext context, Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await createMockTestRepo.createMockTest(data);
      print("Full API Response: $response");

      _createMockTestModel = response;

      if (_createMockTestModel?.success == true &&
          _createMockTestModel!.questions != null) {
        _questionList = _createMockTestModel!.questions!;
        _numberOfQuestions = _questionList.length;
        _isSubmitted = List<bool>.filled(_questionList.length, false);
        _selectedOptions = List<int?>.filled(_questionList.length, null);
        _isTrue = List<bool>.filled(_questionList.length, false);
        _correctAnswerOptionIndex = List<int>.filled(_numberOfQuestions, 0);
        _showExplanation = List<bool>.filled(_questionList.length, false);
        _timeInSeconds = _timeInSeconds * _questionList.length;
        notifyListeners();
        print("Questions Fetched: ${_questionList.length}");
      } else {
        print("No questions received from API.");
        _questionList = [];
        _numberOfQuestions = 0;
      }
    } catch (error) {
      print("Error fetching questions: $error");
      _questionList = [];
      _numberOfQuestions = 0;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _questionsToPost = [];
  List<Map<String, dynamic>> get questionsToPost => _questionsToPost;

  void submitAnswer(BuildContext context, int index) {
    if (_selectedOptions.isNotEmpty &&
        index < _selectedOptions.length &&
        _selectedOptions[index] != null) {
      if (_isSubmitted.isNotEmpty &&
          index >= 0 &&
          index < _isSubmitted.length) {
        _isSubmitted[index] = true;
      }

      if (_questionList.isNotEmpty && index < _questionList.length) {
        final question = _questionList[index];
        String correctAnswerKey = question.correctAnswer!.toLowerCase();
        int? correctAnswerIndex = correctOptionMapping[correctAnswerKey];
        _correctAnswerOptionIndex![index] = correctAnswerIndex!;
        bool isCorrect = (_selectedOptions[index] == correctAnswerIndex);

        if (isCorrect) {
          _correctAns++;
          _isTrue![index] = true;
        } else {
          _incorrectAns++;
          _isTrue![index] = false;
        }

        _questionsToPost.add({
          'question_id': question.id,
          'question_result': isCorrect ? "correct" : "incorrect",
          'question_status': "submitted",
          'question_text': question.question,
          'selected_option': _selectedOptions[index],
          'correct_option': correctAnswerIndex,
        });

        // Check if all questions are submitted
        bool allSubmitted =
            _isSubmitted.every((submitted) => submitted == true);
        print("allSubmitted ===> $allSubmitted");

        if (allSubmitted) {
          Future.microtask(() {
            Navigator.pushReplacementNamed(
              context,
              RoutesName.resultScreen,
              arguments: {
                'correctAns': _correctAns,
                'incorrectAns': _incorrectAns,
                'totalQuestions': _numberOfQuestions,
                'questions': _questionsToPost,
              },
            );
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select an option before submitting!"),
          ),
        );
      }

      notifyListeners();
    }
  }

  void goBack(context) {
    _questionsToPost = [];
    Navigator.pop(context);
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

  navigate(BuildContext context) {
    if (_shouldNavigate) {
      _isTestStarted = false;
      Navigator.pushReplacementNamed(context, RoutesName.resultScreen,
          arguments: {
            'subject': 'Created Mock Test',
            'correctAns': _correctAns,
            'incorrectAns': _incorrectAns,
            'totalQuestion': _numberOfQuestions
          });
    }
    notifyListeners();
  }

  void restartTest() {
    resetProvider();
    notifyListeners();
  }

  void startTest() {
    if (_questionList.isEmpty) {
      print("Cannot start test: No questions available");
      return;
    }
    _isTestStarted = true;
    _isPrevEnabled = false;
    _isNxtEnabled = _questionList.length > 1;
    _currentIndex = 0;
    _correctAns = 0;
    _incorrectAns = 0;
    _shouldNavigate = true;
    _timeInSeconds = 30 * _numberOfQuestions;
    _isSubmitted = List<bool>.filled(_questionList.length, false);
    _selectedOptions = List<int?>.filled(_questionList.length, null);
    _showExplanation = List<bool>.filled(_questionList.length, false);

    _endTime = DateTime.now().millisecondsSinceEpoch + _timeInSeconds * 1000;
    notifyListeners();
  }

  void resetProvider() {
    _correctAns = 0;
    _incorrectAns = 0;

    if (_questionList.isNotEmpty) {
      _isSubmitted = List<bool>.filled(_questionList.length, false);
      _selectedOptions = List<int?>.filled(_questionList.length, null);
      _showExplanation = List<bool>.filled(_questionList.length, false);
    }

    _isTestStarted = false;
    _isNxtEnabled = false;
    _numberOfQuestions = _questionList.length;
    _isPrevEnabled = false;
    _currentIndex = 0;
    _shouldNavigate = false;
    _timeInSeconds = 30;
    _endTime = DateTime.now().millisecondsSinceEpoch + _timeInSeconds * 1000;

    notifyListeners();
  }

  void goToNext() {
    if (_currentIndex < (_questionList.length - 1)) {
      _currentIndex++;
      _isPrevEnabled = true;
      _isNxtEnabled = _currentIndex < (_questionList.length - 1);
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

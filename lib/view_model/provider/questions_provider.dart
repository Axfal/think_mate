// ignore_for_file: avoid_print, prefer_final_fields, use_build_context_synchronously

import 'dart:convert';
import 'package:education_app/model/check_model.dart';
import 'package:education_app/model/get_checked_question_model.dart';
import 'package:education_app/repository/check_question_repo.dart';
import 'package:education_app/resources/exports.dart';
import '../../model/incorrect_questions_model.dart';
import '../../model/hive_database_model/submitted_questions_model.dart';
import '../../repository/incorrect_question_repo.dart';

enum FilterType { all, incorrect, unmarked, marked }

class QuestionsProvider with ChangeNotifier {
  final QuestionRepository _mockTestRepo = QuestionRepository();
  final IncorrectQuestionRepository _incorrectTestRepo =
      IncorrectQuestionRepository();
  final CheckQuestionRepo _checkQuestionRepo = CheckQuestionRepo();
  var box = Hive.box<SubmittedQuestionsModel>('submittedQuestionsBox');

  MockTestModel? _questions;
  MockTestModel? get questions => _questions;

  String? _subject;
  String? get subject => _subject;

  IncorrectQuestionModel? _incorrectQuestionsModel;
  IncorrectQuestionModel? get incorrectQuestionsModel =>
      _incorrectQuestionsModel;

  List<Question> _questionList = [];
  List<Question> get questionList => _questionList;

  final Map<String, int> correctOptionMapping = {
    "a": 0,
    "b": 1,
    "c": 2,
    "d": 3,
  };

  Map<int, int> _correctAnswerOptionIndex = {};
  Map<int, int> get correctAnswerOptionIndex => _correctAnswerOptionIndex;

  int? _numberOfQuestions;
  int? get numberOfQuestions => _numberOfQuestions;

  Map<int, bool> _isSubmitted = {};
  Map<int, bool> get isSubmitted => _isSubmitted;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  int _incorrectAns = 0;
  int get incorrectAns => _incorrectAns;

  bool _loading = false;
  bool get loading => _loading;

  bool _isTestStarted = false;
  bool get isTestStarted => _isTestStarted;

  Map<int, int> _selectedOptions = {};
  Map<int, int> get selectedOptions => _selectedOptions;

  List<bool> _showExplanation = [];
  List<bool> get showExplanation => _showExplanation;

  final Map<int, bool> _bookmarkedQuestions = {};
  Map<int, bool> get bookmarkedQuestions => _bookmarkedQuestions;

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

  Map<int, bool> _isTrue = {};
  Map<int, bool> get isTrue => _isTrue;

  List<Map<String, dynamic>> _questionsToPost = [];
  List<Map<String, dynamic>> get questionsToPost => _questionsToPost;

  List<Question> _incorrectQuestions = [];
  List<Question> get incorrectQuestions => _incorrectQuestions;

  List<Question> _filteredQuestions = [];
  List<Question> get filteredQuestions => _filteredQuestions;

  Map<int, bool> _checkMap = {};
  Map<int, bool> get checkMap => _checkMap;

  CheckModel? _checkModel;
  CheckModel? get checkModel => _checkModel;

  CheckModel? _unCheckModel;
  CheckModel? get unCheckModel => _unCheckModel;

  GetCheckedQuestionModel? _getCheckedQuestionModel;
  GetCheckedQuestionModel? get getCheckedQuestionModel =>
      _getCheckedQuestionModel;

  bool _isQuestionsAllSubmitted = false;

  void getSelectedOptions() {
    _selectedOptions.clear();

    for (var entry in box.values) {
      int questionId = entry.questionId ?? -1;
      int selectedOption = entry.selectedOption ?? -1;

      if (questionId != -1 && selectedOption != -1) {
        _selectedOptions[questionId] = selectedOption;
      }
    }

    notifyListeners();
  }

  Future<void> getCheckedQuestions(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userSession!.userId;
    final testId = authProvider.userSession!.testId;
    final chapterProvider =
        Provider.of<ChapterProvider>(context, listen: false);
    final subjectId = chapterProvider.subjectId;
    final chapterId = chapterProvider.chapterId;

    try {
      _getCheckedQuestionModel = await _checkQuestionRepo.getCheckedQuestion(
          userId, testId, subjectId!, chapterId);
      if (_getCheckedQuestionModel != null &&
          _getCheckedQuestionModel!.success == true &&
          _getCheckedQuestionModel!.checkMarkQuestions != null) {
        for (var question in _getCheckedQuestionModel!.checkMarkQuestions!) {
          _checkMap[question.questionId!] = true;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkQuestions(BuildContext context, int questionId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userSession?.userId;
    final testId = authProvider.userSession?.testId;
    final chapterProvider =
        Provider.of<ChapterProvider>(context, listen: false);
    final subjectId = chapterProvider.subjectId;
    final chapterId = chapterProvider.chapterId;

    if (userId == null || testId == null) {
      ToastHelper.showError('User or test information is missing');
      return;
    }

    final Map<String, dynamic> data = {
      "user_id": userId,
      "test_id": testId,
      "question_id": questionId,
      "subject_id": subjectId,
      "chapter_id": chapterId
    };

    try {
      _checkModel = await _checkQuestionRepo.checkQuestion(data);

      if (_checkModel?.success == true &&
          _checkModel?.message?.isNotEmpty == true) {
        _checkMap[questionId] = true;
        notifyListeners();

        ToastHelper.showSuccess(_checkModel!.message!);
      }
    } catch (e) {
      debugPrint('Error checking question: $e');
      ToastHelper.showError(
          'Failed to check the question. Please try again later.');
      rethrow;
    }
  }

  Future<void> unCheckQuestions(BuildContext context, int questionId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userSession!.userId;
    final testId = authProvider.userSession!.testId;

    Map<String, dynamic> data = {
      "user_id": userId,
      "test_id": testId,
      "question_id": questionId,
    };

    try {
      _checkModel = await _checkQuestionRepo.unCheckQuestion(data);

      if (_checkModel?.success == true &&
          _checkModel?.message?.isNotEmpty == true) {
        _checkMap.remove(questionId);
        ToastHelper.showSuccess(_checkModel!.message!);
      }
    } catch (e) {
      print('Error unchecking question: $e');
      rethrow;
    }
  }

  void checkTheQuestion(context, int questionId) async {
    if (_checkMap[questionId] == true) {
      await unCheckQuestions(context, questionId);
    } else {
      await checkQuestions(context, questionId);
    }
    notifyListeners();
  }

  bool isQuestionChecked(int questionId) {
    return _checkMap[questionId] ?? false;
  }

  Future<void> applyFilter(
      BuildContext context, FilterType filterType, testId) async {
    final chapterProvider =
        Provider.of<ChapterProvider>(context, listen: false);
    final subjectId = chapterProvider.subjectId;
    final chapterId = chapterProvider.chapterId;

    switch (filterType) {
      case FilterType.incorrect:
        if (!_isQuestionsAllSubmitted) {
          showIncorrectQuestionLocally(context);
        } else {
          await fetchIncorrectQuestions(context, testId, subjectId!, chapterId);
        }
        break;
      case FilterType.marked:
        await fetchQuestions(context, testId, subjectId!, chapterId);
        _filteredQuestions =
            _filteredQuestions.where((q) => _checkMap[q.id] == true).toList();
        _numberOfQuestions = _filteredQuestions.length;
        _showExplanation = List<bool>.filled(_numberOfQuestions!, false);

        break;

      case FilterType.unmarked:
        await fetchQuestions(context, testId, subjectId!, chapterId);
        _filteredQuestions = _filteredQuestions
            .where((q) => _checkMap[q.id] == null || _checkMap[q.id] == false)
            .toList();
        break;
      case FilterType.all:
      default:
        await fetchQuestions(context, testId, subjectId!, chapterId);
        await getCheckedQuestions(context);
        break;
    }
    notifyListeners();
  }

  Future<void> fetchIncorrectQuestions(
      BuildContext context, int testId, int subjectId, int chapterId) async {
    try {
      _loading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userSession?.userId;
      final testId = authProvider.userSession?.testId;

      Map<String, dynamic> data = {
        "user_id": userId ?? 0,
        "test_id": testId ?? 0,
        "subject_id": subjectId,
        "chapter_id": chapterId
      };

      debugPrint("Response: ${jsonEncode(data)}");

      final response = await _incorrectTestRepo.fetchIncorrectQuestions(data);

      debugPrint("Response: ${jsonEncode(response)}");

      if (response.success == true && response.incorrectQuestions!.isNotEmpty) {
        _incorrectQuestions = response.incorrectQuestions!
            .map((incorrect) => Question(
                id: incorrect.id!,
                question: incorrect.question!,
                option1: incorrect.option1!,
                option2: incorrect.option2!,
                option3: incorrect.option3!,
                option4: incorrect.option4!,
                detail: incorrect.detail!,
                capacity: incorrect.capacity!,
                correctAnswer: incorrect.correctAnswer!,
                subjectName:
                    '' // as i don't need subject name in questions screen of chapters. so set it default empty
                ))
            .toList();

        _filteredQuestions = List.from(_incorrectQuestions);
        _numberOfQuestions = _filteredQuestions.length;
        _showExplanation = List<bool>.filled(_numberOfQuestions!, false);
      } else {
        debugPrint("Response contains no questions.");
        _questions = null;
        _filteredQuestions = [];
        _numberOfQuestions = 0;
      }
    } catch (error) {
      debugPrint("Error fetching incorrect questions: $error");
      _questions = null;
      _filteredQuestions = [];
      _numberOfQuestions = 0;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchQuestions(
      BuildContext context, int testId, int subjectId, int chapterId) async {
    try {
      _loading = true;
      // clearSubmittedQuestions(); // for testing purpose, to remove testing data
      notifyListeners();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userSession?.userId ?? 0;
      Map<String, dynamic> data = {
        "user_id": userId,
        "test_id": testId,
        "subject_id": subjectId,
        "chapter_id": chapterId
      };

      final response = await _mockTestRepo.fetchQuestions(data);

      if (response.success == true && response.questions.isNotEmpty) {
        _questions = response;
        _questionList = _questions!.questions;
        _filteredQuestions = List.from(_questionList);
        _numberOfQuestions = _questionList.length;
        // for (var i in _questionList) {
        //   if (!_restQuestionData.contains(i.id)) {
        //     _restQuestionData.add(i.id);
        //   }
        // }
        _showExplanation = List<bool>.filled(_numberOfQuestions!, false);
      } else {
        _questions = null;
        _questionList = [];
        _numberOfQuestions = 0;
      }
    } catch (error) {
      debugPrint("Error fetching questions: $error");
      _questions = null;
      _questionList = [];
      _numberOfQuestions = 0;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void showIncorrectQuestionLocally(BuildContext context) async {
    _filteredQuestions.clear();

    final chapterProvider =
        Provider.of<ChapterProvider>(context, listen: false);
    final chapterId = chapterProvider.chapterId;

    final incorrectQuestionsFromHive = box.values
        .where(
            (q) => q.chapterId == chapterId && q.questionResult == "incorrect")
        .toList();

    for (var question in _questionList) {
      int questionId = question.id;

      bool isIncorrect =
          incorrectQuestionsFromHive.any((q) => q.questionId == questionId);

      if (isIncorrect) {
        _filteredQuestions.add(question);
      }
    }

    _numberOfQuestions = _filteredQuestions.length;
    _showExplanation = List<bool>.filled(_numberOfQuestions!, false);

    print(
        'Filtered Incorrect Questions for current chapter: ${_filteredQuestions.length}');
    notifyListeners();
  }

  void submitAnswer(BuildContext context, int questionId) {
    if (_selectedOptions.containsKey(questionId) &&
        _selectedOptions[questionId] != null) {
      _isSubmitted[questionId] = true;

      if (_filteredQuestions.isNotEmpty) {
        Question question =
            _filteredQuestions.firstWhere((q) => q.id == questionId);
        String correctAnswerKey = question.correctAnswer.toLowerCase();
        int correctAnswerIndex = correctOptionMapping[correctAnswerKey] ?? -1;

        _correctAnswerOptionIndex[questionId] = correctAnswerIndex;

        String result = (_selectedOptions[questionId] == correctAnswerIndex)
            ? "correct"
            : "incorrect";

        if (result == "correct") {
          _correctAns++;
          _isTrue[questionId] = true;
        } else {
          _incorrectAns++;
          _isTrue[questionId] = false;
        }

        final chapterProvider =
            Provider.of<ChapterProvider>(context, listen: false);
        final chapterId = chapterProvider.chapterId;

        // Store data in Hive, avoid duplicates
        if (!box.values.any(
            (q) => q.questionId == questionId && q.chapterId == chapterId)) {
          addToSubmittedQuestions(context, questionId, result,
              _selectedOptions[questionId]!, chapterId);
        }

        // Only include current chapter's questions in _questionsToPost
        List<Map<String, dynamic>> filteredQuestionsToPost = box.values
            .where((q) => q.chapterId == chapterId)
            .map((q) => {
                  'question_id': q.questionId,
                  'question_result': q.questionResult,
                  'question_status': 'Not Mock',
                })
            .toList();

        print(
            'Filtered questions for current chapter =>>>> $filteredQuestionsToPost');

        // Calculate total questions and check for all submissions for the current chapter
        int totalQuestionsInChapter = _filteredQuestions.length;
        int submittedQuestionsCount =
            box.values.where((q) => q.chapterId == chapterId).length;

        bool allQuestionsInChapterSubmitted =
            submittedQuestionsCount == totalQuestionsInChapter;

        print(
            "All questions in current chapter submitted: $allQuestionsInChapterSubmitted");

        if (allQuestionsInChapterSubmitted) {
          _isQuestionsAllSubmitted = true;
          Future.microtask(() {
            Navigator.pushReplacementNamed(
              context,
              RoutesName.resultScreen,
              arguments: {
                'correctAns': filteredQuestionsToPost
                    .where((q) => q['question_result'] == 'correct')
                    .length,
                'incorrectAns': filteredQuestionsToPost
                    .where((q) => q['question_result'] == 'incorrect')
                    .length,
                'totalQuestion': totalQuestionsInChapter,
                'questions': filteredQuestionsToPost,
              },
            );
          });
        }
      }
    } else {
      ToastHelper.showError("Please select an option before submitting!");
    }

    notifyListeners();
  }

  Future<void> removeAllDataByChapterId(int chapterId) async {
    try {
      final questionsToRemove =
          box.values.where((q) => q.chapterId == chapterId).toList();

      for (var question in questionsToRemove) {
        await box.delete(question.key);

        _selectedOptions.remove(question.questionId);
        _isSubmitted.remove(question.questionId);
        _isTrue.remove(question.questionId);
      }

      notifyListeners();
      print("All data with chapterId $chapterId removed.");
    } catch (e) {
      print("Error removing data by chapterId: $e");
    }
  }

  void addToSubmittedQuestions(context, int questionId, String questionResult,
      int selectedOption, int chapterId) {
    var box = Hive.box<SubmittedQuestionsModel>('submittedQuestionsBox');
    var question = SubmittedQuestionsModel(
        questionId: questionId,
        questionResult: questionResult,
        selectedOption: selectedOption,
        chapterId: chapterId);
    print(
        'question id =$questionId question result $questionResult selected option $selectedOption');

    box.add(question);
  }

  int? getStoredSelectedOption(int questionId) {
    var box = Hive.box<SubmittedQuestionsModel>('submittedQuestionsBox');
    var storedQuestion = box.values.firstWhere(
      (question) => question.questionId == questionId,
      orElse: () => SubmittedQuestionsModel(
          questionId: -1,
          questionResult: "",
          selectedOption: -1,
          chapterId: -1),
    );

    return storedQuestion.questionId == -1
        ? null
        : storedQuestion.selectedOption;
  }

  void clearSubmittedQuestions() {
    var box = Hive.box<SubmittedQuestionsModel>('submittedQuestionsBox');
    box.clear();
    print("All submitted questions cleared.");
  }

  bool isQuestionAlreadySubmitted(int questionId) {
    var box = Hive.box<SubmittedQuestionsModel>('submittedQuestionsBox');

    return box.values.any((question) => question.questionId == questionId);
  }

  void addNoteWithKey(int key, String title, String detail) {
    final box = Boxes.getData();

    if (key < 0 || key > 0xFFFFFFFF) {
      print("Invalid key: $key. Must be between 0 and 0xFFFFFFFF.");
      return;
    }
    final note = NotesModel(title: title, description: detail);
    box.put(key, note);
    print("Note added successfully with key: $key");
  }

  void removeNoteByKey(int key) {
    final box = Boxes.getData();
    if (key < 0 || key > 0xFFFFFFFF) {
      print("Invalid key: $key");
      return;
    }
    if (box.containsKey(key)) {
      box.delete(key);
      print("Note with key $key removed successfully.");
    } else {
      print("Key $key does not exist in Hive.");
    }
  }

  void onChangeRadio(int questionId, int value) {
    if (!_isSubmitted.containsKey(questionId) ||
        _isSubmitted[questionId] == false) {
      _selectedOptions[questionId] = value;
      notifyListeners();
    }
  }

  void restartTest() {
    resetProvider();
    notifyListeners();
  }

  void goBack(context) {
    _filteredQuestions.clear();
    _questionsToPost = [];
    Navigator.pop(context);
    notifyListeners();
  }

  void resetProvider() {
    _correctAns = 0;
    _incorrectAns = 0;
    // clearSubmittedQuestions();
    if (_numberOfQuestions != null && _numberOfQuestions! > 0) {
      _showExplanation = List<bool>.filled(_numberOfQuestions!, false);
    }

    _isTestStarted = false;
    _isNxtEnabled = false;
    _isPrevEnabled = false;
    _currentIndex = 0;
    _shouldNavigate = false;
    notifyListeners();
  }

  void toggleExplanationSwitch(int index, bool value) {
    if (index >= 0 && index < _showExplanation.length) {
      _showExplanation[index] = value;
      notifyListeners();
    }
  }
}

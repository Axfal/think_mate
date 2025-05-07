import 'package:education_app/resources/exports.dart';

class BookMarkProvider with ChangeNotifier {
  final _bookMarkRepo = BookMarkRepository();

  bool _isMarked = false;
  bool get isMarked => _isMarked;

  final Map<int, bool> _bookmarkedQuestions = {};
  Map<int, bool> get bookmarkedQuestions => _bookmarkedQuestions;

  BookMarkModel? _bookMarkModel;
  BookMarkModel? get bookMark => _bookMarkModel;

  GetBookMarkModel? _getBookMarkModel;
  GetBookMarkModel? get getBookMark => _getBookMarkModel;

  DeleteBookMarkModel? _deleteBookMarkModel;
  DeleteBookMarkModel? get deleteBookMarkModel => _deleteBookMarkModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isBookmarked(int questionId) {
    return _bookmarkedQuestions[questionId] ?? false;
  }

  Future<void> bookMarking(BuildContext context, int questionId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUserSession();
    final userId = authProvider.userSession?.userId;
    final testId = authProvider.userSession?.testId;
    final questionProvider =
        Provider.of<QuestionsProvider>(context, listen: false);
    if (userId == null || testId == null) {
      debugPrint("User session data is missing.");
      return;
    }

    Map<String, dynamic> data = {
      "user_id": userId,
      "test_id": testId,
      "question_id": questionId
    };

    _isLoading = true;
    notifyListeners();

    try {
      _bookMarkModel = await _bookMarkRepo.bookMarking(data);
      if (_bookMarkModel != null && _bookMarkModel!.success == true) {
        _isMarked = true;
        _bookmarkedQuestions[questionId] = true;
        Question? question = questionProvider.questionList.firstWhere(
          (q) => q.id == questionId,
          orElse: () => Question(
            id: -1,
            question: '',
            detail: '',
            option1: '',
            option2: '',
            option3: '',
            option4: '',
            capacity: '',
            correctAnswer: '',
          ),
        );
        if (question.id != -1) {
          addNoteWithKey(question.id, question.question, question.detail);
        }
      } else {
        debugPrint("Bookmark API response: ${_bookMarkModel?.success}");
      }
    } catch (e) {
      debugPrint("Bookmarking failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getBookMarking(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    final questionProvider =
        Provider.of<QuestionsProvider>(context, listen: false);

    try {
      _getBookMarkModel = await _bookMarkRepo.getBookMarking();
      if (_getBookMarkModel != null && _getBookMarkModel!.bookmarks != null) {
        for (var item in _getBookMarkModel!.bookmarks!) {
          if (item.questionId != null) {
            _bookmarkedQuestions[item.questionId!] = true;
            Question? question = questionProvider.questionList.firstWhere(
              (q) => q.id == item.questionId,
              orElse: () => Question(
                  id: -1,
                  question: '',
                  detail: '',
                  option1: '',
                  option2: '',
                  option3: '',
                  option4: '',
                  capacity: '',
                  correctAnswer: ''),
            );
            addNoteWithKey(question.id, question.question, question.detail);
            if (question.id != -1) {
              addNoteWithKey(
                  item.questionId!, question.question, question.detail);
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Bookmarking failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBookMarking(BuildContext context, int questionId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUserSession();
    final userId = authProvider.userSession?.userId;
    final testId = authProvider.userSession?.testId;

    if (userId == null || testId == null) {
      debugPrint("User session data is missing.");
      return;
    }

    Map<String, dynamic> data = {
      "user_id": userId,
      "test_id": testId,
      "question_id": questionId
    };

    _isLoading = true;
    notifyListeners();

    try {
      _deleteBookMarkModel = await _bookMarkRepo.deleteBookMarking(data);
      if (_deleteBookMarkModel != null &&
          _deleteBookMarkModel!.success == true) {
        _isMarked = false;
        _bookmarkedQuestions.remove(questionId);
        removeNoteByKey(questionId);
        ToastHelper.showSuccess("BookMarks deleted successfully");
      } else {
        ToastHelper.showError("BookMark not found.");
      }
    } catch (e) {
      debugPrint("Delete Bookmark failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addNoteWithKey(int key, String title, String detail) {
    final box = Boxes.getData();
    final note = NotesModel(title: title, description: detail);
    box.put(key, note);
  }

  void removeNoteByKey(int key) {
    final box = Boxes.getData();
    box.delete(key);
  }
}

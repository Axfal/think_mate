import 'package:education_app/resources/exports.dart';

class SubjectProvider with ChangeNotifier {
  final _courseRepository = SubjectsRepository();

  List<int> _subjectId = [];
  List<int> get subjectId => _subjectId;

  List<String> _subjects = [];
  List<String> get subjects => _subjects;

  String? _subject;
  String? get subject => _subject;

  final List<String> _courses = <String>[];
  List<String> get courses => _courses;

  int _testId = 0;
  int get testId => _testId;

  int _selectedSubjectId = 0;
  int get selectedSubjectId => _selectedSubjectId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<int, String>? _subjectsMap;
  Map<int, String>? get subjectsMap => _subjectsMap;

  String getSubjectName(int id) {
    return _subjectsMap?[id] ?? 'Unknown Subject';
  }


  void setTestId(int id) {
    _testId = id;
    notifyListeners();
  }

  void disposeChapters() {
    _subjectId = [];
    _subjects = [];
    notifyListeners();
  }

  void setSelectedSubjectId(int id) {
    _selectedSubjectId = id;
    notifyListeners();
  }

  Future<void> setSubjects(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _courseRepository.getCourses(id);
      _testId = id;
      if (response != null &&
          response.success == true &&
          response.subjects != null &&
          response.subjects!.isNotEmpty) {

        _subjects = response.subjects!
            .map((subject) => subject.subjectName ?? '')
            .toList();

        _subjectsMap = {
          for (var subject in response.subjects!)
            subject.id!: subject.subjectName ?? '',
        };

        _subjectId =
            response.subjects!.map((subject) => subject.id ?? 0).toList();

      } else {
        _subjects = [];
      }
    } catch (e) {
      ToastHelper.showError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

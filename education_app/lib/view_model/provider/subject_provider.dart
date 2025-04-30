import 'package:education_app/resources/exports.dart';

class SubjectProvider with ChangeNotifier {
  final _courseRepository = SubjectsRepository();

  List<int> _subjectId = [];
  List<int> get subjectId => _subjectId;

  List<String> _subjects = [];
  List<String> get subjects => _subjects;

  String? _subject;
  String? get subject =>_subject;

  final List<String> _courses = <String>[];
  List<String> get courses => _courses;

  int _testId = 0;
  int get testId => _testId;

  int _selectedSubjectId = 0;
  int get selectedSubjectId => _selectedSubjectId;

  void setTestId(int id) {
    _testId = id;
    notifyListeners();
  }

  void setSelectedSubjectId(int id) {
    _selectedSubjectId = id;
    notifyListeners();
  }

  Future<void> setSubjects(int id) async {
    final response = await _courseRepository.getCourses(id);
    _testId = id;
    if (response != null &&
        response.success == true &&
        response.subjects != null &&
        response.subjects!.isNotEmpty) {
      _subjects = response.subjects!
          .map((subject) => subject.subjectName ?? '')
          .toList();

      _subjectId =
          response.subjects!.map((subject) => subject.id ?? 0).toList();
    } else {
      _subjects = [];
    }
    notifyListeners();
  }
}

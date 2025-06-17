// ignore_for_file: avoid_print

import 'package:education_app/repository/chapter_repo.dart';
import 'package:education_app/resources/exports.dart';

class ChapterProvider with ChangeNotifier {
  final chapterRepo = ChapterRepository();

  ChapterModel? _chapterData;
  ChapterModel? get chapterData => _chapterData;

  int? _subjectId;
  int? get subjectId => _subjectId;

  int _chapterId = 0;
  int get chapterId => _chapterId;

  List<String> _chapterNo = [];
  List<String> get chapterNo => _chapterNo;

  List<String> _chapterName = [];
  List<String> get chapterName => _chapterName;

  String? _subject;
  String? get subject => _subject;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void reset() {
    _chapterData = null;
  }

  Future<void> setData(int testId, int subjectId, String subjectName) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await chapterRepo.getChapters(testId, subjectId);

      if (response["success"] == true && response['chapters'] != null) {
        _chapterData = ChapterModel.fromJson(response);
        _subject = subjectName;

        _chapterName = _chapterData!.chapters!.map((chapter) => chapter.chapName ?? "").toList();
        _chapterNo = _chapterData!.chapters!.map((chapter) => chapter.chapNo ?? "").toList();
      } else {
        _chapterData = ChapterModel(success: false, chapters: []);
        _chapterName = [];
        _chapterNo = [];
      }

    } catch (e) {
      print("Error in setData: $e");
      _chapterData = ChapterModel(success: false, chapters: []);
      _chapterName = [];
      _chapterNo = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void openChapter(int index) {
    if (_chapterData != null &&
        _chapterData!.chapters != null &&
        index < _chapterData!.chapters!.length) {
      _subjectId = _chapterData!.chapters![index].subjectId;
      _chapterId = _chapterData!.chapters![index].id!;
      print("Subject ID: $_subjectId, Chapter ID: $_chapterId");
      notifyListeners();
    } else {
      print("Invalid index or empty chapter data.");
    }
  }

}

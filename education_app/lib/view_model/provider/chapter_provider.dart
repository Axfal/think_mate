// ignore_for_file: avoid_print

import 'package:education_app/repository/chapter_repo.dart';
import 'package:education_app/resources/exports.dart';

class ChapterProvider with ChangeNotifier {
  final chapterRepo = ChapterRepository();

  dynamic _chapterData;
  dynamic get chapterData => _chapterData;

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

  void reset() {
    _chapterNo = [];
    _chapterName = [];
  }

  Future<void> setData(int testId, int subjectId, String subjectName) async {
    try {
      final response = await chapterRepo.getChapters(testId, subjectId);

      if (kDebugMode) {
        print("Fetched Chapters: ${response.chapters}");
      }

      if (response.success == true &&
          response.chapters != null &&
          subjectName != '') {
        _chapterData = response.chapters;
        print('subjectName = $subjectName');
        _subject = subjectName;
        // notifyListeners();
        _chapterName = response.chapters!.map((chapter) {
          if (chapter.chapName is String) {
            return chapter.chapName!;
          } else {
            throw Exception("chapName is not a String: ${chapter.chapName}");
          }
        }).toList();

        _chapterNo = response.chapters!.map((chapter) {
          if (chapter.chapNo is String) {
            return chapter.chapNo!;
          } else {
            return chapter.chapNo.toString();
          }
        }).toList();
      } else {
        _chapterName = [];
        _chapterNo = [];
      }

      if (kDebugMode) {
        print("Stored Chapters: $_chapterName");
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error in setData: $e");
      }
      rethrow;
    }
  }

  void openChapter(int index) {
    if (_chapterData != null && index < _chapterData.length) {
      _subjectId =
          _chapterData![index].subjectId; // Use subjectId instead of subject_id
      _chapterId = _chapterData![index].id;
      print("Subject ID: $_subjectId, Chapter ID: $_chapterId");
      notifyListeners();
    } else {
      print("Invalid index or empty chapter data.");
    }
  }
}

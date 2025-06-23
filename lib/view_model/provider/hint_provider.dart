import 'package:education_app/model/hint_model.dart';
import 'package:education_app/repository/hint_repo.dart';
import 'package:education_app/resources/exports.dart' hide Data;

class HintProvider with ChangeNotifier {
  final _hintRepository = HintRepo();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HintModel? _hintModel;
  HintModel? get hintModel => _hintModel;

  final Map<int, Data> _hintCache = {}; // subject id + data

  Future<void> loadAllHints(int testId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _hintRepository.generalHint(testId);
      _hintModel = HintModel.fromJson(response);

      _hintCache.clear();
      for (var hint in _hintModel?.data ?? []) {
        if (hint.subjectId != null) {
          _hintCache[hint.subjectId!] = hint;
        }
      }
    } catch (e) {
      debugPrint("Hint loading error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Hint for a specific subject
  Data? getHintForSubject(int subjectId) {
    return _hintCache[subjectId];
  }

  void clearHints() {
    _hintModel = null;
    _hintCache.clear();
    notifyListeners();
  }
}

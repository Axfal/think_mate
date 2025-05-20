// ignore_for_file: avoid_print

import 'package:education_app/model/note_book_model.dart';
import 'package:education_app/repository/note_bookrepo.dart';
import 'package:education_app/resources/exports.dart';

class NoteBookProvider with ChangeNotifier {
  final _noteBookRepository = NoteBookRepository();

  NoteBookModel? _noteBookModel;
  NoteBookModel? get noteBookModel => _noteBookModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getNoteBooks(context) async {
    _isLoading = true;
    notifyListeners();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userSession?.userId;

    if (userId == null) {
      return;
    }
    try {
      final response = await _noteBookRepository.getNoteBooks(userId);
      if (response != null && response["success"] == true) {
        _noteBookModel = NoteBookModel.fromJson(response);
      } else {
        ToastHelper.showError(
            "success = false check your repo and provider dear developer Anfal!");
      }
    } catch (e) {
      print("error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

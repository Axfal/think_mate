// ignore_for_file: avoid_print

import 'package:education_app/model/note_book_model.dart';
import 'package:education_app/repository/note_bookrepo.dart';
import 'package:education_app/resources/exports.dart';

import '../../model/library/folder_model.dart';

class NoteBookProvider with ChangeNotifier {
  final _noteBookRepository = NoteBookRepository();

  NoteBookModel? _noteBookModel;
  NoteBookModel? get noteBookModel => _noteBookModel;

  FolderModel? _folderModel;
  FolderModel? get folderModel => _folderModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getNoteBooks(context, int folderId) async {
    _isLoading = true;
    notifyListeners();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userSession?.userId;

    if (userId == null) {
      return;
    }
    try {
      final response = await _noteBookRepository.getNoteBooks(userId, folderId);
      if (response != null && response["success"] == true) {
        _noteBookModel = NoteBookModel.fromJson(response);
      } else {
        ToastHelper.showError(
            "success = false, check your repo and provider dear developer Anfal!");
      }
    } catch (e) {
      print("error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFolders() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _noteBookRepository.getFolders();
      if (response != null) {
        if (response['success'] == true && response['folders'] != null) {
          _folderModel = FolderModel.fromJson(response);
        } else {
          print(
              'error: ${response['error'] ?? 'error in your api response dear anfal'}');
        }
      } else {
        print('no response from server');
      }
    } catch (e) {
      print("error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

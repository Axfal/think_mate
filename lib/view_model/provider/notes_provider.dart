// ignore_for_file: prefer_final_fields, avoid_print

import 'package:education_app/model/get_notes_model.dart';
import 'package:education_app/repository/notes_repository.dart';
import 'package:education_app/resources/exports.dart';

class NotesProvider with ChangeNotifier {
  final _notesRepo = NotesRepository();

  GetNotesModel? _getNotesModel;
  GetNotesModel? get getNotesModel => _getNotesModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// get notes
  Future<void> getNotes(context, int subjectId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loadUserSession();
      final userId = authProvider.userSession!.userId;
      final testId = authProvider.userSession!.testId;
      final response = await _notesRepo.getNotes(userId, testId, subjectId);
      if (response != null && response["success"] == true) {
        _getNotesModel = GetNotesModel.fromJson(response);
      } else {
        print("error when success = false: ${response!["error"]}");
      }
    } catch (e) {
      print("error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// add notes
  Future<void> addNotesData(context, int subjectId, String title,
      String description) async {
    _isLoading = true;
    notifyListeners();
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loadUserSession();
      final userId = authProvider.userSession!.userId;
      final testId = authProvider.userSession!.testId;
      Map<String, dynamic> data = {
        "user_id": userId,
        "test_id": testId,
        "subject_id": subjectId,
        "title": title,
        "description": description
      };
      final response = await _notesRepo.addNotes(data);
      if (response != null && response["success"] == true) {
        ToastHelper.showSuccess("${response["message"]}");
      } else {
        ToastHelper.showError("${response!["error"]}");
        print("error when success = false: ${response["error"]}");
      }
    } catch (e) {
      print("error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// delete notes
  Future<void> deleteNotes(int noteId) async {
    try {
      Map<String, dynamic> data = {"note_id": noteId};

      final response = await _notesRepo.deleteNotes(data);
      if (response != null && response["success"] == true) {
        ToastHelper.showSuccess("${response["message"]}");
      } else {
        ToastHelper.showError("${response!["error"]}");
      }
    } catch (e) {
      print("error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// update notes
  Future<void> updateNotes(int noteId, String title, String description) async {
    try {
      _isLoading = true;
      notifyListeners();
      Map<String, dynamic> data = {
        "note_id": noteId,
        "title": title,
        "description": description
      };
      final response = await _notesRepo.updateNotes(data);
      if (response != null && response["success"] == true) {
        ToastHelper.showSuccess("${response["message"]}");
      } else {
        ToastHelper.showError("${response!["error"]}");
      }
    } catch (e) {
      print("error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

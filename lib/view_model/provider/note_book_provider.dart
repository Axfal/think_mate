// ignore_for_file: avoid_print
import 'package:education_app/model/note_book_model.dart';
import 'package:education_app/repository/note_bookrepo.dart';
import 'package:education_app/resources/exports.dart';
import '../../model/library/folder_model.dart';

class NoteBookProvider with ChangeNotifier {
  final NoteBookRepository _noteBookRepository = NoteBookRepository();

  // Cached notebooks per folder
  final Map<int, NoteBookModel> _cachedNotebooks = {};

  NoteBookModel? _noteBookModel;
  NoteBookModel? get noteBookModel => _noteBookModel;

  FolderModel? _folderModel;
  FolderModel? get folderModel => _folderModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Fetch notebooks for a specific folder
  Future<void> getNoteBooks(BuildContext context, int folderId) async {
    if (_cachedNotebooks.containsKey(folderId)) {
      _noteBookModel = _cachedNotebooks[folderId];
      notifyListeners();
      return;
    }

    _setLoading(true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userSession?.userId;

    if (userId == null) {
      _setLoading(false);
      return;
    }

    try {
      final response = await _noteBookRepository.getNoteBooks(userId, folderId);
      if (response != null && response["success"] == true) {
        final model = NoteBookModel.fromJson(response);
        _cachedNotebooks[folderId] = model;
        _noteBookModel = model;
      } else {
        ToastHelper.showError(
            "Success = false. Check your repo and provider, dear developer Anfal!"
        );
      }
    } catch (e) {
      print("Error fetching notebooks: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch all folders
  Future<void> getFolders() async {
    if (_folderModel != null) return;

    _setLoading(true);

    try {
      final response = await _noteBookRepository.getFolders();
      if (response != null) {
        if (response['success'] == true && response['folders'] != null) {
          _folderModel = FolderModel.fromJson(response);
        } else {
          print('API error: ${response['error'] ?? 'Unknown error'}');
        }
      } else {
        print('No response from server');
      }
    } catch (e) {
      print("Error fetching folders: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

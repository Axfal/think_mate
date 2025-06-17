import 'package:education_app/resources/exports.dart';


class NotesRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  /// get notes
  Future<Map<String, dynamic>?> getNotes(int userId, int testId, int subjectId) async {
    try {
      final uri = Uri.parse(AppUrl.getNotes).replace(queryParameters: {
        'user_id': userId.toString(),
        'test_id': testId.toString(),
        'subject_id': subjectId.toString(),
      });
      final response = await _apiServices.getGetApiResponse(uri.toString());

      return response;
    } catch (error) {
      debugPrint('Error while getting notes: $error');
      throw Exception('Failed to load notes');
    }
  }

  /// add note
  Future<Map<String, dynamic>?> addNotes(dynamic data) async {
    try {
      final response =
      await _apiServices.getPostApiResponse(AppUrl.addNotes, data);

      return response;
    } catch (error) {
      debugPrint('Error while adding notes: $error');
      throw Exception('Failed to add notes');
    }
  }

  /// update notes
  Future<Map<String, dynamic>?> updateNotes(dynamic data) async {
    try {
      final response =
      await _apiServices.getPostApiResponse(AppUrl.updateNote, data);

      return response;
    } catch (error) {
      debugPrint('Error while updating notes: $error');
      throw Exception('Failed to updating notes');
    }
  }

  /// delete notes
  Future<Map<String, dynamic>?> deleteNotes(dynamic data) async {
    try {
      final response =
      await _apiServices.getDeleteRequestApiResponse(AppUrl.deleteNote, data);

      return response;
    } catch (error) {
      debugPrint('Error while delete notes: $error');
      throw Exception('Failed to delete notes');
    }
  }
}

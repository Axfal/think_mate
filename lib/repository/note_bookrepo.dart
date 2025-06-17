import 'package:education_app/resources/exports.dart';

class NoteBookRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<Map<String, dynamic>?> getNoteBooks(int userId) async {
    try {
      final response =
          await _apiServices.getGetApiResponse("${AppUrl.getNoteBook} $userId");
      return response;
    } catch (error) {
      debugPrint('Error while fetching note books: $error');
      throw Exception('Failed to load note books');
    }
  }
}
